"""Unpublished source must be audited without invoking Git in the sandbox."""
import importlib.util
from pathlib import Path
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("startup", ROOT / "tools/acilis_denetimi.py")
startup = importlib.util.module_from_spec(spec)
spec.loader.exec_module(startup)


class FilesystemAuditTest(unittest.TestCase):
    def test_local_sources_pass_without_git(self):
        with patch.object(startup.subprocess, "check_output", side_effect=AssertionError("Git forbidden")):
            self.assertTrue(startup.scan(ROOT, filesystem=True)["passed"])


if __name__ == "__main__":
    unittest.main()
