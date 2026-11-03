"""YAZ-10: Inceleme modu ve kapsam taramasi."""
from __future__ import annotations
import sys
import json
from pathlib import Path

def kapsam_tara() -> int:
    gecis_p = Path("data/soz/gecis.json")
    if not gecis_p.exists():
        print("HATA: data/soz/gecis.json bulunamadi")
        return 1
    
    gecis = json.loads(gecis_p.read_text(encoding="utf-8")).get("karakterler", {})
    if len(gecis) < 30:
        print(f"HATA: 30 karakter gecisi beklenirken {len(gecis)} bulundu")
        return 1

    print(f"YAZ-10 KAPSAM TARAMASI: {len(gecis)} karakter tam kapsama alindi.")
    return 0

if __name__ == "__main__":
    sys.exit(kapsam_tara())
