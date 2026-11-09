"""KLT: söz dosyası oyuna girmeden önceki tek kapı.

Godot başlatmaz, user:// yazmaz, data/soz silmez. Metin üretmez.
Yasak kalıplar USLUP_REHBERI.md §1 ve §3'tedir; ikinci yasak dosyası yoktur.
"""
from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from pathlib import Path

if __package__:
    from .metin_dogrula import ogretici_uzunluk_hatasi
else:
    from metin_dogrula import ogretici_uzunluk_hatasi

ROOT = Path(__file__).resolve().parents[1]
SIRA = ("kitap", "taslak", "yapaylik", "kor_okuma", "kota", "onay", "kopya")
ONAY = ("anlati", "ahmet")
KOTA_DEDIKODU = 0.20
KOR_AGIZ = 3
KOR_ALT = 0.70
YONERGE = ("tıkla", "tikla", "menüye dön", "menuye don")
YILLAR = ("1240", "1243")
IS_EMRI = ("is_ata", "gorev_ver")
USLUP = ROOT / "Roadmap-2" / "USLUP_REHBERI.md"
BINA = ROOT / "data" / "koy" / "binalar.json"
MESLEK = ROOT / "data" / "meslek_binalari.json"
KADRO_OZGUNLUK = ROOT / "data" / "soz" / "kadro_ozgunluk.json"
KURALLAR = KADRO_OZGUNLUK.with_name("kurallar.json")
SIR_KOTASI = "sir_cekirdegi_kotasi_yuzde_max"
SOZ = ROOT / "data" / "soz"
ESKI_DIYALOG = ROOT / "data" / "diyalog" / "diyalog_01_20.json"
ESKI_SOHBET = ROOT / "data" / "sohbetler"
METIN_TABLOSU = ROOT / "data" / "metin" / "metinler.csv"
# Kısa selam ve tek kelimelik cevaplar ortak dildir; kopya sayılmaz.
ESKI_ASGARI_KELIME = 4


def _modern_kelimeler() -> list[str]:
    metin = USLUP.read_text(encoding="utf-8")
    satir = next((s for s in metin.splitlines() if "Kaçınılacak modern sözler" in s), "")
    return [k.strip() for k in satir.split(":", 1)[-1].split(",") if k.strip()]


def _soyut_kelimeler() -> list[str]:
    return ["umut", "kader", "yalnızlık", "hayat", "geçmiş"]


def bina_adlari() -> set[str]:
    veri = json.loads(BINA.read_text(encoding="utf-8"))
    return {k for k in veri if not str(k).startswith("_")}


def meslek_adlari() -> set[str]:
    veri = json.loads(MESLEK.read_text(encoding="utf-8"))
    return {str(k).lower() for k in veri.get("meslekler", {})} | {"ciftci", "esnaf", "asker"}


def denetle(paket: dict, kor_satirlari: list[dict] | None = None) -> tuple[list[dict], list[dict]]:
    hatalar: list[dict] = []
    uyarilar: list[dict] = []
    if paket.get("sira_zorunlu") is True:
        hatalar.append({"tur": "hata", "kod": "KLT-03", "mesaj": "zorunlu sira"})
    if not paket.get("kutu", False):
        hatalar.append({"tur": "hata", "kod": "KLT-26", "mesaj": "kutusuz paket"})
    adimlar = [str(a) for a in paket.get("adimlar", [])]
    atlanan = paket.get("atlama", [])
    if not isinstance(atlanan, list):
        atlanan = []
    sebepsiz = [a for a in atlanan if not str(a.get("sebep", "")).strip()]
    if sebepsiz:
        hatalar.append({"tur": "hata", "kod": "KLT-27", "mesaj": "sebepsiz atlama"})
    atlanan_adim = {str(a.get("adim", "")) for a in atlanan if str(a.get("sebep", "")).strip()}
    for adim in SIRA[:-1]:
        if adim not in adimlar and adim not in atlanan_adim:
            hatalar.append({"tur": "hata", "kod": "KLT-01", "mesaj": "adim yok: " + adim})
    onay = [str(a).strip() for a in paket.get("onay", [])]
    if any(not a for a in paket.get("onay", [])) or onay != list(ONAY):
        hatalar.append({"tur": "hata", "kod": "KLT-02", "mesaj": "onay iki isim ister"})
    if paket.get("prototip_kaydi") and not paket.get("onay"):
        hatalar.append({"tur": "hata", "kod": "KLT-53", "mesaj": "prototip onay sayilmaz"})
    kor = {str(s.get("id", "")): s for s in (kor_satirlari or [])}
    kimlik = str(paket.get("id", ""))
    skor = kor.get(kimlik)
    if skor is None or int(skor.get("agiz", 0)) < KOR_AGIZ or "skor" not in skor:
        hatalar.append({"tur": "hata", "kod": "KLT-05", "mesaj": "kor okuma satiri yok"})
    elif KOR_AGIZ:
        deger = float(skor.get("skor", 0))
        sans = 1.0 / int(skor.get("agiz", KOR_AGIZ))
        if sans < deger < KOR_ALT:
            uyarilar.append({"tur": "uyari", "kod": "KLT-05", "mesaj": "ses kartlari yakin"})
    cekirdek = [str(c) for c in paket.get("cekirdekler", [])]
    if cekirdek and sum(c == "dedikodu" for c in cekirdek) / len(cekirdek) > KOTA_DEDIKODU:
        hatalar.append({"tur": "hata", "kod": "KLT-06", "mesaj": "dedikodu kotasi"})
    if kota_hatasi := _sir_kotasi_hatasi(_cekirdek_kota_sayimi(cekirdek)):
        kod, mesaj = kota_hatasi
        hatalar.append({"tur": "hata", "kod": kod, "mesaj": mesaj})
    hatalar.extend(_satir_hatalari(paket))
    hatalar.extend(_kopya_hatalari(paket))
    uyarilar.extend(_satir_uyarilari(paket))
    return hatalar, uyarilar


