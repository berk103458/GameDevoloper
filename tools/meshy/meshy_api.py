"""Meshy REST istemcisi (https://api.meshy.ai/openapi, belge: https://docs.meshy.ai/llms.txt).

Kredi güvenliği kuralları (Meshy belgesindeki "Common Mistakes" bölümü):
- Görev oluşturan POST, zaman aşımı / bağlantı kopması / 5xx sonrası **otomatik yeniden gönderilmez**;
  görev yine de açılmış olabilir. `BelirsizGonderim` fırlatılır; çağıran geçmişi tarayarak karar verir.
- 4xx yanıtı görev açılmadığı anlamına gelir (`GonderimReddedildi`).
- GET istekleri (durum, liste, bakiye) güvenle yeniden denenir.
Anahtar hiçbir hata metnine girmez (`ortak.gizle`).
"""
import json
import os
import time
import urllib.error
import urllib.parse
import urllib.request

from ortak import gizle

API = "https://api.meshy.ai/openapi"
# Geçmiş taramasında bakılan görev uç noktaları (aşama → liste yolu).
LISTE_UCLARI = {
    "text-to-3d": "/v2/text-to-3d",
    "image-to-3d": "/v1/image-to-3d",
    "multi-image-to-3d": "/v1/multi-image-to-3d",
    "rigging": "/v1/rigging",
    "animations": "/v1/animations",
    "remesh": "/v1/remesh",
    "retexture": "/v1/retexture",
}


class MeshyHata(RuntimeError):
    pass


class BelirsizGonderim(MeshyHata):
    """POST sonucu bilinmiyor: görev açılmış olabilir, kredi düşmüş olabilir."""


class GonderimReddedildi(MeshyHata):
    """4xx: görev açılmadı, kredi düşmedi."""


class KrediYetersiz(GonderimReddedildi):
    pass


class Istemci:
    def __init__(self, anahtar, zaman_asimi=60):
        self._anahtar = anahtar
        self.zaman_asimi = zaman_asimi

    def _istek(self, yontem, yol, govde=None):
        veri = json.dumps(govde).encode() if govde is not None else None
        req = urllib.request.Request(API + yol, data=veri, method=yontem, headers={
            "Authorization": "Bearer " + self._anahtar, "Content-Type": "application/json",
            "User-Agent": "kapi-muhafizi-meshy-hat/1"})
        return urllib.request.urlopen(req, timeout=self.zaman_asimi)

    def get(self, yol, deneme=6):
        son = None
        for i in range(deneme):
            try:
                with self._istek("GET", yol) as r:
                    return json.load(r)
            except urllib.error.HTTPError as e:
                son = e
                if e.code in (429, 500, 502, 503, 504) and i < deneme - 1:
                    time.sleep(int(e.headers.get("Retry-After") or 5 * (i + 1)))
                    continue
                raise MeshyHata(gizle("GET %s → HTTP %d %r" % (yol, e.code, e.read()[:300]), self._anahtar))
            except (urllib.error.URLError, TimeoutError, OSError) as e:
                son = e
                if i < deneme - 1:
                    time.sleep(5)
                    continue
        raise MeshyHata(gizle("GET %s başarısız: %s" % (yol, son), self._anahtar))

    def post_gorev(self, yol, govde):
        """Görev açar, görev kimliğini döndürür. Hiçbir durumda kendiliğinden ikinci kez göndermez."""
        try:
            with self._istek("POST", yol, govde) as r:
                cevap = json.load(r)
        except urllib.error.HTTPError as e:
            ic = gizle(repr(e.read()[:300]), self._anahtar)
            if e.code == 402:
                raise KrediYetersiz("Meshy: kredi yetersiz ya da plan uygun değil (402) %s" % ic)
            if 400 <= e.code < 500:
                raise GonderimReddedildi("POST %s → HTTP %d %s" % (yol, e.code, ic))
            raise BelirsizGonderim("POST %s → HTTP %d (görev açılmış olabilir) %s" % (yol, e.code, ic))
        except (urllib.error.URLError, TimeoutError, OSError) as e:
            raise BelirsizGonderim(gizle("POST %s bağlantı hatası (görev açılmış olabilir): %s" % (yol, e), self._anahtar))
        kimlik = cevap.get("result") if isinstance(cevap, dict) else None
        if not kimlik:
            raise BelirsizGonderim("POST %s yanıtında görev kimliği yok: %r" % (yol, str(cevap)[:200]))
        return kimlik

    def bakiye(self):
        return self.get("/v1/balance").get("balance")

    def gorev(self, uc, kimlik):
        return self.get("%s/%s" % (uc, urllib.parse.quote(kimlik)))

    def gorevleri_listele(self, uc, sayfa_sayisi=10, sayfa_boyu=50):
        """En yeniden eskiye görevler. Meshy sayfa_boyu üst sınırı 255."""
        hepsi = []
        for sayfa in range(1, sayfa_sayisi + 1):
            yol = "%s?%s" % (uc, urllib.parse.urlencode({"page_num": sayfa, "page_size": sayfa_boyu, "sort_by": "-created_at"}))
            g = self.get(yol)
            liste = g if isinstance(g, list) else g.get("result", g.get("data", []))
            if not liste:
                break
            hepsi.extend(liste)
            if len(liste) < sayfa_boyu:
                break
        return hepsi

    def bitmesini_bekle(self, uc, kimlik, en_cok_sn=3600):
        """SUCCEEDED görevi döndürür; FAILED/CANCELED'da MeshyHata; süre dolarsa TimeoutError (görev sürer)."""
        son_tarih = time.time() + en_cok_sn
        while time.time() < son_tarih:
            g = self.gorev(uc, kimlik)
            d = g.get("status")
            if d == "SUCCEEDED":
                return g
            if d in ("FAILED", "CANCELED", "EXPIRED"):
                raise MeshyHata("%s %s: %s" % (kimlik, d, (g.get("task_error") or {}).get("message", "")))
            time.sleep(8)
        raise TimeoutError("%s hâlâ bitmedi; kimlik saklandı, sonra `devam` ile sürdürülür" % kimlik)

    def animasyon_kitapligi(self, arama=None):
        yol = "/v1/animations/library" + ("?" + urllib.parse.urlencode({"search": arama}) if arama else "")
        g = self.get(yol)
        return g if isinstance(g, list) else g.get("result", g.get("data", []))


def indir(url, hedef, zaman_asimi=300):
    """Meshy dosya bağlantıları imzalıdır, anahtar istemez. Önce geçici dosyaya iner."""
    os.makedirs(os.path.dirname(hedef), exist_ok=True)
    gecici = hedef + ".iniyor"
    with urllib.request.urlopen(url, timeout=zaman_asimi) as r, open(gecici, "wb") as f:
        while True:
            parca = r.read(1 << 20)
            if not parca:
                break
            f.write(parca)
    os.replace(gecici, hedef)
