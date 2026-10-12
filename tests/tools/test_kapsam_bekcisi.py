"""Kapsam bekçisi: depo her kurala uyar ve her kural gerçek bir ihlali yakalar."""
import importlib.util
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("kapsam_bekcisi", ROOT / "tools/kapsam_bekcisi.py")
arac = importlib.util.module_from_spec(spec)
spec.loader.exec_module(arac)

# kural adı → (yol, içerik) — o kuralı ihlal eden en küçük örnek
IHLAL = {
    "HAN-47": ("src/koy/hane_sozlugu.gd", "var iliski := 3\n"),
    "HFZ-30": ("src/sistemler/defter.gd", "var hediye_sayisi := 0\n"),
    "KLT-21": ("data/soz/hitap.json", '{"hitap_puani": 2}'),
    "HAN-50": ("src/dunya/hane_sahnesi.tscn", "[gd_scene]\n"),
    "SOY-31": ("src/koy/gorsel/baloncuk.gd", "func ciz():\n\tSoylentiAgi.oku()\n"),
    "OZL-23": ("data/olaylar/kule_gorusu.tres", "[gd_resource]\n"),
    "OZL-28": ("src/arayuz/olay_sahnesi.tscn", "[gd_scene]\n"),
    "OZL-32": ("src/dunya/gece_haritasi.gd", "extends Node\n"),
    "HFZ-22": ("src/arayuz/ana.gd", "func _son_goster():\n\tHafizaDefteriEkrani.new()\n"),
    "HAN-49": ("src/koy/gorsel/es_gorunumu.gd", "func git(es):\n\tawait es.yuru(Vector3.ZERO)\n"),
    "SRM-15": ("src/arayuz/menu_cikis.gd", "func cik():\n\tget_tree().quit()\n"),
    "GRV-27": ("src/arayuz/panel.gd", 'var t := load("res://assets/art/ui/x.png")\n'),
    "YER-14": ("src/sistemler/ek.gd", "static func cogul_ek(s):\n\treturn s\n"),
    "YER-15": ("src/sistemler/dil.gd", 'func _ready():\n\tTranslationServer.set_locale("en")\n'),
    "OMR-46": ("data/omurga.json", '{"acilis": "ACL-04"}'),
    "OMR-51": ("data/nihai_sonlar.json", '{"sonlar": {"altinci": {}}}'),
}


class KapsamBekcisiTest(unittest.TestCase):
    def test_depo_temiz(self):
        sonuc = arac.denetle()
        self.assertEqual({k: [] for k in sonuc}, sonuc)
        self.assertTrue({"TEK-30", "TEK-32", "TEK-33"} <= set(sonuc))

    def test_tek_commiti_dokunmaz_dosyaya_dokununca_yakalanir(self):
        kayitlar = [("abc1234", "abc1234 fix(TEK-29): bellek", "src/koy/odun_zinciri.gd"),
                    ("def5678", "def5678 feat(MEV-02): donma", "src/dunya/donma_yoneticisi.gd")]
        ihlal = arac.tek_dokunmaz_ihlalleri([k for k in kayitlar if "TEK-" in k[1]])
        self.assertEqual(["abc1234 src/koy/odun_zinciri.gd"], ihlal["TEK-33"])
        self.assertEqual([], ihlal["TEK-30"])

    def test_gir18_ikinci_orta_tus_maddesi_yakalanir(self):
        temiz = "## BÖLÜM 45\n- [ ] **GIR-18:** Orta tuş BUG-24'te kalır.\n## BÖLÜM 46\n"
        self.assertEqual([], arac.gir18_orta_tus(temiz))
        bozuk = temiz.replace("## BÖLÜM 46", "- [ ] **GIR-40:** Orta tuş ile döndürme.\n## BÖLÜM 46")
        self.assertEqual(1, len(arac.gir18_orta_tus(bozuk)))

    def test_grv27_belgelenmis_istisna_gecer(self):
        with tempfile.TemporaryDirectory() as tmp:
            kok = Path(tmp)
            (kok / "src/arayuz").mkdir(parents=True)
            (kok / "docs/arayuz").mkdir(parents=True)
            (kok / "src/arayuz/tema.gd").write_text('var f := load("res://assets/font/a.ttf")\n', encoding="utf-8")
            (kok / "docs/arayuz/YUKLEME_ISTISNALARI.md").write_text("| `src/arayuz/tema.gd` | font | tema |\n", encoding="utf-8")
            self.assertEqual([], arac.denetle(kok)["GRV-27"])

    def test_tek32_chr011_baska_maddede_yakalanir(self):
        temiz = "## BÖLÜM 41\n- [ ] **TEK-32:** Model ölçüsü\n  - Ne: chr_011 Bölüm 44.\n## BÖLÜM 42\n"
        self.assertEqual([], arac.tek32_chr011(temiz))
        bozuk = temiz.replace("## BÖLÜM 42", "- [ ] **TEK-35:** chr_011 pelerini düzelt.\n## BÖLÜM 42")
        self.assertEqual(1, len(arac.tek32_chr011(bozuk)))

    def test_her_kural_ihlali_yakalar_digerleri_temiz_kalir(self):
        for ad, (yol, icerik) in IHLAL.items():
            with self.subTest(kural=ad), tempfile.TemporaryDirectory() as tmp:
                kok = Path(tmp)
                hedef = kok / yol
                hedef.parent.mkdir(parents=True, exist_ok=True)
                hedef.write_text(icerik, encoding="utf-8")
                sonuc = arac.denetle(kok)
                self.assertTrue(sonuc[ad], f"{ad} ihlali yakalamadı")
                self.assertEqual([], [k for k, v in sonuc.items() if v and k != ad])

    def test_ses_sayisi_tabani_asilinca_yakalanir(self):
        with tempfile.TemporaryDirectory() as tmp:
            kok = Path(tmp)
            (kok / "assets/ses").mkdir(parents=True)
            for i in range(arac.SES_TABANI + 1):
                (kok / f"assets/ses/s{i}.wav").write_bytes(b"")
            self.assertTrue(arac.denetle(kok)["SOY-49/OZL-31/AYR-49"])

    def test_hfz30_yorum_ve_diyalog_metnini_saymaz_han47_sayar(self):
        with tempfile.TemporaryDirectory() as tmp:
            kok = Path(tmp)
            (kok / "src/koy").mkdir(parents=True)
            (kok / "src/koy/hane_durumu.gd").write_text('# kalp puanı yok\nvar s := "hediye getirdim"\n', encoding="utf-8")
            sonuc = arac.denetle(kok)
            self.assertEqual([], sonuc["HFZ-30"])
            # HAN-47 Kabul'ü düz rg'dir: hane dosyasında yorum ya da dize de sayılır.
            self.assertEqual(["src/koy/hane_durumu.gd"], sonuc["HAN-47"])


if __name__ == "__main__":
    unittest.main()
