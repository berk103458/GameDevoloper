"""KAY-34: tek çekirdekli kadro uyarı verir, yüklemeyi durdurmaz."""
from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "tools"))

from soz_kadro_denetimi import denetle, goc_durur  # noqa: E402


class KadroDenetimiTest(unittest.TestCase):
    def test_tek_cekirdek_uyari(self):
        uyarilar = denetle(["cekirdek_a"] * 5)
        self.assertEqual(len(uyarilar), 1)
        self.assertEqual(uyarilar[0]["tur"], "kota")
        self.assertFalse(goc_durur(uyarilar))

    def test_daginik_kadronun_uyarisi_yok(self):
        self.assertEqual(denetle(["a", "b", "c", "d", "e"]), [])


if __name__ == "__main__":
    unittest.main()
