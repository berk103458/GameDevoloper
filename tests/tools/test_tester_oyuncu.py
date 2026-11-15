import importlib.util
import json
from pathlib import Path
import socket
import threading
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("tester_oyuncu", ROOT / "tools/tester_oyuncu.py")
tester = importlib.util.module_from_spec(spec)
spec.loader.exec_module(tester)


class TesterOyuncuTest(unittest.TestCase):
    def test_politika_yalniz_acik_kararlari_secer(self):
        s = {"hazir": True, "ekran": "kapi", "evre": "karar", "erzak": 40,
             "kisi": {"kararlar": ["ret", "kisla"], "konusma": ""}}
        for ad in ("rastgele", "temkinli", "rusvetci"):
            cmd, args = tester.Politika(ad, 11).sec(s)
            self.assertEqual(cmd, "kapi_karar")
            self.assertIn(args["karar"], s["kisi"]["kararlar"])
        s["kisi"]["kararlar"] = ["kabul", "rusvet"]
        self.assertEqual(tester.Politika("rusvetci", 11).sec(s)[1]["karar"], "rusvet")

    def test_bekleme_son_ve_tohum(self):
        self.assertIsNone(tester.Politika("temkinli", 1).sec({"hazir": False}))
        self.assertIsNone(tester.Politika("temkinli", 1).sec({"hazir": True, "ekran": "son"}))
        s = {"hazir": True, "ekran": "rapor", "secenekler": [{"indeks": i} for i in range(4)]}
        a, b = tester.Politika("rastgele", 55), tester.Politika("rastgele", 55)
        self.assertEqual([a.sec(s) for _ in range(30)], [b.sec(s) for _ in range(30)])

    def test_koy_sadece_onizlemede_yasal_hucre(self):
        s = {"hazir": True, "ekran": "koy", "gun": 0, "koy": {"nufus": 4, "yatak": 2,
             "bosta": [], "binalar": [], "kurulabilir": [{"tur": "cadir", "hucreler": [[3, 4]]}]}}
        self.assertEqual(tester.Politika("temkinli", 1).sec(s),
                         ("koy_eylem", {"tur": "insa", "bina": "cadir", "hucre": [3, 4]}))

    def test_sohbet_dongusunde_tek_secenege_takilmaz(self):
        s = {"hazir": True, "ekran": "kapi", "evre": "sohbet", "gun": 2,
             "kisi": {"ad": "Gaffar", "sirada": 1}, "eylemler": [],
             "secenekler": [{"indeks": 0, "metin": "A"}, {"indeks": 1, "metin": "B"}]}
        p = tester.Politika("temkinli", 1)
        self.assertEqual([p.sec(s)[1]["indeks"] for _ in range(4)], [0, 1, 0, 1])

    def test_arac_raporu_olculmeyeni_kullanilmayanla_karistirmaz(self):
        ozet = {"tohum": 11, "politika": "temkinli", "gece_sayisi": 6, "hata_sayisi": 0,
                "ILKSAAT_ARACLAR": {"heybe": 2, "beyan": -1}}
        rapor = tester.arac_raporu(ozet)
        self.assertIn("| Heybeyi açma | Kullanıldı | 2 |", rapor)
        self.assertIn("| Heybe beyanını sorma | Kullanılmadı | — |", rapor)
        self.assertIn("| Yemin | Ölçülmedi | — |", rapor)

    def test_kayip_yanit_eylemi_tekrarlamaz(self):
        received = []
        with socket.socket() as server:
            server.bind(("127.0.0.1", 0))
            server.listen()
            def answer():
                peer, _ = server.accept()
                with peer, peer.makefile("r", encoding="utf-8") as stream:
                    received.append(json.loads(stream.readline()))
                    # Action accepted, reply lost.
            thread = threading.Thread(target=answer)
            thread.start()
            client = tester.Bridge(port=server.getsockname()[1], timeout=1)
            try:
                with self.assertRaises(tester.BridgeError):
                    client.call("gece_bitir")
            finally:
                client.close()
                thread.join(timeout=3)
            self.assertEqual(len(received), 1)

    def test_hikaye_odakli_dali_ve_eylemleri_gezer_sonra_karar_verir(self):
        p = tester.Politika("hikaye_odakli", 11)
        s = {
            "hazir": True, "ekran": "kapi", "evre": "sohbet", "gun": 1,
            "kisi": {"ad": "Yusuf", "sirada": 0},
            "secenekler": [{"indeks": 0, "metin": "Nereden geldin?"}, {"indeks": 1, "metin": "Kimle yolculuk ettin?"}],
            "eylemler": [{"indeks": 0, "metin": "Heybeyi incele"}, {"indeks": 1, "metin": "Kararını ver"}],
        }
        adimlar = [p.sec(s) for _ in range(4)]
        self.assertEqual(adimlar, [
            ("soru_sor", {"indeks": 0}),
            ("soru_sor", {"indeks": 1}),
            ("devam", {"alan": "eylem", "indeks": 0}),
            ("devam", {"alan": "eylem", "indeks": 1}),
        ])


if __name__ == "__main__":
    unittest.main()
