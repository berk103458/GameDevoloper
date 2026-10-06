"""Runner must reject errors even when a process exits zero."""
import importlib.util
from pathlib import Path
import sys
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("sanity", ROOT / "tools/sanity_check.py")
sanity = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sanity)


class RunnerTest(unittest.TestCase):
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


if __name__ == "__main__":
    unittest.main()
