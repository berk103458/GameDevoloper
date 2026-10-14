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
import sys

ROOT = Path(__file__).resolve().parents[1]
DENGE_YOLU = ROOT / "data/ayarlar/denge.json"
SINIR_YOLU = ROOT / "data/ayarlar/denge_sinirlari.json"


def _sayi(deger) -> bool:
    return isinstance(deger, (int, float)) and not isinstance(deger, bool)


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
    if not isinstance(sinirlar, dict):
        return ["denge_sinirlari.json bir nesne olmali"]
    for anahtar in sorted(yapraklar):
        if anahtar not in sinirlar:
            hatalar.append(f"{anahtar}: sayisal anahtarin siniri denge_sinirlari.json icinde yok")
    for anahtar in sorted(sinirlar):
        if anahtar not in yapraklar:
            hatalar.append(f"{anahtar}: sinir kaydi var ama denge.json icinde sayisal anahtar yok")
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


def yukle(yol: Path):
    return json.loads(yol.read_text(encoding="utf-8"))


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--denge", type=Path, default=DENGE_YOLU)
    ap.add_argument("--sinirlar", type=Path, default=SINIR_YOLU)
    args = ap.parse_args(argv)
    try:
        hatalar = dogrula(yukle(args.denge), yukle(args.sinirlar))
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
