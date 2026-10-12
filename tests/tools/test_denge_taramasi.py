import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("denge_taramasi", ROOT / "tools/denge_taramasi.py")
scanner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scanner)


class DengeTaramasiTest(unittest.TestCase):
    def test_bes_grup_denge_tablosunda(self):
        veri = scanner.gruplar()
        for grup in ("zar_esigi", "acilis_stoku", "fiyat_carpani", "kriz_araligi", "zorluk_carpani"):
            self.assertIn(grup, veri, f"{grup} denge.json icinde yok")
        self.assertIn("kamera_surukleme", veri)

    def test_gd_icinde_denge_sayisi_sifir(self):
        bulunan = scanner.tara()
        self.assertEqual(bulunan, [], f".gd icinde denge sayisi sabiti: {bulunan}")

    def test_kasitli_ihlal_yakalanir(self):
        ornek = (
            "const fiyat_carpani := 1.5\n"
            "const kriz_araligi := 3\n"
            "var meclis_bekleme_gun = 2\n"
        )
        bulunan = scanner.sabitler(ornek)
        self.assertEqual(len(bulunan), 3, bulunan)

    def test_veri_dosyasi_ve_export_varsayilani_yakalanmaz(self):
        ornek = (
            "@export var baslangic_kaynak: Dictionary = {\"gida\": 30}\n"
            "    \"olay_olasiligi\": 0.75\n"
            "static var HIZ: float = 1.0\n"
        )
        self.assertEqual(scanner.sabitler(ornek), [])

    def test_olay_olasiligi_dunya_isaretini_silmez(self):
        # Ek sart: olay olasiligi dunya isaretini silmez.
        oyun = (ROOT / "data/ayarlar/oyun.tres").read_text(encoding="utf-8")
        self.assertIn("olay_olasiligi", oyun)
        sahne = (ROOT / "src/dunya/koy_yonetim_sahnesi.gd").read_text(encoding="utf-8")
        self.assertIn("func isaret(", sahne)


if __name__ == "__main__":
    unittest.main()
