"""Tracked kaynakların açılış bütünlüğü; salt okunur, CSV/ayar/sır yazmaz.
Godot parse ve gerçek menü için ayrıca acilis_bagimlilik_kontrol.tscn çalıştırılır.
"""
import argparse
import collections
import csv
import json
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
TEXT = {".gd", ".tscn", ".tres", ".csv", ".json", ".godot", ".cfg", ".uid"}
DEPENDENCIES = "EfektHavuzuTemizligi Sanat Pbr Dunya3B KarakterModel DurusDuzeltici KapiManzarasi Katalog Oturum KoyEkrani KapiEkrani Tema VarlikYuklemePaneli GuvenliKayit Ayarlar AdminHud GrafikProfiliAdaptoru KapiAnlikGoruntusu BilgiEkrani MenuEkrani".split()

def scan(root):
    paths = [Path(n) for n in subprocess.check_output(["git", "ls-files", "-z"], cwd=root).decode().split("\0") if n]
    classes, uids = collections.defaultdict(list), collections.defaultdict(list)
    report = {"errors": [], "bom": [], "nested_projects": []}
    for relative in paths:
        path = root / relative
        if not path.is_file():
            report["errors"].append(f"Missing tracked file: {relative.as_posix()}")
            continue
        content = path.read_bytes()
        if path.suffix == ".uid":
            uid = content.strip().decode("ascii", errors="replace")
            if not re.fullmatch(r"uid://[a-z0-9]+", uid):
                report["errors"].append(f"Invalid UID: {relative.as_posix()}")
            uids[uid].append(relative.as_posix())
        if path.suffix not in TEXT:
            continue
        if content.startswith(b"\xef\xbb\xbf"):
            report["bom"].append(relative.as_posix())
        try:
            text = content.decode("utf-8-sig")
        except UnicodeDecodeError:
            report["errors"].append(f"Invalid UTF-8: {relative.as_posix()}")
            continue
        if re.search(r"^(?:<<<<<<<|=======|>>>>>>>)", text, re.M):
            report["errors"].append(f"Merge marker: {relative.as_posix()}")
        if path.suffix == ".gd":
            for name in re.findall(r"^class_name\s+(\w+)", text, re.M):
                classes[name].append(relative.as_posix())
        if path.suffix in {".tscn", ".tres"}:
            owner = root
            for parent in path.parents:
                if parent == root:
                    break
                if (parent / "project.godot").is_file():
                    owner = parent
                    report["nested_projects"].append(parent.relative_to(root).as_posix())
                    break
            for target in re.findall(r'path="(res://[^"\n]+)"', text):
                if not (owner / target[6:]).is_file():
                    report["errors"].append(f"Missing scene/resource: {relative.as_posix()} -> {target}")
        if path.suffix == ".json" and relative.parts[0] == "data":
            try:
                json.loads(text)
            except ValueError:
                report["errors"].append(f"Invalid JSON: {relative.as_posix()}")
    report["class_duplicates"] = {k: v for k, v in classes.items() if len(v) > 1}
    report["uid_duplicates"] = {k: v for k, v in uids.items() if len(v) > 1}
    for kind in ("class_duplicates", "uid_duplicates"):
        if report[kind]:
            report["errors"].append(kind)
    report["dependencies"] = {k: classes.get(k, []) for k in DEPENDENCIES}
    for name, found in report["dependencies"].items():
        if len(found) != 1:
            report["errors"].append(f"Missing/ambiguous dependency class: {name}")
    with (root / "data/metin/metinler.csv").open(encoding="utf-8-sig", newline="") as handle:
        rows = list(csv.reader(handle, strict=True))
    bad_rows = [i + 1 for i, row in enumerate(rows) if len(row) != 2]
    keys = collections.Counter(row[0] for row in rows[1:] if row)
    report["csv"] = {"rows": len(rows), "bad_rows": bad_rows, "duplicate_keys": [k for k, count in keys.items() if count > 1]}
    if bad_rows or report["csv"]["duplicate_keys"]:
        report["errors"].append("CSV structural error")
    report["nested_projects"] = sorted(set(report["nested_projects"]))
    report["passed"] = not report["errors"]
    return report

def main():
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("--report", type=Path)
    cli.add_argument("--remote-check", action="store_true", help="Yerel kritik dosyaları fetch edilmiş origin/festive ile karşılaştırır; değiştirmez")
    args = cli.parse_args()
    report = scan(ROOT)
    if args.remote_check:
        ref = "origin/claude/festive-volta-li1sfm"
        critical = ["src/sistemler/ses.gd", "src/arayuz/ana.gd", "project.godot"]
        critical += [v[0] for v in report["dependencies"].values() if len(v) == 1]
        different = []
        for name in sorted(set(critical)):
            expected = subprocess.check_output(["git", "show", ref + ":" + name], cwd=ROOT)
            actual = (ROOT / name).read_bytes()
            if expected.replace(b"\r\n", b"\n") != actual.replace(b"\r\n", b"\n"):
                different.append(name)
        report["remote_difference"] = different
        if different:
            report["errors"].append("Kritik yerel dosyalar origin/festive ile farklı: " + ", ".join(different))
            report["passed"] = False
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    for error in report["errors"]:
        print(error)
    print("Startup source audit: " + ("PASS" if report["passed"] else "FAIL"))
    return 0 if report["passed"] else 1

if __name__ == "__main__":
    raise SystemExit(main())
