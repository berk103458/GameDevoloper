"""ARY-01: üç şablon belgede ve veride birebir; dört düğme durumu; seçim satırı; seçim yokken tema dokunulmaz."""
import json
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]
VERI = json.loads((ROOT / "data/arayuz/tema_sablonlari.json").read_text(encoding="utf-8"))
BELGE = (ROOT / "docs/arayuz/SABLONLAR.md").read_text(encoding="utf-8")


def secim(belge=BELGE):
    m = re.search(r"^- Seçilen şablon:(.*)$", belge, re.M)
    return m.group(1).strip() if m else None


class TemaSablonlariTest(unittest.TestCase):
    def test_uc_sablon_ve_alanlari(self):
        sablonlar = VERI["sablonlar"]
        self.assertEqual(3, len(sablonlar))
        for s in sablonlar:
            for alan in ("renk", "cerceve", "yazi", "dugme", "panel"):
                self.assertIn(alan, s, s["kimlik"])
            self.assertEqual({"normal", "ustunde", "basili", "kapali"}, set(s["dugme"]))
            self.assertIn(s["yazi"]["baslik"], ("Alegreya", "Cinzel"))
            self.assertIn(s["yazi"]["govde"], ("Alegreya", "Cinzel"))

    def test_belge_veriyle_birebir(self):
        for s in VERI["sablonlar"]:
            self.assertIn(f"## {s['ad']} (`{s['kimlik']}`)", BELGE)
            for renk in s["renk"].values():
                self.assertIn(f"`{renk}`", BELGE)
            for durum in s["dugme"].values():
                for renk in durum.values():
                    self.assertIn(f"`{renk}`", BELGE)
        for ad in ("Normal", "Üstünde", "Basılı", "Kapalı"):
            self.assertIn(f"| {ad} |", BELGE)

    def test_renk_ciftleri_ayrik(self):
        ciftler = [(s["renk"]["zemin"], s["renk"]["vurgu"]) for s in VERI["sablonlar"]]
        self.assertEqual(len(ciftler), len(set(ciftler)))

    def test_secim_satiri_var_ve_bosken_tema_dokunulmaz(self):
        self.assertIsNotNone(secim())
        if secim() == "":
            self.assertFalse((ROOT / "src/arayuz/tema").exists(), "seçim yokken src/arayuz/tema oluşmaz")
            self.assertNotIn("tema_sablonlari", (ROOT / "src/arayuz/tema.gd").read_text(encoding="utf-8"))

    def test_ana_sahne_degismez_ve_onizleme_var(self):
        proje = (ROOT / "project.godot").read_text(encoding="utf-8")
        self.assertIn('run/main_scene="res://src/arayuz/ana.tscn"', proje)
        self.assertTrue((ROOT / "src/arayuz/tema_onizleme.tscn").is_file())

    def test_secim_okuyucu(self):
        self.assertEqual("ocak", secim("- Seçilen şablon: ocak\n"))
        self.assertEqual("", secim("- Seçilen şablon: \n"))


if __name__ == "__main__":
    unittest.main()
