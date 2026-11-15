#!/usr/bin/env python3
"""Kapı Muhafızı Meshy üretim hattı: istem → görev → indirme → doğrulama → Godot'a yerleştirme.

Varsayılan kip KURU ÇALIŞTIRMADIR: hiçbir komut, açık `uret --gercek` verilmeden Meshy'de görev açmaz.

Komutlar:
  python3 tools/meshy/meshy_hat.py                  # = kuru: plan, mevcutlar, tahmini kredi (anahtar gerekmez)
  python3 tools/meshy/meshy_hat.py manifest         # planlardan + diskten assets/meshy_manifest.json'u yenile
  python3 tools/meshy/meshy_hat.py kuru [--sadece ID ...] [--oncelik yuksek] [--tur karakter] [--belgeye-yaz]
  python3 tools/meshy/meshy_hat.py gecmis [--esle]  # Meshy hesabındaki görevleri manifestle eşle (ücretsiz)
  python3 tools/meshy/meshy_hat.py uret --gercek --sadece ID ... [--butce N] [--onay-kredi N]
  python3 tools/meshy/meshy_hat.py devam --gercek   # yarım kalan (uretiliyor) satırları sürdür
  python3 tools/meshy/meshy_hat.py dogrula [ID ...] # indirilen GLB'leri ölç (üçgen, boy, pivot, iskelet)
  python3 tools/meshy/meshy_hat.py onayla ID [--not "..."] | reddet ID --neden "..."
  python3 tools/meshy/meshy_hat.py yerlestir [ID ...]   # Godot import + klip ayıklama + Godot doğrulaması

Tekrar üretim engelleri (hepsi her görev açılışından önce):
  1. Manifest durumu uretiliyor/uretildi/onaylandi/mevcut → görev açılmaz; reddedildi → yalnız --yeniden ile.
  2. Aşamanın görev kimliği manifestte varsa yeni görev açılmaz; mevcut görev izlenir.
  3. Hedef dosya diskte ya da eski dalda varsa → mevcut.
  4. Meshy geçmişi taranır: görev adı `KM|<asset_id>|<aşama>` ya da aynı istem → görev benimsenir, yenisi açılmaz.
  5. Görev açmadan önce manifeste `BELIRSIZ` işareti yazılır; yanıt gelmezse sonraki çalıştırma göndermez,
     geçmişte arar (Meshy'de idempotency anahtarı yoktur).
  6. Kilit dosyası iki üretim sürecini aynı anda çalıştırmaz.
  7. Manifestte aynı istem iki üretilecek satırda varsa üretim reddedilir.
"""
import argparse
import os
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import glb_bilgi  # noqa: E402
import manifest as mf  # noqa: E402
import ortak  # noqa: E402
from ortak import KOK  # noqa: E402

BELGE = os.path.join(KOK, "docs", "MESHY_URETIM_SISTEMI.md")
OZET_BAS = "<!-- MESHY_OZET_BASLA -->"
OZET_SON = "<!-- MESHY_OZET_BITIR -->"
UC = {"onizleme": "/v2/text-to-3d", "doku": "/v2/text-to-3d", "iskelet": "/v1/rigging", "hareket": "/v1/animations"}


# ---------------------------------------------------------------- manifest yardımcıları
def manifest_yukle(yenile=False):
    nesne = mf.oku()
    if nesne is None or yenile:
        nesne, _ = mf.guncelle()
    return nesne


def satir_haritasi(nesne):
    return {r["asset_id"]: r for r in nesne["assetler"]}


def kaydet(nesne):
    ayar = ortak.ayarlar_oku()
    for r in nesne["assetler"]:
        r["kredi_tahmini"] = mf.kredi_hesapla(r, ayar)
    mf.yaz(nesne)


def secim(nesne, o, uretilecek=True):
    sonuc = []
    for r in nesne["assetler"]:
        if o.sadece and r["asset_id"] not in o.sadece:
            continue
        if getattr(o, "oncelik", None) and r["oncelik"] != o.oncelik:
            continue
        if getattr(o, "tur", None) and r["tur"] != o.tur:
            continue
        if uretilecek and not (r["meshy_uygun"] and r["durum"] in ("planli", "uretiliyor")):
            continue
        sonuc.append(r)
    return sonuc


