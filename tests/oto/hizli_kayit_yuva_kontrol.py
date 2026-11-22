"""Run the village F5 save and reload checks in separate Godot processes."""

import argparse
import os
from pathlib import Path
import subprocess
from tempfile import TemporaryDirectory

ROOT = Path(__file__).resolve().parents[2]
SCENE = "res://tests/oto/hizli_kayit_yuva_kontrol.tscn"


def dene(godot: Path, cikti: Path | None) -> int:
    if cikti is not None:
        cikti.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(prefix="hizli-kayit-yuva-", dir=cikti) as klasor:
        kok = Path(klasor).resolve()
        for asama in ("yaz", "yukle"):
            log = kok / f"{asama}.log"
            env = {
                **os.environ,
                "KM_HIZLI_KAYIT_TEST_KOK": kok.as_posix(),
                "KM_HIZLI_KAYIT_TEST_ASAMA": asama,
            }
            secenekler = {"creationflags": subprocess.CREATE_NO_WINDOW} if os.name == "nt" else {}
            try:
                sonuc = subprocess.run(
                    [str(godot), "--headless", "--path", str(ROOT), "--log-file", str(log), SCENE],
                    cwd=ROOT,
                    env=env,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    encoding="utf-8",
                    errors="replace",
                    timeout=85,
                    **secenekler,
                )
            except subprocess.TimeoutExpired:
                print(f"Hızlı kayıt {asama} aşaması süre sınırını aştı.")
                return 1
            metin = log.read_text(encoding="utf-8") if log.is_file() else sonuc.stdout
            if cikti is not None:
                (cikti / f"hizli-kayit-{asama}.log").write_text(metin, encoding="utf-8")
            if sonuc.returncode or f"HIZLI KAYIT {asama}: GEÇTİ" not in metin or "SCRIPT ERROR" in metin:
                print(metin)
                return 1
            print(f"HIZLI KAYIT {asama}: GEÇTİ")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("godot", type=Path)
    parser.add_argument("--cikti", type=Path)
    args = parser.parse_args()
    return dene(args.godot, args.cikti)


if __name__ == "__main__":
    raise SystemExit(main())
