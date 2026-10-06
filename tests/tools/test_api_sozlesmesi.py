import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("api", ROOT / "tools/api_sozlesmesi.py")
api = importlib.util.module_from_spec(spec)
spec.loader.exec_module(api)


class ApiTest(unittest.TestCase):
    def test_deleted_or_changed_parameter_rejected(self):
        old = 'func kur(model: Node3D, ad: String = "") -> void:\n\tpass\n'
        self.assertIsNotNone(api.differences(old, "", "func", "kur"))
        self.assertIsNotNone(api.differences(old, old.replace('ad: String', 'ad: int'), "func", "kur"))

    def test_multiline_and_parenthesis_in_literal(self):
        one = 'func kur(model: Node3D, ad: String = ")") -> void:\n\tpass\n'
        multiline = 'func kur(\n model: Node3D,\n ad: String = ")"\n) -> void:\n\treturn\n'
        self.assertIsNone(api.differences(one, multiline, "func", "kur"))

    def test_literal_whitespace_is_not_ignored(self):
        one = 'func kur(ad: String = "A B") -> void:\n\tpass\n'
        self.assertIsNotNone(api.differences(one, one.replace('A B', 'AB'), "func", "kur"))
        self.assertIsNone(api.differences(one, 'func kur(ad:String="A B")->void:\n\tpass\n', "func", "kur"))

    def test_cache_type_and_signal_payload(self):
        self.assertIsNotNone(api.differences('static var _klip_onbellek: Dictionary = {}\n', 'static var _klip_onbellek: Array = []\n', "var", "_klip_onbellek"))
        self.assertIsNotNone(api.differences('signal devam_istendi(rapor: Dictionary)\n', 'signal devam_istendi()\n', "signal", "devam_istendi"))


if __name__ == "__main__":
    unittest.main()