# ---------------------------------------------------------------- kuru çalıştırma / özet
def ozet(nesne):
    a = nesne["assetler"]
    say = lambda f: sum(1 for r in a if f(r))  # noqa: E731
    uretilecek = [r for r in a if r["meshy_uygun"] and r["durum"] == "planli"]
    kredi = lambda liste: sum(r["kredi_tahmini"] for r in liste)  # noqa: E731
    tur_toplam = {}
    for r in uretilecek:
        t = tur_toplam.setdefault(r["tur"], [0, 0])
        t[0] += 1
        t[1] += r["kredi_tahmini"]
    onc_toplam = {}
    for r in uretilecek:
        t = onc_toplam.setdefault(r["oncelik"], [0, 0])
        t[0] += 1
        t[1] += r["kredi_tahmini"]
    topluluk_tasarruf = [r for r in uretilecek if r.get("topluluk_adayi")]
    return {
        "toplam_satir": len(a),
        "mevcut": say(lambda r: r["durum"] == "mevcut"),
        "mevcut_meshy": say(lambda r: r["durum"] == "mevcut" and str(r.get("kaynak", "")).startswith("Meshy") and r["tur"] != "topluluk"),
        "mevcut_meshy_model": say(lambda r: r["durum"] == "mevcut" and str(r.get("kaynak", "")).startswith("Meshy") and r["tur"] in ("karakter", "yapi", "nesne", "hayvan")),
        "mevcut_meshy_klip": say(lambda r: r["durum"] == "mevcut" and r["asset_id"].startswith("klip:")),
        "mevcut_eski_dalda": say(lambda r: r["durum"] == "mevcut" and str(r.get("dosya", "")).startswith("git:")),
        "mevcut_harici": say(lambda r: r["durum"] == "mevcut" and r["tur"] == "harici"),
        "planli_uretilecek": len(uretilecek),
        "planli_tahmini_kredi": kredi(uretilecek),
        "uretiliyor": say(lambda r: r["durum"] == "uretiliyor"),
        "uretildi": say(lambda r: r["durum"] == "uretildi"),
        "onaylandi": say(lambda r: r["durum"] == "onaylandi"),
        "reddedildi": say(lambda r: r["durum"] == "reddedildi"),
        "topluluk_indirilecek": say(lambda r: r["tur"] == "topluluk" and r["durum"] != "mevcut"),
        "meshy_disi": say(lambda r: r["tur"] == "duzeltme"),
        "istemsiz": say(lambda r: not r["meshy_uygun"] and "istem" in r.get("uygun_degil_nedeni", "")),
        "tur": tur_toplam,
        "oncelik": onc_toplam,
        "topluluk_adayli_satir": len(topluluk_tasarruf),
        "topluluk_adayli_kredi": kredi(topluluk_tasarruf),
        "on_kosullu_klip_satiri": say(lambda r: r["meshy_uygun"] and r["durum"] == "planli" and r["tur"] == "animasyon" and r.get("hedef_karakter") and not r.get("iskelet_kaynagi")),
    }


def kuru_yazdir(nesne, secilen, tekrarlar):
    oz = ozet(nesne)
    print("== Meshy kuru çalıştırma (görev açılmaz, kredi harcanmaz) ==")
    print("Anahtar: %s | hesap planı: %s" % (ortak.anahtar_kaynagi(), nesne.get("hesap_plani")))
    print("Manifest satırı %d | mevcut %d (Meshy modeli %d, Meshy klibi %d, eski dalda %d, hazır paket %d)"
          % (oz["toplam_satir"], oz["mevcut"], oz["mevcut_meshy_model"], oz["mevcut_meshy_klip"], oz["mevcut_eski_dalda"], oz["mevcut_harici"]))
    print("Üretilecek (planlı) %d satır, tahmini %d kredi | üretimde %d, üretildi %d, onaylı %d, reddedildi %d"
          % (oz["planli_uretilecek"], oz["planli_tahmini_kredi"], oz["uretiliyor"], oz["uretildi"], oz["onaylandi"], oz["reddedildi"]))
    print("Topluluk (kredisiz indirme) %d | Meshy dışı ihtiyaç %d | istemi eksik %d"
          % (oz["topluluk_indirilecek"], oz["meshy_disi"], oz["istemsiz"]))
    if tekrarlar:
        print("UYARI: aynı istem birden çok üretilecek satırda:", tekrarlar)
    if nesne.get("eslenmeyen_envanter"):
        print("UYARI: plan_eki.json'da eşlemesi olmayan envanter kimlikleri:", ", ".join(nesne["eslenmeyen_envanter"]))
    toplam = 0
    print("\n%-4s %-26s %-10s %-7s %6s  %s" % ("#", "asset_id", "tür", "öncelik", "kredi", "not"))
    for i, r in enumerate(secilen, 1):
        toplam += r["kredi_tahmini"]
        notlar = []
        if r.get("topluluk_adayi"):
            notlar.append("topluluk adayı " + "/".join(r["topluluk_adayi"]))
        if r["tur"] == "animasyon" and r.get("hedef_karakter") and not r.get("iskelet_kaynagi"):
            notlar.append("iskelet ön koşulu")
        if r["durum"] == "uretiliyor":
            notlar.append("yarım: devam")
        print("%-4d %-26s %-10s %-7s %6d  %s" % (i, r["asset_id"][:26], r["tur"], r["oncelik"], r["kredi_tahmini"], "; ".join(notlar)))
    print("\nSeçimin tahmini toplamı: %d kredi" % toplam)
    return oz


