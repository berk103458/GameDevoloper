"""Audit protected GDScript API declarations against a Git baseline."""
import argparse
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
CONTRACTS = {
    "src/dunya/karakter_model.gd": [("func", "kur"), ("func", "yuru"), ("var", "_klip_onbellek")],
    "src/arayuz/koy_ekrani.gd": [("signal", "devam_istendi"), ("signal", "oturum_bitti")],
    "src/sistemler/oturum.gd": [("func", "gece_sonu"), ("var", "akce"), ("const", "KAYIT_SURUMU")],
    "src/koy/guvenli_kayit.gd": [("func", "yaz"), ("func", "oku"), ("func", "sil")],
}


def normalize(text):
    # Whitespace outside literals is irrelevant; whitespace inside is API data.
    result, quote, escaped, comment = [], None, False, False
    for char in text:
        if comment:
            comment = char != "\n"
            continue
        if quote:
            result.append(char)
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
        elif char in ('"', "'"):
            quote = char
            result.append(char)
        elif char == "#":
            comment = True
        elif not char.isspace():
            result.append(char)
    return "".join(result)


def declaration(source, kind, name):
    start = re.search(r"^[ \t]*(?:static[ \t]+)?" + kind + r"[ \t]+" + re.escape(name) + r"\b", source, re.M)
    if not start:
        return None
    if kind in ("var", "const"):
        line = source[start.start():].splitlines()[0].strip()
        # Values may legitimately change (save version); declaration/type stays.
        return normalize(line.split("=", 1)[0].rstrip(": "))
    opening = source.find("(", start.end())
    if opening < 0:
        return None
    depth, quote, escaped, closing, comment = 0, None, False, None, False
    for index in range(opening, len(source)):
        char = source[index]
        if comment:
            comment = char != "\n"
            continue
        if quote:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
            continue
        if char in ('"', "'"):
            quote = char
        elif char == "#":
            comment = True
        elif char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                closing = index
                break
    if closing is None:
        return None
    header = source[start.start():closing + 1]
    if kind == "func":
        tail = source[closing + 1:].splitlines()[0]
        ending = re.match(r"\s*(?:->\s*([^:]+))?\s*:", tail)
        if not ending:
            return None
        if ending[1]:
            header += "->" + ending[1]
    return normalize(header)


def differences(old, new, kind, name):
    before, after = declaration(old, kind, name), declaration(new, kind, name)
    if before is None:
        return f"Baseline contract missing: {kind} {name}"
    if after is None:
        return f"Deleted/malformed contract: {kind} {name}"
    if before != after:
        return f"Changed contract {kind} {name}: {before} -> {after}"
    return None


def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--base", default="HEAD")
    cli.add_argument("--manifest", type=Path, help="Git çalıştırmadan sabit API imza manifestine karşı denetler")
    args = cli.parse_args()
    manifest = json.loads(args.manifest.read_text(encoding="utf-8")) if args.manifest else None
    errors = []
    for relative, contracts in CONTRACTS.items():
        try:
            old = None if manifest is not None else subprocess.check_output(["git", "show", f"{args.base}:{relative}"], cwd=ROOT, stderr=subprocess.PIPE).decode("utf-8")
            new = (ROOT / relative).read_text(encoding="utf-8-sig")
        except (subprocess.CalledProcessError, OSError) as error:
            errors.append(f"{relative}: {error}")
            continue
        for kind, name in contracts:
            if manifest is not None:
                expected = manifest.get(relative, {}).get(f"{kind}:{name}")
                problem = None if expected is not None and declaration(new, kind, name) == expected else f"Missing/changed manifest contract: {kind} {name}"
            else:
                problem = differences(old, new, kind, name)
            if problem:
                errors.append(f"{relative}: {problem}")
    for error in errors:
        print(error)
    print("API contract: " + ("FAIL" if errors else "PASS"))
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
