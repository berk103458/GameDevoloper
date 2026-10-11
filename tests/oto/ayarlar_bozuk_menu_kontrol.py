"""TEK-18 fault injection: exact expected config errors in an isolated Godot child."""
from pathlib import Path
import os
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]


def main():
    result = subprocess.run(
        [sys.argv[1], "--headless", "--path", str(ROOT), "tests/fixtures/ayarlar_bozuk_menu.tscn"],
        cwd=ROOT, capture_output=True, text=True, encoding="utf-8", timeout=75,
    )
    output = result.stdout + result.stderr
    directory = os.environ.get("TEK18_TEST_CIKTI", "")
    if directory:
        path = Path(directory)
        path.mkdir(parents=True, exist_ok=True)
        (path / "expected-config-errors.log").write_text(output, encoding="utf-8")
    errors = re.findall(r"^ERROR: (.*)$", output, re.M)
    expected = (
        len(errors) == 2
        and re.fullmatch(r"ConfigFile parse error at user://tek18_\d+_\d+\.cfg:0: Unexpected EOF while parsing simple tag\.", errors[0])
        and errors[1] == "Ayar dosyası okunamadı; varsayılanlar kullanılıyor"
    )
    valid = (
        result.returncode == 0 and expected
        and "TEK18 VARSAYILAN VE GERÇEK MENÜ: GEÇTİ" in output
        and not re.search(r"SCRIPT ERROR|Failed to load script|\bKALDI\b", output)
    )
    if not valid:
        print(output)
        print("BOZUK AYAR MENÜ: KALDI")
        return 1
    print("Beklenen iki bozuk ayar kaydı doğrulandı; varsayılanlar ve gerçek menü açık.")
    print("BOZUK AYAR MENÜ: GEÇTİ")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
