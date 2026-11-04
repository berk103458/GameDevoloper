"""DEN-03 denge dogrulama: tablo degerleri alt/ust sinirlarin icinde kalmalidir.

Kural (ROADMAP_2 Bolum 32 / DEN-03): dogrulama her anahtarin alt ve ust sinirina
bakar. Sinir disi deger kirpilmaz, hata verir (oyun acilmaz, sanity kirmizi olur).

Sinirlar `data/ayarlar/denge_sinirlari.json` icindedir; anahtar yolu
`denge.json` icindeki yolla ayni, noktayla ayrilir (ornek `kriz_araligi.meclis_bekleme_gun`).
Hatalar:
  - sayisal anahtarin siniri yok,
  - sinir kaydi var ama denge.json'da o anahtar yok,
  - sinir kaydi bozuk (alt/ust eksik ya da sayi degil, alt > ust),
  - deger sinir disinda ya da sayi degil.
`denge.json` ve `tools/denge_taramasi.py` degismez; yalniz okunur.
"""
from pathlib import Path
import argparse
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
DENGE_YOLU = ROOT / "data/ayarlar/denge.json"
SINIR_YOLU = ROOT / "data/ayarlar/denge_sinirlari.json"
KOY_YOLU = ROOT / "data/ayarlar/koy.tres"
VERI_KOKU = ROOT / "data"
KOY_RES = "res://data/ayarlar/koy.tres"
KOY_AYARLARI_GD = ROOT / "src/veri/koy_ayarlari.gd"
SORGU_KURALLARI_YOLU = ROOT / "data/chr_runtime/sorgu_kurallari.tres"
SORGU_KURALLARI_RES = "res://data/chr_runtime/sorgu_kurallari.tres"

# DEN-07: anahtar ASCII snake_case'dir (kucuk harf, rakam, alt cizgi; harfle baslar).
ANAHTAR_DESENI = re.compile(r"^[a-z][a-z0-9_]*$")


def _sayi(deger) -> bool:
    return isinstance(deger, (int, float)) and not isinstance(deger, bool)


def anahtar_adlari(veri) -> list:
    """denge.json icindeki tum nesne anahtarlari (her derinlikte)."""
    adlar: list = []
    if isinstance(veri, dict):
        for k, v in veri.items():
            adlar.append(str(k))
            adlar.extend(anahtar_adlari(v))
    elif isinstance(veri, list):
        for e in veri:
            adlar.extend(anahtar_adlari(e))
    return adlar


def sayisal_yapraklar(veri) -> dict:
    """denge.json sayisal yapraklari {anahtar_yolu: deger}. Dizi elemanlari `yol[]` anahtarinda liste olur."""
    bulunan: dict = {}

    def gez(d, yol):
        if isinstance(d, dict):
            for k, v in d.items():
                gez(v, f"{yol}.{k}" if yol else str(k))
        elif isinstance(d, list):
            for e in d:
                if isinstance(e, (dict, list)):
                    gez(e, yol + "[]")
                elif _sayi(e):
                    bulunan.setdefault(yol + "[]", []).append(e)
        elif _sayi(d):
            bulunan[yol] = d

    gez(veri, "")
    return bulunan


def dogrula(denge: dict, sinirlar: dict) -> list:
    """Hata listesi dondurur; bos liste = temiz."""
    hatalar: list = []
    yapraklar = sayisal_yapraklar(denge)
    for ad in sorted(set(anahtar_adlari(denge))):
        if not ANAHTAR_DESENI.match(ad):
            hatalar.append(f"{ad}: anahtar ASCII snake_case degil (kucuk harf, rakam, alt cizgi)")
    if not isinstance(sinirlar, dict):
        return ["denge_sinirlari.json bir nesne olmali"]
    for anahtar in sorted(yapraklar):
        if anahtar not in sinirlar:
            hatalar.append(f"{anahtar}: sayisal anahtarin siniri denge_sinirlari.json icinde yok")
    if isinstance(sinirlar, dict):
        for yol in sorted(sinirlar):
            for parca in yol.replace("[]", "").split("."):
                if not ANAHTAR_DESENI.match(parca):
                    hatalar.append(f"{yol}: sinir anahtari ASCII snake_case degil")
                    break
    for anahtar in sorted(sinirlar):
        if anahtar not in yapraklar:
            hatalar.append(f"{anahtar}: eksik anahtar; sinir kaydi var ama denge.json icinde sayisal anahtar yok (kod ici yedek sayi yok, oyun acilmaz)")
            continue
        kayit = sinirlar[anahtar]
        if not isinstance(kayit, dict) or not _sayi(kayit.get("alt")) or not _sayi(kayit.get("ust")):
            hatalar.append(f"{anahtar}: sinir kaydi bozuk; sayi olan alt ve ust gerekli")
            continue
        alt, ust = kayit["alt"], kayit["ust"]
        if alt > ust:
            hatalar.append(f"{anahtar}: alt sinir ({alt}) ust sinirdan ({ust}) buyuk")
            continue
        deger = yapraklar[anahtar]
        for d in (deger if isinstance(deger, list) else [deger]):
            if d < alt or d > ust:
                hatalar.append(f"{anahtar}: deger {d} sinir disi [{alt}, {ust}]")
    return hatalar