def belge_ozeti(nesne, tekrarlar):
    oz = ozet(nesne)
    satir = []
    satir.append("_Üreten: `python3 tools/meshy/meshy_hat.py kuru --belgeye-yaz` — %s. Fiyat kaynağı: %s._" % (ortak.simdi(), nesne.get("fiyat_kaynagi")))
    satir.append("")
    satir.append("| Ölçü | Değer |")
    satir.append("|---|---|")
    for ad, deger in [
        ("Manifest satırı (toplam)", oz["toplam_satir"]),
        ("Zaten var (`mevcut`)", oz["mevcut"]),
        ("— Meshy modeli (eski hat; festive + keen-cerf)", oz["mevcut_meshy_model"]),
        ("— Meshy hareket klibi (`assets/model/hareket`)", oz["mevcut_meshy_klip"]),
        ("— yalnız eski dalda (`claude/keen-cerf-42meo7`)", oz["mevcut_eski_dalda"]),
        ("— hazır paket / diğer 3D dosya", oz["mevcut_harici"]),
        ("Meshy ile üretilecek (`planli`)", oz["planli_uretilecek"]),
        ("**Tahmini toplam kredi (planlı hepsi)**", "**%d**" % oz["planli_tahmini_kredi"]),
        ("Topluluk adayı olan planlı satır / kredisi", "%d / %d" % (oz["topluluk_adayli_satir"], oz["topluluk_adayli_kredi"])),
        ("İskelet ön koşullu klip satırı (eski karakterler)", oz["on_kosullu_klip_satiri"]),
        ("Meshy topluluğundan kredisiz indirilecek (CC0)", oz["topluluk_indirilecek"]),
        ("Meshy dışı ihtiyaç (düzeltme, VFX, dört ayaklı klip)", oz["meshy_disi"]),
        ("Üretimde / üretildi / onaylı / reddedildi", "%d / %d / %d / %d" % (oz["uretiliyor"], oz["uretildi"], oz["onaylandi"], oz["reddedildi"])),
        ("Aynı istemli üretilecek satır grubu", len(tekrarlar)),
        ("Eşlemesiz envanter kimliği", len(nesne.get("eslenmeyen_envanter", []))),
    ]:
        satir.append("| %s | %s |" % (ad, deger))
    satir.append("")
    satir.append("**Türe göre (planlı):**")
    satir.append("")
    satir.append("| Tür | Satır | Tahmini kredi |")
    satir.append("|---|---:|---:|")
    for t, (n, k) in sorted(oz["tur"].items()):
        satir.append("| %s | %d | %d |" % (t, n, k))
    satir.append("")
    satir.append("**Önceliğe göre (planlı):**")
    satir.append("")
    satir.append("| Öncelik | Satır | Tahmini kredi | Birikimli kredi |")
    satir.append("|---|---:|---:|---:|")
    birikim = 0
    for o in ("yuksek", "orta", "dusuk"):
        n, k = oz["oncelik"].get(o, (0, 0))
        birikim += k
        satir.append("| %s | %d | %d | %d |" % (o, n, k, birikim))
    satir.append("")
    satir.append("**Öncelik sırası (üretim kuyruğu):**")
    satir.append("")
    satir.append("| # | asset_id | Ad | Tür | Öncelik | Kredi | Plan kimlikleri | Not |")
    satir.append("|---:|---|---|---|---|---:|---|---|")
    uretilecek = [r for r in nesne["assetler"] if r["meshy_uygun"] and r["durum"] == "planli"]
    for i, r in enumerate(uretilecek, 1):
        notlar = []
        if r.get("topluluk_adayi"):
            notlar.append("topluluk adayı: " + ", ".join(r["topluluk_adayi"]))
        if r["tur"] == "animasyon" and r.get("hedef_karakter") and not r.get("iskelet_kaynagi"):
            notlar.append("iskelet ön koşulu")
        if r["tur"] == "animasyon" and r.get("hedef_karakter"):
            notlar.append("klipler: " + ", ".join(r["hareketler"]))
        kimlik = ", ".join(r["plan_kimlikleri"][:4]) + (" …" if len(r["plan_kimlikleri"]) > 4 else "")
        satir.append("| %d | `%s` | %s | %s | %s | %d | %s | %s |" % (i, r["asset_id"], r["ad"].replace("|", "/"), r["tur"], r["oncelik"], r["kredi_tahmini"], kimlik, "; ".join(notlar)))
    return "\n".join(satir)


def belgeye_yaz(nesne, tekrarlar):
    metin = Path(BELGE).read_text(encoding="utf-8")
    if OZET_BAS not in metin or OZET_SON not in metin:
        sys.exit("Belgede özet işaretleri yok: %s" % BELGE)
    bas, kalan = metin.split(OZET_BAS, 1)
    _, son = kalan.split(OZET_SON, 1)
    with open(BELGE, "w", encoding="utf-8", newline="\n") as f:
        f.write(bas + OZET_BAS + "\n" + belge_ozeti(nesne, tekrarlar) + "\n" + OZET_SON + son)
    print("Özet yazıldı:", os.path.relpath(BELGE, KOK))


# ---------------------------------------------------------------- geçmiş eşleme
def gecmis_cek(istemci, ayar):
    import meshy_api
    gorevler = []
    for ad, uc in meshy_api.LISTE_UCLARI.items():
        try:
            liste = istemci.gorevleri_listele(uc, sayfa_sayisi=ayar.get("gecmis_sayfa_sayisi", 10))
        except meshy_api.MeshyHata as e:
            print("  geçmiş okunamadı (%s): %s" % (ad, e))
            continue
        for g in liste:
            g["_uc"] = ad
        gorevler.extend(liste)
    ortak.json_yaz_atomik(ortak.GECMIS_ONBELLEK, {"zaman": ortak.simdi(), "gorevler": gorevler})
    return gorevler


