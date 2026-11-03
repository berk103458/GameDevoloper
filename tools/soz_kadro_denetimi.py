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
