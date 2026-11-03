"""GRV kabuk: punto tabanı, gömülü renk istisnası, ekran hükmü, debug ve gece raporu."""
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HEX_ISTISNA = {
    "src/arayuz/renkler.gd",
    "src/arayuz/kabuk.gd",
    "src/arayuz/menu_satiri.gd",
    "src/arayuz/muhur.gd",
    "src/arayuz/okculuk_oyunu.gd",
    "src/arayuz/harman_oyunu.gd",
    "src/arayuz/esya_simgesi.gd",
    "src/arayuz/heybe_cizimi.gd",
    "src/arayuz/hud.gd",
    "src/arayuz/kapi/tansiyon_gostergesi.gd",
}
PUNTO = re.compile(r"boyut\((\d+)\)|font_size\",\s*(\d+)")


def _gd_metinleri(kok: str):
    for yol in (ROOT / kok).rglob("*.gd"):
        goreli = yol.relative_to(ROOT).as_posix()
        yield goreli, yol.read_text(encoding="utf-8")


class KabukTest(unittest.TestCase):
    def test_punto_tek_yerde(self):
        kabuk = (ROOT / "src/arayuz/kabuk.gd").read_text(encoding="utf-8")
        tema = (ROOT / "src/arayuz/tema.gd").read_text(encoding="utf-8")
        for ad in ("GOVDE", "KUCUK", "BASLIK"):
            self.assertIn(f"const {ad} :=", kabuk)
        self.assertIn("const GOVDE_PX := Kabuk.GOVDE", tema)
        self.assertIn("const KUCUK_PX := Kabuk.KUCUK", tema)
        self.assertIn("const BASLIK_PX := Kabuk.BASLIK", tema)
        self.assertIn("return Kabuk.panel()", tema)
        self.assertNotIn("preload(", kabuk)
        self.assertNotIn("load(", kabuk)

    def test_punto_tabani(self):
        for goreli, metin in list(_gd_metinleri("src/arayuz")) + list(_gd_metinleri("src/kapi")):
            if goreli.startswith("src/debug/"):
                continue
            for i, satir in enumerate(metin.splitlines(), 1):
                for eslesen in PUNTO.finditer(satir):
                    sayi = int(next(g for g in eslesen.groups() if g))
                    self.assertGreaterEqual(sayi, 22, f"{goreli}:{i} punto {sayi}")

    def test_gomulu_renk_istisna_disi_yok(self):
        for goreli, metin in _gd_metinleri("src/arayuz"):
            if goreli in HEX_ISTISNA:
                continue
            self.assertNotIn('Color("#', metin, goreli)

    def test_ekran_hukmu(self):
        belge = (ROOT / "docs/arayuz/EKRANLAR.md").read_text(encoding="utf-8")
        satirlar = [s for s in belge.splitlines() if s.startswith("| ") and not s.startswith("| Ekran") and not s.startswith("|---")]
        self.assertGreaterEqual(len(satirlar), 14)
        for satir in satirlar:
            hucre = [h.strip() for h in satir.strip("|").split("|")]
            self.assertIn(hucre[-1], {"sahne", "tema", "eksik"}, satir)

    def test_debug_kabugu_yutmaz(self):
        for yol in (ROOT / "src/debug").rglob("*.gd"):
            metin = yol.read_text(encoding="utf-8")
            self.assertNotIn("Kabuk", metin, yol.name)
            self.assertNotIn("src/arayuz/tema", metin, yol.name)

    def test_gece_raporu_ayri_sahne_degil(self):
        self.assertFalse((ROOT / "src/arayuz/gece_raporu_ekrani.tscn").exists())
        self.assertFalse(list(ROOT.rglob("gece_raporu_ekrani.tscn")))

    def test_yukleme_hex_yok(self):
        metin = (ROOT / "src/arayuz/varlik_yukleme_paneli.gd").read_text(encoding="utf-8")
        self.assertNotIn('Color("#0d1117")', metin)
        self.assertIn("Kabuk.zemin()", metin)

    def test_heybe_defter_ayri(self):
        kapi = (ROOT / "src/arayuz/kapi_ekrani.gd").read_text(encoding="utf-8")
        self.assertIn("Rect2(1172, 104, 716, 952)", kapi)
        self.assertIn("Vector2(0, 92)", kapi)
        self.assertIn("Vector2(1140, 988)", kapi)

    def test_menu_3b_durur(self):
        metin = (ROOT / "src/arayuz/menu_ekrani.gd").read_text(encoding="utf-8")
        self.assertIn("SubViewport", metin)
        self.assertIn("MenuSahnesi.new()", metin)

    def test_tema_dort_dugme_durumu(self):
        tema = (ROOT / "src/arayuz/tema.gd").read_text(encoding="utf-8")
        for durum in ("normal", "hover", "pressed", "disabled"):
            self.assertIn(f'set_stylebox("{durum}", "Button"', tema)
