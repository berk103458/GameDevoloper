"""OMR-01: design/omurga.md referans taraması — `dosya::ad` referanslarının hepsi kodda vardır."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]
BELGE = (ROOT / "design/omurga.md").read_text(encoding="utf-8")
REF = re.compile(r"`([\w./-]+\.(?:gd|tres|json))::(\w+)`")


class OmurgaTest(unittest.TestCase):
    def test_referanslar_kodda_var(self):
        refler = REF.findall(BELGE)
        self.assertGreater(len(refler), 20)
        eksik = []
        for yol, ad in refler:
            dosya = ROOT / yol
            if not dosya.is_file():
                eksik.append(f"{yol} yok")
            elif not re.search(r"\b" + re.escape(ad) + r"\b", dosya.read_text(encoding="utf-8")):
                eksik.append(f"{yol}::{ad} yok")
        self.assertEqual([], eksik)

    def test_kabulun_istedigi_dosyalar_adlariyla_gecer(self):
        for ad in ("perde_gecisi.gd", "nihai_son.gd", "oyun.tres"):
            self.assertIn(ad, BELGE)
        for alan in ("perde2_hedef_gece", "perde2_gece_basina_gelen", "gece_basina_gelen"):
            self.assertIn("oyun.tres::" + alan, BELGE)

    def test_bes_son_ve_iki_perde(self):
        self.assertEqual(3, len(re.findall(r"^## ", BELGE, re.M)))
        for son in ("tekfur_haraccisi", "ertugrul_obasi", "beyin_uc_koyu", "ahi_kasabasi", "uc_tutundu"):
            self.assertIn("nihai_sonlar.json::" + son, BELGE)

    def test_belgede_sayi_esigi_yazilmaz(self):
        # Sayılar dosyada okunur; belge "18 nüfus", "12 gece" gibi denge sayısı taşımaz.
        self.assertIsNone(re.search(r"\b\d+\s*(nüfus|gece|gün|baskın)\b", BELGE))


if __name__ == "__main__":
    unittest.main()
