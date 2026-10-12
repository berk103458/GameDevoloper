import importlib.util
import io
from contextlib import redirect_stdout
from pathlib import Path
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("api", ROOT / "tools/api_sozlesmesi.py")
api = importlib.util.module_from_spec(spec)
spec.loader.exec_module(api)


class ApiTest(unittest.TestCase):
    def test_manifest_audit_never_calls_git_and_rejects_changed_signature(self):
        argv = ["api_sozlesmesi.py", "--manifest", str(ROOT / "tools/api_sozlesmesi_baseline.json")]
        with patch("sys.argv", argv), patch.object(api.subprocess, "check_output", side_effect=AssertionError("Git forbidden")), redirect_stdout(io.StringIO()):
            self.assertEqual(api.main(), 0)
            with patch.object(api, "declaration", return_value="changed-signature"):
                self.assertEqual(api.main(), 1)

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

    def test_blank_line_does_not_hide_constant_or_variable_declaration(self):
        self.assertEqual(api.declaration('\nconst KAYIT_SURUMU := 3\n', "const", "KAYIT_SURUMU"), "constKAYIT_SURUMU")
        self.assertIsNotNone(api.differences('\nvar akce: int = 0\n', '\nvar akce: String = ""\n', "var", "akce"))


import json
import shutil
import subprocess
import sys
import tempfile


class BaselineAuditTest(unittest.TestCase):
    """TEK-12: eski/bozuk baseline sessiz gecmez; araci gercek kaynaga dokunmadan kosar."""

    def _kopyala(self, kok):
        (kok / "tools").mkdir(parents=True, exist_ok=True)
        shutil.copy(ROOT / "tools/api_sozlesmesi.py", kok / "tools/api_sozlesmesi.py")
        for relative in api.CONTRACTS:
            hedef = kok / relative
            hedef.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(ROOT / relative, hedef)
        return kok

    def _kos(self, kok):
        return subprocess.run(
            [sys.executable, "-B", str(kok / "tools/api_sozlesmesi.py"),
             "--manifest", str(kok / "tools/api_sozlesmesi_baseline.json")],
            capture_output=True, text=True, encoding="utf-8", cwd=str(kok))

    def test_broken_baseline_fails_and_correct_baseline_passes(self):
        gercek = (ROOT / "tools/api_sozlesmesi_baseline.json").read_text(encoding="utf-8")
        gecici = tempfile.mkdtemp(prefix="api_sozlesmesi_")
        try:
            kok = self._kopyala(Path(gecici))
            kok_baseline = kok / "tools/api_sozlesmesi_baseline.json"
            kok_baseline.write_text(gercek, encoding="utf-8")
            iyi = self._kos(kok)
            self.assertEqual(iyi.returncode, 0, iyi.stdout + iyi.stderr)
            self.assertIn("PASS", iyi.stdout)
            bozuk = json.loads(gercek)
            bozuk["src/dunya/karakter_model.gd"]["func:kur"] = 'funckur(model:Node3D,ad:String="",ek:int=0)->void'
            kok_baseline.write_text(json.dumps(bozuk), encoding="utf-8")
            kotu = self._kos(kok)
            self.assertEqual(kotu.returncode, 1, kotu.stdout + kotu.stderr)
            self.assertIn("FAIL", kotu.stdout)
        finally:
            shutil.rmtree(gecici, ignore_errors=True)
        self.assertEqual((ROOT / "tools/api_sozlesmesi_baseline.json").read_text(encoding="utf-8"), gercek)

    def test_kapi_ekrani_has_no_eylem_biti_signal(self):
        kaynak = (ROOT / "src/arayuz/kapi_ekrani.gd").read_text(encoding="utf-8-sig")
        self.assertNotIn("eylem_bitti", kaynak)

if __name__ == "__main__":
    unittest.main()


class GenisSozlesmeTest(unittest.TestCase):
    """OMR-52, HAN-51, SOY-47, OZL-30, HFZ-31: korunan dosyalar ve maddenin adını verdiği imzalar sözleşmede."""

    def test_madde_imzalari_sozlesmede(self):
        spec = importlib.util.spec_from_file_location("api_genis", ROOT / "tools/api_sozlesmesi.py")
        api = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(api)
        c = {yol: set(liste) for yol, liste in api.CONTRACTS.items()}
        for ad in ("baslangic", "gece", "isaretle", "yukle", "denetle", "olay_metin"):
            self.assertIn(("func", ad), c["src/koy/perde_gecisi.gd"])
        for ad in ("son", "son_metni", "gostergeler"):
            self.assertIn(("func", ad), c["src/sistemler/nihai_son.gd"])
        self.assertIn(("signal", "oturum_bitti"), c["src/arayuz/koy_ekrani.gd"])
        for yol in ("src/sistemler/koy_nufusu.gd", "src/sistemler/oturum.gd", "src/kapi/fisilti_gazetesi.gd",
                    "src/koy/batil_inanc_histerisi.gd", "src/sistemler/karakter_kadrosu.gd", "src/arayuz/kapi_ekrani.gd"):
            self.assertTrue(c.get(yol), yol)
        # OZL-30: olay_verisi.gd export alanı sayısı sabit (10).
        export = [n for k, n in c["src/veri/olay_verisi.gd"] if k == "var"]
        self.assertEqual(10, len(export))

    def test_export_alani_eklenince_taban_yakalar(self):
        spec = importlib.util.spec_from_file_location("api_genis2", ROOT / "tools/api_sozlesmesi.py")
        api = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(api)
        kaynak = "@export var id: StringName\n@export var agirlik: float = 1.0\n"
        self.assertEqual("@exportvarid:StringName", api.declaration(kaynak, "var", "id"))
        self.assertIsNone(api.declaration(kaynak.replace("var id", "var kimlik"), "var", "id"))
