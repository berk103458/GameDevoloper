"""YAZ-01 kabulü (onay imzaları hariç): 14 dosya kaynaklı; kaynak başlığı silinen dosya sayımda 13
kalır ve onaylı listeye girmez; çelişen olgu çifti listelenir; coğrafyada olmayan şehir 1 hata."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("dunya_kitabi_dogrula", ROOT / "tools/dunya_kitabi_dogrula.py")
arac = importlib.util.module_from_spec(spec)
spec.loader.exec_module(arac)


class DunyaKitabiTest(unittest.TestCase):
    def setUp(self):
        self.d = arac.dosyalar()

    def test_on_dort_dosya_kaynakli_ve_yapisal_hata_yok(self):
        self.assertEqual(14, arac.kaynakli_sayim(self.d))
        self.assertEqual([], arac.yapisal_hatalar(self.d))

    def test_kaynak_basligi_silinen_dosya_sayimda_13_kalir_ve_onayli_olamaz(self):
        d = dict(self.d)
        d["ahi"] = d["ahi"].replace("## Kaynaklar", "## Notlar").replace("Anlatı yönetmeni: bekliyor", "Anlatı yönetmeni: X").replace("Ahmet: bekliyor", "Ahmet: Y")
        self.assertEqual(13, arac.kaynakli_sayim(d))
        self.assertNotIn("ahi", arac.onayli_dosyalar(d))

    def test_onay_iki_isim_olunca_dosya_onayli(self):
        d = dict(self.d)
        self.assertNotIn("yemek", arac.onayli_dosyalar(d))
        d["yemek"] = d["yemek"].replace("Anlatı yönetmeni: bekliyor", "Anlatı yönetmeni: X").replace("Ahmet: bekliyor", "Ahmet: Y")
        self.assertIn("yemek", arac.onayli_dosyalar(d))

    def test_celisen_olgu_cifti_listelenir(self):
        d = dict(self.d)
        d["meslekler"] = d["meslekler"].replace("- **ciftci:**", "- **kosedag_savasi:** 1250'de oldu.\n- **ciftci:**")
        cift = [c for c in arac.celiskiler(d) if c[0] == "kosedag_savasi"]
        self.assertEqual(1, len(cift))
        self.assertEqual({"meslekler", "tarih"}, set(cift[0][1:]))
        self.assertTrue(any("kosedag_savasi" in h for h in arac.yapisal_hatalar(d)))

    def test_cografyada_olmayan_sehir_bir_hata(self):
        self.assertEqual([], arac.sehir_hatalari("Kayseri'den geldim, Sivas yolundan.", self.d))
        self.assertEqual(["Trabzon"], arac.sehir_hatalari("Trabzon'dan geldim.", self.d))


if __name__ == "__main__":
    unittest.main()
