"""Meshy üretim hattı (tools/meshy): plan eşlemesi eksiksiz, tekrar üretim imkânsız, anahtar sızmaz.

Ağ kullanmaz, kredi harcamaz: Meshy istemcisi sahte nesneyle değiştirilir.
    python3 -m unittest tests/tools/test_meshy_hat.py
"""
import copy
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools" / "meshy"))

import manifest as mf  # noqa: E402
import meshy_api  # noqa: E402
import meshy_hat  # noqa: E402
import ortak  # noqa: E402

NESNE, TEKRAR = mf.guncelle()


class SahteIstemci:
    """POST'ları sayar; istenen hatayı fırlatır. Gerçek ağa çıkmaz."""

    def __init__(self, hata=None, kimlik="gorev-1"):
        self.postlar = []
        self.hata = hata
        self.kimlik = kimlik

    def post_gorev(self, uc, govde):
        self.postlar.append((uc, govde))
        if self.hata:
            raise self.hata
        return self.kimlik


class GeciciManifest:
    def __enter__(self):
        self.dizin = tempfile.TemporaryDirectory()
        self.yamalar = [mock.patch.object(ortak, "MANIFEST", os.path.join(self.dizin.name, "m.json")),
                        mock.patch.object(ortak, "MANIFEST_CSV", os.path.join(self.dizin.name, "m.csv"))]
        for y in self.yamalar:
            y.start()
        return copy.deepcopy(NESNE)

    def __exit__(self, *_):
        for y in self.yamalar:
            y.stop()
        self.dizin.cleanup()


def satir(nesne, aid):
    return meshy_hat.satir_haritasi(nesne)[aid]


def planli_satir(nesne):
    return next(r for r in nesne["assetler"] if r["meshy_uygun"] and r["durum"] == "planli" and r["tur"] == "nesne")


class PlanTest(unittest.TestCase):
    def test_envanterdeki_her_3d_kimlik_manifeste_bagli(self):
        self.assertEqual(NESNE["eslenmeyen_envanter"], [])
        bagli = {k for r in NESNE["assetler"] for k in r["plan_kimlikleri"]}
        tablo, _ = mf.envanter_oku()
        self.assertEqual(sorted(k for k, _, _ in tablo if k not in bagli), [])

    def test_ayni_istem_iki_kez_uretilmez(self):
        self.assertEqual(TEKRAR, {})

    def test_uretilecek_her_satirin_istemi_ve_kredisi_var(self):
        for r in NESNE["assetler"]:
            if r["meshy_uygun"] and r["durum"] == "planli" and r["tur"] != "animasyon":
                self.assertTrue(r["prompt"], r["asset_id"])
                self.assertGreater(r["kredi_tahmini"], 0, r["asset_id"])

    def test_mevcut_dosyalar_diskte_ve_sha_tutarli(self):
        for r in NESNE["assetler"]:
            if r["durum"] == "mevcut" and r["dosya"] and not r["dosya"].startswith("git:"):
                yol = ROOT / r["dosya"]
                self.assertTrue(yol.is_file(), r["dosya"])
                self.assertEqual(ortak.sha256_dosya(str(yol)), r["sha256"], r["dosya"])
                self.assertEqual(r["kredi_tahmini"], 0, r["asset_id"])

    def test_meshy_satirlarinda_kaynak_ve_lisans_notu(self):
        for r in NESNE["assetler"]:
            if r["tur"] in ("karakter", "yapi", "nesne", "hayvan", "animasyon"):
                self.assertTrue(r["kaynak"].startswith("Meshy") or r["tur"] == "harici", r["asset_id"])
                self.assertIn("CC BY 4.0", r["lisans_notu"], r["asset_id"])