def gecmisle_esle(nesne, gorevler):
    """Manifest satırına ait Meshy görevlerini bulur: önce etiket, sonra aynı istem. {asset_id: {aşama: görev}}."""
    harita = satir_haritasi(nesne)
    istem_dizini = {}
    for r in nesne["assetler"]:
        if r.get("prompt"):
            istem_dizini.setdefault(ortak.istem_normal(r["prompt"])[:600], []).append(r["asset_id"])
    eslesme = {}
    sahipsiz = []
    for g in gorevler:
        e = ortak.etiket_coz(g.get("name"))
        if e and e[0] in harita:
            eslesme.setdefault(e[0], {}).setdefault(e[1], []).append(g)
            continue
        if g.get("_uc") == "text-to-3d" and g.get("prompt"):
            adaylar = istem_dizini.get(ortak.istem_normal(g["prompt"])[:600], [])
            if len(adaylar) == 1:
                asama = "doku" if g.get("mode") == "refine" else "onizleme"
                eslesme.setdefault(adaylar[0], {}).setdefault(asama, []).append(g)
                continue
        sahipsiz.append(g)
    return eslesme, sahipsiz


def esleme_uygula(nesne, eslesme):
    """Eşleşen görevleri manifeste yazar. Başarısız (FAILED) görevler benimsenmez (kredisi iade edilmiştir)."""
    degisen = []
    harita = satir_haritasi(nesne)
    for aid, asamalar in eslesme.items():
        r = harita[aid]
        for asama, liste in asamalar.items():
            iyi = [g for g in liste if g.get("status") != "FAILED"]
            if not iyi:
                continue
            g = sorted(iyi, key=lambda x: x.get("created_at", 0))[-1]
            mevcut = r.setdefault("meshy_gorevleri", {}).get(asama)
            if mevcut and not str(mevcut).startswith("BELIRSIZ"):
                continue
            r["meshy_gorevleri"][asama] = g["id"]
            if asama in ("onizleme", "doku"):
                r["meshy_task_id"] = r["meshy_gorevleri"].get("doku") or r["meshy_gorevleri"].get("onizleme", "")
            if r["durum"] == "planli":
                r["durum"] = "uretiliyor"
            _gunluk(r, "Meshy geçmişinden benimsendi: %s=%s (%s)" % (asama, g["id"], g.get("status")))
            degisen.append((aid, asama, g["id"]))
    return degisen


# ---------------------------------------------------------------- gerçek üretim
def _gunluk(r, metin):
    r.setdefault("uretim_gunlugu", []).append("%s %s" % (ortak.simdi(), metin))


class Durdur(Exception):
    pass


def _govde(r, asama, ayar, ek=None):
    v = ayar["varsayilan"]
    if asama == "onizleme":
        lo, hi = v["poly_sinir"]
        g = {"mode": "preview", "prompt": r["prompt"][:800], "model_type": v["model_type"], "ai_model": v["ai_model"],
             "topology": v["topology"], "target_polycount": max(lo, min(hi, int(r.get("poly_hedef") or 5000))),
             "origin_at": v.get("origin_at", "bottom"), "target_formats": v["target_formats"],
             "name": ortak.etiket(r["asset_id"], asama)}
        if r["tur"] == "karakter":
            g["pose_mode"] = ayar["tur_varsayilan"]["karakter"].get("pose_mode", "a-pose")
        return g
    if asama == "doku":
        return {"mode": "refine", "preview_task_id": r["meshy_gorevleri"]["onizleme"], "enable_pbr": v["enable_pbr"],
                "texture_resolution": v["texture_resolution"], "remove_lighting": v.get("remove_lighting", True),
                "target_formats": v["target_formats"], "name": ortak.etiket(r["asset_id"], asama)}
    if asama == "iskelet":
        girdi = r["meshy_gorevleri"].get("doku") or r["meshy_gorevleri"]["onizleme"]
        return {"input_task_id": girdi, "height_meters": r.get("boy_m") or 1.7, "name": ortak.etiket(r["asset_id"], asama)}
    if asama.startswith("hareket:"):
        return {"rig_task_id": ek["rig"], "action_id": ek["action_id"],
                "post_process": {"operation_type": "change_fps", "fps": 30}, "name": ortak.etiket(r["asset_id"], asama)}
    raise ValueError(asama)


