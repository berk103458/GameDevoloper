"""KAY-34: kayıtlı kadrodaki çekirdek kotası. Sapma uyarıdır, yüklemeyi durdurmaz."""
from __future__ import annotations

from collections import Counter


KOTA = 0.40


def denetle(varyantlar: list[str]) -> list[dict]:
    temiz = [str(v).strip() for v in varyantlar if str(v).strip()]
    if not temiz:
        return []
    sayim = Counter(temiz)
    uyarilar = []
    for cekirdek, adet in sorted(sayim.items()):
        oran = adet / len(temiz)
        if oran > KOTA:
            uyarilar.append({
                "tur": "kota",
                "cekirdek": cekirdek,
                "oran": round(oran, 4),
                "mesaj": "cekirdek kotasi asildi: %s %.0f%%" % (cekirdek, oran * 100),
            })
    return uyarilar


def goc_durur(_uyarilar: list[dict]) -> bool:
    return False


# SOY-27: "duydum ki" satırları YAZ-09 kotasında "dedikodu" çekirdeğine sayılır.
DEDIKODU = "dedikodu"
DEDIKODU_KOTA_ANAHTARI = "dedikodu_kotasi_yuzde_max"


def soylenti_dallari(soz_dizini) -> list[str]:
    """`soylenti_duydu` koşulu taşıyan söz dallarının kimlikleri (kaynak dosya:dal)."""
    import json
    from pathlib import Path

    bulunan: list[str] = []
    for yol in sorted(Path(soz_dizini).glob("*.json")):
        if yol.name.startswith("_"):
            continue
        try:
            veri = json.loads(yol.read_text(encoding="utf-8-sig"))
        except (OSError, ValueError):
            continue
        dallar = veri.get("dallar", []) if isinstance(veri, dict) else []
        for dal in dallar:
            if isinstance(dal, dict) and "soylenti_duydu" in dal.get("kosullar", {}):
                bulunan.append("%s:%s" % (yol.stem, dal.get("id", "")))
    return bulunan


def soylenti_kota_raporu(kadro: dict, dallar: list[str]) -> dict:
    """Kota tablosuna söylenti satırlarını `dedikodu` olarak ekler; oran tavanı aşarsa hata döner."""
    dagilim = {str(k): int(v) for k, v in dict(kadro.get("cekirdek_dagilimi", {})).items()}
    dagilim[DEDIKODU] = dagilim.get(DEDIKODU, 0) + len(dallar)
    toplam = sum(dagilim.values())
    oran = dagilim[DEDIKODU] / toplam if toplam else 0.0
    tavan = float(kadro.get(DEDIKODU_KOTA_ANAHTARI, 20)) / 100.0
    hatalar = []
    if oran > tavan:
        hatalar.append({"tur": "hata", "kod": "SOY-27", "mesaj": "dedikodu kotasi %.0f%% > %.0f%%" % (oran * 100, tavan * 100)})
    return {"dagilim": dagilim, "dedikodu_orani": round(oran, 4), "tavan": tavan, "dallar": dallar, "hatalar": hatalar}


def gercek_soylenti_raporu() -> dict:
    import json
    from pathlib import Path

    soz = Path(__file__).resolve().parents[1] / "data" / "soz"
    kadro = json.loads((soz / "kadro_ozgunluk.json").read_text(encoding="utf-8"))
    return soylenti_kota_raporu(kadro, soylenti_dallari(soz))


if __name__ == "__main__":
    import json
    import sys

    rapor = gercek_soylenti_raporu()
    print(json.dumps(rapor, ensure_ascii=False, indent=2))
    sys.exit(1 if rapor["hatalar"] else 0)
