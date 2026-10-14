import unittest
from pathlib import Path
from tools import denge_dogrula

ROOT = Path(__file__).resolve().parents[2]


class TestKacanBedeli(unittest.TestCase):
    """DEN-19: Kaçan kişinin ekonomik bedeli tablodaki tek satırdır: dedikodu, kasa değil."""

    def test_gercek_denge_ve_sinirlar_gecer(self):
        denge = denge_dogrula.yukle(ROOT / "data/ayarlar/denge.json")
        sinirlar = denge_dogrula.yukle(ROOT / "data/ayarlar/denge_sinirlari.json")
        self.assertIn("kacan_bedeli", denge)
        self.assertEqual(denge["kacan_bedeli"]["kasa"], 0)
        self.assertGreaterEqual(denge["kacan_bedeli"]["dedikodu"], 0)
        self.assertEqual(denge_dogrula.kacan_bedeli_hatalari(denge), [])
        hatalar = denge_dogrula.dogrula(denge, sinirlar)
        self.assertEqual(hatalar, [])

    def test_kasa_sifirdan_farkliysa_hata_verir(self):
        bozuk = {"kacan_bedeli": {"dedikodu": 1, "kasa": 5}}
        hatalar = denge_dogrula.kacan_bedeli_hatalari(bozuk)
        self.assertTrue(any("kasa 0 olmali" in h for h in hatalar))

    def test_eksik_alanlar_hata_verir(self):
        bozuk1 = {"kacan_bedeli": {"dedikodu": 1}}
        self.assertTrue(any("kasa alani zorunludur" in h for h in denge_dogrula.kacan_bedeli_hatalari(bozuk1)))
        bozuk2 = {"kacan_bedeli": {"kasa": 0}}
        self.assertTrue(any("dedikodu alani zorunludur" in h for h in denge_dogrula.kacan_bedeli_hatalari(bozuk2)))


if __name__ == "__main__":
    unittest.main()