def _gorev_ac(istemci, nesne, r, asama, govde, o):
    """Yazmadan-önce-kaydet: işaret → POST → kimlik. Hiçbir koşulda aynı aşamayı ikinci kez göndermez."""
    import meshy_api
    gorevler = r.setdefault("meshy_gorevleri", {})
    var = gorevler.get(asama)
    if var and not str(var).startswith("BELIRSIZ"):
        return var
    if var:
        raise Durdur("%s/%s: önceki gönderimin sonucu belirsiz (%s). Görev açılmış olabilir; `gecmis --esle` ile "
                     "arayın. Meshy'de gerçekten yoksa `uret --belirsizi-sifirla %s` ile işareti kaldırın." % (r["asset_id"], asama, var, r["asset_id"]))
    gorevler[asama] = "BELIRSIZ@" + ortak.simdi()
    r["durum"] = "uretiliyor"
    _gunluk(r, "gönderiliyor: %s" % asama)
    kaydet(nesne)
    uc = UC["hareket" if asama.startswith("hareket:") else asama]
    try:
        kimlik = istemci.post_gorev(uc, govde)
    except meshy_api.GonderimReddedildi as e:
        del gorevler[asama]
        if not any(v for v in gorevler.values()):
            r["durum"] = "planli"
        _gunluk(r, "reddedildi (görev açılmadı): %s" % e)
        kaydet(nesne)
        raise Durdur("%s/%s: %s" % (r["asset_id"], asama, e))
    except meshy_api.BelirsizGonderim as e:
        _gunluk(r, "belirsiz gönderim: %s" % e)
        kaydet(nesne)
        raise Durdur("%s/%s: %s — tekrar gönderilmeyecek; geçmişte aranacak." % (r["asset_id"], asama, e))
    gorevler[asama] = kimlik
    if asama in ("onizleme", "doku"):
        r["meshy_task_id"] = gorevler.get("doku") or gorevler.get("onizleme", "")
    _gunluk(r, "görev açıldı: %s=%s" % (asama, kimlik))
    kaydet(nesne)
    return kimlik


def _bekle(istemci, nesne, r, asama, ayar):
    import meshy_api
    uc = UC["hareket" if asama.startswith("hareket:") else asama]
    try:
        g = istemci.bitmesini_bekle(uc, r["meshy_gorevleri"][asama], ayar.get("gorev_bekleme_sn", 3600))
    except TimeoutError as e:
        raise Durdur(str(e))
    except meshy_api.MeshyHata as e:
        r["meshy_gorevleri"].pop(asama, None)
        _gunluk(r, "Meshy görevi başarısız (kredi iade edilir): %s — %s" % (asama, e))
        kaydet(nesne)
        raise Durdur("%s/%s başarısız: %s" % (r["asset_id"], asama, e))
    r["kredi_harcanan"] = int(r.get("kredi_harcanan") or 0)
    sayilan = r.setdefault("_sayilan_gorev", [])
    if g.get("id") not in sayilan and g.get("consumed_credits") is not None:
        r["kredi_harcanan"] += int(g["consumed_credits"])
        sayilan.append(g.get("id"))
    return g


def _indir_kaydet(r, url, goreli):
    import meshy_api
    meshy_api.indir(url, os.path.join(KOK, goreli))
    return goreli


def _hareket_kimligi(istemci, r, hareket, ayar, nesne):
    onbellek = nesne.setdefault("_kitaplik", {})
    if hareket in onbellek:
        return onbellek[hareket]
    sys.path.insert(0, os.path.join(KOK, "tools", "model"))
    import chr_istemleri
    adaylar = list(r.get("kitaplik") or chr_istemleri.HAREKETLER.get(hareket, [hareket]))
    for aday in adaylar:
        for x in istemci.animasyon_kitapligi(aday):
            if aday.lower() in (str(x.get("key", "")).lower(), str(x.get("name", "")).lower()):
                onbellek[hareket] = {"id": int(x.get("action_id", x.get("id"))), "ad": x.get("name", aday)}
                kaydet(nesne)
                return onbellek[hareket]
    raise Durdur("Kitaplıkta bulunamadı: %s %s — plan_eki.json 'kitaplik' anahtarını düzeltin (arama ücretsiz)." % (hareket, adaylar))


def uret_satir(istemci, nesne, r, ayar, o):
    ad = r["asset_id"]
    tv = ayar["tur_varsayilan"]
    if r["tur"] in ("karakter", "yapi", "nesne", "hayvan"):
        _gorev_ac(istemci, nesne, r, "onizleme", _govde(r, "onizleme", ayar), o)
        son = _bekle(istemci, nesne, r, "onizleme", ayar)
        if r.get("doku"):
            _gorev_ac(istemci, nesne, r, "doku", _govde(r, "doku", ayar), o)
            son = _bekle(istemci, nesne, r, "doku", ayar)
        klasor = tv[r["tur"]]["klasor"]
        if not r.get("iskelet"):
            r["dosya"] = _indir_kaydet(r, son["model_urls"]["glb"], "%s/%s.glb" % (klasor, ad))
        else:
            ham = _indir_kaydet(r, son["model_urls"]["glb"], "%s/%s.glb" % (klasor, ad))
            _gorev_ac(istemci, nesne, r, "iskelet", _govde(r, "iskelet", ayar), o)
            rig = _bekle(istemci, nesne, r, "iskelet", ayar)["result"]
            iskelet = _indir_kaydet(r, rig["rigged_character_glb_url"], "%s/%s_iskelet.glb" % (klasor, ad))
            r["dosya"] = _indir_kaydet(r, rig["basic_animations"]["walking_glb_url"], "%s/%s_yuru.glb" % (klasor, ad))
            ek = [ham, iskelet]
            if rig.get("basic_animations", {}).get("running_glb_url"):
                ek.append(_indir_kaydet(r, rig["basic_animations"]["running_glb_url"], "%s/%s_kos.glb" % (klasor, ad)))
            r["ek_dosyalar"] = sorted(set(r.get("ek_dosyalar", []) + ek))
            for h in r.get("hareketler") or []:
                _hareket_uret(istemci, nesne, r, h, r["meshy_gorevleri"]["iskelet"], ad, ayar, o)
    elif r["tur"] == "animasyon":
        rig, hedef = _rig_bul(nesne, r, ayar)
        for h in r.get("hareketler") or []:
            _hareket_uret(istemci, nesne, r, h, rig, hedef, ayar, o)
        r["dosya"] = r["ek_dosyalar"][0] if r.get("ek_dosyalar") else ""
    else:
        raise Durdur("%s: tür %s Meshy ile üretilmez" % (ad, r["tur"]))
    if r.get("dosya"):
        r["sha256"] = ortak.sha256_dosya(os.path.join(KOK, r["dosya"]))
        bilgi = glb_bilgi.incele(os.path.join(KOK, r["dosya"]))
        r["dogrulama"] = {"zaman": ortak.simdi(), "bilgi": bilgi, "gozlem": glb_bilgi.dogrula(bilgi, r)}
    r["durum"] = "uretildi"
    r["hesap_plani_uretimde"] = ayar.get("hesap_plani")
    _gunluk(r, "üretildi: %s" % r.get("dosya"))
    kaydet(nesne)


