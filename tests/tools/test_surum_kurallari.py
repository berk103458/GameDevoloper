"""SRM-01 pencere adı, KLT-23 ağ/model çağrısı yok, KAY-40 göç hatası paketi kırar."""
import csv
import importlib.util
import io
from pathlib import Path
import re
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]


def _yukle(ad, yol):
    spec = importlib.util.spec_from_file_location(ad, ROOT / yol)
    modul = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(modul)
    return modul


sys.path.insert(0, str(ROOT / "tools"))
tarama = _yukle("godot_script_taramasi", "tools/godot_script_taramasi.py")
sanity = _yukle("sanity_check_srm", "tools/sanity_check.py")


class PencereAdiTest(unittest.TestCase):
    def setUp(self):
        self.proje = (ROOT / "project.godot").read_text(encoding="utf-8")
        satirlar = csv.reader(io.StringIO((ROOT / "data/metin/metinler.csv").read_text(encoding="utf-8-sig")))
        self.metin = {s[0]: s[1] for s in satirlar if len(s) > 1}

    def test_baslik_menu_metninin_duz_kopyasi(self):
        ad = re.search(r'^config/name="(.*)"\s*$', self.proje, re.M).group(1)
        self.assertNotIn("GameDevoloper", ad)
        self.assertEqual(self.metin["arayuz.menu.baslik"], ad)

    def test_kayit_klasoru_sabit_ve_noktasiz(self):
        # Ad noktayla bitiyor; Windows klasör adında sondaki nokta sorun çıkarır. Kayıt yeri sabit ad.
        self.assertIn("config/use_custom_user_dir=true", self.proje)
        klasor = re.search(r'^config/custom_user_dir_name="(.*)"\s*$', self.proje, re.M).group(1)
        self.assertRegex(klasor, r"^[A-Za-z0-9_]+$")

    def test_menu_ikinci_ad_yazmaz(self):
        menu = (ROOT / "src/arayuz/menu_ekrani.gd").read_text(encoding="utf-8")
        self.assertIn('const OYUN_ADI := ""', menu)


class AgCagrisiTest(unittest.TestCase):
    def test_src_icinde_ag_ve_model_cagrisi_yok(self):
        self.assertEqual([], tarama.ag_cagrilari())

    def test_kural_cagriyi_yakalar_yorumu_saymaz(self):
        with tempfile.TemporaryDirectory() as tmp:
            kok = Path(tmp)
            (kok / "src").mkdir()
            (kok / "src/a.gd").write_text('## https://docs.godotengine.org belge bağı\nvar h := HTTPRequest.new()\n', encoding="utf-8")
            (kok / "src/debug").mkdir()
            (kok / "src/debug/oyun_koprusu.gd").write_text('var s := TCPServer.new()\n', encoding="utf-8")
            bulunan = tarama.ag_cagrilari(kok)
            self.assertEqual([("src/a.gd", 2)], [(b[0], b[1]) for b in bulunan])


class GocHatasiTest(unittest.TestCase):
    def test_kasitli_goc_hatasi_paketi_kirar(self):
        kod = "print('ERROR: Kayıt göçü başarısız: surum 3 bilinmiyor'); print('GEÇTİ')"
        ok, cikti = sanity.run([sys.executable, "-c", kod], ROOT, 10)
        self.assertFalse(ok, cikti)


if __name__ == "__main__":
    unittest.main()
