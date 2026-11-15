"""YAZ-10: inceleme işaretleri, kapsam taraması ve onay kapısı."""
from __future__ import annotations

import copy
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

import soz_inceleme as inc  # noqa: E402
from soz_kapi import _temiz_paket, denetle  # noqa: E402

KOR = [{"id": "ornek", "skor": 0.9, "agiz": 3}]


def _sahne() -> dict:
    return {
        "dosya_id": "deneme",
        "baslangic_dugumu": "giris",
        "dugumler": {
            "giris": {"id": "giris", "satir": "Kapıya vardık.", "secenekler": [
                {"id": "sec_a", "metin": "Nereden?", "hedef": "a"},
                {"id": "sec_b", "metin": "Mühür nerede?", "hedef": "b", "kosul": {"gerekli_ipucu": "muhur"}},
                {"id": "sec_c", "metin": "Sus.", "hedef": "a", "kosul": {"tansiyon_min": 5}},
            ]},
            "a": {"id": "a", "satir": "Ovadan geldik.", "secenekler": []},
            "b": {"id": "b", "satir": "Heybede.", "secenekler": []},
            "yetim": {"id": "yetim", "satir": "Bu satıra yol yok.", "secenekler": []},
        },
    }


def _tohumlar() -> list[dict]:
    return [{"tansiyon": i % 10, "ipuclari": ["muhur"] if i % 7 == 0 else []} for i in range(1000)]


def _hepsi_dogal(sahne: dict) -> dict:
    isaret: dict = {}
    for sid in inc.satirlar(sahne):
        inc.isaretle(isaret, sahne, sid, "dogal")
    return isaret


class SozKapsamTest(unittest.TestCase):
    def test_bin_tohumda_ulasilmayan_dugum_bir_satir(self):
        tarama = inc.kapsam(_sahne(), _tohumlar())
        self.assertFalse(tarama["calismadi"])
        self.assertEqual(tarama["ulasilmayan"], ["yetim"])
        self.assertEqual(tarama["secilmeyen"], [])
        kilitli = inc.kapsam(_sahne(), [{"tansiyon": 0}])
        self.assertEqual(kilitli["ulasilmayan"], ["b", "yetim"])
        self.assertEqual(kilitli["secilmeyen"], ["giris/sec_b", "giris/sec_c"])

    def test_yapay_isaret_onayi_reddeder(self):
        sahne = _sahne()
        del sahne["dugumler"]["yetim"]
        isaret = _hepsi_dogal(sahne)
        self.assertEqual(inc.onay_hatalari(sahne, isaret, _tohumlar()), [])
        inc.isaretle(isaret, sahne, "a", "yapay")
        hatalar = inc.onay_hatalari(sahne, isaret, _tohumlar())
        self.assertEqual([h["mesaj"] for h in hatalar], ["a: yapay"])
        inc.isaretle(isaret, sahne, "a", "yeniden_yaz")
        self.assertEqual(len(inc.onay_hatalari(sahne, isaret, _tohumlar())), 1)

    def test_metin_degisince_isaret_metin_degisti(self):
        sahne = _sahne()
        isaret = _hepsi_dogal(sahne)
        yeni = copy.deepcopy(sahne)
        yeni["dugumler"]["a"]["satir"] = "Ovadan değil, dağdan geldik."
        durum, _ = inc.durumlar(yeni, isaret)
        self.assertEqual(durum["a"], inc.METIN_DEGISTI)
        self.assertEqual(durum["b"], "dogal")
        self.assertIn("a: metin_degisti", [h["mesaj"] for h in inc.onay_hatalari(yeni, isaret, _tohumlar())])

    def test_tohum_bossa_calismadi_onay_yok(self):
        sahne = _sahne()
        del sahne["dugumler"]["yetim"]
        tarama = inc.kapsam(sahne, [])
        self.assertTrue(tarama["calismadi"])
        self.assertEqual([h["mesaj"] for h in inc.onay_hatalari(sahne, _hepsi_dogal(sahne), [])], ["kapsam calismadi: tohum yok"])

    def test_silinen_satirin_isareti_eslesmeyen_listelenir(self):
        sahne = _sahne()
        isaret = _hepsi_dogal(sahne)
        del sahne["dugumler"]["yetim"]
        _, eslesmeyen = inc.durumlar(sahne, isaret)
        self.assertEqual(eslesmeyen, ["yetim"])

    def test_kapi_ve_komut_satiri_ayni_karari_verir(self):
        sahne = _sahne()
        isaret = _hepsi_dogal(sahne)
        inc.isaretle(isaret, sahne, "b", "yapay")
        paket = _temiz_paket()
        paket["inceleme"] = {"sahne": sahne, "isaret": isaret, "tohumlar": _tohumlar()}
        kodlar = [h["mesaj"] for h in denetle(paket, KOR)[0] if h["kod"] == "YAZ-10"]
        self.assertEqual(kodlar, ["b: yapay", "ulasilmayan dugum: yetim"])
        with tempfile.TemporaryDirectory() as klasor:
            yol = Path(klasor)
            (yol / "sahne.json").write_text(json.dumps(sahne, ensure_ascii=False), encoding="utf-8")
            (yol / "tohum.json").write_text(json.dumps(_tohumlar()), encoding="utf-8")
            (yol / "isaret.json").write_text(json.dumps(isaret, ensure_ascii=False), encoding="utf-8")
            sonuc = subprocess.run(
                [sys.executable, "-B", str(ROOT / "tools" / "soz_dogrula.py"), "--kapsam", str(yol / "sahne.json"),
                 "--tohum", str(yol / "tohum.json"), "--isaret", str(yol / "isaret.json")],
                capture_output=True, text=True, encoding="utf-8", timeout=30)
        self.assertEqual(sonuc.returncode, 1)
        self.assertIn("YAZ-10 ulasilmayan dugum: yetim", sonuc.stdout)
        self.assertIn("YAZ-10 onay=red hata=2", sonuc.stdout)

    def test_gercek_soz_dosyasi_taranir(self):
        sahne = json.loads((ROOT / "data" / "soz" / "yetim_kafilesi.json").read_text(encoding="utf-8-sig"))
        tarama = inc.kapsam(sahne, [{}])
        self.assertFalse(tarama["calismadi"])
        self.assertNotIn(sahne["baslangic_dugumu"], tarama["ulasilmayan"])


if __name__ == "__main__":
    unittest.main()
