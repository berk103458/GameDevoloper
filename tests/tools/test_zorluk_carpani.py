import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
DENGE = json.loads((ROOT / "data/ayarlar/denge.json").read_text(encoding="utf-8"))
ZORLUK = DENGE.get("zorluk", {})


class ZorlukCarpaniTest(unittest.TestCase):
    """DEN-04: zorluk tabloyu carpar, ikinci tablo acmaz."""

    def test_uc_kademe_dosyada(self):
        self.assertEqual(sorted(ZORLUK), ["kolay", "olagan", "siki"])

    def test_olaganda_carpan_bir(self):
        self.assertEqual(ZORLUK["olagan"], 1)

    def test_diger_iki_carpan_dosyada_ve_yone_dogru(self):
        self.assertLess(ZORLUK["kolay"], 1)
        self.assertGreater(ZORLUK["siki"], 1)

    def test_yalniz_carpan_ikinci_tablo_yok(self):
        for ad, deger in ZORLUK.items():
            self.assertIsInstance(deger, (int, float), f"{ad} bir carpan degil")
            self.assertNotIsInstance(deger, bool)

    def test_anahtarlar_uc_kez_yazilmaz(self):
        # Zorluk basina ayri tablo (ornek: denge.json icinde kolay/siki kopyalari) acilmaz.
        ust_anahtarlar = [k for k in DENGE if k.startswith(("kolay", "olagan", "siki"))]
        self.assertEqual(ust_anahtarlar, [])


if __name__ == "__main__":
    unittest.main()
