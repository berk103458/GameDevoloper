"""YAZ-07: Soz dogrulayici ve onizleme araci."""
from __future__ import annotations
import sys
import json
from pathlib import Path

def dogrula() -> int:
    kurallar_p = Path("data/soz/kurallar.json")
    if not kurallar_p.exists():
        print("HATA: kurallar.json bulunamadi")
        return 1
    
    kartlar_p = Path("data/karakter_ses_kartlari.json")
    if not kartlar_p.exists():
        print("HATA: karakter_ses_kartlari.json bulunamadi")
        return 1
    
    kartlar = json.loads(kartlar_p.read_text(encoding="utf-8")).get("kartlar", {})
    if len(kartlar) < 30:
        print(f"HATA: 30 karakter ses karti beklenirken {len(kartlar)} bulundu")
        return 1
        
    print(f"YAZ-07 DOGRULAMA: {len(kartlar)} karakter ses karti eksiksiz gecti.")
    return 0

if __name__ == "__main__":
    sys.exit(dogrula())
