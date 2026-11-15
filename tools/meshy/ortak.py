"""Meshy üretim hattının ortak sabitleri ve yardımcıları.

Anahtar kuralı: anahtar yalnız `MESHY_API_KEY` ortam değişkeninden ya da git'e girmeyen
`.meshy-api-key` dosyasından okunur. Hiçbir fonksiyon anahtarı yazdırmaz, loglamaz, dosyaya yazmaz.
"""
import contextlib
import hashlib
import json
import os
import re
import sys
import tempfile
import time
import unicodedata
from datetime import datetime, timezone

KOK = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."))
HAT = os.path.dirname(os.path.abspath(__file__))
MANIFEST = os.path.join(KOK, "assets", "meshy_manifest.json")
MANIFEST_CSV = os.path.join(KOK, "assets", "meshy_manifest.csv")
AYARLAR = os.path.join(HAT, "ayarlar.json")
PLAN_EKI = os.path.join(HAT, "plan_eki.json")
ANAHTAR_DOSYASI = os.path.join(KOK, ".meshy-api-key")
KILIT = os.path.join(HAT, ".uretim.kilit")
GECMIS_ONBELLEK = os.path.join(HAT, ".meshy_gecmis.json")
ESKI_DURUM = os.path.join(KOK, "tools", "model", "durum.json")

DURUMLAR = ("planli", "uretiliyor", "uretildi", "onaylandi", "reddedildi", "mevcut")
# Bu durumlardaki bir asset için yeni Meshy görevi asla açılmaz.
KILITLI_DURUMLAR = ("uretiliyor", "uretildi", "onaylandi", "mevcut")
TURLER = ("karakter", "yapi", "nesne", "hayvan", "animasyon", "topluluk", "duzeltme", "harici")
ONCELIK_SIRASI = {"yuksek": 0, "orta": 1, "dusuk": 2}

# Görev adı etiketi: Meshy geçmişinde asset'i bulmak için her görevin `name` alanına yazılır.
ETIKET_ON = "KM"


def etiket(asset_id, asama):
    return "%s|%s|%s" % (ETIKET_ON, asset_id, asama)


def etiket_coz(ad):
    parca = str(ad or "").split("|")
    if len(parca) == 3 and parca[0] == ETIKET_ON:
        return parca[1], parca[2]
    return None


def simdi():
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def ayarlar_oku():
    with open(AYARLAR, encoding="utf-8") as f:
        return json.load(f)


def sha256_dosya(yol):
    h = hashlib.sha256()
    with open(yol, "rb") as f:
        for parca in iter(lambda: f.read(1 << 20), b""):
            h.update(parca)
    return h.hexdigest()


def sha256_bayt(veri):
    return hashlib.sha256(veri).hexdigest()


def istem_normal(metin):
    """Aynı istemin farklı boşluk/büyük harfle iki kez gönderilmesini yakalamak için normal biçim."""
    metin = unicodedata.normalize("NFKC", str(metin or "")).lower()
    return re.sub(r"[^a-z0-9]+", " ", metin).strip()


def istem_ozeti(metin):
    return hashlib.sha256(istem_normal(metin).encode()).hexdigest()[:16]


def json_yaz_atomik(yol, veri):
    """Yarım yazılmış manifest bırakmamak için geçici dosyaya yazıp yerine taşır."""
    klasor = os.path.dirname(yol)
    os.makedirs(klasor, exist_ok=True)
    fd, gecici = tempfile.mkstemp(prefix=".tmp_", dir=klasor)
    try:
        with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as f:
            json.dump(veri, f, ensure_ascii=False, indent=1)
            f.write("\n")
        os.replace(gecici, yol)
    except BaseException:
        with contextlib.suppress(OSError):
            os.unlink(gecici)
        raise


def anahtar_al(zorunlu=True):
    """Anahtarı döndürür; yoksa None ya da çıkış. Anahtarın kendisi hiçbir çıktıya yazılmaz."""
    anahtar = os.environ.get("MESHY_API_KEY", "").strip()
    if not anahtar and os.path.isfile(ANAHTAR_DOSYASI):
        with open(ANAHTAR_DOSYASI, encoding="utf-8-sig") as f:
            anahtar = f.read().strip()
    if anahtar:
        return anahtar
    if zorunlu:
        sys.exit("Meshy anahtarı yok: MESHY_API_KEY ortam değişkenini ya da repo kökünde "
                 "git'e girmeyen .meshy-api-key dosyasını kullanın (bkz. docs/MESHY_URETIM_SISTEMI.md).")
    return None


def anahtar_kaynagi():
    if os.environ.get("MESHY_API_KEY", "").strip():
        return "ortam değişkeni (MESHY_API_KEY)"
    if os.path.isfile(ANAHTAR_DOSYASI):
        return "yerel dosya (.meshy-api-key)"
    return "yok"


def gizle(metin, anahtar):
    """Hata metinlerinde anahtar geçerse maskeler."""
    metin = str(metin)
    if anahtar:
        metin = metin.replace(anahtar, "msy_***")
    return re.sub(r"msy_[A-Za-z0-9_\-]{6,}", "msy_***", metin)


class UretimKilidi:
    """Aynı makinede iki üretim sürecinin aynı anda çalışmasını engeller (O_EXCL kilit dosyası)."""

    def __init__(self, yol=KILIT):
        self.yol = yol
        self.fd = None

    def __enter__(self):
        try:
            self.fd = os.open(self.yol, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
        except FileExistsError:
            try:
                with open(self.yol, encoding="utf-8") as f:
                    bilgi = f.read().strip()
            except OSError:
                bilgi = "?"
            sys.exit("Başka bir Meshy üretim süreci çalışıyor ya da yarım kaldı (kilit: %s; %s). "
                     "Süreç gerçekten yoksa kilidi elle silin." % (os.path.relpath(self.yol, KOK), bilgi))
        os.write(self.fd, ("pid=%d zaman=%s" % (os.getpid(), simdi())).encode())
        return self

    def __exit__(self, *_):
        if self.fd is not None:
            os.close(self.fd)
            with contextlib.suppress(OSError):
                os.unlink(self.yol)


def bekle_saniye(s):
    time.sleep(s)
