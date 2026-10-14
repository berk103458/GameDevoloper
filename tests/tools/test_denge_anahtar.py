import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("denge_dogrula", ROOT / "tools/denge_dogrula.py")
dogrulayici = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dogrulayici)

SINIR = {"acilis.baslangic_odun": {"alt": 0, "ust": 500}, "fiyat.odun_carpani": {"alt": 0.1, "ust": 5}}
DENGE = {"acilis": {"baslangic_odun": 24}, "fiyat": {"odun_carpani": 1.0}}


class DengeAnahtarTest(unittest.TestCase):
    """DEN-07 (ASCII snake_case anahtar) ve DEN-08 (eksik anahtar oyunu acmaz)."""

    def test_odun_carpani_gecer(self):
        self.assertEqual(dogrulayici.dogrula(DENGE, SINIR), [])

    def test_turkce_harfli_anahtar_reddedilir(self):
        denge = {"fiyat": {"odun çarpanı": 1.0}}
        hatalar = dogrulayici.dogrula(denge, {"fiyat.odun çarpanı": {"alt": 0, "ust": 5}})
        self.assertTrue(any("snake_case" in h and "odun çarpanı" in h for h in hatalar), hatalar)

    def test_buyuk_harf_ve_bosluk_reddedilir(self):
        for ad in ("OdunCarpani", "odun carpani", "1odun", "odun-carpani", ""):
            self.assertFalse(dogrulayici.ANAHTAR_DESENI.match(ad), ad)
        self.assertTrue(dogrulayici.ANAHTAR_DESENI.match("odun_carpani"))

    def test_ic_ice_anahtar_da_denetlenir(self):
        denge = {"fiyat": {"ic": {"gıda": 1}}}
        hatalar = dogrulayici.dogrula(denge, {"fiyat.ic.gıda": {"alt": 0, "ust": 5}})
        self.assertTrue(any("snake_case" in h for h in hatalar))

    def test_silinmis_baslangic_odun_acilis_hatasi(self):
        denge = {"acilis": {}, "fiyat": {"odun_carpani": 1.0}}
        hatalar = dogrulayici.dogrula(denge, SINIR)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("acilis.baslangic_odun", hatalar[0])
        self.assertIn("eksik anahtar", hatalar[0])

    def test_eksik_anahtar_sessiz_varsayilan_almaz(self):
        # Sinir kaydi var, deger yok: hata verir; deger uydurulmaz ya da kirpilmaz.
        hatalar = dogrulayici.dogrula({}, SINIR)
        self.assertEqual(len(hatalar), 2)
        self.assertTrue(all("eksik anahtar" in h for h in hatalar))

    def test_gercek_dosyalar_temiz(self):
        self.assertEqual(dogrulayici.main([]), 0)


if __name__ == "__main__":
    unittest.main()