def _rig_bul(nesne, r, ayar):
    harita = satir_haritasi(nesne)
    if r.get("hedef_karakter"):
        k = harita.get(r["hedef_karakter"], {})
        rig = r.get("iskelet_kaynagi") or (k.get("meshy_gorevleri") or {}).get("iskelet")
        if not rig:
            raise Durdur("%s: hedef karakterin iskelet görevi yok (ön koşul). Kredi harcanmadı." % r["asset_id"])
        return rig, r["hedef_karakter"]
    ref = ayar.get("referans_iskelet")
    k = harita.get(ref or "", {})
    rig = (k.get("meshy_gorevleri") or {}).get("iskelet")
    if not rig:
        raise Durdur("%s: ayarlar.json 'referans_iskelet' yeni hatla iskeleti üretilmiş bir karakter olmalı. Kredi harcanmadı." % r["asset_id"])
    return rig, ref


def _hareket_uret(istemci, nesne, r, h, rig, hedef_ad, ayar, o):
    asama = "hareket:" + h
    klip_ad = h.replace("anim_", "") if h.startswith("anim_") else h
    goreli = "%s/%s_%s.glb" % (ayar["tur_varsayilan"]["animasyon"]["klasor"], hedef_ad, klip_ad)
    if os.path.exists(os.path.join(KOK, goreli)) or os.path.exists(os.path.join(KOK, "assets/model/hareket/%s_%s.res" % (hedef_ad, klip_ad))):
        _gunluk(r, "klip diskte var, atlandı: %s" % goreli)
        return
    k = _hareket_kimligi(istemci, r, h, ayar, nesne)
    _gorev_ac(istemci, nesne, r, asama, _govde(r, asama, ayar, {"rig": rig, "action_id": k["id"]}), o)
    g = _bekle(istemci, nesne, r, asama, ayar)
    _indir_kaydet(r, g["result"]["animation_glb_url"], goreli)
    r["ek_dosyalar"] = sorted(set(r.get("ek_dosyalar", []) + [goreli]))
    kaydet(nesne)


