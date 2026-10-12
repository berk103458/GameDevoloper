"""Runner must reject errors even when a process exits zero."""
import importlib.util
from pathlib import Path
import os
import sys
import tempfile
import unittest
from unittest import mock

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("sanity", ROOT / "tools/sanity_check.py")
sanity = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sanity)


class RunnerTest(unittest.TestCase):
    def test_runner_lock_blocks_overlap_and_releases_after_exit(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp) / "sanity.lock"
            with sanity.runner_lock(path):
                with self.assertRaises(BlockingIOError):
                    with sanity.runner_lock(path):
                        self.fail("Concurrent runner acquired the lock")
            with sanity.runner_lock(path):
                pass

    def test_success_marker_with_parse_error_fails(self):
        ok, _ = sanity.run([sys.executable, "-c", "print('GEÇTİ\\n  Parse Error: broken')"], ROOT, 5)
        self.assertFalse(ok)

    def test_exit_zero_with_script_error_fails(self):
        ok, output = sanity.run([sys.executable, "-c", "print('SCRIPT ERROR: broken')"], ROOT, 5)
        self.assertFalse(ok)
        self.assertIn("broken", output)

    def test_nonzero_exit_fails(self):
        ok, _ = sanity.run([sys.executable, "-c", "raise SystemExit(7)"], ROOT, 5)
        self.assertFalse(ok)

    def test_timeout_fails(self):
        ok, _ = sanity.run([sys.executable, "-c", "import time; time.sleep(2)"], ROOT, 0.1)
        self.assertFalse(ok)

    def test_sandbox_certificate_noise_is_ignored(self):
        kod = "print('ERROR: Failed to read the root certificate store.'); print('GEÇTİ')"
        ok, _ = sanity.run([sys.executable, "-c", kod], ROOT, 5)
        self.assertTrue(ok)

    def test_other_errors_still_fail_next_to_certificate_noise(self):
        kod = "print('ERROR: Failed to read the root certificate store.'); print('ERROR: gercek hata')"
        ok, _ = sanity.run([sys.executable, "-c", kod], ROOT, 5)
        self.assertFalse(ok)

    def test_python_child_marker_survives_windows_codepage(self):
        temiz = {k: v for k, v in os.environ.items() if k not in ("PYTHONIOENCODING", "PYTHONUTF8")}
        with mock.patch.dict(os.environ, temiz, clear=True):
            ok, output = sanity.run([sys.executable, "-c", "print('BOZUK AYAR MENÜ: GEÇTİ')"], ROOT, 10)
        self.assertTrue(ok)
        self.assertIn("GEÇTİ", output)

    def test_klt10_missing_key_in_20_night_smoke_fails(self):
        uyari = "WARNING: Metin tablosu: eksik anahtar koy.kaynak.tomruk; ekranda [KEY_NOT_FOUND] gösteriliyor\n20 GECE DUMAN: GEÇTİ"
        self.assertEqual(["koy.kaynak.tomruk"], sanity.eksik_anahtar_hatasi("20-night-smoke", uyari))
        self.assertEqual([], sanity.eksik_anahtar_hatasi("20-night-smoke", "20 GECE DUMAN: GEÇTİ"))
        # Birim testleri kasıtlı eksik anahtar dener (guvenli_metin_test); kural yalnız temiz turdadır.
        self.assertEqual([], sanity.eksik_anahtar_hatasi("guvenli_metin_test", uyari))

    def test_good_output_passes(self):
        ok, _ = sanity.run([sys.executable, "-c", "print('GEÇTİ')"], ROOT, 5)
        self.assertTrue(ok)

    def test_sandbox_audits_and_real_flow_are_in_full_suite(self):
        commands = {name: command for name, command, _ in sanity.checks("godot", ROOT)}
        self.assertIn("--filesystem", commands["startup-source"])
        self.assertIn("--manifest", commands["protected-api"])
        self.assertIn("tests/oto/levent_firari_kontrol.tscn", commands["levent_firari_kontrol"])
        self.assertIn("tests/oto/performans_gunlugu_kontrol.tscn", commands["performans_gunlugu_kontrol"])
        self.assertIn("performans_gunlugu_test", commands)
        self.assertIn("20-night-smoke", commands)


if __name__ == "__main__":
    unittest.main()
