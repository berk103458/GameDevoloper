"""CIL-02 hedefli testi: manifest.py yaz() sonrası JSON/CSV ve Ahmet tekilleştirme uyumu."""
import csv
import json
import pathlib
import sys
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]


class ManifestUyumuTest(unittest.TestCase):
    def test_json_ve_csv_esit_ve_eksiksiz(self):
        m = json.loads((ROOT / "assets" / "meshy_manifest.json").read_text(encoding="utf-8"))
        rows = {r["asset_id"]: r for r in m["assetler"]}
        with (ROOT / "assets" / "meshy_manifest.csv").open(encoding="utf-8", newline="") as f:
            csv_rows = list(csv.DictReader(f))
        self.assertEqual(len(csv_rows), len(m["assetler"]))

        # Etkin yapılar baglandi + boy_m dolu
        for aid in ["demirhane", "firin", "ambar", "sifahane", "tas_ev", "atolye", "muhafiz_kislasi",
                    "cadir", "ev", "hizarhane", "odunluk", "tas_ocagi", "tas_yatagi", "avci_cadiri",
                    "kirec_kuyusu", "demir_madeni", "demir_ocagi", "gozetleme_kulesi", "cozumleme_odasi"]:
            self.assertEqual(rows[aid].get("oyun_baglantisi"), "baglandi", aid)
            self.assertIsNotNone(rows[aid].get("boy_m"), aid)

        # Ahmet tekilleştirme kararları
        for kapali in ["degirmen", "ahir", "topluluk_k04"]:
            self.assertEqual(rows[kapali].get("oyun_baglantisi"), "devre_disi", kapali)
            self.assertEqual(rows[kapali].get("durum"), "reddedildi", kapali)

        # Koreli satıcı ekstra klasöründe kalmamış
        ekstra = [p for p in (ROOT / "assets" / "meshy" / "ekstra").glob("*") if "20251018" in p.name]
        self.assertEqual(ekstra, [])


if __name__ == "__main__":
    res = unittest.main(exit=False, verbosity=2)
    sys.exit(0 if res.result.wasSuccessful() else 1)
