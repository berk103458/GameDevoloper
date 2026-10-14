import importlib.util
import json
import tempfile
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("denge_dogrula", ROOT / "tools/denge_dogrula.py")
dogrulayici = importlib.util.module_from_spec(spec)
spec.loader.exec_module(dogrulayici)

KOY = '[resource]\nkervan_araligi = 4\nbaslangic_kaynak = {"gida": 30, "odun": 24, "tas": 5}\n'
KAYNAK = "res://data/ayarlar/koy.tres"


class AcilisStokuTest(unittest.TestCase):
    """DEN-09: acilis stoku BUG-22 tablosudur (koy.tres); ikinci baslangic dosyasi yok."""

    def test_koy_tres_okunur(self):
        self.assertEqual(dogrulayici.koy_baslangic_kaynagi(KOY), {"gida": 30, "odun": 24, "tas": 5})

    def test_yalniz_isaret_eden_denge_temiz(self):
        self.assertEqual(dogrulayici.acilis_stoku_hatalari({"acilis_stoku": {"kaynak": KAYNAK}}, KOY, []), [])

    def test_ayni_sayilar_temiz(self):
        denge = {"acilis_stoku": {"kaynak": KAYNAK, "baslangic_kaynak": {"gida": 30, "odun": 24, "tas": 5}}}
        self.assertEqual(dogrulayici.acilis_stoku_hatalari(denge, KOY, []), [])

    def test_iki_dosyada_farkli_odun_hata(self):
        denge = {"acilis_stoku": {"kaynak": KAYNAK, "baslangic_kaynak": {"gida": 30, "odun": 40, "tas": 5}}}
        hatalar = dogrulayici.acilis_stoku_hatalari(denge, KOY, [])
        self.assertEqual(len(hatalar), 1)
        self.assertIn("odun", hatalar[0])

    def test_yanlis_kaynak_yolu_hata(self):
        denge = {"acilis_stoku": {"kaynak": "res://data/baska.tres"}}
        self.assertEqual(len(dogrulayici.acilis_stoku_hatalari(denge, KOY, [])), 1)

    def test_ikinci_baslangic_dosyasi_hata(self):
        hatalar = dogrulayici.acilis_stoku_hatalari({"acilis_stoku": {"kaynak": KAYNAK}}, KOY, ["ayarlar/baslangic.json"])
        self.assertEqual(len(hatalar), 1)
        self.assertIn("ikinci", hatalar[0])

    def test_ikinci_dosya_taramasi_gecici_klasorde(self):
        with tempfile.TemporaryDirectory() as klasor:
            kok = Path(klasor)
            koy = kok / "koy.tres"
            denge = kok / "denge.json"
            koy.write_text(KOY, encoding="utf-8")
            denge.write_text("{}", encoding="utf-8")
            self.assertEqual(dogrulayici.ikinci_baslangic_dosyalari(kok, koy, denge), [])
            (kok / "yedek.json").write_text(json.dumps({"baslangic_kaynak": {"odun": 1}}), encoding="utf-8")
            self.assertEqual(dogrulayici.ikinci_baslangic_dosyalari(kok, koy, denge), ["yedek.json"])

    def test_gercek_repoda_ikinci_dosya_yok(self):
        self.assertEqual(dogrulayici.ikinci_baslangic_dosyalari(), [])
        self.assertEqual(dogrulayici.main([]), 0)


if __name__ == "__main__":
    unittest.main()
