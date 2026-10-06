"""Source-derived compiler regressions, malformed input and write isolation."""
import importlib.util
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("chr_parser", ROOT / "tools/chr_parser.py")
parser = importlib.util.module_from_spec(spec)
spec.loader.exec_module(parser)


class CompilerTest(unittest.TestCase):
    def test_hamza_source_semantics(self):
        data = parser.parse(ROOT / "karakterler/CHR_001.md")
        self.assertEqual(data["entity_id"], "CHR_001")
        self.assertEqual(data["ad"], "Rüstem oğlu Hamza")
        self.assertEqual(data["en_erken_tur"], 3)
        self.assertEqual(data["karar_matrisi"]["rusvet"]["muhafiz_akce"], 4)
        # Timed sabotage must not apply immediately, and lasts separately.
        self.assertEqual(data["karar_matrisi"]["rusvet"]["stat_etkisi"], {})
        delayed = next(e for e in data["gecikmeli_etkiler"] if e["karar"] == "rusvet")
        self.assertEqual(delayed["tur_offset"], 4)
        forced = next(e for e in data["gecikmeli_etkiler"] if e["karar"] == "zorunlu_ret")
        self.assertEqual((forced["tur_offset"], forced["sure"]), (1, 3))
        self.assertEqual(data["sonraki_spawns"]["on_accept"]["entity_id"], "CHR_004")
        self.assertEqual(data["diyalog_dugumleri"]["3.2"]["gecisler"][0]["tansiyon_kosulu"], {"operator": ">=", "deger": 8})

        accusation = data["diyalog_dugumleri"]["00"]["secenekler"][2]
        self.assertNotIn("Clue_", data["metinler"][accusation["metin_anahtari"]])
        self.assertEqual(len(accusation["gerekli_ipuclari"]), 3)

    def test_source_variants_and_external_spawn(self):
        self.assertIn("Çıngırak", parser.parse(ROOT / "karakterler/CHR_010.md")["sfx"])
        data = parser.parse(ROOT / "karakterler/CHR_029.md")
        self.assertGreater(int(data["sonraki_spawns"]["on_accept"]["entity_id"][-3:]), 30)

    def test_missing_field_and_broken_graph_rejected(self):
        source = (ROOT / "karakterler/CHR_001.md").read_text(encoding="utf-8")
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "CHR_001.md"
            path.write_text(source.replace("[Secere_Matrisi]", "[Wrong]"), encoding="utf-8")
            with self.assertRaisesRegex(parser.SourceError, "Secere_Matrisi"):
                parser.parse(path)
            path.write_text(source.replace("[Hedef: Düğüm 1.1]", "[Hedef: Düğüm 99]"), encoding="utf-8")
            with self.assertRaisesRegex(parser.SourceError, "broken node target"):
                parser.parse(path)
            path.write_text(source.replace("CHR_001", "CHR_999"), encoding="utf-8")
            with self.assertRaisesRegex(parser.SourceError, "filename"):
                parser.parse(path)

    def test_resource_escaping(self):
        encoded = parser.resource({"ad": 'Ahmet "usta"\\test\nyeni', "gecikmeli_etkiler": []})
        self.assertIn('\\"usta\\"', encoded)
        self.assertIn('Array[Dictionary]([])', encoded)

    def test_low_initial_tension_preserved(self):
        for n in (22, 24, 26, 28, 30):
            self.assertEqual(parser.parse(ROOT / f"karakterler/CHR_{n:03}.md")["baslangic_tansiyonu"], 1)


if __name__ == "__main__":
    unittest.main()
