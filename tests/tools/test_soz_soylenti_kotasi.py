"""SOY-27: "duydum ki" söylenti satırları YAZ-09 kotasında dedikodu çekirdeğine sayılır."""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

from soz_kadro_denetimi import gercek_soylenti_raporu, soylenti_dallari, soylenti_kota_raporu  # noqa: E402


class SoylentiKotasiTest(unittest.TestCase):
    def test_gercek_soylenti_dallari_dedikoduya_sayilir(self):
        dallar = soylenti_dallari(ROOT / "data" / "soz")
        self.assertIn("soylenti_duydum:duydum_ki", dallar)
        self.assertIn("donen_soylenti:donen_soylenti", dallar)
        rapor = gercek_soylenti_raporu()
        self.assertEqual(rapor["dagilim"]["dedikodu"], len(dallar))
        self.assertLessEqual(rapor["dedikodu_orani"], 0.20)
        self.assertEqual(rapor["hatalar"], [])

    def test_kota_asilinca_hata(self):
        kadro = {"cekirdek_dagilimi": {"durust": 4}, "dedikodu_kotasi_yuzde_max": 20}
        rapor = soylenti_kota_raporu(kadro, ["a:1", "b:2"])
        self.assertEqual(rapor["dagilim"]["dedikodu"], 2)
        self.assertEqual(len(rapor["hatalar"]), 1)
        self.assertEqual(rapor["hatalar"][0]["kod"], "SOY-27")

    def test_sinirda_hata_yok(self):
        kadro = {"cekirdek_dagilimi": {"durust": 4}, "dedikodu_kotasi_yuzde_max": 20}
        self.assertEqual(soylenti_kota_raporu(kadro, ["a:1"])["hatalar"], [])


if __name__ == "__main__":
    unittest.main()
