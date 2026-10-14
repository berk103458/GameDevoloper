import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("denge_dogrula", ROOT / "tools/denge_dogrula.py")
dogrulayici = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dogrulayici)

TRES = (
    "[resource]\n"
    "zar_gergin_alt = 4\n"
    "zar_panik_alt = 8\n"
)


class DengeZarTest(unittest.TestCase):
    """DEN-17 (zar eşiği doğrulaması) ve DEN-23 (tansiyon eki üç kademedir, ikinci ek yok)."""

    def test_tres_esikleri_okunur(self):
        esikler = dogrulayici.sorgu_zar_esikleri(TRES)
        self.assertEqual(esikler, {"zar_gergin_alt": 4, "zar_panik_alt": 8})

    def test_eslesmeyen_esik_hata_verir(self):
        bozuk = {
            "zar_esigi": {
                "kaynak": "res://data/chr_runtime/sorgu_kurallari.tres",
                "zar_gergin_alt": 5,
                "zar_panik_alt": 8,
            }
        }
        hatalar = dogrulayici.zar_esigi_hatalari(bozuk, TRES)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("zar_gergin_alt", hatalar[0])

    def test_ikinci_ek_anahtari_hata_verir_den23(self):
        bozuk = {
            "zar_esigi": {"kaynak": "res://data/chr_runtime/sorgu_kurallari.tres"},
            "tansiyon_ek_listesi": [0, 1, 2],
        }
        hatalar = dogrulayici.zar_esigi_hatalari(bozuk, TRES)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("ikinci bir tansiyon ek anahtari olamaz", hatalar[0])

    def test_gercek_dosyalar_temiz(self):
        self.assertEqual(dogrulayici.main([]), 0)


if __name__ == "__main__":
    unittest.main()
