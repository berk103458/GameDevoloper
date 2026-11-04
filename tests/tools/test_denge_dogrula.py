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
    def test_aclik_kademesi_ikinci_tablo_olamaz(self):
        for alan in ["aclik", "aclik_kademeleri", "aclik_uretim", "aclik_yatar_esigi"]:
            with self.subTest(alan=alan):
                denge = {alan: {"1": {"uretim": 0.8}}}
                self.assertTrue(dogrulayici.aclik_kademesi_hatalari(denge))
                self.assertTrue(dogrulayici.aclik_kademesi_hatalari({"ekonomi": denge}))

    def test_aclik_kaynagina_referans_serbest(self):
        denge = {"aclik_kademeleri": {"kaynak": "res://data/koy/aclik_kademeleri.json"}}
        self.assertEqual(dogrulayici.aclik_kademesi_hatalari(denge), [])
        self.assertEqual(dogrulayici.aclik_kademesi_hatalari({}), [])

    def test_erzak_esigi_tek_kaynak(self):
        self.assertTrue(dogrulayici.aclik_kademesi_hatalari({"aclik_saglik": {"erzak_esigi": 3}}))
        self.assertEqual(dogrulayici.aclik_kademesi_hatalari(
            {"aclik_saglik": {"kaynak": "res://data/koy/aclik_saglik.json"}}), [])

    def test_gecici_is_verimi_kopyalanmaz(self):
        self.assertEqual(dogrulayici.gecici_is_hatalari(
            {"gecici_isler": {"kaynak": "res://data/gecici_isler.json"}}), [])
        self.assertTrue(dogrulayici.gecici_is_hatalari({"gecici_isler": {"verim_yuzde": 50}}))
        self.assertTrue(dogrulayici.gecici_is_hatalari({"ekonomi": {"gecici_isler": {"verim_yuzde": 50}}}))

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
