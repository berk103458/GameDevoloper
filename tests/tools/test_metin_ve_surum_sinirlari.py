"""YAZ-81 / KLT-29: metin satırı silinmez (git farkı); YER-09 istisna listesi; SRM-03 motor sürümü;
YER-22 dil sekmesinde ağ çağrısı yok; SRM-22/23/24 mağaza sayfası sınırları yakalanır."""
import csv
import importlib.util
import io
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))


def _yukle(ad, yol):
    spec = importlib.util.spec_from_file_location(ad, ROOT / yol)
    modul = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(modul)
    return modul


bekci = _yukle("kapsam_bekcisi_ms", "tools/kapsam_bekcisi.py")
tarama = _yukle("godot_script_taramasi_ms", "tools/godot_script_taramasi.py")
# YAZ-81/KLT-29 tabanı: YER-02 kapanış commit'i (cff249b). Bu andan sonra CSV'den satır silinmez.
TABAN = "cff249b"


def _anahtarlar(metin):
    return {s[0] for s in csv.reader(io.StringIO(metin.lstrip("﻿"))) if s and s[0] != "keys"}


class MetinSilinmezTest(unittest.TestCase):
    def test_tabandaki_her_anahtar_hala_var(self):
        try:
            eski = subprocess.run(["git", "show", f"{TABAN}:data/metin/metinler.csv"], cwd=ROOT, capture_output=True,
                                  text=True, encoding="utf-8", timeout=60)
        except OSError:
            self.skipTest("git yok")
        if eski.returncode != 0:
            self.skipTest("taban commit bu klonda yok")
        simdi = (ROOT / "data/metin/metinler.csv").read_text(encoding="utf-8")
        self.assertEqual(set(), _anahtarlar(eski.stdout) - _anahtarlar(simdi), "silinen anahtar")

    def test_yetim_listesi_en_az_bir_satir(self):
        standart = (ROOT / "docs/METIN_ANAHTAR_STANDARDI.md").read_text(encoding="utf-8")
        tablo = standart.split("## 5. Yetim anahtarlar", 1)[1].split("\n## ", 1)[0]
        satirlar = [s for s in tablo.splitlines() if s.startswith("| `")]
        self.assertGreaterEqual(len(satirlar), 1)
        csv_anahtarlari = _anahtarlar((ROOT / "data/metin/metinler.csv").read_text(encoding="utf-8"))
        for s in satirlar:
            self.assertIn(re.search(r"`([^`]+)`", s).group(1), csv_anahtarlari, "yetim CSV'de durur")


class IstisnaVeSurumTest(unittest.TestCase):
    def test_yer09_istisna_listesi_tek_satir_ve_kodda_var(self):
        standart = (ROOT / "docs/METIN_ANAHTAR_STANDARDI.md").read_text(encoding="utf-8")
        tablo = standart.split("## 6. Çeviri dışı istisnalar", 1)[1]
        satirlar = [s for s in tablo.splitlines() if s.startswith("| `")]
        self.assertEqual(1, len(satirlar))
        self.assertIn("Oyun içeriği yüklenemedi.", (ROOT / "src/arayuz/ana.gd").read_text(encoding="utf-8"))

    def test_srm03_motor_47_kalir_ve_not_var(self):
        proje = (ROOT / "project.godot").read_text(encoding="utf-8")
        self.assertRegex(proje, r'config/features=PackedStringArray\("4\.7"')
        self.assertIn("4.7.2", (ROOT / "docs/surum/SURUM_NOTU.md").read_text(encoding="utf-8"))

    def test_yer22_dil_sekmesinde_ag_cagrisi_yok(self):
        # KLT-23 kuralı src/ altının tamamını tarar; dil sekmesi yazılınca da kapsanır.
        self.assertEqual([], [b for b in tarama.ag_cagrilari() if "dil_sekmesi" in b[0]])
        with tempfile.TemporaryDirectory() as tmp:
            kok = Path(tmp)
            (kok / "src/arayuz").mkdir(parents=True)
            (kok / "src/arayuz/dil_sekmesi.gd").write_text('var h := HTTPRequest.new()\n', encoding="utf-8")
            self.assertEqual(["src/arayuz/dil_sekmesi.gd"], [b[0] for b in tarama.ag_cagrilari(kok)])


class MagazaSinirTest(unittest.TestCase):
    def test_gercek_sayfa_temiz(self):
        self.assertEqual([], bekci.srm22_24_magaza(ROOT))

    def test_bulut_seslendirme_ikinci_harita_yakalanir(self):
        temel = "Kayıt: `user://kayit.json`.\n"
        for ek, beklenen in (("Bulut kaydı vardır.", "bulut sözü"), ("Sesli diyalog içerir.", "seslendirme vaadi"),
                             ("Geniş dünya haritası.", "ikinci harita")):
            with self.subTest(ek=ek), tempfile.TemporaryDirectory() as tmp:
                kok = Path(tmp)
                (kok / "docs/surum").mkdir(parents=True)
                (kok / "docs/surum/MAGAZA.md").write_text(temel + ek, encoding="utf-8")
                self.assertEqual([beklenen], bekci.srm22_24_magaza(kok))

    def test_steam_ve_ikinci_tarayici_yakalanir(self):
        with tempfile.TemporaryDirectory() as tmp:
            kok = Path(tmp)
            (kok / "src").mkdir()
            (kok / "src/basarim.gd").write_text("var s := Steam.new()\n", encoding="utf-8")
            (kok / "tools").mkdir()
            (kok / "tools/metin_tarayici.py").write_text("print(1)\n", encoding="utf-8")
            sonuc = bekci.denetle(kok)
            self.assertEqual(["src/basarim.gd"], sonuc["SRM-16"])
            self.assertEqual(["tools/metin_tarayici.py"], sonuc["YER-20"])


if __name__ == "__main__":
    unittest.main()