def koy_baslangic_kaynagi(koy_metni: str) -> dict:
    """koy.tres icindeki `baslangic_kaynak = {...}` satirini {ad: sayi} olarak okur (BUG-22)."""
    eslesme = re.search(r"^baslangic_kaynak\s*=\s*\{([^}]*)\}", koy_metni, re.MULTILINE)
    if not eslesme:
        return {}
    return {a: int(s) for a, s in re.findall(r'"([a-z_]+)"\s*:\s*(-?\d+)', eslesme.group(1))}


def acilis_stoku_hatalari(denge: dict, koy_metni: str, baska_dosyalar: list) -> list:
    """DEN-09: acilis stoku tek kaynaktan gelir (BUG-22 / koy.tres), ikinci dosya yoktur.

    denge.json yalniz koy.tres'e isaret eder ya da ayni sayilari gosterir; farkli odun sayisi hatadir.
    `baska_dosyalar`: koy.tres disinda `baslangic_kaynak` iceren veri dosyalarinin adlari.
    """
    hatalar: list = []
    stok = denge.get("acilis_stoku", {}) if isinstance(denge, dict) else {}
    if not isinstance(stok, dict):
        return ["acilis_stoku bir nesne olmali"]
    gercek = koy_baslangic_kaynagi(koy_metni)
    if not gercek:
        hatalar.append("koy.tres icinde baslangic_kaynak okunamadi")
    kaynak = stok.get("kaynak")
    if kaynak is not None and kaynak != KOY_RES:
        hatalar.append(f"acilis_stoku.kaynak {KOY_RES} olmali, bulundu: {kaynak}")
    kopya = stok.get("baslangic_kaynak")
    if kopya is not None:
        if not isinstance(kopya, dict):
            hatalar.append("acilis_stoku.baslangic_kaynak bir nesne olmali")
        else:
            for ad in sorted(set(kopya) | set(gercek)):
                if kopya.get(ad) != gercek.get(ad):
                    hatalar.append(f"acilis_stoku.{ad}: denge.json {kopya.get(ad)} ama koy.tres {gercek.get(ad)} (ikinci tablo yok)")
    for dosya in baska_dosyalar:
        hatalar.append(f"{dosya}: ikinci bir baslangic dosyasi (baslangic_kaynak) olamaz; tek tablo koy.tres")
    return hatalar


def ikinci_baslangic_dosyalari(kok: Path = VERI_KOKU, koy: Path = KOY_YOLU, denge: Path = DENGE_YOLU) -> list:
    """data/ altinda koy.tres ve denge.json disinda `baslangic_kaynak` iceren dosyalar."""
    bulunan = []
    for yol in sorted(kok.rglob("*")):
        if yol.suffix not in (".json", ".tres", ".cfg") or yol.resolve() in (koy.resolve(), denge.resolve()):
            continue
        try:
            if "baslangic_kaynak" in yol.read_text(encoding="utf-8", errors="ignore"):
                bulunan.append(yol.relative_to(kok).as_posix())
        except OSError:
            pass
    return bulunan

def gida_kisi_degeri(ayar_metni: str) -> int:
    """koy_ayarlari.gd icindeki kisi basina gece gida tuketimi (`gida_kisi`)."""
    eslesme = re.search(r"@export\s+var\s+gida_kisi\s*:\s*int\s*=\s*(\d+)", ayar_metni)
    return int(eslesme.group(1)) if eslesme else 0


