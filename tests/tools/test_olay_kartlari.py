"""OZL-06 sıra kartları 5; OZL-26 kart anahtarları olay. önekli; OZL-33 34 eski kart silinmez;
SRM-10 son ekranı istatistiği dört alandır."""
import csv
import io
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[2]
# OZL-33: bu dosyanın zemini — ROADMAP 2 öncesi 34 olay kartı. Silinmez, kimliği değişmez; yeni kart eklenebilir.
ESKI_KARTLAR = {
    "ahi_haber", "aydogdu_oba", "ayse_tezgah", "bebek", "bey_daveti", "dervis", "dugun", "ertugrul_haberi", "harman",
    "hasan_defter", "hirsizlik", "kacak_koylu", "karaca_ocak", "kervan", "kitlik", "kurt", "miraen_cavus", "mogol_duman",
    "nogay_haber", "okculuk", "pazar_gunu", "salgin", "saruca_tohum", "sorhan_damga", "sur_catlak", "tarla_cekirge",
    "tarla_don", "tarla_kuraklik", "tarla_yagmur", "tekfur_elcisi", "thessra_afyon", "vergi_tahsildari", "yangin", "yusuf_keci",
}


def kartlar():
    sonuc = {}
    for p in sorted((ROOT / "data/olaylar").glob("*.tres")):
        metin = p.read_text(encoding="utf-8")
        m = re.search(r'^id = &"([^"]+)"', metin, re.M)
        sonuc[m.group(1) if m else p.stem] = metin
    return sonuc


class OlayKartlariTest(unittest.TestCase):
    def test_ozl06_sira_karti_bes(self):
        self.assertEqual(5, len(list((ROOT / "data/sira_olaylari").glob("*.tres"))))

    def test_ozl26_kart_anahtarlari_olay_onekli(self):
        disi = []
        for kimlik, metin in kartlar().items():
            for alan in ("baslik_anahtari", "metin_anahtari", "secenek_anahtarlari"):
                for satir in re.findall(alan + r" = (.*)", metin):
                    disi += [(kimlik, a) for a in re.findall(r'"([^"]*)"', satir) if a and not a.startswith("olay.")]
        self.assertEqual([], disi)

    def test_ozl33_eski_kartlar_durur(self):
        self.assertEqual(set(), ESKI_KARTLAR - set(kartlar()))

    def test_srm10_son_istatistigi_dort_alan(self):
        ana = (ROOT / "src/arayuz/ana.gd").read_text(encoding="utf-8")
        m = re.search(r'tr\("arayuz\.son\.istatistik"\) % \[([^\]]*)\]', ana)
        self.assertIsNotNone(m)
        self.assertEqual(4, len([a for a in m.group(1).split(",") if a.strip()]))
        satirlar = csv.reader(io.StringIO((ROOT / "data/metin/metinler.csv").read_text(encoding="utf-8-sig")))
        metin = {s[0]: s[1] for s in satirlar if len(s) > 1}["arayuz.son.istatistik"]
        self.assertEqual(4, len(re.findall(r"%(?!%)[-+ 0#]*\d*(?:\.\d+)?[sdif]", metin)))



class RoadmapKimlikTest(unittest.TestCase):
    def test_klt24_dyl_11_16_durur(self):
        roadmap = (ROOT / "ROADMAP_2.md").read_text(encoding="utf-8")
        for n in range(11, 17):
            self.assertEqual(1, len(re.findall(rf"^- \[[ /x]\] \*\*DYL-{n}:\*\*", roadmap, re.M)), f"DYL-{n}")


if __name__ == "__main__":
    unittest.main()
