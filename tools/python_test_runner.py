"""Run repository Python tests with workspace-owned temporary fixtures on Windows.

Python 3.13's mkdtemp(0700) cannot be reopened under the managed Windows ACL.
Only test fixtures inherit the workspace ACL; production tempfile is unchanged.
"""
from pathlib import Path
import os
import sys
import tempfile
import unittest
import uuid

ROOT = Path(__file__).resolve().parents[1]


def main():
    original = tempfile.mkdtemp
    base = ROOT / "work/sanity_python_tmp"

    def fixture_directory(suffix=None, prefix=None, dir=None):
        parent = Path(dir).resolve() if dir else base
        if not parent.is_relative_to(ROOT):
            raise ValueError("Test temporary directory must stay in workspace")
        parent.mkdir(parents=True, exist_ok=True)
        path = parent / ((prefix or "tmp") + uuid.uuid4().hex + (suffix or ""))
        path.mkdir()
        return str(path)

    try:
        if os.name == "nt":
            tempfile.mkdtemp = fixture_directory
        suite = unittest.defaultTestLoader.discover(str(ROOT / "tests/tools"))
        result = unittest.TextTestRunner().run(suite)
        return 0 if result.wasSuccessful() else 1
    finally:
        tempfile.mkdtemp = original


if __name__ == "__main__":
    sys.exit(main())
