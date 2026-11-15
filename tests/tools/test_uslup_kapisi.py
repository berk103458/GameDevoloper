"""YAZ-02: Üslup kapısı ve yasak kelime listesi testleri."""
from __future__ import annotations

import json
import re
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "tools"))

from soz_dogrulayici import metni_tara, replik_uyarilari, yasak_kelimeler_oku  # noqa: E402


def _rehber_modern_sozler() -> list[str]:
    rehber = (ROOT / "Roadmap-2" / "USLUP_REHBERI.md").read_text(encoding="utf-8")
    satir = next((s for s in rehber.splitlines() if "Kaçınılacak modern sözler" in s), "")
    parcalar = satir.split(":", 1)[-1].split(",")
    return [p.strip().strip(".*` ") for p in parcalar if p.strip().strip(".*` ")]


class UslupKapisiTest(unittest.TestCase):
    def test_yasak_liste_rehberdeki_tum_modern_sozleri_tasir(self):
        liste_dosyasi = ROOT / "data" / "soz" / "yasak_kelimeler.txt"
        self.assertTrue(liste_dosyasi.is_file(), "data/soz/yasak_kelimeler.txt eksik")
        yasaklar = yasak_kelimeler_oku(liste_dosyasi)
        rehber_sozler = _rehber_modern_sozler()
        self.assertGreaterEqual(len(rehber_sozler), 10)
        for soz in rehber_sozler:
            self.assertIn(soz, yasaklar, f"Rehberdeki modern söz yasak_kelimeler.txt içinde yok: {soz}")

    def test_aslinda_iceren_replik_bir_uyari_uretir_ve_satir_silinmez(self):
        replikler = [
            "Köyden çıktığımda hava kararmıştı.",
            "Ben aslında buraya sadece ekmek istemeye geldim.",
        ]
        kopya = list(replikler)
        uyarilar = replik_uyarilari(replikler)
        self.assertEqual(len(uyarilar), 1)
        self.assertEqual(uyarilar[0]["kelime"], "aslında")
        self.assertEqual(uyarilar[0]["tur"], "uyari")
        # Satır silinmez.
        self.assertEqual(replikler, kopya)

        # yapaylik.js de uyarı üretir, satırı silmez (node varsa doğrula).
        yapaylik_js = ROOT / "Roadmap-2" / "soz_agaci" / "yapaylik.js"
        sahne = {
            "dugumler": {
                "giris": {
                    "satirlar": [
                        {"k": "karakter", "m": replikler[1]},
                    ]
                }
            }
        }
        js_kod = (
            yapaylik_js.read_text(encoding="utf-8")
            + f"\nconst s = {json.dumps(sahne, ensure_ascii=False)};"
            + "\nconsole.log(JSON.stringify({sonuc: Yapaylik.denetle(s), kalan: s.dugumler.giris.satirlar.length}));"
        )
        r = subprocess.run(["node", "-e", js_kod], capture_output=True, text=True, encoding="utf-8", timeout=10)
        self.assertEqual(r.returncode, 0, r.stderr)
        veri = json.loads(r.stdout.strip().splitlines()[-1])
        self.assertEqual(veri["kalan"], 1)
        self.assertIn("modern", veri["sonuc"]["satirlar"].get("giris.s0", []))

    def test_yapaylik_kural_sayisi_14_ve_tek_uslup_dosyasi(self):
        yapaylik_metni = (ROOT / "Roadmap-2" / "soz_agaci" / "yapaylik.js").read_text(encoding="utf-8")
        blok = re.search(r"const\s+KURALLAR\s*=\s*\{(.*?)\n\s*\};", yapaylik_metni, re.S)
        self.assertIsNotNone(blok, "yapaylik.js KURALLAR bloğu bulunamadı")
        anahtarlar = re.findall(r"^\s*([a-z_]+)\s*:", blok.group(1), re.M)
        self.assertEqual(len(anahtarlar), 14, f"Beklenen 14 yapaylık kuralı, bulunan: {anahtarlar}")

        # İkinci üslup rehberi dosyası olmamalı.
        rehberler = [p.relative_to(ROOT).as_posix() for p in ROOT.rglob("USLUP*.md") if ".git" not in p.parts]
        self.assertEqual(rehberler, ["Roadmap-2/USLUP_REHBERI.md"])

        # Doğaçlama taslağı dışa aktarım ayarlarında olmamalı.
        godot_cfg = (ROOT / "project.godot").read_text(encoding="utf-8")
        self.assertNotIn("dogaclama", godot_cfg.lower())
        export_cfg = ROOT / "export_presets.cfg"
        if export_cfg.is_file():
            self.assertNotIn("dogaclama", export_cfg.read_text(encoding="utf-8").lower())


if __name__ == "__main__":
    unittest.main()
