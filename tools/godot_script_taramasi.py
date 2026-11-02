"""Headless import/parse audit with structured file/line diagnostics."""
from pathlib import Path
import argparse
import json
import re
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from sanity_check import ROOT, find_godot, run


def diagnostics(output):
    errors = []
    current = None
    for line in output.splitlines():
        stripped = line.strip()
        if stripped.startswith(("SCRIPT ERROR:", "ERROR:")):
            current = {"message": stripped, "file": None, "line": None}
            errors.append(current)
        elif current and current["file"] is None:
            location = re.search(r"\((res://[^)]+):(\d+)\)", stripped)
            if location:
                current["file"], current["line"] = location[1], int(location[2])
    return errors


# KLT-23 / KLT-67: çalışma anında model ya da ağ çağrısı yoktur. src/ içinde HTTP/LLM/soket sınıfı ve
# http(s) dizesi 0; tek istisna localhost oyun köprüsüdür (ADM-16). Yorum satırları sayılmaz.
AG_DESENI = re.compile(r"\b(HTTPRequest|HTTPClient|WebSocketPeer|WebSocketMultiplayerPeer|StreamPeerTCP|TCPServer|PacketPeerUDP|UDPServer)\b|https?://")
AG_ISTISNA = {"src/debug/oyun_koprusu.gd"}

# OGR-53: Cekirdek dosyalarda ipucu metni (`ogretici.` anahtari) gecmez; yalniz adaptor cagrisi vardir.
CEKIRDEK_IPUCU_DOSYALARI = (
    "src/arayuz/ana.gd",
    "src/arayuz/koy_ekrani.gd",
    "src/arayuz/hud.gd",
    "src/arayuz/kapi_ekrani.gd",
)
OGRETICI_ANAHTAR_DESENI = re.compile(r"\bogretici\.[a-z0-9_]+")


def cekirdek_ipucu_ihlalleri(root=ROOT):
    """OGR-53: Cekirdek 4 dosyada `ogretici.*` anahtari gecen satirlari doner: [(dosya, satir, metin)]."""
    ihlaller = []
    for goreli in CEKIRDEK_IPUCU_DOSYALARI:
        dosya = root / goreli
        if not dosya.is_file():
            continue
        for no, satir in enumerate(dosya.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            kod = satir.split("#", 1)[0]
            if OGRETICI_ANAHTAR_DESENI.search(kod):
                ihlaller.append((goreli, no, satir.strip()))
    return ihlaller


def ag_cagrilari(root=ROOT):
    """src/**/*.gd içinde ağ/model çağrısı satırları: [(dosya, satır, metin)]."""
    bulunan = []
    for dosya in sorted((root / "src").rglob("*.gd")):
        yol = dosya.relative_to(root).as_posix()
        if yol in AG_ISTISNA:
            continue
        for no, satir in enumerate(dosya.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            kod = satir.split("#", 1)[0]
            if AG_DESENI.search(kod):
                bulunan.append((yol, no, satir.strip()))
    return bulunan


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--godot")
    cli.add_argument("--timeout", type=float, default=120)
    cli.add_argument("--report", type=Path, default=ROOT / "work/sanity/script-scan.json")
    args = cli.parse_args()
    godot = find_godot(args.godot)
    if not godot:
        cli.error("Godot not found; use --godot or GODOT_BIN")
    ok, output = run([godot, "--headless", "--path", str(ROOT), "--editor", "--import", "--quit"], ROOT, args.timeout)
    errors = diagnostics(output)
    report = {"passed": bool(ok and not errors), "errors": errors}
    if not ok and not errors:
        report["process_failure"] = output
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    args.report.with_suffix(".log").write_text(output, encoding="utf-8")
    for error in errors:
        print(f"{error['file'] or 'Godot'}:{error['line'] or '-'}: {error['message']}")
    print("Headless scan: " + ("PASS" if report["passed"] else "FAIL"))
    return 0 if report["passed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
