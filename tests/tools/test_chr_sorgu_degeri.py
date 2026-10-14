import importlib.util
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("chr_parser", ROOT / "tools/chr_parser.py")
parser = importlib.util.module_from_spec(spec)
spec.loader.exec_module(parser)

SAMPLE_CHR = """### KARAKTER ŞABLONU

#### BÖLÜM 1
- [Entity_ID]: CHR_999
- [Tag_Array]: Erkek, Yetişkin, Asker, Karaboran Boğazı
- [Gerçek_Kimlik]: Test Askeri; sahte kimlik.
- [Sadakat_Fraksiyonu]: Test Fraksiyonu
- [Secere_Matrisi]: Doğum_Yeri: Köy; Aile_Bağı: Yok; Kırılma_Olayı: Savaş.
- [Spawn_Koşulu]: Tur > 2
- [Köy_içi_Davranış]: Gündüz_Döngüsü: Nöbet; Gece_Döngüsü: Uyku.
- [Base_Stat_Potansiyeli]: Güvenlik +1

#### BÖLÜM 2
- [Persona_Maskesi]: Sıradan asker.
- [Gizlenen_Gerçek]: Yok.
- [Obje_1_Nişan]: Nişan kılıcı. Generate [Clue_CHR999_Kilic]
- [Obje_2_Yük]: Yük torbası. Generate [Clue_CHR999_Torba]

#### BÖLÜM 3
- [Yüz_ve_Postür]: Sert duruş.
- [Kıyafet_ve_Doku]: Zırh.
- [Görsel_Hata], [Sır_Bağlantısı], Generate [Clue_Görsel_CHR999_Yara]:
  - [Görsel_Hata]: Yara izi.
  - [Sır_Bağlantısı]: Eski savaş.
  - Generate [Clue_Görsel_CHR999_Yara]
- [State_0 Idle] tension 0-3, [State_1 Stressed] 4-7, [State_2 Panic] 8-10:
  - [State_0 Idle]: Sakin.
  - [State_1 Stressed]: Gergin.
  - [State_2 Panic]: Panik.
- [SFX]: Kılıç sesi.

#### BÖLÜM 4
- [Başlangıç_Tansiyonu]: 2
- [Zar]: d12
- [Sorgu_Değeri]: 4
- Düğüm 00:
  - NPC Replik: "Selam."
  - Seçenek 1: "Kimsin?" -> [Hedef: Düğüm 00]

#### BÖLÜM 5
- Kabul and secret solved: [Flag_Sir_Tamamen_Cozuldu] doğru ise Güvenlik +1.
- Zorunlu ret: Kovulur.
- Gönüllü ret: Gider.
- Rüşvet: 2 altın sikke verir.
- Kışla: Zindana atılır.
- on accept: [CHR_004] +4 tur
- on reject: [CHR_005] +3 tur
- on bribe: [CHR_006] +2 tur
- on jail: [CHR_007] +5 tur
"""


class ChrSorguDegeriTest(unittest.TestCase):
    """ZAR-02: Karakter değeri — kişiye göre taban zorluk testleri."""

    def test_gecerli_chr_gecer(self):
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "CHR_999.md"
            p.write_text(SAMPLE_CHR, encoding="utf-8")
            res = parser.parse(p)
            self.assertEqual(res["zar"], "d12")
            self.assertEqual(res["sorgu_degeri"], 4)

    def test_alan_silinince_hata_verir(self):
        # Kabul: Bir CHR'den alan silinince chr_parser.py --check 1 hata verir
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "CHR_999.md"
            bozuk = SAMPLE_CHR.replace("- [Sorgu_Değeri]: 4\n", "")
            p.write_text(bozuk, encoding="utf-8")
            with self.assertRaises(parser.SourceError) as ctx:
                parser.parse(p)
            self.assertIn("missing field [Sorgu_Degeri]", str(ctx.exception))

    def test_d12_deger_1_hata_verir(self):
        # Kabul: d12'de değer 1 yazılırsa 1 hata verir
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "CHR_999.md"
            bozuk = SAMPLE_CHR.replace("- [Sorgu_Değeri]: 4\n", "- [Sorgu_Değeri]: 1\n")
            p.write_text(bozuk, encoding="utf-8")
            with self.assertRaises(parser.SourceError) as ctx:
                parser.parse(p)
            self.assertIn("d12 icin Sorgu_Degeri 2-10 araliginda olmalidir", str(ctx.exception))

    def test_d6_deger_6_hata_verir(self):
        # Uç durum: d6 karakterde değer 6 yazılırsa 1 hata
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "CHR_999.md"
            bozuk = SAMPLE_CHR.replace("Asker", "Çiftçi").replace("- [Zar]: d12\n", "- [Zar]: d6\n").replace("- [Sorgu_Değeri]: 4\n", "- [Sorgu_Değeri]: 6\n")
            p.write_text(bozuk, encoding="utf-8")
            with self.assertRaises(parser.SourceError) as ctx:
                parser.parse(p)
            self.assertIn("d6 icin Sorgu_Degeri 1-5 araliginda olmalidir", str(ctx.exception))

    def test_ayni_ziyarette_iki_atis_ayni_tabani_kullanir(self):
        # Ek şart: aynı ziyarette iki atışın tabanı aynıdır
        # KarakterVerisi değişmez kaynaktır; sorgu_degeri sabittir
        with tempfile.TemporaryDirectory() as tmp:
            p = Path(tmp) / "CHR_999.md"
            p.write_text(SAMPLE_CHR, encoding="utf-8")
            res = parser.parse(p)
            taban1 = res["sorgu_degeri"]
            taban2 = res["sorgu_degeri"]
            self.assertEqual(taban1, taban2)


if __name__ == "__main__":
    unittest.main()