def ilk_hafta_erzak_hatalari(denge: dict, koy_metni: str, ayar_metni: str) -> list:
    """DEN-13: acilis erzagi = evdeki kisi * 7 gece * kisi basi tuketim + tablodaki pay.

    `ilk_hafta_erzak` tablosu yoksa denetim atlanir (DEN-08 sayisal anahtarlarda eksikligi zaten yakalar).
    """
    tablo = denge.get("ilk_hafta_erzak") if isinstance(denge, dict) else None
    if tablo is None:
        return []
    if not isinstance(tablo, dict) or not all(_sayi(tablo.get(a)) for a in ("acilis_kisi", "gece", "pay")):
        return ["ilk_hafta_erzak: acilis_kisi, gece ve pay sayi olmali"]
    kisi_tuketimi = gida_kisi_degeri(ayar_metni)
    if kisi_tuketimi <= 0:
        return ["koy_ayarlari.gd icinde gida_kisi okunamadi"]
    gida = koy_baslangic_kaynagi(koy_metni).get("gida")
    beklenen = tablo["acilis_kisi"] * tablo["gece"] * kisi_tuketimi + tablo["pay"]
    if gida != beklenen:
        return [f"ilk_hafta_erzak: koy.tres gida {gida} ama formul {tablo['acilis_kisi']}*{tablo['gece']}*{kisi_tuketimi}+{tablo['pay']} = {beklenen}"]
    return []

def sorgu_zar_esikleri(tres_metni: str) -> dict:
    """sorgu_kurallari.tres icindeki zar_gergin_alt ve zar_panik_alt degerlerini okur."""
    esikler = {}
    g = re.search(r"zar_gergin_alt\s*=\s*(\d+)", tres_metni)
    if g:
        esikler["zar_gergin_alt"] = int(g.group(1))
    p = re.search(r"zar_panik_alt\s*=\s*(\d+)", tres_metni)
    if p:
        esikler["zar_panik_alt"] = int(p.group(1))
    k = re.search(r"tansiyon_kacis_esigi\s*=\s*(\d+)", tres_metni)
    if k:
        esikler["tansiyon_kacis_esigi"] = int(k.group(1))
    return esikler


def zar_esigi_hatalari(denge: dict, tres_metni: str) -> list:
    """DEN-17 ve DEN-23: zar formulu ZAR-01'dedir; denge dosyasindaki esik ile sorgu_kurallari.tres aynidir.

    DEN-23: tansiyon eki uc kademedir (sakin, gergin, panik); dosyada ikinci bir ek anahtari yoktur.
    """
    hatalar: list = []
    zar = denge.get("zar_esigi") if isinstance(denge, dict) else None
    if zar is None or not isinstance(zar, dict):
        return []
    if zar.get("sistem_yok"):
        return []
    kaynak = zar.get("kaynak")
    if kaynak is not None and kaynak != SORGU_KURALLARI_RES:
        hatalar.append(f"zar_esigi.kaynak {SORGU_KURALLARI_RES} olmali, bulundu: {kaynak}")
    gercek_esikler = sorgu_zar_esikleri(tres_metni)
    for k in ("zar_gergin_alt", "zar_panik_alt", "tansiyon_kacis_esigi"):
        if k in zar and k in gercek_esikler:
            if zar[k] != gercek_esikler[k]:
                hatalar.append(f"zar_esigi.{k}: denge.json {zar[k]} ama sorgu_kurallari.tres {gercek_esikler[k]} (farkli esik olamaz)")
    # DEN-23: dosyada ikinci bir ek anahtari yoktur (yalniz zar_esigi grubunda tansiyon esikleri)
    yasak_ek_anahtarlari = [k for k in denge if "tansiyon_ek" in k or "zar_ek" in k]
    for y in yasak_ek_anahtarlari:
        hatalar.append(f"{y}: denge dosyasinda ikinci bir tansiyon ek anahtari olamaz (DEN-23)")
    return hatalar


