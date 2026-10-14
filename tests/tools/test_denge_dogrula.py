import importlib.util
import json
import tempfile
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("denge_dogrula", ROOT / "tools/denge_dogrula.py")
dogrulayici = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dogrulayici)

DENGE = {"fiyat": {"carpan": 1.0}, "kriz_araligi": {"meclis_bekleme_gun": 2}, "kaynak": "res://x", "bayrak": True}
SINIR = {
    "fiyat.carpan": {"alt": 0.1, "ust": 5.0},
    "kriz_araligi.meclis_bekleme_gun": {"alt": 1, "ust": 14},
}


class DengeDogrulaTest(unittest.TestCase):
    def test_gercek_tablo_temiz(self):
        self.assertEqual(dogrulayici.main([]), 0)

    def test_temiz_veri_hatasiz(self):
        self.assertEqual(dogrulayici.dogrula(DENGE, SINIR), [])

    def test_negatif_fiyat_carpani_acilis_hatasi(self):
        bozuk = {**DENGE, "fiyat": {"carpan": -1.0}}
        hatalar = dogrulayici.dogrula(bozuk, SINIR)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("fiyat.carpan", hatalar[0])
        self.assertIn("sinir disi", hatalar[0])

    def test_ust_sinir_asimi_kirpilmaz_hata_verir(self):
        bozuk = {**DENGE, "kriz_araligi": {"meclis_bekleme_gun": 99}}
        self.assertEqual(len(dogrulayici.dogrula(bozuk, SINIR)), 1)

    def test_sinirsiz_sayisal_anahtar_hata(self):
        sinir = {k: v for k, v in SINIR.items() if k != "fiyat.carpan"}
        hatalar = dogrulayici.dogrula(DENGE, sinir)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("siniri", hatalar[0])

    def test_denge_de_olmayan_sinir_kaydi_hata(self):
        sinir = {**SINIR, "olmayan.anahtar": {"alt": 0, "ust": 1}}
        hatalar = dogrulayici.dogrula(DENGE, sinir)
        self.assertEqual(len(hatalar), 1)
        self.assertIn("olmayan.anahtar", hatalar[0])

    def test_bozuk_sinir_kaydi_hata(self):
        self.assertEqual(len(dogrulayici.dogrula(DENGE, {**SINIR, "fiyat.carpan": {"alt": 5, "ust": 1}})), 1)
        self.assertEqual(len(dogrulayici.dogrula(DENGE, {**SINIR, "fiyat.carpan": {"alt": 0}})), 1)

    def test_dizi_elemanlari_tek_tek_denetlenir(self):
        denge = {"liste": [1.0, 2.0, 50.0]}
        hatalar = dogrulayici.dogrula(denge, {"liste[]": {"alt": 0, "ust": 10}})
        self.assertEqual(len(hatalar), 1)

    def test_bool_sayi_sayilmaz(self):
        self.assertEqual(dogrulayici.sayisal_yapraklar({"a": True}), {})

    def test_komut_satiri_aralik_disi_dosyada_kirmizi(self):
        with tempfile.TemporaryDirectory() as klasor:
            denge = Path(klasor) / "denge.json"
            sinir = Path(klasor) / "sinir.json"
            denge.write_text(json.dumps({**DENGE, "fiyat": {"carpan": -1.0}}), encoding="utf-8")
            sinir.write_text(json.dumps(SINIR), encoding="utf-8")
            self.assertEqual(dogrulayici.main(["--denge", str(denge), "--sinirlar", str(sinir)]), 1)

    def test_eksik_dosya_kirmizi(self):
        self.assertEqual(dogrulayici.main(["--denge", "yok_boyle_dosya.json"]), 1)


if __name__ == "__main__":
    unittest.main()