def _cumle_anahtari(metin: str) -> str:
    kucuk = metin.replace("İ", "i").replace("I", "i").casefold().replace("ı", "i")
    sade = re.sub(r"[^\w\s]", " ", kucuk)
    return " ".join(sade.split())


def _json_metinleri(veri) -> list[str]:
    if isinstance(veri, str):
        return [veri]
    if isinstance(veri, dict):
        return [m for v in veri.values() for m in _json_metinleri(v)]
    if isinstance(veri, list):
        return [m for v in veri for m in _json_metinleri(v)]
    return []


def eski_cumleler() -> set[str]:
    """DIY-16 öncesi konuşma metni: eski soru dizisi ve SohbetVerisi'nin metin tablosundaki satırları."""
    metinler = _json_metinleri(json.loads(ESKI_DIYALOG.read_text(encoding="utf-8-sig")))
    anahtarlar: set[str] = set()
    for yol in sorted(ESKI_SOHBET.glob("*.tres")):
        anahtarlar.update(re.findall(r'"(sohbet\.[^"]+)"', yol.read_text(encoding="utf-8-sig")))
    with METIN_TABLOSU.open(encoding="utf-8-sig", newline="") as dosya:
        metinler.extend(s.get("tr", "") for s in csv.DictReader(dosya) if s.get("keys") in anahtarlar)
    return {a for a in map(_cumle_anahtari, metinler) if len(a.split()) >= ESKI_ASGARI_KELIME}


def _kopya_hatalari(paket: dict, eski: set[str] | None = None) -> list[dict]:
    eski = eski_cumleler() if eski is None else eski
    hatalar = []
    for satir in paket.get("satirlar", []):
        if isinstance(satir, dict) and _cumle_anahtari(str(satir.get("metin", ""))) in eski:
            hatalar.append({"tur": "hata", "kod": "KLT-48", "mesaj": "eski metin kopyasi: " + str(satir.get("id", ""))})
    return hatalar


def soz_kopya_taramasi(klasor: Path = SOZ, eski: set[str] | None = None) -> list[tuple[str, str]]:
    """`data/soz` altındaki her metinde eski konuşma cümlesi arar; bulunan her cümle bir hatadır."""
    eski = eski_cumleler() if eski is None else eski
    bulunan = []
    for yol in sorted(klasor.rglob("*.json")):
        try:
            veri = json.loads(yol.read_text(encoding="utf-8-sig"))
        except ValueError:
            continue
        for metin in _json_metinleri(veri):
            if _cumle_anahtari(metin) in eski:
                bulunan.append((yol.relative_to(klasor).as_posix(), metin))
    return bulunan


def _cekirdek_kota_sayimi(cekirdekler: list[str]) -> dict[str, int]:
    return {
        "toplam": len(cekirdekler),
        "sir": sum(c in {"sir", "baskasinin_sirri"} for c in cekirdekler),
        "dinleyici": cekirdekler.count("dinlenmek_isteyen"),
    }