def kacan_bedeli_hatalari(denge: dict) -> list:
    """DEN-19: ZAR-03 kacisi kabul matrisinin tersi degildir; bedel kacan kisi basina dedikodu, kasa degildir."""
    hatalar: list = []
    kb = denge.get("kacan_bedeli") if isinstance(denge, dict) else None
    if kb is None:
        return []
    if not isinstance(kb, dict):
        return ["kacan_bedeli bir nesne olmali (DEN-19)"]
    if "dedikodu" not in kb:
        hatalar.append("kacan_bedeli.dedikodu alani zorunludur (DEN-19)")
    if "kasa" not in kb:
        hatalar.append("kacan_bedeli.kasa alani zorunludur (DEN-19)")
    elif kb["kasa"] != 0:
        hatalar.append("kacan_bedeli.kasa 0 olmali; kacan kisi kasayi etkilemez (DEN-19)")
    return hatalar


def acilis_kasasi_hatalari(denge: dict) -> list:
    """DEN-14: Acilista koy akcesi ve muhafiz akcesi ayri satirdir.

    Goc onlari birbirine katmaz (KAY-45). Iki satir ayridir; toplam alani yazilmaz.
    """
    hatalar: list = []
    ak = denge.get("acilis_kasasi") if isinstance(denge, dict) else None
    if ak is None:
        return []
    if not isinstance(ak, dict):
        return ["acilis_kasasi bir nesne olmali (DEN-14)"]
    if "koy_akce" not in ak:
        hatalar.append("acilis_kasasi.koy_akce alani zorunludur (DEN-14)")
    if "muhafiz_akce" not in ak:
        hatalar.append("acilis_kasasi.muhafiz_akce alani zorunludur (DEN-14)")
    if "toplam" in ak or "toplam_akce" in ak:
        hatalar.append("acilis_kasasi icinde toplam alani olamaz; iki kasa ayri satirdir (DEN-14)")
    return hatalar


def aclik_kademesi_hatalari(denge: dict) -> list:
    """DEN-25/27: açlık kademesi ve erzak eşiği kendi kaynaklarında kalır."""
    hatalar = []
    for ad, veri in denge.items():
        if ad == "aclik" or ad.startswith("aclik_"):
            kaynak = "aclik_saglik" if ad == "aclik_saglik" else "aclik_kademeleri"
            if veri != {"kaynak": f"res://data/koy/{kaynak}.json"}:
                hatalar.append(f"{ad}: açlık değeri ikinci kez yazılamaz; kaynak data/koy/{kaynak}.json (DEN-25/27)")
        elif isinstance(veri, dict):
            hatalar.extend(aclik_kademesi_hatalari(veri))
    return hatalar


def yukle(yol: Path):
    return json.loads(yol.read_text(encoding="utf-8"))


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--denge", type=Path, default=DENGE_YOLU)
    ap.add_argument("--sinirlar", type=Path, default=SINIR_YOLU)
    ap.add_argument("--koy", type=Path, default=KOY_YOLU)
    ap.add_argument("--koy-ayarlari", type=Path, default=KOY_AYARLARI_GD)
    ap.add_argument("--sorgu-kurallari", type=Path, default=SORGU_KURALLARI_YOLU)
    args = ap.parse_args(argv)
    try:
        denge = yukle(args.denge)
        hatalar = dogrula(denge, yukle(args.sinirlar))
        hatalar += acilis_stoku_hatalari(denge, args.koy.read_text(encoding="utf-8"), ikinci_baslangic_dosyalari(koy=args.koy, denge=args.denge))
        hatalar += ilk_hafta_erzak_hatalari(denge, args.koy.read_text(encoding="utf-8"), args.koy_ayarlari.read_text(encoding="utf-8"))
        hatalar += zar_esigi_hatalari(denge, args.sorgu_kurallari.read_text(encoding="utf-8"))
        hatalar += kacan_bedeli_hatalari(denge)
        hatalar += acilis_kasasi_hatalari(denge)
        hatalar += aclik_kademesi_hatalari(denge)
    except (OSError, ValueError) as hata:
        hatalar = [f"dosya okunamadi: {hata}"]
    for h in hatalar:
        print("DENGE SINIR HATASI: " + h)
    if hatalar:
        print(f"Denge dogrulama: {len(hatalar)} hata.")
        return 1
    print("Denge dogrulama: GECTI")
    return 0


if __name__ == "__main__":
    sys.exit(main())
