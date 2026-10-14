import unittest
from pathlib import Path
from tools import denge_dogrula

ROOT = Path(__file__).resolve().parents[2]


class TestDengeSurumu(unittest.TestCase):
    """DEN-02: Tablo sürümü kayıtla birlikte durur, kayda gömülmez."""

    def test_denge_dosyasi_surum_tasir(self):
        denge = denge_dogrula.yukle(ROOT / "data/ayarlar/denge.json")
        sinirlar = denge_dogrula.yukle(ROOT / "data/ayarlar/denge_sinirlari.json")
        self.assertIn("surum", denge)
        self.assertIsInstance(denge["surum"], int)
        self.assertGreaterEqual(denge["surum"], 1)
        # Sınır dosyası ile tam doğrulama
        hatalar = denge_dogrula.dogrula(denge, sinirlar)
        self.assertEqual(hatalar, [])

    def test_surum_artinca_sinir_gecerli(self):
        denge = denge_dogrula.yukle(ROOT / "data/ayarlar/denge.json")
        sinirlar = denge_dogrula.yukle(ROOT / "data/ayarlar/denge_sinirlari.json")
        denge["surum"] = 2
        hatalar = denge_dogrula.dogrula(denge, sinirlar)
        self.assertEqual(hatalar, [])

    def test_bozuk_surum_hata_verir(self):
        denge = denge_dogrula.yukle(ROOT / "data/ayarlar/denge.json")
        sinirlar = denge_dogrula.yukle(ROOT / "data/ayarlar/denge_sinirlari.json")
        denge["surum"] = 0
        hatalar = denge_dogrula.dogrula(denge, sinirlar)
        self.assertTrue(any("surum" in h for h in hatalar))


if __name__ == "__main__":
    unittest.main()
