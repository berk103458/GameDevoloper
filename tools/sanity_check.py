"""Pre-merge local checks. Does not stage, commit, write CSV or touch user saves.

python -B tools/sanity_check.py --godot /path/to/godot
Defaults: CHR validation, CSV/key validation (SYS-09/KVR-11), Python tests, headless import, all unit scripts and
isolated CHR/village UI scenarios. Logs go to work/sanity (gitignored).
"""
from __future__ import annotations
import argparse
from contextlib import contextmanager
import os
from pathlib import Path
import re
import shutil
import signal
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
ERROR = re.compile(r"SCRIPT ERROR|Parse Error|(?:^|\n)ERROR:|Failed to load script|\bKALDI\b")
# Kısıtlı ajan ortamlarında (Codex/Tester sandbox) Godot sistem sertifika deposunu okuyamaz; oyunla ilgisiz
# bu tek satır hata sayılmaz (TST-0011). Başka hiçbir ERROR satırı bu istisnaya girmez.
ORTAM_GURULTUSU = re.compile(r"(?m)^ERROR: Failed to read the root certificate store\.[ \t]*\r?$")


@contextmanager
def runner_lock(path):
    """One full suite per checkout; duplicate automation must not spawn Godot."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a+b") as handle:
        if handle.tell() == 0:
            handle.write(b"0")
            handle.flush()
        handle.seek(0)
        if os.name == "nt":
            import msvcrt
            try:
                msvcrt.locking(handle.fileno(), msvcrt.LK_NBLCK, 1)
            except OSError as error:
                raise BlockingIOError("Another sanity runner is active") from error
        else:
            import fcntl
            fcntl.flock(handle.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        try:
            yield
        finally:
            handle.seek(0)
            if os.name == "nt":
                msvcrt.locking(handle.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                fcntl.flock(handle.fileno(), fcntl.LOCK_UN)


def run(command, root, timeout, env=None):
    process = None
    try:
        options = {"creationflags": subprocess.CREATE_NEW_PROCESS_GROUP} if os.name == "nt" else {"start_new_session": True}
        process = subprocess.Popen(command, cwd=root, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                   text=True, encoding="utf-8", errors="replace",
                                   # Python alt testleri (ör. ayarlar_bozuk_menu_kontrol.py) Windows kod sayfasıyla
                                   # yazarsa "GEÇTİ" işareti utf-8 okunamaz; çocuk süreçlerin çıktısı utf-8 olur.
                                   env={**os.environ, "PYTHONIOENCODING": "utf-8", **(env or {})}, **options)
        stdout, stderr = process.communicate(timeout=timeout)
        output = stdout + stderr
        return process.returncode == 0 and not ERROR.search(ORTAM_GURULTUSU.sub("", output)), output
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
    yield "denge-sinirlari", [sys.executable, "-B", "tools/denge_dogrula.py"], "GECTI"
    yield "python-tests", [sys.executable, "-B", "tools/python_test_runner.py"], None
    yield "startup-source", [sys.executable, "-B", "tools/acilis_denetimi.py", "--filesystem"], None
    yield "protected-api", [sys.executable, "-B", "tools/api_sozlesmesi.py", "--manifest", "tools/api_sozlesmesi_baseline.json"], None
    yield "headless-import", [godot, "--headless", "--path", str(root), "--editor", "--import", "--quit"], None
    # oyun_koprusu_test.gd and tests/tools/test_tester_oyuncu.py are discovered below.
    yield "oyun_koprusu_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/oyun_koprusu_kontrol.tscn"], "GEÇTİ"
    # BUG-0011..15: oturum_fazi, levent_gonderim_gecmisi, atil_bayrak_kapanis,
    # kitlik_nobet_tekrar, aclik_saglik_rng_sinir unit tests are included by discovery.
    # KAY-37: kayit_gocu_soz_test.gd (KAY-03) bu keşifle tek kez pakete girer.
    # KAY-38: söz şeması tek doğrulayıcıdan girer. Kopuk düğüm çıkış kodunu bozar.
    # KAY-39: tests/unit/soz/altin_oynanis_test.gd aynı birim keşfiyle pakettedir.
    yield "soz-sema", [sys.executable, "-B", "tools/soz_dogrula.py", "--sema"], "KAY-38"
    for script in sorted((root / "tests/unit").rglob("*test.gd")):
        ilk = script.read_text(encoding="utf-8", errors="replace").lstrip().splitlines()
        if ilk and ilk[0].strip() == "extends Node":
            yol = "res://" + script.relative_to(root).as_posix()
            yield script.stem, [godot, "--headless", "--path", str(root), "-s", "res://tests/oto/dugum_testi.gd", "--", yol], "GEÇTİ"
        else:
            yield script.stem, [godot, "--headless", "--path", str(root), "-s", str(script)], "GEÇTİ"
    for scene in ("chr_kapi_kontrol", "koy_ortam_kontrol", "sira_atlama_kontrol", "karakter_omru_kontrol", "gece_gecis_kontrol", "zaman_olcegi_kontrol", "giris_yukleme_kontrol", "admin_atlama_kontrol", "admin_zaman_kontrol", "admin_kaynak_kontrol", "admin_npc_kontrol", "admin_bayrak_kontrol", "admin_bina_kontrol", "admin_senaryo_kontrol", "admin_snapshot_kontrol", "admin_kasa_kontrol", "admin_iklim_kontrol", "admin_koylu_kontrol", "admin_kriz_kontrol", "admin_diyalog_kontrol", "meslek_uyumu_kontrol", "yas_rolleri_kontrol", "gizli_egilimler_kontrol", "koylu_karti_kontrol", "koylu_gelisim_kontrol", "zanaat_kazasi_kontrol", "meslek_grevi_kontrol", "nobet_yorgunlugu_kontrol", "atama_onizlemesi_kontrol", "odun_zinciri_kontrol", "ceki_lojistigi_kontrol", "tahil_zinciri_kontrol", "harc_zinciri_kontrol", "demir_zinciri_kontrol", "muhafiz_maasi_kontrol", "vergi_politikasi_kontrol", "tuketim_dengesi_kontrol", "iflas_yonetimi_kontrol", "kese_gostergesi_kontrol", "acilis_bagimlilik_kontrol", "ambar_bakimi_kontrol", "kasa_transferi_kontrol", "muhafiz_donanimi_kontrol", "muhafiz_devriyesi_kontrol", "sulama_rutini_kontrol", "oduncu_rutini_kontrol", "coban_surusu_kontrol", "degirmen_hareketi_kontrol", "ates_basi_rutini_kontrol", "zanaat_tezgahi_kontrol", "karakter_hava_kontrol", "sinsi_gece_kontrol", "casus_devriye_kontrol", "kuyu_zehirleme_kontrol", "ambar_kundaklamasi_kontrol", "divan_ekrani_kontrol", "divan_kanit_kontrol", "divan_kanit_karti_kontrol", "muhafiz_odasi_kontrol", "oda_kasasi_kontrol", "oda_envanter_kontrol", "oda_terazisi_kontrol", "oda_yetenek_kontrol", "oda_adalet_kontrol", "sancak_teftis_kontrol", "oda_gelisim_kontrol", "oda_vicdan_kontrol", "muhafiz_epilogu_kontrol", "harita_ekrani_kontrol", "mogol_oncusu_kontrol", "tekfur_heyeti_kontrol", "sancak_asker_kontrol", "goc_yolu_kontrol", "pusu_ticaret_akisi_kontrol", "gozcu_ongoru_kontrol", "gozcu_kafile_ozeti_kontrol", "oba_ittifaki_kontrol", "cete_anlasmasi_kontrol", "haberci_agi_kontrol", "savunma_konuslanmasi_kontrol", "savunma_guvenligi_kontrol", "diplomatik_heyet_kontrol", "divan_hukum_kontrol", "karaboran_intikami_kontrol", "fisilti_gazetesi_kontrol", "divan_haksizlik_kontrol", "karakter_ekipman_kontrol", "bekleme_cesitliligi_kontrol", "zemin_navigasyonu_kontrol", "koylu_takibi_kontrol", "atolye_parcaciklari_kontrol", "gezgin_tuccar_kontrol", "celep_hamdullah_kontrol", "nalbur_kontrol", "kumas_aktar_kontrol", "siparis_sozlesme_kontrol", "siparis_teslim_kontrol", "siparis_ihlal_kontrol", "silah_karaborsa_kontrol", "ticaret_fiyat_kontrol", "pazar_satis_kontrol", "kisisel_karaborsa_kontrol", "tuccar_kapi_kontrol", "siparis_komisyon_kontrol", "hayvan_takas_kontrol", "saman_bakimi_kontrol", "kervan_koruma_kontrol", "donma_kontrol", "mevsim_kar_kontrol", "cati_kar_kontrol", "ilkbahar_taskini_kontrol", "yaz_su_yangin_kontrol", "hasat_senligi_kontrol", "kapi_gorus_kontrol", "kapi_firtina_kuyrugu_kontrol", "kurt_surusu_kontrol", "mevsim_takvim_kontrol", "kis_hastaligi_kontrol", "saglik_salgini_kontrol", "karantina_kontrol"):
        yield scene, [godot, "--headless", "--path", str(root), f"tests/oto/{scene}.tscn"], "GEÇTİ"
    yield "hekim_ilac_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/hekim_ilac_kontrol.tscn"], "GEÇTİ"
    yield "kuyu_kirliligi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/kuyu_kirliligi_kontrol.tscn"], "GEÇTİ"
    yield "cenaze_yasi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/cenaze_yasi_kontrol.tscn"], "GEÇTİ"
    yield "kitlik_isyani_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/kitlik_isyani_kontrol.tscn"], "GEÇTİ"
    yield "cinar_alti_meclisi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/cinar_alti_meclisi_kontrol.tscn"], "GEÇTİ"
    yield "batil_inanc_histerisi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/batil_inanc_histerisi_kontrol.tscn"], "GEÇTİ"
    yield "levent_firari_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/levent_firari_kontrol.tscn"], "GEÇTİ"
    yield "kriz_kenetlenmesi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/kriz_kenetlenmesi_kontrol.tscn"], "GEÇTİ"
    yield "hastalik_teshis_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/hastalik_teshis_kontrol.tscn"], "GEÇTİ"
    yield "aclik_saglik_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/aclik_saglik_kontrol.tscn"], "GEÇTİ"
    yield "sifahane_triyaj_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/sifahane_triyaj_kontrol.tscn"], "GEÇTİ"
    yield "kitlik_nobeti_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/kitlik_nobeti_kontrol.tscn"], "GEÇTİ"
    yield "sifali_ot_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/sifali_ot_kontrol.tscn"], "GEÇTİ"
    yield "diyalog_sirasi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/diyalog_sirasi_kontrol.tscn"], "GEÇTİ"
    yield "koy_hareket_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/koy_hareket_kontrol.tscn"], "GEÇTİ"
    yield "nihai_son_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/nihai_son_kontrol.tscn"], "GEÇTİ"
    for scene in ("levent_final_kontrol", "atil_bayrak_kapanis_kontrol"):
        yield scene, [godot, "--headless", "--path", str(root), f"tests/oto/{scene}.tscn"], "GEÇTİ"
    yield "tas_yatagi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/tas_yatagi_kontrol.tscn"], "GEÇTİ"
    yield "acilis_denge_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/acilis_denge_kontrol.tscn"], "GEÇTİ"
    yield "yapi_kademeleri", [godot, "--headless", "--path", str(root), "--script", "tools/yapi_kademeleri_dogrula.gd"], "GEÇTİ"
    yield "yapi_kilidi", [godot, "--headless", "--path", str(root), "tests/oto/yapi_kilidi_kontrol.tscn"], "GEÇTİ"
    yield "usta_defteri_envanter", [godot, "--headless", "--path", str(root), "tests/oto/usta_defteri_envanter_kontrol.tscn"], "GEÇTİ"
    yield "cozumleme", [godot, "--headless", "--path", str(root), "tests/oto/cozumleme_kontrol.tscn"], "GEÇTİ"
    yield "ayarlar_is_atamaz", [godot, "--headless", "--path", str(root), "tests/oto/ayarlar_is_atamaz_kontrol.tscn"], "GEÇTİ"
    yield "atama_klavye", [godot, "--headless", "--path", str(root), "tests/oto/atama_klavye_kontrol.tscn"], "GEÇTİ"
    yield "atama_duraklat", [godot, "--headless", "--path", str(root), "tests/oto/atama_duraklat_kontrol.tscn"], "GEÇTİ"
    yield "denge_persona", [godot, "--headless", "--path", str(root), "tests/oto/denge_persona.tscn"], "GEÇTİ"
    yield "sira_olayi_sonucu_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/sira_olayi_sonucu_kontrol.tscn"], "GEÇTİ"
    yield "kapi_kuyu_donusu_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/kapi_kuyu_donusu_kontrol.tscn"], "GEÇTİ"
    yield "bellek_sahne_gecisi_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/bellek_sahne_gecisi_kontrol.tscn"], "GEÇTİ"
    yield "ayarlar_bozuk_menu_kontrol", [sys.executable, "-B", str(root / "tests/oto/ayarlar_bozuk_menu_kontrol.py"), godot], "GEÇTİ"
    yield "devam_pasif_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/devam_pasif_kontrol.tscn"], "GEÇTİ"
    yield "duraklat_menu_kayit_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/duraklat_menu_kayit_kontrol.tscn"], "GEÇTİ"
    yield "tema_onizleme_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/tema_onizleme_kontrol.tscn"], "GEÇTİ"
    yield "kesik_kayit_devam_kontrol", [sys.executable, "-B", str(root / "tests/oto/kesik_kayit_devam_kontrol.py"), godot], "GEÇTİ"
    yield "acilis_koy_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/acilis_koy_kontrol.tscn"], "GEÇTİ"
    yield "performans_gunlugu_kontrol", [godot, "--headless", "--path", str(root), "tests/oto/performans_gunlugu_kontrol.tscn"], "GEÇTİ"
    yield "20-night-smoke", [godot, "--headless", "--path", str(root), "tests/oto/otomatik_oyuncu.tscn"], "20 GECE DUMAN: GEÇTİ"


# KLT-10: temiz turda çalışma anı eksik anahtar listesi (GuvenliMetin.eksikler) boştur; 20 gece dumanı
# "eksik anahtar" uyarısı yazarsa adım düşer. Eksik anahtar listesi tektir (KLT-41): GuvenliMetin'in uyarısı.
EKSIK_ANAHTAR = re.compile(r"Metin tablosu: eksik anahtar (\S+?);")


def eksik_anahtar_hatasi(name, output):
    """20 gece dumanında görülen eksik anahtarlar; başka adımlarda boş."""
    return sorted(set(EKSIK_ANAHTAR.findall(output))) if name == "20-night-smoke" else []


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
        env = {"DUMAN_TESTI_20": "1"} if name == "20-night-smoke" else {"DUMAN_TESTI_ACILIS": "1"} if name == "acilis_denge_kontrol" else None
        ok, output = run(command, ROOT, args.timeout, env=env)
        if marker and marker not in output:
            ok = False
            output += "\nMissing completion marker: " + marker
        eksik = eksik_anahtar_hatasi(name, output)
        if eksik:
            ok = False
            output += "\nKLT-10 eksik anahtar: " + ", ".join(eksik)
        (args.logs / (name + ".log")).write_text(output, encoding="utf-8")
        print(("PASS " if ok else "FAIL ") + name, flush=True)
        if not ok:
            failed.append(name)
    print(f"Sanity: {len(failed)} failed. No staging/commit/push.")
    return 1 if failed else 0


if __name__ == "__main__":
    try:
        with runner_lock(ROOT / "work/sanity_runner.lock"):
            raise SystemExit(main())
    except BlockingIOError as error:
        print(str(error))
        raise SystemExit(2)
