"""SYS-09 / KVR-11 / BUG-07: Godot translation CSV and key validator (read-only).

Origin: PR #2 (feature/sys09-csv-dogrulama, ee9d314). Cursor added the KVR-11 dotted
key standard and a source cross-check (literal tr() keys, catalog .tres key fields and
placeholder/argument counts). Standard: docs/METIN_ANAHTAR_STANDARDI.md
"""
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
# KVR-11: lower-case dotted keys, e.g. arayuz.hud.gun, sohbet.kurt.1.giris
DOTTED_KEY = re.compile(r"[a-z][a-z0-9_]*(?:\.[a-z0-9_]+)+", re.ASCII)
PLACEHOLDER = re.compile(r"%(?!%)[-+ 0#]*(?:\d+|\*)?(?:\.(?:\d+|\*))?[sdifxXocv]")
LITERAL_CALL = re.compile(r"""\b(?:tr|atr|TranslationServer\.translate)\(\s*"([^"+%\\]+)"\s*\)""")
FORMAT_CALL = re.compile(r"""\b(?:tr|TranslationServer\.translate)\(\s*"([^"+%\\]+)"\s*\)\s*%\s*(\[?)""")
TRES_FIELD = re.compile(r"^(\w*anahtar\w*|ad_havuzu)\s*=\s*(.*)$", re.M)
TRES_SKIP_FIELDS = {"animasyon_anahtarlari"}
# YER-02: yeni anahtar alan.alt.ad (en az üç parça); YER-02 öncesi iki parçalı anahtarlar dosyada korunur.
_ESKI = Path(__file__).resolve().parent / "metin_eski_iki_parcali.txt"
ESKI_IKI_PARCALI = frozenset(s.strip() for s in _ESKI.read_text(encoding="utf-8").splitlines()
                             if s.strip() and not s.startswith("#")) if _ESKI.is_file() else frozenset()


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
            elif key and not key.startswith(("CHR_", "CLUE_")) and not DOTTED_KEY.fullmatch(key):
                errors.append(f"line {line}: KVR-11 key format invalid (lower-case dotted): {key!r}")
            elif key.count(".") == 1 and not key.startswith(("CHR_", "CLUE_")) and key not in ESKI_IKI_PARCALI:
                errors.append(f"line {line}: YER-02 new key must be alan.alt.ad (three parts): {key!r}")
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


def read_texts(path: Path) -> dict[str, str]:
    """Key -> Turkish text from a CSV that already passed validate_text."""
    reader = csv.reader(io.StringIO(path.read_text(encoding="utf-8-sig"), newline=""))
    header = next(reader, [])
    col = header.index("tr") if "tr" in header else 1
    return {row[0]: row[col] for row in reader if len(row) > col and row[0]}


def _arg_count(text: str, start: int) -> int | None:
    """Top-level comma count of the [..] literal starting at text[start]."""
    depth, count, i = 0, 1, start
    while i < len(text):
        char = text[i]
        if char == '"':
            i += 1
            while i < len(text) and text[i] != '"':
                i += 2 if text[i] == "\\" else 1
        elif char in "([{":
            depth += 1
        elif char in ")]}":
            depth -= 1
            if depth == 0:
                return count
        elif char == "," and depth == 1:
            count += 1
        i += 1
    return None


def validate_sources(root: Path, texts: dict[str, str]) -> list[str]:
    """Keys used by code/catalog must exist; simple tr("k") % args must match placeholders."""
    errors: list[str] = []
    for script in sorted((root / "src").rglob("*.gd")):
        source = script.read_text(encoding="utf-8", errors="replace")
        rel = script.relative_to(root).as_posix()
        for match in LITERAL_CALL.finditer(source):
            key = match.group(1)
            if DOTTED_KEY.fullmatch(key) and key not in texts:
                line = source.count("\n", 0, match.start()) + 1
                errors.append(f"{rel}:{line}: key not in CSV: {key!r}")
        for match in FORMAT_CALL.finditer(source):
            key = match.group(1)
            if key not in texts:
                continue
            args = _arg_count(source, match.end() - 1) if match.group(2) else 1
            wanted = len(PLACEHOLDER.findall(texts[key].replace("%%", "")))
            if args is not None and args != wanted:
                line = source.count("\n", 0, match.start()) + 1
                errors.append(f"{rel}:{line}: {key!r} gets {args} argument(s) but text has {wanted} placeholder(s)")
    for resource in sorted((root / "data").rglob("*.tres")):
        source = resource.read_text(encoding="utf-8", errors="replace")
        rel = resource.relative_to(root).as_posix()
        for match in TRES_FIELD.finditer(source):
            if match.group(1) in TRES_SKIP_FIELDS:
                continue
            for key in re.findall(r'"([^"]*)"', match.group(2)):
                if key and DOTTED_KEY.fullmatch(key) and key not in texts:
                    errors.append(f"{rel}: {match.group(1)} key not in CSV: {key!r}")
    return errors


def main() -> int:
    """Validate requested files; exit 1 on any error, otherwise exit 0."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", type=Path,
                        default=[Path(__file__).resolve().parents[1] / "data/metin/metinler.csv"])
    parser.add_argument("--kaynak", action="store_true",
                        help="also cross-check src/*.gd and data/*.tres keys against the CSV")
    args = parser.parse_args()
    failed = False
    for path in args.paths:
        errors = validate_file(path)
        if not errors and args.kaynak:
            errors = validate_sources(Path(__file__).resolve().parents[1], read_texts(path))
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
