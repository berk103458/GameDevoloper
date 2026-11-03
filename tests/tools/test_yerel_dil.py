"""YER-05, YER-06, YER-10, YER-11, YER-13, YER-16, YER-17, YER-19, YER-21, YER-23."""
from __future__ import annotations

import re
import unittest
from pathlib import Path

from tools.metin_dogrula import validate_sources, validate_text

KOK = Path(__file__).resolve().parents[2]
YEDI = [
    "src/kapi/karar_replik_adaptoru.gd",
    "src/koy/iflas_yoneticisi.gd",
    "src/koy/koylu_karti_verisi.gd",
    "src/koy/levent_firari.gd",
    "src/sistemler/sancak_teftisi.gd",
    "src/koy/gorsel/koylu_takibi.gd",
    "src/koy/gorsel/coban_surusu.gd",
]
FONT = {
    "Alegreya-Italic-wght.ttf",
    "Alegreya-wght.ttf",
    "Cinzel-OFL.txt",
    "Cinzel-wght.ttf",
    "OFL.txt",
}


class YerelDilTest(unittest.TestCase):
    def test_proje_tek_ceviri_ve_fallback(self) -> None:
        metin = (KOK / "project.godot").read_text(encoding="utf-8")
        satir = next(s for s in metin.splitlines() if s.startswith("locale/translations="))
        self.assertEqual(satir.count("res://"), 1)
        self.assertIn('locale/fallback="tr"', metin)
        self.assertNotIn("metinler.en.translation", metin)

    def test_bos_tr_hata_bos_en_yok(self) -> None:
        bos_tr = "keys,tr,en\nornek.deneme.satir,,\n"
        hatalar = validate_text(bos_tr)
        self.assertTrue(any("empty Turkish" in h for h in hatalar))
        bos_en = "keys,tr,en\nornek.deneme.satir,Türkçe,\n"
        self.assertEqual(validate_text(bos_en), [])

    def test_en_cift_bosluk_ve_ad(self) -> None:
        cift = "keys,tr,en\nornek.deneme.satir,Türkçe,iki  boşluk\n"
        self.assertTrue(any("double space in en" in h for h in validate_text(cift)))
        ad = "keys,tr,en\nkarakter.deneme.ad,Ayşe,Ayse\n"
        uyari = [h for h in validate_text(ad) if "YER-17" in h]
        self.assertEqual(len(uyari), 1)
        ayni = "keys,tr,en\nkarakter.deneme.ad,Ayşe,Ayşe\n"
        self.assertEqual([h for h in validate_text(ayni) if "YER-17" in h], [])

    def test_yedi_dosya_yeni_translate_yok(self) -> None:
        for yol in YEDI:
            kod = (KOK / yol).read_text(encoding="utf-8")
            for parca in re.findall(r'"([^"\n]*)"', kod):
                if len(parca) >= 40 and " " in parca and not re.fullmatch(r"[a-z0-9_.%]+", parca):
                    self.fail(f"{yol}: uzun Türkçe cümle kaldı: {parca[:60]}")

    def test_yukleme_istisna_degil_debug_disarida(self) -> None:
        panel = (KOK / "src/arayuz/varlik_yukleme_paneli.gd").read_text(encoding="utf-8")
        self.assertNotIn("Hazırlanıyor", panel)
        belge = (KOK / "docs/METIN_ANAHTAR_STANDARDI.md").read_text(encoding="utf-8")
        self.assertEqual(belge.count("| `src/arayuz/ana.gd` `_hata_goster`"), 1)
        self.assertIn("src/debug/", belge)
        debug = KOK / "src/debug/yerel_deneme.gd"
        debug.write_text('extends Node\nfunc _ready() -> void:\n\ttr("yok.deneme.anahtar")\n', encoding="utf-8")
        try:
            hatalar = validate_sources(KOK, {})
        finally:
            debug.unlink()
        self.assertFalse(any("yerel_deneme" in h for h in hatalar))

    def test_font_sayisi_ve_diyalog_kayit(self) -> None:
        adlar = {p.name for p in (KOK / "assets/font").iterdir() if p.is_file() and not p.name.endswith(".import")}
        self.assertEqual(adlar, FONT)
        self.assertFalse((KOK / "data/metin/metinler.en.translation").exists())
        kayit = (KOK / "src/sistemler/oturum.gd").read_text(encoding="utf-8")
        govde = kayit.split("func kaydet()", 1)[1].split("\nfunc ", 1)[0]
        self.assertNotIn('"dil"', govde)
        sekme = (KOK / "src/arayuz/dil_sekmesi.gd").read_text(encoding="utf-8")
        self.assertNotIn("HTTPRequest", sekme)
        self.assertNotIn("data/soz", sekme)


if __name__ == "__main__":
    unittest.main()