def uretim(o, sadece_yarim=False):
    import meshy_api
    ayar = ortak.ayarlar_oku()
    if not o.gercek:
        sys.exit("Gerçek üretim için --gercek bayrağı gerekir. Önce kuru çalıştırmayı inceleyin: python3 tools/meshy/meshy_hat.py kuru")
    if ayar.get("hesap_plani") not in ("ucretli", "ucretsiz"):
        sys.exit("tools/meshy/ayarlar.json 'hesap_plani' ucretli ya da ucretsiz olmalı (lisans notu için). Şu an: %s" % ayar.get("hesap_plani"))
    if not sadece_yarim and not o.sadece and not o.oncelik:
        sys.exit("Toplu üretim kapalı: --sadece ID ... ya da --oncelik yuksek|orta|dusuk ile seçim yapın.")
    with ortak.UretimKilidi():
        nesne, tekrarlar = mf.guncelle()
        anahtar = ortak.anahtar_al()
        istemci = meshy_api.Istemci(anahtar)
        print("Meshy geçmişi taranıyor (ücretsiz)…")
        gorevler = gecmis_cek(istemci, ayar)
        eslesme, _ = gecmisle_esle(nesne, gorevler)
        for aid, asama, gid in esleme_uygula(nesne, eslesme):
            print("  benimsendi: %s %s=%s" % (aid, asama, gid))
        if o.belirsizi_sifirla:
            harita = satir_haritasi(nesne)
            for aid in o.belirsizi_sifirla:
                r = harita[aid]
                for k in [k for k, v in r.get("meshy_gorevleri", {}).items() if str(v).startswith("BELIRSIZ")]:
                    del r["meshy_gorevleri"][k]
                    _gunluk(r, "belirsiz işaret elle sıfırlandı (%s); geçmişte görev bulunmadı" % k)
                if not any(r.get("meshy_gorevleri", {}).values()):
                    r["durum"] = "planli"
        if o.yeniden:
            harita = satir_haritasi(nesne)
            for aid in o.yeniden:
                r = harita[aid]
                if r["durum"] == "uretiliyor":
                    sys.exit("%s üretimde; --yeniden kullanılamaz." % aid)
                _gunluk(r, "AÇIK KARARLA yeniden üretim: önceki durum %s, dosya %s" % (r["durum"], r.get("dosya")))
                r.setdefault("onceki_uretimler", []).append({k: r.get(k) for k in ("durum", "dosya", "sha256", "meshy_gorevleri", "meshy_task_id")})
                r.update(durum="planli", meshy_gorevleri={}, meshy_task_id="", meshy_uygun=True)
                taze_satir = mf.kur(ayar)[0].get(aid)
                if taze_satir and taze_satir.get("prompt"):
                    r["prompt"] = taze_satir["prompt"]
                    r["prompt_ozeti"] = taze_satir["prompt_ozeti"]
                if r["tur"] == "harici":
                    sys.exit("%s hazır paket dosyası; Meshy ile yeniden üretilmez." % aid)
        kaydet(nesne)
        secilen = [r for r in secim(nesne, o) if (r["durum"] == "uretiliyor") or not sadece_yarim]
        if tekrarlar:
            cakisan = {k: v for k, v in tekrarlar.items() if any(x in {r["asset_id"] for r in secilen} for x in v)}
            if cakisan:
                sys.exit("Aynı istem birden çok satırda; önce birini düzeltin: %s" % cakisan)
        if not secilen:
            print("Üretilecek satır yok (hepsi mevcut/üretilmiş ya da seçim boş).")
            return
        toplam = sum(r["kredi_tahmini"] for r in secilen)
        kuru_yazdir(nesne, secilen, {})
        bakiye = istemci.bakiye()
        print("Meshy bakiyesi: %s kredi | bütçe: %s" % (bakiye, o.butce if o.butce is not None else "yok"))
        if bakiye is not None and bakiye < min(toplam, o.butce if o.butce is not None else toplam):
            sys.exit("Bakiye tahmini harcamadan az; üretim başlatılmadı.")
        if o.onay_kredi is None:
            if not sys.stdin.isatty():
                sys.exit("Etkileşimsiz çalışma: onay için --onay-kredi %d verin." % toplam)
            cevap = input("Onaylamak için tahmini krediyi yazın (%d): " % toplam).strip()
            if cevap != str(toplam):
                sys.exit("Onay verilmedi; kredi harcanmadı.")
        elif o.onay_kredi != toplam:
            sys.exit("--onay-kredi %d ≠ tahmini %d; seçim değişmiş olabilir. Kredi harcanmadı." % (o.onay_kredi, toplam))
        harcanan = 0
        for r in secilen:
            m = r["kredi_tahmini"]
            if o.butce is not None and harcanan + m > o.butce:
                print("Bütçe doldu; %s atlandı." % r["asset_id"])
                continue
            print("→ %s (%d kredi)" % (r["asset_id"], m), flush=True)
            try:
                uret_satir(istemci, nesne, r, ayar, o)
                harcanan += m
                print("  bitti:", r.get("dosya"))
            except Durdur as e:
                print("  DURDU:", e)
            except meshy_api.MeshyHata as e:
                print("  HATA:", ortak.gizle(e, anahtar))
        print("Son bakiye:", istemci.bakiye())
        print("Manifesti hemen commit edin (diğer ajanlar/makineler aynı asset'i yeniden üretmesin).")


# ---------------------------------------------------------------- doğrulama / onay
def dogrula_komut(o):
    nesne = manifest_yukle()
    harita = satir_haritasi(nesne)
    hedefler = [harita[x] for x in o.ids] if o.ids else [r for r in nesne["assetler"] if r["durum"] in ("uretildi", "onaylandi") and r.get("dosya")]
    if not hedefler:
        print("Doğrulanacak üretilmiş dosya yok.")
    for r in hedefler:
        yol = os.path.join(KOK, r["dosya"])
        if not os.path.exists(yol):
            print("%-24s dosya yok: %s" % (r["asset_id"], r["dosya"]))
            continue
        bilgi = glb_bilgi.incele(yol)
        gozlem = glb_bilgi.dogrula(bilgi, r)
        if r["durum"] in ("uretildi", "onaylandi"):
            r["dogrulama"] = {"zaman": ortak.simdi(), "bilgi": bilgi, "gozlem": gozlem}
            r["sha256_simdi"] = ortak.sha256_dosya(yol)
        print("%-24s %s" % (r["asset_id"], "; ".join("%s:%s %s" % g for g in gozlem)))
    if any(r["durum"] in ("uretildi", "onaylandi") for r in hedefler):
        kaydet(nesne)


def durum_degistir(o, yeni):
    nesne = manifest_yukle()
    r = satir_haritasi(nesne).get(o.id)
    if not r:
        sys.exit("Manifestte yok: %s" % o.id)
    if r["durum"] not in ("uretildi", "onaylandi", "reddedildi"):
        sys.exit("%s durumu %s; yalnız üretilmiş satır onaylanır/reddedilir." % (o.id, r["durum"]))
    r["durum"] = yeni
    if yeni == "onaylandi":
        r["onay_notu"] = o.not_ or ""
    else:
        r["red_nedeni"] = o.neden
    _gunluk(r, "%s: %s" % (yeni, o.not_ if yeni == "onaylandi" else o.neden))
    kaydet(nesne)
    print("%s → %s" % (o.id, yeni))


