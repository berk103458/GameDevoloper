import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("olay_denetimi", ROOT / "tools/olay_on_kosul_denetimi.py")
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)


class OlayOnKosulTest(unittest.TestCase):
    def test_imzasiz_bina_tek_hata(self):
        self.assertEqual(len(mod.denetle({}, "Ambarın kapısı açık.", [])), 1)

    def test_bilinmeyen_anahtar_tek_hata(self):
        self.assertEqual(len(mod.denetle({"hatalı": 1}, "Köy sessiz.", [])), 1)

    def test_imzali_bina(self):
        self.assertEqual(mod.denetle({"bina_var": "ambar"}, "Ambarda çuval var.", ["bina_var"]), [])

    def test_tum_kartlar(self):
        sonuc = mod.tara()
        self.assertEqual(len(sonuc), len(list((ROOT / "data/olaylar").glob("*.tres"))))
        self.assertEqual([(ad, h) for ad, _, h in sonuc if h], [])
