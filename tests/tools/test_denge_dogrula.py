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

    def test_teftis_rusvet_sayisi_kaynaklarla_eslesir(self):
        denge = {"teftis_rusvet_sayisi": 20}
        self.assertEqual(dogrulayici.teftis_esigi_hatalari(denge, {"rusvet_agirlik": 1}, {"yozlasma_esigi": 20}), [])
        self.assertTrue(dogrulayici.teftis_esigi_hatalari(denge, {"rusvet_agirlik": 5}, {"yozlasma_esigi": 20}))

    def test_teftis_bozuk_degerde_cokmez(self):
        for deger in [0, -1, float("inf"), float("nan"), "20", True]:
            with self.subTest(deger=deger):
                self.assertTrue(dogrulayici.teftis_esigi_hatalari(
                    {"teftis_rusvet_sayisi": deger}, {"rusvet_agirlik": 1}, {"yozlasma_esigi": 20}))
        self.assertTrue(dogrulayici.teftis_esigi_hatalari({}, [], {}))

    def test_kis_fiyati_ikinci_tablo_olamaz(self):
        kaynak = {"kaynak": "res://data/ticaret_fiyatlari.json"}
        self.assertEqual(dogrulayici.fiyat_kaynagi_hatalari({"fiyat_carpani": kaynak}), [])
        for veri in [3, {"kis": 3}, {**kaynak, "mevsim_carpani": [1, 0.75, 1, 3]}]:
            with self.subTest(veri=veri):
                self.assertTrue(dogrulayici.fiyat_kaynagi_hatalari({"fiyat_carpani": veri}))
        self.assertTrue(dogrulayici.fiyat_kaynagi_hatalari(
            {"ekonomi": {"fiyat_carpani": {"kis": 3}}}))

    def test_sozlesme_faizi_tek_kaynaktadir(self):
        kaynak = {"sozlesme_cezasi": {"kaynak": "res://data/siparis_ihlali.json"}}
        self.assertEqual(dogrulayici.faiz_kaynagi_hatalari(kaynak), [])
        for veri in [{"gecelik_faiz": 0.1}, {"ekonomi": {"ceza_faizi": 0.1}},
                     {"senaryolar": [{"siparis_faiz": 0.1}]}]:
            with self.subTest(veri=veri):
                self.assertTrue(dogrulayici.faiz_kaynagi_hatalari(veri))

    def test_kriz_araligi_yalniz_sinirlardan_olusur(self):
        self.assertEqual(dogrulayici.kriz_aralik_hatalari({"kriz_aralik": {"alt": 0, "ust": 12}}), [])
        for aralik in [None, {}, {"alt": 0}, {"alt": 2, "ust": 1},
                       {"alt": 0, "ust": 12, "tetikle": "salgin"},
                       {"alt": -1, "ust": 12}, {"alt": True, "ust": 12},
                       {"alt": 0, "ust": float("inf")}, {"alt": 0, "ust": 2.5}]:
            with self.subTest(aralik=aralik):
                self.assertTrue(dogrulayici.kriz_aralik_hatalari({"kriz_aralik": aralik}))
        self.assertTrue(dogrulayici.kriz_aralik_hatalari({}))

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
