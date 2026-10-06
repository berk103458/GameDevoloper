import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("scanner", ROOT / "tools/godot_script_taramasi.py")
scanner = importlib.util.module_from_spec(spec)
spec.loader.exec_module(scanner)


class ScannerTest(unittest.TestCase):
    def test_error_path_line_and_multiple_diagnostics(self):
        output = "SCRIPT ERROR: Parse Error: unknown name\n at: GDScript::reload (res://src/test.gd:42)\nERROR: Failed to load script\n at: load (modules/gdscript/file.cpp:12)"
        errors = scanner.diagnostics(output)
        self.assertEqual(len(errors), 2)
        self.assertEqual((errors[0]["file"], errors[0]["line"]), ("res://src/test.gd", 42))
        self.assertIsNone(errors[1]["file"])

    def test_warning_is_not_script_failure(self):
        self.assertEqual(scanner.diagnostics("WARNING: using path fallback\nGodot Engine\n"), [])


if __name__ == "__main__":
    unittest.main()
