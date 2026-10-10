"""Runner must reject errors even when a process exits zero."""
import importlib.util
from pathlib import Path
import sys
import tempfile
import unittest

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

    def test_good_output_passes(self):
        ok, _ = sanity.run([sys.executable, "-c", "print('GEÇTİ')"], ROOT, 5)
        self.assertTrue(ok)

    def test_sandbox_audits_and_real_flow_are_in_full_suite(self):
        commands = {name: command for name, command, _ in sanity.checks("godot", ROOT)}
        self.assertIn("--filesystem", commands["startup-source"])
        self.assertIn("--manifest", commands["protected-api"])
        self.assertIn("tests/oto/levent_firari_kontrol.tscn", commands["levent_firari_kontrol"])
        self.assertIn("20-night-smoke", commands)


if __name__ == "__main__":
    unittest.main()
