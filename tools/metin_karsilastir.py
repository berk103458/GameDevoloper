"""DYL-13: Eski ve yeni metni yan yana gosteren karsilastirma araci."""
from __future__ import annotations
import sys
import json
from pathlib import Path

def karsilastir(eski_dosya: Path, yeni_dosya: Path) -> dict:
    eski = json.loads(eski_dosya.read_text(encoding="utf-8")) if eski_dosya.exists() else {}
    yeni = json.loads(yeni_dosya.read_text(encoding="utf-8")) if yeni_dosya.exists() else {}
    return {
        "eski_sayisi": len(eski),
        "yeni_sayisi": len(yeni),
        "fark": len(yeni) - len(eski)
    }

if __name__ == "__main__":
    print("DYL-13 Metin Karsilastirma Araci Hazir.")