class TekrarUretimTest(unittest.TestCase):
    def test_kilitli_durumlar_uretim_secimine_girmez(self):
        o = mock.Mock(sadece=None, oncelik=None, tur=None)
        for r in meshy_hat.secim(NESNE, o):
            self.assertIn(r["durum"], ("planli", "uretiliyor"))
            self.assertNotIn(r["durum"], ("mevcut", "uretildi", "onaylandi", "reddedildi"))

    def test_gorev_kimligi_varsa_post_yok(self):
        with GeciciManifest() as nesne:
            r = planli_satir(nesne)
            r["meshy_gorevleri"] = {"onizleme": "var-olan"}
            ist = SahteIstemci()
            self.assertEqual(meshy_hat._gorev_ac(ist, nesne, r, "onizleme", {}, None), "var-olan")
            self.assertEqual(ist.postlar, [])

    def test_belirsiz_gonderim_ikinci_kez_gonderilmez(self):
        with GeciciManifest() as nesne:
            r = planli_satir(nesne)
            ist = SahteIstemci(hata=meshy_api.BelirsizGonderim("zaman aşımı"))
            with self.assertRaises(meshy_hat.Durdur):
                meshy_hat._gorev_ac(ist, nesne, r, "onizleme", {"name": "x"}, None)
            self.assertTrue(r["meshy_gorevleri"]["onizleme"].startswith("BELIRSIZ"))
            self.assertEqual(r["durum"], "uretiliyor")
            ist2 = SahteIstemci()
            with self.assertRaises(meshy_hat.Durdur):
                meshy_hat._gorev_ac(ist2, nesne, r, "onizleme", {"name": "x"}, None)
            self.assertEqual(len(ist.postlar) + len(ist2.postlar), 1)
            kayitli = mf.oku()
            self.assertTrue(satir(kayitli, r["asset_id"])["meshy_gorevleri"]["onizleme"].startswith("BELIRSIZ"))

    def test_isaret_posttan_once_diske_yazilir(self):
        with GeciciManifest() as nesne:
            r = planli_satir(nesne)
            gorulen = {}

            class Izleyen(SahteIstemci):
                def post_gorev(self, uc, govde):
                    gorulen["diskte"] = satir(mf.oku(), r["asset_id"])["meshy_gorevleri"].get("onizleme")
                    return super().post_gorev(uc, govde)

            meshy_hat._gorev_ac(Izleyen(), nesne, r, "onizleme", {}, None)
            self.assertTrue(str(gorulen["diskte"]).startswith("BELIRSIZ"))
            self.assertEqual(satir(mf.oku(), r["asset_id"])["meshy_gorevleri"]["onizleme"], "gorev-1")

    def test_4xx_reddi_satiri_planliya_dondurur(self):
        with GeciciManifest() as nesne:
            r = planli_satir(nesne)
            ist = SahteIstemci(hata=meshy_api.GonderimReddedildi("HTTP 400"))
            with self.assertRaises(meshy_hat.Durdur):
                meshy_hat._gorev_ac(ist, nesne, r, "onizleme", {}, None)
            self.assertEqual(r["durum"], "planli")
            self.assertNotIn("onizleme", r["meshy_gorevleri"])

    def test_meshy_gecmisindeki_gorev_benimsenir(self):
        with GeciciManifest() as nesne:
            r = planli_satir(nesne)
            once = r["kredi_tahmini"]
            gorevler = [{"id": "eski-1", "name": ortak.etiket(r["asset_id"], "onizleme"), "status": "SUCCEEDED",
                         "_uc": "text-to-3d", "created_at": 1},
                        {"id": "basarisiz", "name": ortak.etiket(r["asset_id"], "doku"), "status": "FAILED",
                         "_uc": "text-to-3d", "created_at": 2}]
            eslesme, sahipsiz = meshy_hat.gecmisle_esle(nesne, gorevler)
            meshy_hat.esleme_uygula(nesne, eslesme)
            meshy_hat.kaydet(nesne)
            self.assertEqual(r["meshy_gorevleri"], {"onizleme": "eski-1"})
            self.assertEqual(r["durum"], "uretiliyor")
            self.assertLess(r["kredi_tahmini"], once)

    def test_ayni_istemli_etiketsiz_gorev_de_benimsenir(self):
        with GeciciManifest() as nesne:
            r = planli_satir(nesne)
            g = {"id": "web-1", "name": "", "prompt": "  " + r["prompt"].upper() + " ", "mode": "preview",
                 "status": "SUCCEEDED", "_uc": "text-to-3d"}
            eslesme, _ = meshy_hat.gecmisle_esle(nesne, [g])
            self.assertIn(r["asset_id"], eslesme)

    def test_gercek_bayragi_ve_hesap_plani_olmadan_uretim_yok(self):
        o = mock.Mock(gercek=False, sadece=["x"], oncelik=None)
        with mock.patch.object(meshy_api, "Istemci") as ist:
            with self.assertRaises(SystemExit):
                meshy_hat.uretim(o)
            o.gercek = True
            with mock.patch.object(ortak, "ayarlar_oku", return_value={"hesap_plani": "bilinmiyor"}):
                with self.assertRaises(SystemExit):
                    meshy_hat.uretim(o)
            ist.assert_not_called()

    def test_eski_hat_onaysiz_calismaz(self):
        ortam = {k: v for k, v in os.environ.items() if k not in ("MESHY_API_KEY", "MESHY_ESKI_HAT_ONAY")}
        p = subprocess.run([sys.executable, str(ROOT / "tools/model/meshy_uret.py"), "--sadece", "kuyu"],
                           capture_output=True, text=True, env=ortam, cwd=ROOT)
        self.assertNotEqual(p.returncode, 0)
        self.assertIn("Eski hat kapalı", p.stderr)


class AnahtarTest(unittest.TestCase):
    def test_anahtar_maskelenir(self):
        sahte = "msy_" + "A" * 24
        self.assertNotIn(sahte, ortak.gizle("Bearer %s hata" % sahte, sahte))
        self.assertNotIn(sahte, ortak.gizle("baska msy_BBBBBBBBBBBB", None).replace("msy_***", ""))

    def test_anahtar_dosyasi_ve_onbellekler_gitte_yok_sayilir(self):
        for yol in (".meshy-api-key", "tools/meshy/.uretim.kilit", "tools/meshy/.meshy_gecmis.json", "a.glb.iniyor"):
            p = subprocess.run(["git", "-C", str(ROOT), "check-ignore", "-q", yol])
            self.assertEqual(p.returncode, 0, yol)

    def test_manifestte_anahtar_yok(self):
        metin = (ROOT / "assets/meshy_manifest.json").read_text(encoding="utf-8")
        self.assertNotRegex(metin, r"msy_[A-Za-z0-9]{6,}")


if __name__ == "__main__":
    unittest.main()
