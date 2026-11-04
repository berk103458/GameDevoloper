"""TEK-25: kesik kayıt hata ekranını açar, menüye dönüş ve dosya korunur."""
from pathlib import Path
import os
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
ORTAM_GURULTUSU = re.compile(r"^ERROR: Failed to read the root certificate store\.[ \t]*$", re.M)


def main():
    result = subprocess.run(
        [sys.argv[1], "--headless", "--path", str(ROOT), "tests/fixtures/kesik_kayit_menusu.tscn"],
        cwd=ROOT, capture_output=True, text=True, encoding="utf-8", timeout=75,
    )
    output = result.stdout + result.stderr
    directory = os.environ.get("TEK25_TEST_CIKTI", "")
    if directory:
        path = Path(directory)
        path.mkdir(parents=True, exist_ok=True)
        (path / "kesik-kayit-menu.log").write_text(output, encoding="utf-8")
    errors = re.findall(r"^ERROR: (.*)$", ORTAM_GURULTUSU.sub("", output), re.M)
    valid = (
        result.returncode == 0
        and not errors
        and "TEK25 KESİK KAYIT MENÜSÜ: GEÇTİ" in output
        and not re.search(r"SCRIPT ERROR|Failed to load script|\bKALDI\b", output)
    )
    if not valid:
        print(output)
        print("KESİK KAYIT MENÜ: KALDI")
        return 1
    print("Kesik kayıtta hata ekranı, menüye dönüş ve dosya koruması doğrulandı.")
    print("KESİK KAYIT MENÜ: GEÇTİ")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())