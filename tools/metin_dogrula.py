"""SYS-09: Godot translation CSV and CHR/CLUE key validator (read-only)."""
from __future__ import annotations

import argparse
import csv
import io
import re
from pathlib import Path

KEY_PATTERNS = (
    re.compile(r"CHR_\d{3}_DUGUM_\d{2}_REPLIK", re.ASCII),
    re.compile(r"CHR_\d{3}_DUGUM_\d{2}_SEC_\d+_METIN", re.ASCII),
    re.compile(r"CLUE_CHR[0-9]{3}_\w+_(?:BASLIK|TANIM)"),
)


def validate_text(text: str) -> list[str]:
    """Return diagnostics without rewriting keys, translations or source files.

    Existing dotted keys remain valid. New CHR_/CLUE_ keys follow ROADMAP SYS-09.
    Additional locale columns are supported; Turkish translations are required.
    """
    errors: list[str] = []
    reader = csv.reader(io.StringIO(text.lstrip("\ufeff"), newline=""), strict=True)
    try:
        header = next(reader, None)
        if header is None:
            return ["line 1: empty CSV"]
        if not header or header[0] != "keys":
            errors.append("line 1: first column must be 'keys'")
        if "tr" not in header:
            errors.append("line 1: missing 'tr' locale column")
        if len(set(header)) != len(header) or any(not col.strip() for col in header):
            errors.append("line 1: duplicate or empty column name")
        turkish = header.index("tr") if "tr" in header else None
        seen: dict[str, int] = {}
        for row in reader:
            line = reader.line_num
            if len(row) != len(header):
                errors.append(f"line {line}: expected {len(header)} columns, got {len(row)}")
            if not row:
                continue
            key = row[0]
            if not key or any(char.isspace() for char in key):
                errors.append(f"line {line}: empty key or whitespace in key")
            if key in seen:
                errors.append(f"line {line}: duplicate key {key!r} (first at line {seen[key]})")
            else:
                seen[key] = line
            if key.startswith(("CHR_", "CLUE_")) and not any(p.fullmatch(key) for p in KEY_PATTERNS):
                errors.append(f"line {line}: SYS-09 key format invalid: {key!r}")
            if turkish is not None and turkish < len(row) and not row[turkish].strip():
                errors.append(f"line {line}: empty Turkish translation for {key!r}")
    except csv.Error as exc:
        errors.append(f"line {reader.line_num}: malformed CSV: {exc}")
    return errors


def validate_file(path: Path) -> list[str]:
    """Read a UTF-8 CSV and return diagnostics, including read/decode failures."""
    try:
        return validate_text(path.read_text(encoding="utf-8-sig"))
    except (OSError, UnicodeError) as exc:
        return [f"cannot read {path}: {exc}"]


def main() -> int:
    """Validate requested files; exit 1 on any error, otherwise exit 0."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", type=Path,
                        default=[Path(__file__).resolve().parents[1] / "data/metin/metinler.csv"])
    args = parser.parse_args()
    failed = False
    for path in args.paths:
        errors = validate_file(path)
        if errors:
            failed = True
            print(f"FAIL {path}: {len(errors)} error(s)")
            for error in errors:
                print(f"  {error}")
        else:
            print(f"PASS {path}")
    return int(failed)


if __name__ == "__main__":
    raise SystemExit(main())
