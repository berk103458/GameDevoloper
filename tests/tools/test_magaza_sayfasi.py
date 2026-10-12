"""SRM-17: mağaza metni docs/surum/MAGAZA.md'dedir ve oyuna gömülmez (res:// altında mağaza md 0)."""
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
SAYFA = ROOT / "docs/surum/MAGAZA.md"


def godot_gorur(yol: Path) -> bool:
    """Godot bir dosyayı ancak yolunda .gdignore'lu klasör yoksa içe aktarır ve dışa aktarır."""
    klasor = yol.parent
    while klasor != ROOT.parent:
        if (klasor / ".gdignore").exists():
            return False
        if klasor == ROOT:
            break
        klasor = klasor.parent
    return True


class MagazaSayfasiTest(unittest.TestCase):
    def test_sayfa_var_ve_bes_son_dürüst_satir(self):
        metin = SAYFA.read_text(encoding="utf-8")
        sonlar = json.loads((ROOT / "data/nihai_sonlar.json").read_text(encoding="utf-8"))["sonlar"]
        for son in sonlar.values():
            self.assertIn(son["baslik"], metin)
        self.assertIn("Seslendirme yoktur", metin)
        self.assertIn("Tek harita", metin)

    def test_res_altinda_magaza_md_sifir(self):
        gorulen = [p for p in ROOT.rglob("*.md") if "magaza" in p.name.lower() and ".godot" not in p.parts and godot_gorur(p)]
        self.assertEqual([], gorulen)

    def test_oyun_kodu_sayfayi_okumaz(self):
        for gd in (ROOT / "src").rglob("*.gd"):
            metin = gd.read_text(encoding="utf-8", errors="replace")
            self.assertNotIn("MAGAZA.md", metin, gd)
            self.assertNotIn("docs/surum", metin, gd)

    def test_kural_gdignore_disindaki_md_yi_yakalar(self):
        self.assertFalse(godot_gorur(SAYFA))
        self.assertTrue(godot_gorur(ROOT / "src/arayuz/MAGAZA.md"))


if __name__ == "__main__":
    unittest.main()
