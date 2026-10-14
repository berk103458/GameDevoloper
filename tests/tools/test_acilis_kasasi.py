import sys
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from tools import denge_dogrula


class TestAcilisKasasi(unittest.TestCase):
    def test_gercek_denge_ve_sinirlar_gecer(self):
        denge = denge_dogrula.yukle(ROOT / "data/ayarlar/denge.json")
        sinirlar = denge_dogrula.yukle(ROOT / "data/ayarlar/denge_sinirlari.json")
        self.assertIn("acilis_kasasi", denge)
        kasalar = denge["acilis_kasasi"]
        self.assertIn("koy_akce", kasalar)
        self.assertIn("muhafiz_akce", kasalar)
        self.assertNotIn("toplam", kasalar)
        self.assertNotIn("toplam_akce", kasalar)
        self.assertEqual(denge_dogrula.acilis_kasasi_hatalari(denge), [])
        hatalar = denge_dogrula.dogrula(denge, sinirlar)
        self.assertEqual(hatalar, [])

    def test_toplam_alani_yazilirsa_hata_verir(self):
        bozuk = {
            "acilis_kasasi": {
                "koy_akce": 10,
                "muhafiz_akce": 0,
                "toplam": 10
            }
        }
        hatalar = denge_dogrula.acilis_kasasi_hatalari(bozuk)
        self.assertTrue(any("toplam alani olamaz" in h for h in hatalar))

    def test_eksik_kasa_alani_hata_verir(self):
        bozuk1 = {"acilis_kasasi": {"muhafiz_akce": 0}}
        bozuk2 = {"acilis_kasasi": {"koy_akce": 10}}
        self.assertTrue(any("koy_akce alani zorunludur" in h for h in denge_dogrula.acilis_kasasi_hatalari(bozuk1)))
        self.assertTrue(any("muhafiz_akce alani zorunludur" in h for h in denge_dogrula.acilis_kasasi_hatalari(bozuk2)))


if __name__ == "__main__":
    unittest.main()
