import copy
import unittest
from tools.denge_dogrula import bosta_terk_hatalari

class BostaTerkDogrulama(unittest.TestCase):
    def test_sinir_ve_sema(self):
        iyi = {"bosta_terk_aralik": {"gun": 20, "alt": 0, "ust": 3}}
        self.assertEqual(bosta_terk_hatalari(iyi), [])
        for alan, deger in [("gun", 19), ("gun", True), ("alt", -1), ("alt", 4), ("ust", 1.5), ("ust", float("inf")), ("ust", float("nan"))]:
            with self.subTest(alan=alan, deger=deger):
                kotu = copy.deepcopy(iyi)
                kotu["bosta_terk_aralik"][alan] = deger
                self.assertTrue(bosta_terk_hatalari(kotu))
        self.assertTrue(bosta_terk_hatalari({}))
        iyi["bosta_terk_aralik"]["otomatik_ayar"] = 1
        self.assertTrue(bosta_terk_hatalari(iyi))
