"""KAY-31…33, KAY-35, KAY-38, KAY-42, KAY-53 söz doğrulayıcısı."""
from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

from soz_dogrula import (  # noqa: E402
    goc_durur,
    katalog_kimlikleri,
    kayit_hatalari,
    main,
    sema_hatalari,
    sema_kosusu,
)


class SozDogrulaTest(unittest.TestCase):
    def test_betik_adi_biricik(self):
        adlar = [p for p in ROOT.rglob("soz_dogrula.py") if "work" not in p.parts]
        self.assertEqual(len(adlar), 1)
        self.assertEqual(adlar[0].name, "soz_dogrula.py")

    def test_sahte_kimlik_cikis_kodu(self):
        with tempfile.TemporaryDirectory() as klasor:
            yol = Path(klasor) / "kayit.json"
            yol.write_text(json.dumps({"soz": {"hafiza": [{"id": "sahte_kisi"}]}}), encoding="utf-8")
            self.assertEqual(main(["--kayit", str(yol)]), 1)

    def test_eksik_anahtar_gocu_durdurmaz(self):
        katalog = katalog_kimlikleri()
        kayit = {"soz": {"satirlar": ["olmayan.anahtar"]}}
        hatalar = kayit_hatalari(kayit, katalog, {"var.olan"})
        self.assertTrue(any(h["tur"] == "eksik_anahtar" for h in hatalar))
        self.assertFalse(goc_durur(hatalar))

    def test_yasak_kelime_gocu_durdurmaz(self):
        hatalar = kayit_hatalari({"soz": {"not": "bu metin yasakli"}}, katalog_kimlikleri(), None, ["yasakli"])
        self.assertTrue(any(h["tur"] == "yasak_kelime" for h in hatalar))
        self.assertFalse(goc_durur(hatalar))

    def test_uc_hata_tek_listede(self):
        kayit = {"soz": {"hafiza": [{"id": "sahte_kisi"}], "satirlar": ["yok.anahtar"], "not": "yasakli"}}
        hatalar = kayit_hatalari(kayit, katalog_kimlikleri(), {"var.olan"}, ["yasakli"])
        turler = [h["tur"] for h in hatalar]
        self.assertIn("sahte_kimlik", turler)
        self.assertIn("eksik_anahtar", turler)
        self.assertIn("yasak_kelime", turler)
        self.assertGreaterEqual(len(hatalar), 3)
        self.assertFalse(goc_durur(hatalar))

    def test_kopuk_dugum(self):
        hatalar = sema_hatalari('{"dugumler":{"00":{"secenekler":[{"hedef":"yok"}]}}}', "bozuk")
        self.assertEqual(len(hatalar), 1)
        self.assertEqual(hatalar[0]["tur"], "kopuk_dugum")
        self.assertFalse(goc_durur(hatalar))

    def test_otuz_chr_tek_kosu(self):
        hatalar, rapor = sema_kosusu()
        self.assertEqual(rapor["chr"], 30)
        self.assertGreaterEqual(rapor["adli"], 1)
        self.assertGreaterEqual(rapor["sure_ms"], 0)
        self.assertEqual(hatalar, [])


if __name__ == "__main__":
    unittest.main()
