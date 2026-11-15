"""KLT kapı testleri. Oyun diyaloğu yazılmaz; paketler anahtar ve kural fişidir."""
from __future__ import annotations

import csv
import json
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

from metin_dogrula import validate_text  # noqa: E402
from soz_kapi import (  # noqa: E402
    denetle,
    eski_cumleler,
    godot_baslatir_mi,
    kitap_exportta_mi,
    kopyala,
    kor_okuma_gecmis_hatalari,
    soz_kopya_taramasi,
    src_editor_sayisi,
    _temiz_paket,
)


KOR = [{"id": "ornek", "skor": 0.9, "agiz": 3}]


class SozKapiTest(unittest.TestCase):
    def test_tek_soz_motoru_sinifi(self):
        sinif = re.compile(r"^class_name +\w*Soz\w*(?:Motor|Yurutucu)\w*\b", re.M)
        bulunan = []
        for yol in (ROOT / "src").rglob("*.gd"):
            kaynak = yol.read_text(encoding="utf-8-sig")
            bulunan.extend((yol.relative_to(ROOT).as_posix(), ad) for ad in sinif.findall(kaynak))
        self.assertEqual(bulunan, [("src/soz/soz_motoru.gd", "class_name SozMotoru")])

    def test_kirmizi_yazim_kapisi_tur_diyalog_kutusunu_acik_birakir(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "Kaldı; bekler."
        with tempfile.TemporaryDirectory() as klasor:
            yol = Path(klasor) / "paket.json"
            yol.write_text(json.dumps(paket), encoding="utf-8")
            sonuc = subprocess.run(
                [sys.executable, "-B", str(ROOT / "tools" / "soz_kapi.py"), "--paket", str(yol)],
                capture_output=True, text=True, encoding="utf-8", timeout=15,
            )
        self.assertEqual(sonuc.returncode, 1)
        self.assertIn("hata=1", sonuc.stdout)
        sablon = (ROOT / "docs" / "soz" / "HAT.md").read_text(encoding="utf-8")
        self.assertIn("- [x] Oyun testleri geçti.", sablon)
        self.assertIn("- [ ] Diyalog geçti. Yazım kapısı çıkış 1", sablon)

    def test_yazim_kapisinda_ses_turu_yok(self):
        paket = _temiz_paket()
        sonuc = denetle(paket, KOR)
        paket["ses"] = "olmayan/klt19.wav"
        paket["satirlar"][0]["ses"] = "olmayan/klt19.wav"
        self.assertEqual(denetle(paket, KOR), sonuc)
        kaynak = (ROOT / "tools" / "soz_kapi.py").read_text(encoding="utf-8")
        self.assertNotRegex(kaynak, r"(?i)\.wav|\b(?:audio|wave|seslendirme)\b")

    def test_dyl12_son_dagilimi_yazim_kapisini_etkilemez(self):
        paket = _temiz_paket()
        sonuc = denetle(paket, KOR)
        self.assertEqual(sonuc, ([], []))
        paket["persona"] = "rusvetci"
        paket["son_dagilimi"] = {
            "tekfur_haraccisi": 100, "ertugrul_obasi": 0, "beyin_uc_koyu": 0,
            "ahi_kasabasi": 0, "uc_tutundu": 0,
        }
        self.assertEqual(denetle(paket, KOR), sonuc)
        with tempfile.TemporaryDirectory() as klasor:
            self.assertEqual(kopyala(paket, Path(klasor), KOR), 1)

    def test_ogretici_uzunlugu_csv_ile_ortak(self):
        paket = _temiz_paket()
        anahtar = "ogretici.test.ipucu"
        for uzunluk in (90, 91):
            with self.subTest(uzunluk=uzunluk):
                metin = "a" * uzunluk
                paket["satirlar"] = [{"anahtar": anahtar, "metin": metin, "agiz": "kitap"}]
                hatalar, _ = denetle(paket, KOR)
                kapi = [h["mesaj"] for h in hatalar if h["kod"] == "KLT-12"]
                csv = validate_text(f"keys,tr\n{anahtar},{metin}\n")
                self.assertEqual(kapi, [s.removeprefix("line 2: ") for s in csv])
                self.assertEqual(len(kapi), int(uzunluk > 90))

    def test_onaysiz_kopya_yok(self):
        paket = _temiz_paket()
        paket["onay"] = ["anlati"]
        with tempfile.TemporaryDirectory() as klasor:
            self.assertEqual(kopyala(paket, Path(klasor), KOR), 0)
            self.assertEqual(list(Path(klasor).glob("ornek.json")), [])

    def test_bos_isim_red(self):
        paket = _temiz_paket()
        paket["onay"] = ["anlati", ""]
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-02" for h in hatalar))

    def test_zorunlu_sira_hata(self):
        paket = _temiz_paket()
        paket["sira_zorunlu"] = True
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-03" for h in hatalar))

    def test_sira_alani_yoksa_kabul(self):
        paket = _temiz_paket()
        self.assertNotIn("sira", paket)
        hatalar, _ = denetle(paket, KOR)
        self.assertFalse(any(h["kod"] == "KLT-03" for h in hatalar))

    def test_kutusuz_kopya_yok(self):
        paket = _temiz_paket()
        paket["kutu"] = False
        with tempfile.TemporaryDirectory() as klasor:
            self.assertEqual(kopyala(paket, Path(klasor), KOR), 0)

    def test_sebepsiz_atlama(self):
        paket = _temiz_paket()
        paket["adimlar"] = [a for a in paket["adimlar"] if a != "yapaylik"]
        paket["atlama"] = [{"adim": "yapaylik", "sebep": ""}]
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-27" for h in hatalar))

    def test_godot_yok(self):
        self.assertFalse(godot_baslatir_mi())
        kaynak = (ROOT / "tools" / "soz_kapi.py").read_text(encoding="utf-8")
        self.assertNotIn("subprocess", kaynak)

    def test_hata_keser_uyari_kesmez(self):
        hatali = _temiz_paket()
        hatali["satirlar"][0]["metin"] = "Tıkla"
        with tempfile.TemporaryDirectory() as klasor:
            self.assertEqual(kopyala(hatali, Path(klasor), KOR), 0)
        uyarili = _temiz_paket()
        uyarili["satirlar"][0]["metin"] = "bekler!!!"
        with tempfile.TemporaryDirectory() as klasor:
            self.assertEqual(kopyala(uyarili, Path(klasor), KOR), 1)

    def test_yasak_kalip_ve_tek_kaynak(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "bu değil, o"
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-04" for h in hatalar))
        yasak_dosyalari = [p for p in (ROOT / "tools").glob("*yasak*")]
        self.assertEqual(yasak_dosyalari, [])

    def test_kor_okuma_yoksa_red(self):
        hatalar, _ = denetle(_temiz_paket(), [])
        self.assertTrue(any(h["kod"] == "KLT-05" for h in hatalar))

    def test_celisen_kota_dosyalari_kapiyi_durdurur(self):
        paket = _temiz_paket()
        with tempfile.TemporaryDirectory() as klasor:
            yol = Path(klasor) / "kurallar.json"
            yol.write_text('{"sir_cekirdegi_kotasi_yuzde_max": 51}', encoding="utf-8")
            with patch("soz_kapi.KURALLAR", yol):
                for cekirdekler in ([], ["sir", "sir"]):
                    with self.subTest(cekirdekler=cekirdekler):
                        paket["cekirdekler"] = cekirdekler
                        hatalar, _ = denetle(paket, KOR)
                        self.assertEqual([h["kod"] for h in hatalar], ["KLT-65"])
                        self.assertIn("%50", hatalar[0]["mesaj"])
                        self.assertIn("%51", hatalar[0]["mesaj"])
                        self.assertEqual(kopyala(paket, Path(klasor), KOR), 0)
            self.assertFalse((Path(klasor) / "ornek.json").exists())

    def test_dinleyici_kotasi_ayri_sutundur(self):
        paket = _temiz_paket()
        paket["cekirdekler"] = ["dinlenmek_isteyen", "dinlenmek_isteyen", "baskasinin_sirri", "durust"]
        with tempfile.TemporaryDirectory() as klasor:
            yol = Path(klasor) / "paket.json"
            yol.write_text(json.dumps(paket), encoding="utf-8")
            sonuc = subprocess.run(
                [sys.executable, "-B", str(ROOT / "tools" / "soz_kapi.py"), "--paket", str(yol)],
                capture_output=True, text=True, encoding="utf-8", timeout=15,
            )
        self.assertEqual(sonuc.returncode, 0)
        self.assertEqual(sonuc.stdout.splitlines()[-2:], ["toplam\tsır\tdinleyici", "4\t1\t2"])

    def test_yaz09_sir_kotasi(self):
        paket = _temiz_paket()
        paket["cekirdekler"] = ["baskasinin_sirri", "sir"]
        hatalar, _ = denetle(paket, KOR)
        self.assertEqual([h["kod"] for h in hatalar], ["KLT-20"])
        paket["cekirdekler"].extend(["dinlenmek_isteyen", "koruma_yalani"])
        hatalar, _ = denetle(paket, KOR)
        self.assertEqual(hatalar, [])

    def test_dedikodu_kotasi(self):
        paket = _temiz_paket()
        paket["cekirdekler"] = ["dedikodu", "dedikodu", "gunluk"]
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-06" for h in hatalar))

    def test_ayni_iskelet_uyari(self):
        paket = _temiz_paket()
        paket["satirlar"] = [
            {"id": "a.1", "agiz": "a", "anahtar": "a.1", "iskelet": "kalip.1"},
            {"id": "b.1", "agiz": "b", "anahtar": "b.1", "iskelet": "kalip.1"},
        ]
        _, uyarilar = denetle(paket, KOR)
        self.assertTrue(any(u["kod"] == "KLT-32" for u in uyarilar))

    def test_unlem_uyari(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "bekler!!!"
        _, uyarilar = denetle(paket, KOR)
        self.assertTrue(any(u["kod"] == "KLT-33" for u in uyarilar))

    def test_yonerge_ve_ipucu_istisnasi(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "menüye dön"
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-34" for h in hatalar))
        paket["satirlar"][0]["anahtar"] = "ipucu.don"
        paket["satirlar"][0]["metin"] = "menüye dön"
        hatalar, _ = denetle(paket, KOR)
        self.assertFalse(any(h["kod"] == "KLT-34" for h in hatalar))

    def test_yil_ve_kitap(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "1243"
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-35" for h in hatalar))
        paket["satirlar"][0]["agiz"] = "kitap"
        hatalar, _ = denetle(paket, KOR)
        self.assertFalse(any(h["kod"] == "KLT-35" for h in hatalar))

    def test_ayrilan_kisi(self):
        paket = _temiz_paket()
        paket["kisiler"] = {"kisi_b": "ayrildi"}
        paket["satirlar"][0]["anilan"] = ["kisi_b"]
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-07" for h in hatalar))

    def test_klt25_kapanis_bes_fixture_bes_red(self):
        def yasak(p):
            p["satirlar"][0]["metin"] = "Kapı açık değil, kapalı."

        def onaysiz(p):
            p["onay"] = ["anlati"]

        def olu(p):
            p["kisiler"]["kisi_b"] = "oldu"
            p["satirlar"][0]["anilan"] = ["kisi_b"]

        def uzun_ipucu(p):
            p["satirlar"][0].update({"anahtar": "ogretici.kapi.ipucu", "metin": "a" * 91})

        def cift_bosluk(p):
            p["satirlar"][0]["metin"] = "Kapı  açık."

        fixtures = {"KLT-04": yasak, "KLT-02": onaysiz, "KLT-07": olu, "KLT-12": uzun_ipucu, "KLT-11": cift_bosluk}
        self.assertEqual(denetle(_temiz_paket(), KOR)[0], [])
        toplam = []
        for kod, boz in fixtures.items():
            with self.subTest(kod=kod):
                paket = _temiz_paket()
                boz(paket)
                hatalar, _ = denetle(paket, KOR)
                self.assertEqual([h["kod"] for h in hatalar], [kod])
                with tempfile.TemporaryDirectory() as klasor:
                    self.assertEqual(kopyala(paket, Path(klasor), KOR), 0)
                    self.assertTrue((Path(klasor) / "red" / "ornek.json").is_file())
                toplam.extend(hatalar)
        self.assertEqual(len(toplam), 5)

    def test_klt46_kor_okuma_satiri_silinmez_tarih_duser(self):
        eski = "id,skor,agiz,tarih\na,0.9,3,2026-11-01\nb,0.8,3,2026-11-01\n"
        self.assertEqual(kor_okuma_gecmis_hatalari(eski, eski + "c,0.7,3,2026-11-02\n"), [])
        silinen = kor_okuma_gecmis_hatalari(eski, "id,skor,agiz,tarih\na,0.9,3,2026-11-01\n")
        self.assertEqual([h["mesaj"] for h in silinen], ["kor okuma satiri silindi: b"])
        tarihsiz = kor_okuma_gecmis_hatalari(eski, eski.replace("b,0.8,3,2026-11-01", "b,0.5,3,2026-11-01"))
        self.assertEqual([h["kod"] for h in tarihsiz], ["KLT-46"])
        tarihli = eski.replace("b,0.8,3,2026-11-01", "b,0.5,3,2026-11-15")
        self.assertEqual(kor_okuma_gecmis_hatalari(eski, tarihli), [])
        sonuc = subprocess.run([sys.executable, "-B", str(ROOT / "tools" / "kor_okuma_gecmis.py")],
                               capture_output=True, text=True, encoding="utf-8", timeout=15)
        self.assertIn("silinen_kor=", sonuc.stdout)

    def test_celiski_uyari(self):
        paket = _temiz_paket()
        paket["olaylar"] = [
            {"gece": 1, "olay_id": "olay.1", "dogru": True},
            {"gece": 1, "olay_id": "olay.1", "dogru": True},
        ]
        _, uyarilar = denetle(paket, KOR)
        self.assertTrue(any(u["kod"] == "KLT-08" for u in uyarilar))

    def test_bina_ve_meslek(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["bina"] = "olmayan_bina"
        paket["satirlar"][0]["meslek"] = "olmayan_meslek"
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-09" for h in hatalar))
        self.assertTrue(any(h["kod"] == "KLT-39" for h in hatalar))

    def test_cocuk_is_emri_uyari(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["yas"] = "cocuk"
        paket["satirlar"][0]["fiil"] = "is_ata"
        _, uyarilar = denetle(paket, KOR)
        self.assertTrue(any(u["kod"] == "KLT-40" for u in uyarilar))

    def test_editor_ve_kitap(self):
        self.assertEqual(src_editor_sayisi(), 0)
        self.assertFalse(kitap_exportta_mi())

    def test_prototip_onay_sayilmaz(self):
        paket = _temiz_paket()
        paket["onay"] = []
        paket["prototip_kaydi"] = True
        with tempfile.TemporaryDirectory() as klasor:
            self.assertEqual(kopyala(paket, Path(klasor), KOR), 0)

    def test_js_ve_beklenen_kimlik(self):
        fixtur = json.loads((ROOT / "tests/fixtures/soz_kapi/secim.json").read_text(encoding="utf-8"))
        js = ROOT / "Roadmap-2/soz_agaci/secim.js"
        kod = js.read_text(encoding="utf-8") + "\nprocess.stdout.write(JSON.stringify(secimKimligi(JSON.parse(process.argv[1]))));"
        for durum in fixtur["durumlar"]:
            cikti = subprocess.check_output(
                ["node", "-e", kod, json.dumps({k: durum[k] for k in ("bayraklar", "secenekler")})],
                text=True,
            )
            self.assertEqual(json.loads(cikti), durum["beklenen"])

    def test_duz_turkce_red(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "bu dort kelimelik cumle"
        hatalar, _ = denetle(paket, KOR)
        self.assertTrue(any(h["kod"] == "KLT-55" for h in hatalar))

    def test_user_yok_ve_silmez(self):
        with self.assertRaises(ValueError):
            kopyala(_temiz_paket(), Path("user://kayit"), KOR)
        with tempfile.TemporaryDirectory() as klasor:
            kaynak = Path(klasor) / "data_soz"
            kaynak.mkdir()
            dosya = kaynak / "durur.json"
            dosya.write_text("{}", encoding="utf-8")
            hedef = Path(klasor) / "cikti"
            paket = _temiz_paket()
            paket["onay"] = []
            self.assertEqual(kopyala(paket, hedef, KOR), 0)
            self.assertTrue(dosya.is_file())
            self.assertTrue((hedef / "red" / "ornek.json").is_file())
            shutil.rmtree(hedef)


class EskiMetinKopyasiTest(unittest.TestCase):
    """KLT-48: DIY-16 öncesi konuşma cümlesi yeni söz dosyasına geçemez."""

    def _eski_cumle(self) -> str:
        veri = json.loads((ROOT / "data" / "diyalog" / "diyalog_01_20.json").read_text(encoding="utf-8-sig"))
        return veri[0]["sorular"][0][1]

    def test_eski_cumle_pakette_bir_hata(self):
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = "  " + self._eski_cumle().upper() + "  "
        kodlar = [h["kod"] for h in denetle(paket, KOR)[0]]
        self.assertEqual(kodlar.count("KLT-48"), 1)

    def test_temiz_pakette_kopya_hatasi_yok(self):
        kodlar = [h["kod"] for h in denetle(_temiz_paket(), KOR)[0]]
        self.assertEqual(kodlar.count("KLT-48"), 0)

    def test_eski_sohbet_kaynagi_da_okunur(self):
        self.assertGreater(len(eski_cumleler()), 100)
        self.assertIn('"sohbet.chr_001.c1"', (ROOT / "data" / "sohbetler" / "chr_001.tres").read_text(encoding="utf-8-sig"))
        with (ROOT / "data" / "metin" / "metinler.csv").open(encoding="utf-8-sig", newline="") as dosya:
            satir = next(s for s in csv.DictReader(dosya) if s["keys"] == "sohbet.chr_001.c1")
        paket = _temiz_paket()
        paket["satirlar"][0]["metin"] = satir["tr"]
        self.assertEqual([h["kod"] for h in denetle(paket, KOR)[0]].count("KLT-48"), 1)

    def test_gercek_data_soz_kopya_sifir(self):
        self.assertEqual(soz_kopya_taramasi(), [])
        sonuc = subprocess.run(
            [sys.executable, "-B", str(ROOT / "tools" / "soz_kapi.py"), "--eski-tara"],
            capture_output=True, text=True, encoding="utf-8", timeout=30,
        )
        self.assertEqual(sonuc.returncode, 0)
        self.assertIn("eski_kopya=0", sonuc.stdout)

    def test_data_soz_icine_dusen_eski_cumle_bir_hata(self):
        with tempfile.TemporaryDirectory() as klasor:
            hedef = Path(klasor) / "soz"
            shutil.copytree(ROOT / "data" / "soz", hedef)
            (hedef / "kopya.json").write_text(
                json.dumps({"satirlar": [{"metin": self._eski_cumle()}]}, ensure_ascii=False), encoding="utf-8")
            bulunan = soz_kopya_taramasi(hedef)
        self.assertEqual(len(bulunan), 1)
        self.assertEqual(bulunan[0][0], "kopya.json")


if __name__ == "__main__":
    unittest.main()
