"""Run repository Python tests with workspace-owned temporary fixtures on Windows.

Python 3.13's mkdtemp(0700) cannot be reopened under the managed Windows ACL.
Only test fixtures inherit the workspace ACL; production tempfile is unchanged.
"""
from pathlib import Path
import argparse
import json
import os
import subprocess
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


def olcum_calistir(args, ad, ortam_ekleri, etiket):
    # Otomatik oyuncu kendi user:// kaydını temizler. Gerçek oyuncu dizininden ayır.
    calisma = ROOT / "work" / (ad + "_" + uuid.uuid4().hex)
    veri = calisma / "veri"
    veri.mkdir(parents=True)
    ortam = {**os.environ, "APPDATA": str(veri), "XDG_DATA_HOME": str(veri),
            "TOHUM": str(args.tohum), "KLASOR": str(calisma),
            "KABUL_ORANI": str(args.kabul_orani)}
    for bayrak in ("DUMAN_TESTI_20", "ILK_SAAT_OLCUMU", "PERDE1_OLCUMU"):
        ortam.pop(bayrak, None)
    ortam.update(ortam_ekleri)
    log_yolu = calisma / "godot.log"
    komut = [args.godot, "--headless", "--path", str(ROOT), "res://tests/oto/otomatik_oyuncu.tscn"]
    secenekler = {"creationflags": subprocess.CREATE_NO_WINDOW} if os.name == "nt" else {}
    try:
        with log_yolu.open("w", encoding="utf-8") as log:
            sonuc = subprocess.run(komut, cwd=ROOT, env=ortam, stdout=log, stderr=subprocess.STDOUT,
                                   timeout=args.zaman_asimi, **secenekler)
        metin = log_yolu.read_text(encoding="utf-8", errors="replace")
        onek = etiket + " "
        satirlar = [s.removeprefix(onek) for s in metin.splitlines() if s.startswith(onek)]
        if sonuc.returncode or len(satirlar) != 1 or any(x in metin for x in ("SCRIPT ERROR", "Parse Error", "Failed to load script")):
            raise ValueError("Başsız ölçüm temiz bir sonuç üretmedi")
        rapor = json.loads(satirlar[0])
        if int(rapor["tohum"]) != args.tohum:
            raise ValueError("Ölçümün tohum değeri geçersiz")
        if etiket == "ILKSAAT_SURE":
            if rapor["gece"] != 6 or rapor["sure_ms"] <= 0:
                raise ValueError("Ölçümün gece veya süre değeri geçersiz")
        else:
            gece = rapor["gece"]
            gecis = rapor["gecis_gecesi"]
            if not 1 <= gece <= 30 or (gecis != -1 and gecis != gece):
                raise ValueError("Perde ölçümünün gece veya geçiş makbuzu geçersiz")
            if gecis == -1 and gece != 30 and not rapor["son"]:
                raise ValueError("Perde ölçümü geçiş, gece sınırı veya oyun sonuyla bitmeli")
            rapor["kabul_orani"] = args.kabul_orani
            rapor["hedef_aralikta"] = 20 <= gecis <= 30
    except (OSError, ValueError, KeyError, subprocess.TimeoutExpired) as hata:
        print(f"{hata}. Günlük {log_yolu}", file=sys.stderr)
        return 1
    print(etiket + " " + json.dumps({**rapor, "gunluk": str(log_yolu)}, ensure_ascii=False))
    return 0


def cli():
    parser = argparse.ArgumentParser(description=__doc__)
    kip = parser.add_mutually_exclusive_group()
    kip.add_argument("--ilk-saat-suresi", action="store_true")
    kip.add_argument("--perde1-suresi", action="store_true")
    parser.add_argument("--kabul-orani", type=float, default=0.75)
    parser.add_argument("--godot", default=os.environ.get("GODOT_BIN", "godot"))
    parser.add_argument("--tohum", type=int, default=11)
    parser.add_argument("--zaman-asimi", type=int, default=480)
    args = parser.parse_args()
    if args.zaman_asimi <= 0 or args.tohum == 0:
        parser.error("Ölçüm için süre pozitif, tohum sıfırdan farklı olmalı")
    if not 0.0 <= args.kabul_orani <= 1.0:
        parser.error("Kabul oranı 0 ile 1 arasında olmalı")
    if args.ilk_saat_suresi:
        return olcum_calistir(args, "ilk_saat_olcumu", {"ILK_SAAT_OLCUMU": "1", "GECE_SINIRI": "6"}, "ILKSAAT_SURE")
    if args.perde1_suresi:
        return olcum_calistir(args, "perde1_olcumu", {"PERDE1_OLCUMU": "1", "GECE_SINIRI": "30"}, "PERDE1_SURE")
    return main()


if __name__ == "__main__":
    sys.exit(cli())
