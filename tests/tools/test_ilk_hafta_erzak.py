import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("denge_dogrula", ROOT / "tools/denge_dogrula.py")
dogrulayici = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dogrulayici)

AYAR = "@export var gida_kisi: int = 1\n"
KOY = 'baslangic_kaynak = {"gida": 30, "odun": 24}\n'
TABLO = {"ilk_hafta_erzak": {"acilis_kisi": 2, "gece": 7, "pay": 16}}


class IlkHaftaErzakTest(unittest.TestCase):
    """DEN-13: acilis erzagi = kisi * 7 + tablodaki pay; pay kodda sabit degil."""

    def test_iki_kisilik_acilista_erzak_formule_esit(self):
        self.assertEqual(dogrulayici.ilk_hafta_erzak_hatalari(TABLO, KOY, AYAR), [])
        self.assertEqual(2 * 7 * 1 + 16, 30)

    def test_pay_degisirse_formul_tutmaz(self):
        denge = {"ilk_hafta_erzak": {"acilis_kisi": 2, "gece": 7, "pay": 20}}
        hatalar = dogrulayici.ilk_hafta_erzak_hatalari(denge, KOY, AYAR)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("34", hatalar[0])

    def test_kisi_sayisi_degisirse_erzak_degisir(self):
        denge = {"ilk_hafta_erzak": {"acilis_kisi": 3, "gece": 7, "pay": 16}}
        self.assertEqual(len(dogrulayici.ilk_hafta_erzak_hatalari(denge, KOY, AYAR)), 1)

    def test_tablo_yoksa_atlanir(self):
        self.assertEqual(dogrulayici.ilk_hafta_erzak_hatalari({}, KOY, AYAR), [])

    def test_bozuk_tablo_hata(self):
        denge = {"ilk_hafta_erzak": {"acilis_kisi": 2, "gece": 7}}
        self.assertEqual(len(dogrulayici.ilk_hafta_erzak_hatalari(denge, KOY, AYAR)), 1)

    def test_pay_gd_icinde_sabit_degil(self):
        kaynak = (ROOT / "src/veri/koy_ayarlari.gd").read_text(encoding="utf-8")
        self.assertNotIn("ilk_hafta_pay", kaynak)
        self.assertEqual(dogrulayici.gida_kisi_degeri(kaynak), 1)

    def test_gercek_dosyalar_formule_uyar(self):
        self.assertEqual(dogrulayici.main([]), 0)


if __name__ == "__main__":
    unittest.main()