def _sir_kotasi_hatasi(sayim: dict[str, int]) -> tuple[str, str] | None:
    try:
        tavan, kural = (json.loads(yol.read_text(encoding="utf-8"))[SIR_KOTASI]
                       for yol in (KADRO_OZGUNLUK, KURALLAR))
    except (OSError, ValueError, KeyError, TypeError):
        return "KLT-65", "Kadro dosyası ve kurallar.json sır kotası okunamadı"
    if any(type(deger) is not int or not 0 <= deger < 100 for deger in (tavan, kural)):
        return "KLT-65", "Sır kotası her iki dosyada 0–99 arasında tam sayı olmalı"
    if tavan != kural:
        return "KLT-65", f"Kadro kotası %{tavan}, kurallar.json kotası %{kural}"
    sir = sayim["sir"]
    toplam = sayim["toplam"]
    if sir * 100 > toplam * tavan:
        return "KLT-20", f"Sır çekirdeği kotası aşıldı ({sir}/{toplam}, en çok %{tavan})"
    return None


def _satir_hatalari(paket: dict) -> list[dict]:
    hatalar = []
    kisiler = paket.get("kisiler", {})
    if not isinstance(kisiler, dict):
        kisiler = {}
    binalar = bina_adlari()
    meslekler = meslek_adlari()
    for satir in paket.get("satirlar", []):
        if not isinstance(satir, dict):
            continue
        metin = str(satir.get("metin", ""))
        agiz = str(satir.get("agiz", ""))
        anahtar = str(satir.get("anahtar", ""))
        if hata := ogretici_uzunluk_hatasi(anahtar, metin):
            hatalar.append({"tur": "hata", "kod": "KLT-12", "mesaj": hata})
        if agiz != "kitap":
            if ";" in metin or re.search(r"değil,\s+\w", metin, re.I):
                hatalar.append({"tur": "hata", "kod": "KLT-04", "mesaj": "yasak kalip"})
            for kelime in _modern_kelimeler() + _soyut_kelimeler():
                if kelime and re.search(r"(?<!\w)" + re.escape(kelime) + r"(?!\w)", metin, re.I):
                    hatalar.append({"tur": "hata", "kod": "KLT-04", "mesaj": "yasak kelime"})
                    break
            if any(y in metin.casefold() for y in YONERGE) and not anahtar.startswith(("ogretici.", "ipucu.")):
                hatalar.append({"tur": "hata", "kod": "KLT-34", "mesaj": "oyuncu yonergesi"})
            if any(y in metin for y in YILLAR):
                hatalar.append({"tur": "hata", "kod": "KLT-35", "mesaj": "rakamla yil"})
        for anilan in satir.get("anilan", []):
            durum = str(kisiler.get(str(anilan), "koyde"))
            if durum in ("ayrildi", "oldu") and not satir.get("kosul"):
                hatalar.append({"tur": "hata", "kod": "KLT-07", "mesaj": "ayrilan kisi"})
        bina = str(satir.get("bina", ""))
        if bina and bina not in binalar:
            hatalar.append({"tur": "hata", "kod": "KLT-09", "mesaj": "olmayan bina"})
        meslek = str(satir.get("meslek", "")).lower()
        if meslek and meslek not in meslekler:
            hatalar.append({"tur": "hata", "kod": "KLT-39", "mesaj": "olmayan meslek"})
        if _duz_cumle(metin):
            hatalar.append({"tur": "hata", "kod": "KLT-55", "mesaj": "duz turkce"})
    return hatalar


def _satir_uyarilari(paket: dict) -> list[dict]:
    uyarilar = []
    iskelet: dict[str, str] = {}
    for satir in paket.get("satirlar", []):
        if not isinstance(satir, dict):
            continue
        metin = str(satir.get("metin", ""))
        if metin.count("!") >= 3:
            uyarilar.append({"tur": "uyari", "kod": "KLT-33", "mesaj": "unlem"})
        agiz = str(satir.get("agiz", ""))
        kalip = str(satir.get("iskelet", ""))
        if kalip:
            if kalip in iskelet and iskelet[kalip] != agiz:
                uyarilar.append({"tur": "uyari", "kod": "KLT-32", "mesaj": "ayni iskelet"})
            iskelet.setdefault(kalip, agiz)
        if str(satir.get("yas", "")) == "cocuk" and str(satir.get("fiil", "")) in IS_EMRI:
            uyarilar.append({"tur": "uyari", "kod": "KLT-40", "mesaj": "cocuk is emri"})
    olaylar: dict[tuple, int] = {}
    for olay in paket.get("olaylar", []):
        if not isinstance(olay, dict) or not olay.get("dogru"):
            continue
        anahtar = (olay.get("gece"), olay.get("olay_id"))
        olaylar[anahtar] = olaylar.get(anahtar, 0) + 1
        if olaylar[anahtar] > 1 and not olay.get("kasitli_celiski"):
            uyarilar.append({"tur": "uyari", "kod": "KLT-08", "mesaj": "celiski"})
    return uyarilar