def yerlestir_komut(o):
    godot = os.environ.get("GODOT_BIN") or "godot"
    adim = [[godot, "--headless", "--path", KOK, "--import"],
            [godot, "--headless", "--path", KOK, "-s", "tools/model/klip_ayikla.gd"]]
    nesne = manifest_yukle()
    harita = satir_haritasi(nesne)
    secilen = [harita[x] for x in o.ids] if o.ids else [r for r in nesne["assetler"] if r["durum"] in ("uretildi", "onaylandi")]
    yollar = ["res://" + r["dosya"] for r in secilen if r.get("dosya") and not r["dosya"].startswith("git:")]
    if yollar:
        adim.append([godot, "--headless", "--path", KOK, "-s", "tools/meshy/godot_dogrula.gd", "--"] + yollar)
    for a in adim:
        print("$", " ".join(a))
        if subprocess.run(a).returncode != 0:
            sys.exit("Adım başarısız.")


# ---------------------------------------------------------------- giriş
def main(argv=None):
    p = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    alt = p.add_subparsers(dest="komut")

    def secim_arg(sp):
        sp.add_argument("--sadece", nargs="*")
        sp.add_argument("--oncelik", choices=["yuksek", "orta", "dusuk"])
        sp.add_argument("--tur", choices=list(ortak.TURLER))

    sp = alt.add_parser("kuru")
    secim_arg(sp)
    sp.add_argument("--belgeye-yaz", action="store_true")
    sp.add_argument("--yenileme", action="store_true", help="manifesti planlardan yenilemeden oku")
    alt.add_parser("manifest").add_argument("--eski-dalsiz", action="store_true")
    sp = alt.add_parser("gecmis")
    sp.add_argument("--esle", action="store_true", help="eşleşen görevleri manifeste yaz")
    for ad in ("uret", "devam"):
        sp = alt.add_parser(ad)
        secim_arg(sp)
        sp.add_argument("--gercek", action="store_true")
        sp.add_argument("--butce", type=int)
        sp.add_argument("--onay-kredi", type=int)
        sp.add_argument("--yeniden", nargs="*", default=[], help="mevcut/reddedilen asset'i AÇIK KARARLA yeniden üret")
        sp.add_argument("--belirsizi-sifirla", nargs="*", default=[])
    sp = alt.add_parser("dogrula")
    sp.add_argument("ids", nargs="*")
    sp = alt.add_parser("onayla")
    sp.add_argument("id")
    sp.add_argument("--not", dest="not_")
    sp = alt.add_parser("reddet")
    sp.add_argument("id")
    sp.add_argument("--neden", required=True)
    sp = alt.add_parser("yerlestir")
    sp.add_argument("ids", nargs="*")
    o = p.parse_args(argv)
    komut = o.komut or "kuru"

    if komut == "manifest":
        nesne, tekrarlar = mf.guncelle(eski_dal=not o.eski_dalsiz)
        mf.yaz(nesne)
        kuru_yazdir(nesne, [], tekrarlar)
        print("Yazıldı:", os.path.relpath(ortak.MANIFEST, KOK), "+", os.path.relpath(ortak.MANIFEST_CSV, KOK))
    elif komut == "kuru":
        if o.komut is None:
            o = argparse.Namespace(sadece=None, oncelik=None, tur=None, belgeye_yaz=False, yenileme=False)
        if o.yenileme:
            nesne, tekrarlar = manifest_yukle(), {}
        else:
            nesne, tekrarlar = mf.guncelle()
        kuru_yazdir(nesne, secim(nesne, o), tekrarlar)
        if o.belgeye_yaz:
            belgeye_yaz(nesne, tekrarlar)
    elif komut == "gecmis":
        import meshy_api
        ayar = ortak.ayarlar_oku()
        istemci = meshy_api.Istemci(ortak.anahtar_al())
        nesne = manifest_yukle()
        gorevler = gecmis_cek(istemci, ayar)
        eslesme, sahipsiz = gecmisle_esle(nesne, gorevler)
        print("Meshy geçmişi: %d görev | manifestle eşleşen asset %d | sahipsiz görev %d" % (len(gorevler), len(eslesme), len(sahipsiz)))
        for aid, asamalar in sorted(eslesme.items()):
            print("  %-24s %s" % (aid, ", ".join("%s:%s" % (a, "/".join(g.get("status", "?") for g in l)) for a, l in asamalar.items())))
        if o.esle:
            with ortak.UretimKilidi():
                nesne = manifest_yukle()
                degisen = esleme_uygula(nesne, eslesme)
                kaydet(nesne)
                print("Manifeste yazılan eşleşme: %d" % len(degisen))
    elif komut in ("uret", "devam"):
        uretim(o, sadece_yarim=(komut == "devam"))
    elif komut == "dogrula":
        dogrula_komut(o)
    elif komut == "onayla":
        durum_degistir(o, "onaylandi")
    elif komut == "reddet":
        durum_degistir(o, "reddedildi")
    elif komut == "yerlestir":
        yerlestir_komut(o)


if __name__ == "__main__":
    main()
