"""BUG-16: gece kartlarının bina imzası ve koşul anahtarı denetimi; dosya yazmaz."""
from pathlib import Path
import csv
import json
import re

ROOT = Path(__file__).resolve().parents[1]
# Eski pazar/kervansaray adları Oturum adaptörüyle çalışır. Samanlık ambarın deposudur.
BINALAR = {"ambar": "ambar", "samanlık": "ambar", "pazar": "pazar",
           "kervansaray": "kervansaray", "ağıl": "agil", "kışla": "muhafiz_kislasi",
           "değirmen": "degirmen", "sur": "sur", "tarla": "tarla",
           "tezgâh": "atolye", "harman yeri": "tarla"}


def denetle(kosullar, metin, anahtarlar):
    hatalar = [f"Tanınmayan olay koşulu: {k}" for k in kosullar if k not in anahtarlar]
    gerekli = kosullar.get("bina_var", [])
    if isinstance(gerekli, str):
        gerekli = [gerekli]
    imzalar = set(gerekli) | set(kosullar.get("yapi_min", {}))
    if kosullar.get("tarla_ekili_min", 0) > 0:
        imzalar.add("tarla")
    for ad, tur in BINALAR.items():
        if re.search(r"\b" + re.escape(ad), metin.lower()) and tur not in imzalar:
            hatalar.append(f"İmzasız bina adı: {ad} ({tur})")
    return hatalar


def tara(root=ROOT):
    gd = (root / "src/sistemler/olay_on_kosulu.gd").read_text(encoding="utf-8")
    anahtarlar = json.loads(re.search(r"const ANAHTARLAR := (\[.*\])", gd).group(1))
    with (root / "data/metin/metinler.csv").open(encoding="utf-8-sig", newline="") as stream:
        metinler = dict(list(csv.reader(stream))[1:])
    sonuc = []
    for path in sorted((root / "data/olaylar").glob("*.tres")):
        kaynak = path.read_text(encoding="utf-8")
        kosullar = json.loads(re.search(r"^kosullar = (.*)$", kaynak, re.M).group(1))
        keys = re.findall(r'^(?:baslik|metin)_anahtari = "([^"]+)"', kaynak, re.M)
        metin = " ".join(metinler.get(key, "") for key in keys)
        sonuc.append((path.name, kosullar, denetle(kosullar, metin, anahtarlar)))
    return sonuc


if __name__ == "__main__":
    rapor = tara()
    for ad, _, hatalar in rapor:
        print(f"{'FAIL' if hatalar else 'PASS'} {ad}: {'; '.join(hatalar)}")
    raise SystemExit(int(any(hatalar for _, _, hatalar in rapor)))
