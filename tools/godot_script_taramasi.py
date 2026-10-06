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