def _duz_cumle(metin: str) -> bool:
    parcalar = [p for p in metin.split() if p]
    return len(parcalar) >= 4 and "." not in metin


def kopyala(paket: dict, hedef: Path, kor_satirlari: list[dict] | None = None) -> int:
    metin_yol = str(hedef)
    if metin_yol.startswith("user:") or "user://" in metin_yol:
        raise ValueError("user:// yazilmaz")
    hatalar, _uyarilar = denetle(paket, kor_satirlari)
    kimlik = str(paket.get("id", "paket"))
    if hatalar:
        red = hedef / "red"
        red.mkdir(parents=True, exist_ok=True)
        (red / (kimlik + ".json")).write_text(json.dumps(hatalar, ensure_ascii=False), encoding="utf-8")
        return 0
    hedef.mkdir(parents=True, exist_ok=True)
    (hedef / (kimlik + ".json")).write_text(json.dumps({"id": kimlik}, ensure_ascii=False), encoding="utf-8")
    return 1


def godot_baslatir_mi() -> bool:
    return False


def src_editor_sayisi() -> int:
    sayi = 0
    for yol in (ROOT / "src").rglob("*.gd"):
        metin = yol.read_text(encoding="utf-8", errors="replace")
        if "class_name SozEditor" in metin or "soz_editor" in metin:
            sayi += 1
    return sayi


def kitap_exportta_mi() -> bool:
    govde = (ROOT / "project.godot").read_text(encoding="utf-8", errors="replace")
    if "dunya_kitabi" in govde:
        return True
    for yol in ROOT.rglob("*"):
        if any(parca in {".git", ".godot", "work"} for parca in yol.parts):
            continue
        if "dunya_kitabi" in yol.parts and "docs" not in yol.parts:
            return True
    return False


def _ornek_kor(kimlik: str = "ornek") -> list[dict]:
    return [{"id": kimlik, "skor": 0.9, "agiz": 3}]


def _temiz_paket() -> dict:
    return {
        "id": "ornek",
        "kutu": True,
        "adimlar": list(SIRA[:-1]),
        "onay": list(ONAY),
        "satirlar": [{"id": "satir.a.1", "agiz": "kisi_a", "anahtar": "satir.a.1", "bina": "kulube", "meslek": "ciftci"}],
        "kisiler": {"kisi_a": "koyde"},
        "cekirdekler": ["gunluk", "gunluk", "gunluk", "gunluk", "gunluk"],
    }


def main(argv: list[str] | None = None) -> int:
    ayr = argparse.ArgumentParser(description="Söz kapısı")
    ayr.add_argument("--paket", type=Path)
    ayr.add_argument("--hedef", type=Path)
    ayr.add_argument("--eski-tara", action="store_true", help="data/soz içinde eski konuşma cümlesi arar (KLT-48)")
    arg = ayr.parse_args(argv)
    if arg.eski_tara:
        bulunan = soz_kopya_taramasi()
        for dosya, metin in bulunan:
            print("KLT-48 %s: %s" % (dosya, metin))
        print("eski_kopya=%d" % len(bulunan))
        return 1 if bulunan else 0
    if arg.paket is None:
        print("KLT kapı hazır")
        return 0
    paket = json.loads(arg.paket.read_text(encoding="utf-8"))
    if arg.hedef is None:
        hatalar, uyarilar = denetle(paket, _ornek_kor(str(paket.get("id", ""))))
        print("hata=%d uyari=%d" % (len(hatalar), len(uyarilar)))
        sayim = _cekirdek_kota_sayimi([str(c) for c in paket.get("cekirdekler", [])])
        print("toplam\tsır\tdinleyici")
        print("\t".join(str(sayi) for sayi in sayim.values()))
        return 1 if hatalar else 0
    return 0 if kopyala(paket, arg.hedef, _ornek_kor(str(paket.get("id", "")))) == 1 else 1


if __name__ == "__main__":
    sys.exit(main())
