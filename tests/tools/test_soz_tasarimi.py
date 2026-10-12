"""DIY-01 kabulü: belge geçer; kimliksiz alınacak satırı 1 hata; bölüm sayısı 2 değilse kalır."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("soz_tasarimi_dogrula", ROOT / "tools/soz_tasarimi_dogrula.py")
arac = importlib.util.module_from_spec(spec)
spec.loader.exec_module(arac)
BELGE = (ROOT / "docs/SOZ_TASARIMI.md").read_text(encoding="utf-8")
GECERLI = arac.kimlikler((ROOT / "ROADMAP_2.md").read_text(encoding="utf-8"))


class SozTasarimiTest(unittest.TestCase):
    def test_gercek_belge_gecer(self):
        self.assertEqual([], arac.dogrula(BELGE, GECERLI))

    def test_kimliksiz_alinacak_parca_bir_hata(self):
        bozuk = BELGE.replace("Görünür zar ve hedefin önceden gösterilmesi (ZAR-01)", "Görünür zar ve hedefin önceden gösterilmesi", 1)
        self.assertNotEqual(bozuk, BELGE)
        hatalar = arac.dogrula(bozuk, GECERLI)
        self.assertEqual(1, len(hatalar), hatalar)
        self.assertIn("kimliği olmayan", hatalar[0])

    def test_ucuncu_bolum_kabul_edilmez(self):
        hatalar = arac.dogrula(BELGE + "\n## Ekler\n\nfazla\n", GECERLI)
        self.assertTrue(any("Bölüm sayısı 3" in h for h in hatalar), hatalar)

    def test_ic_ses_alinacak_olamaz(self):
        bozuk = BELGE.replace("zarsız, yalnız bir satırlık pasif fark ediş (ZAR-06)", "iç ses (ZAR-06)", 1)
        self.assertTrue(any("iç ses" in h for h in arac.dogrula(bozuk, GECERLI)))

    def test_olmayan_kimlik_yakalanir(self):
        bozuk = BELGE.replace("(DIY-12)", "(DIY-97)", 1)
        self.assertTrue(any("DIY-97" in h for h in arac.dogrula(bozuk, GECERLI)))

    def test_yedi_kaynak_dort_satir(self):
        govde = BELGE.split("## Kapı usulü")[0]
        self.assertEqual(7, govde.count("\n### "))
        for satir in arac.SATIRLAR:
            self.assertEqual(7, govde.count(f"- **{satir}:**"), satir)


if __name__ == "__main__":
    unittest.main()
