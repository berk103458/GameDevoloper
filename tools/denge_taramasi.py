"""DEN-01 denge taramasi: bes denge grubu `.gd` icinde sayi sabiti olarak durmaz.

Kural (ROADMAP_2 Bolum 32 / DEN-01): zar esigi, acilis stoku, fiyat carpani,
kriz araligi ve zorluk carpani `data/ayarlar/denge.json` icindedir; bu sayilar
`.gd` dosyasinda sabit degildir. Bu tarayici bes grubun bilinen anahtar adlarini
GDScript kaynaginda sayi sabiti olarak arar ve buldugunu raporlar.
"""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
DENGE_YOLU = ROOT / "data/ayarlar/denge.json"
KAYNAK_KOKU = ROOT / "src"

# DEN-01: bes grup ve denge tablosundaki bilinen anahtar adlari.
GRUP_ANAHTARLARI = {
    "zar_esigi": ["zar_esigi"],
    "acilis_stoku": ["acilis_stoku"],
    "fiyat_carpani": ["fiyat_carpani"],
    "kriz_araligi": ["kriz_araligi", "meclis_bekleme_gun"],
    "zorluk_carpani": ["zorluk_carpani"],
}

_SAYI = r"[-+]?(?:\d+\.\d+|\d+)"


def _desen(ad: str) -> re.Pattern:
    return re.compile(
        r"^[ \t]*(?:const|static\s+var|var)[ \t]+"
        + re.escape(ad)
        + r"[ \t]*(?::=[ \t]*|=[ \t]*)"
        + _SAYI
        + r"\b",
        re.MULTILINE,
    )


def sabitler(kaynak: str) -> list[str]:
    """Verilen GDScript kaynaginda bes grubun anahtar adlarini sayi sabiti olarak bulur."""
    bulunan: list[str] = []
    for adlar in GRUP_ANAHTARLARI.values():
        for ad in adlar:
            bulunan.extend(m.group(0).strip() for m in _desen(ad).finditer(kaynak))
    return bulunan


def tara(kok: Path = KAYNAK_KOKU) -> list[tuple[str, str]]:
    """`kok` altindaki tum `.gd` dosyalarini tarar; (dosya, satir) ciftleri doner."""
    bulunan: list[tuple[str, str]] = []
    for dosya in sorted(kok.rglob("*.gd")):
        metin = dosya.read_text(encoding="utf-8")
        for satir in sabitler(metin):
            bulunan.append((dosya.relative_to(ROOT).as_posix(), satir))
    return bulunan


def gruplar(yol: Path = DENGE_YOLU) -> dict:
    """denge.json icerigini sozluk olarak doner."""
    return json.loads(yol.read_text(encoding="utf-8"))


if __name__ == "__main__":
    for dosya, satir in tara():
        print(f"{dosya}: {satir}")
    print(f"TOPLAM={len(tara())}")
