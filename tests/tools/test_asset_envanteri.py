"""ARY-05: ROADMAP 2 asset listesi — her 'envantere' kimliği listede bir kez; fazla kimlik 0; wav satırı 0."""
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]
ENVANTER = (ROOT / "docs/EKSIK_ASSET_ENVANTERI.md").read_text(encoding="utf-8")
ROADMAP = (ROOT / "ROADMAP_2.md").read_text(encoding="utf-8")
KIMLIK = re.compile(r"`([A-Z]{2,4}\d{2}[a-z]?-[A-Z0-9*-]+|SAH-EL-(?!CAKISMA`)[A-Z0-9-]+)`")


def roadmap_kimlikleri(metin=ROADMAP):
    """Asset satırlarındaki kimlikler; 'X-01 … X-08' aralığı açılır."""
    kimlikler = set()
    for satir in re.findall(r"Asset:([^\n]*)", metin):
        for m in re.finditer(r"`([A-Z0-9]+-[A-Z]+-)(\d+)` … `\1(\d+)`", satir):
            for n in range(int(m.group(2)), int(m.group(3)) + 1):
                kimlikler.add(f"{m.group(1)}{n:0{len(m.group(2))}d}")
        kimlikler.update(KIMLIK.findall(satir))
    return kimlikler


def bolum_satirlari(metin=ENVANTER):
    govde = metin.split("## H. ROADMAP 2 (ARY-05)", 1)[1]
    return [s for s in govde.splitlines() if s.startswith("| ") and not s.startswith("| ID ") and not s.startswith("|---")]


class AssetEnvanteriTest(unittest.TestCase):
    def test_her_kimlik_bolumde_bir_kez_fazla_kimlik_yok(self):
        bolumdeki = [s.split("|")[1].strip() for s in bolum_satirlari()]
        beklenen = roadmap_kimlikleri()
        self.assertEqual(sorted(beklenen), sorted(set(bolumdeki)), "eksik/fazla kimlik")
        self.assertEqual(len(bolumdeki), len(set(bolumdeki)), "aynı kimlik iki satırda")

    def test_kimlik_dosyada_yalniz_bir_satirda(self):
        for kimlik in roadmap_kimlikleri():
            satir = len(re.findall(r"^\| " + re.escape(kimlik) + r" \|", ENVANTER, re.M))
            self.assertEqual(1, satir, kimlik)

    def test_satir_alanlari_dolu_ve_madde_var(self):
        maddeler = set(re.findall(r"^- \[[ /x]\] \*\*([A-Z]+-\d+):", ROADMAP, re.M))
        for s in bolum_satirlari():
            alanlar = [a.strip() for a in s.strip("|").split("|")]
            self.assertEqual(8, len(alanlar), s)
            self.assertTrue(all(alanlar), s)
            self.assertIn(";", alanlar[5], "TR + EN arama sözcüğü: " + s)
            for madde in re.findall(r"[A-Z]{3}-\d+", alanlar[1]):
                self.assertIn(madde, maddeler, s)

    def test_bolumde_wav_satiri_yok(self):
        self.assertEqual([], [s for s in bolum_satirlari() if ".wav" in s.lower() or "| ses" in s.lower()])

    def test_aralik_acilir(self):
        ornek = "  - Asset: 8 yükleme görseli envantere `ARY04-YUKLEME-01` … `ARY04-YUKLEME-08`."
        self.assertEqual({f"ARY04-YUKLEME-{n:02d}" for n in range(1, 9)}, roadmap_kimlikleri(ornek))


    def test_sah_el_kimligi_rapor_etiketinden_ayrilir(self):
        ornek = "  - Asset: `SAH-EL-TORBA`, rapor etiketi `SAH-EL-CAKISMA`."
        self.assertEqual({"SAH-EL-TORBA"}, roadmap_kimlikleri(ornek))


class SurumIkonuTest(unittest.TestCase):
    """SRM-18: ikon üretilmez; Godot varsayılanı durur, ihtiyaç envanterde SRM18-IKON."""

    def test_ikon_dosyasi_ve_ayari_yok_ihtiyac_envanterde(self):
        proje = (ROOT / "project.godot").read_text(encoding="utf-8")
        self.assertNotIn("config/icon", proje)
        self.assertEqual([], [p for p in ROOT.glob("icon.*")])
        self.assertIn("| SRM18-IKON |", ENVANTER)


if __name__ == "__main__":
    unittest.main()
