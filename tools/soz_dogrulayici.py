"""YAZ-07: Soz dogrulayici ve onizleme araci."""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
YASAK_KELIME_YOLU = ROOT / "data" / "soz" / "yasak_kelimeler.txt"


def yasak_kelimeler_oku(yol: Path | None = None) -> list[str]:
    hedef = yol or YASAK_KELIME_YOLU
    if not hedef.is_file():
        return []
    kelimeler: list[str] = []
    for satir in hedef.read_text(encoding="utf-8").splitlines():
        temiz = satir.strip()
        if not temiz or temiz.startswith("#"):
            continue
        kelimeler.append(temiz)
    return kelimeler


def metni_tara(metin: str, yasak_liste: list[str] | None = None) -> list[dict]:
    liste = yasak_liste if yasak_liste is not None else yasak_kelimeler_oku()
    uyarilar: list[dict] = []
    for kelime in liste:
        desen = re.compile(r"(?<!\w)" + re.escape(kelime) + r"(?!\w)", re.IGNORECASE)
        if desen.search(metin):
            uyarilar.append({
                "tur": "uyari",
                "kod": "YAZ-02",
                "kelime": kelime,
                "mesaj": f"Yasak modern sozcuk uyarisi: {kelime}",
            })
    return uyarilar


def replik_uyarilari(replikler: list[str], yasak_liste: list[str] | None = None) -> list[dict]:
    """Replik listesini yasak kelimelere gore tarar; uyari uretir, listeden satir silmez."""
    liste = yasak_liste if yasak_liste is not None else yasak_kelimeler_oku()
    sonuc: list[dict] = []
    for i, satir in enumerate(replikler):
        for u in metni_tara(satir, liste):
            kayit = dict(u)
            kayit["indeks"] = i
            sonuc.append(kayit)
    return sonuc


def dogrula() -> int:
    kurallar_p = ROOT / "data" / "soz" / "kurallar.json"
    if not kurallar_p.exists():
        print("HATA: kurallar.json bulunamadi")
        return 1

    kartlar_p = ROOT / "data" / "karakter_ses_kartlari.json"
    if not kartlar_p.exists():
        print("HATA: karakter_ses_kartlari.json bulunamadi")
        return 1

    yasaklar = yasak_kelimeler_oku()
    if not yasaklar:
        print("HATA: yasak_kelimeler.txt bos veya bulunamadi")
        return 1

    kartlar = json.loads(kartlar_p.read_text(encoding="utf-8")).get("kartlar", {})
    if len(kartlar) < 30:
        print(f"HATA: 30 karakter ses karti beklenirken {len(kartlar)} bulundu")
        return 1

    print(f"YAZ-07 DOGRULAMA: {len(kartlar)} karakter ses karti ve {len(yasaklar)} yasak kelime eksiksiz gecti.")
    return 0


if __name__ == "__main__":
    sys.exit(dogrula())
