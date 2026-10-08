"""Pre-merge local checks. Does not stage, commit, write CSV or touch user saves.

python -B tools/sanity_check.py --godot /path/to/godot
Defaults: CHR validation, CSV/key validation (SYS-09/KVR-11), Python tests, headless import, all unit scripts and
isolated CHR/village UI scenarios. Logs go to work/sanity (gitignored).
"""
from __future__ import annotations
import argparse
import os
from pathlib import Path
import re
import shutil
import signal
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
ERROR = re.compile(r"(?:^|\n)(?:SCRIPT ERROR:|ERROR:)|Failed to load script|\bKALDI\b")


def run(command, root, timeout, env=None):
    process = None
    try:
        options = {"creationflags": subprocess.CREATE_NEW_PROCESS_GROUP} if os.name == "nt" else {"start_new_session": True}
        process = subprocess.Popen(command, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   text=True, encoding="utf-8", errors="replace",
                                   env={**os.environ, **env} if env else None, **options)
        stdout, stderr = process.communicate(timeout=timeout)
        output = stdout + stderr
        return process.returncode == 0 and not ERROR.search(output), output
    except (subprocess.TimeoutExpired, OSError) as error:
        if process is not None and process.poll() is None:
            if os.name == "nt":
                subprocess.run(["taskkill", "/PID", str(process.pid), "/T", "/F"], capture_output=True)
            else:
                os.killpg(process.pid, signal.SIGKILL)
            process.communicate()
        return False, str(error)


def find_godot(explicit=None):
    if explicit:
        return str(Path(explicit).resolve())
    if os.environ.get("GODOT_BIN"):
        return os.environ["GODOT_BIN"]
    for name in ("godot", "godot4"):
        found = shutil.which(name)
        if found:
            return found
    return None


def checks(godot, root):
    yield "chr-source", [sys.executable, "-B", "tools/chr_parser.py", "--check"], None
    yield "metin-csv", [sys.executable, "-B", "tools/metin_dogrula.py", "--kaynak"], None
    yield "python-tests", [sys.executable, "-B", "-m", "unittest", "discover", "-s", "tests/tools"], None
    yield "startup-source", [sys.executable, "-B", "tools/acilis_denetimi.py"], None
    yield "protected-api", [sys.executable, "-B", "tools/api_sozlesmesi.py"], None
    yield "headless-import", [godot, "--headless", "--path", str(root), "--editor", "--import", "--quit"], None
    for script in sorted((root / "tests/unit").rglob("*test.gd")):
        yield script.stem, [godot, "--headless", "--path", str(root), "-s", str(script)], "GEÇTİ"
    for scene in ("chr_kapi_kontrol", "koy_ortam_kontrol", "sira_atlama_kontrol", "karakter_omru_kontrol", "gece_gecis_kontrol", "giris_yukleme_kontrol", "admin_atlama_kontrol", "admin_zaman_kontrol", "admin_kaynak_kontrol", "admin_npc_kontrol", "admin_bayrak_kontrol", "admin_bina_kontrol", "admin_senaryo_kontrol", "admin_snapshot_kontrol", "admin_kasa_kontrol", "admin_iklim_kontrol", "admin_koylu_kontrol", "admin_kriz_kontrol", "admin_diyalog_kontrol", "meslek_uyumu_kontrol", "yas_rolleri_kontrol", "gizli_egilimler_kontrol", "koylu_karti_kontrol", "koylu_gelisim_kontrol", "zanaat_kazasi_kontrol", "meslek_grevi_kontrol", "nobet_yorgunlugu_kontrol", "atama_onizlemesi_kontrol", "odun_zinciri_kontrol", "ceki_lojistigi_kontrol", "tahil_zinciri_kontrol", "harc_zinciri_kontrol", "demir_zinciri_kontrol", "muhafiz_maasi_kontrol", "vergi_politikasi_kontrol", "tuketim_dengesi_kontrol", "iflas_yonetimi_kontrol", "kese_gostergesi_kontrol", "acilis_bagimlilik_kontrol", "ambar_bakimi_kontrol", "kasa_transferi_kontrol", "muhafiz_donanimi_kontrol", "muhafiz_devriyesi_kontrol", "sulama_rutini_kontrol", "oduncu_rutini_kontrol", "coban_surusu_kontrol", "degirmen_hareketi_kontrol", "ates_basi_rutini_kontrol", "zanaat_tezgahi_kontrol", "karakter_hava_kontrol", "sinsi_gece_kontrol", "karakter_ekipman_kontrol", "bekleme_cesitliligi_kontrol", "zemin_navigasyonu_kontrol", "koylu_takibi_kontrol", "atolye_parcaciklari_kontrol", "gezgin_tuccar_kontrol", "celep_hamdullah_kontrol", "nalbur_kontrol", "kumas_aktar_kontrol", "siparis_sozlesme_kontrol"):
        yield scene, [godot, "--headless", "--path", str(root), f"tests/oto/{scene}.tscn"], "GEÇTİ"
    yield "20-night-smoke", [godot, "--headless", "--path", str(root), "tests/oto/otomatik_oyuncu.tscn"], "20 GECE DUMAN: GEÇTİ"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot")
    parser.add_argument("--timeout", type=float, default=120)
    parser.add_argument("--logs", type=Path, default=ROOT / "work/sanity")
    args = parser.parse_args()
    godot = find_godot(args.godot)
    if not godot:
        parser.error("Godot not found; use --godot or GODOT_BIN")
    args.logs.mkdir(parents=True, exist_ok=True)
    failed = []
    for name, command, marker in checks(godot, ROOT):
        env = {"DUMAN_TESTI_20": "1"} if name == "20-night-smoke" else None
        ok, output = run(command, ROOT, args.timeout, env=env)
        if marker and marker not in output:
            ok = False
            output += "\nMissing completion marker: " + marker
        (args.logs / (name + ".log")).write_text(output, encoding="utf-8")
        print(("PASS " if ok else "FAIL ") + name, flush=True)
        if not ok:
            failed.append(name)
    print(f"Sanity: {len(failed)} failed. No staging/commit/push.")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
