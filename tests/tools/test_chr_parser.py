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
        self.assertEqual(delayed["hedef_sistem"], "ambar_kundak")
        self.assertEqual(delayed["alan"], "Erzak")
        self.assertEqual(delayed["deger"], -3)
        kabul_kundak = next(e for e in data["gecikmeli_etkiler"] if e["karar"] == "kabul")
        self.assertEqual((kabul_kundak["hedef_sistem"], kabul_kundak["alan"], kabul_kundak["deger"]), ("ambar_kundak", "Erzak", -4))
        forced = next(e for e in data["gecikmeli_etkiler"] if e["karar"] == "zorunlu_ret")
        self.assertEqual((forced["tur_offset"], forced["sure"]), (1, 3))
        self.assertEqual(forced["hedef_sistem"], "bar")
        self.assertEqual(data["sonraki_spawns"]["on_accept"]["entity_id"], "CHR_004")
        self.assertEqual(data["diyalog_dugumleri"]["3.2"]["gecisler"][0]["tansiyon_kosulu"], {"operator": ">=", "deger": 8})

        accusation = data["diyalog_dugumleri"]["00"]["secenekler"][2]
        self.assertNotIn("Clue_", data["metinler"][accusation["metin_anahtari"]])
        self.assertEqual(len(accusation["gerekli_ipuclari"]), 3)

    def test_source_variants_and_kop09_spawns(self):
        self.assertIn("Çıngırak", parser.parse(ROOT / "karakterler/CHR_010.md")["sfx"])
        all_pages = [parser.parse(p) for p in sorted((ROOT / "karakterler").glob("CHR_*.md"))]
        self.assertEqual(len(all_pages), 30)
        self.assertEqual(parser.validate_spawns(all_pages), [])
        # KOP-09: Characters may have 0, 3, or 4 real follow-up spawns, zero phantom IDs
        chr007 = next(d for d in all_pages if d["entity_id"] == "CHR_007")
        self.assertEqual(len(chr007["sonraki_spawns"]), 3)
        chr029 = next(d for d in all_pages if d["entity_id"] == "CHR_029")
        self.assertEqual(len(chr029["sonraki_spawns"]), 0)
        # Leaving a phantom spawn ID must produce 1 validation error
        chr029["sonraki_spawns"]["on_accept"] = {"entity_id": "CHR_099", "offset": 3, "kaynak": "test"}
        errors = parser.validate_spawns(all_pages)
        self.assertEqual(len(errors), 1)
        self.assertIn("CHR_099", errors[0])

    def test_kop04_delayed_target_guess_rejected(self):
        source = (ROOT / "karakterler/CHR_001.md").read_text(encoding="utf-8")
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "CHR_001.md"
            # Unstructured sentence relying on word-list guessing must fail with 1 error
            unstructured = source.replace(
                "Tur 4'te Erzak Ambarı binasında kundaklama yaşanır",
                "Tur 4'te gece vakti ambar kundaklama yaşanır"
            )
            path.write_text(unstructured, encoding="utf-8")
            with self.assertRaisesRegex(parser.SourceError, "cannot identify delayed target"):
                parser.parse(path)

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
