"""SYS-09 / KVR-11 / BUG-07 regression fixtures: quoting, key conventions, source cross-check."""
import importlib.util
import tempfile
import unittest
from pathlib import Path

PATH = Path(__file__).resolve().parents[2] / "tools/metin_dogrula.py"
SPEC = importlib.util.spec_from_file_location("metin_dogrula", PATH)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class TranslationCSVTest(unittest.TestCase):
    def test_valid_keys_and_quoted_multiline_text(self):
        text = ('keys,tr,en\n'
                'arayuz.menu.baslik,"Bir, iki",Menu\n'
                'CHR_001_DUGUM_00_REPLIK,"Birinci\nikinci",Reply\n'
                'CHR_030_DUGUM_03_SEC_2_METIN,"""Alıntı""",Choice\n'
                'CLUE_CHR015_BENT_CAPASI_BASLIK,Çapa,Hoe\n'
                'CLUE_CHR015_BENT_CAPASI_TANIM,Bir çapa,\n')
        self.assertEqual(MODULE.validate_text(text), [])

    def test_bom(self):
        self.assertEqual(MODULE.validate_text('\ufeffkeys,tr\na.b.c,A\n'), [])

    def test_duplicates(self):
        self.assertTrue(any('duplicate key' in e for e in MODULE.validate_text('keys,tr\na,A\na,B\n')))

    def test_missing_and_extra_columns(self):
        for row in ('a', 'a,A,extra'):
            with self.subTest(row=row):
                self.assertTrue(any('columns' in e for e in MODULE.validate_text('keys,tr\n'+row+'\n')))

    def test_malformed_quotes(self):
        for row in ('a,"unterminated', 'a,"value"unexpected'):
            with self.subTest(row=row):
                self.assertTrue(any('malformed CSV' in e for e in MODULE.validate_text('keys,tr\n'+row)))

    def test_invalid_new_key_formats(self):
        for key in ('CHR_1_DUGUM_00_REPLIK', 'CHR_001_DUGUM_0_REPLIK',
                    'CHR_001_DUGUM_00_SEC_X_METIN', 'CLUE_CHR_015_ESYA_BASLIK',
                    'CLUE_CHR015_ESYA_DESCRIPTION'):
            with self.subTest(key=key):
                self.assertTrue(any('SYS-09' in e for e in MODULE.validate_text(f'keys,tr\n{key},Metin\n')))

    def test_invalid_header(self):
        for header in ('id,tr', 'keys,en', 'keys,tr,tr', 'keys,tr,'):
            with self.subTest(header=header):
                self.assertTrue(MODULE.validate_text(header+'\n'))

    def test_empty_key_or_translation(self):
        for row in (',Metin', 'space key,Metin', 'a,'):
            with self.subTest(row=row):
                self.assertTrue(MODULE.validate_text('keys,tr\n'+row+'\n'))

    def test_missing_file(self):
        self.assertTrue(MODULE.validate_file(PATH.parent / 'does-not-exist.csv'))

    def test_kvr11_dotted_keys(self):
        self.assertEqual(MODULE.validate_text('keys,tr\narayuz.son.kirildi.0,A\nsohbet.kurt_1.giris,B\n'), [])
        for key in ('Arayuz.menu', 'arayuz', 'arayuz..menu', 'arayuz.menu-yeni', '1.arayuz'):
            with self.subTest(key=key):
                self.assertTrue(any('KVR-11' in e for e in MODULE.validate_text(f'keys,tr\n{key},Metin\n')))

    def test_yer02_new_two_part_key_one_error(self):
        hatalar = MODULE.validate_text('keys,tr\narayuz.yeni,Metin\n')
        self.assertEqual(1, len(hatalar), hatalar)
        self.assertIn('YER-02', hatalar[0])
        # YER-02 öncesi iki parçalı anahtar korunur; üç parçalı yeni anahtar geçer.
        self.assertEqual([], MODULE.validate_text('keys,tr\nbar.halk,Halk\narayuz.yeni.ad,Metin\n'))

    def test_source_cross_check(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / 'src').mkdir()
            (root / 'data').mkdir()
            (root / 'src/a.gd').write_text(
                'func f():\n\tvar a = tr("arayuz.var")\n\tvar b = tr("arayuz.yok")\n'
                '\tvar c = tr("arayuz.iki") % [1, 2]\n\tvar d = tr("arayuz.iki") % 5\n'
                '\tvar e = TranslationServer.translate("Merhaba")\n', encoding='utf-8')
            (root / 'data/k.tres').write_text('ad_anahtari = "karakter.yok"\nanimasyon_anahtarlari = PackedStringArray("Idle")\n', encoding='utf-8')
            errors = MODULE.validate_sources(root, {'arayuz.var': 'V', 'arayuz.iki': '%s ve %d'})
            self.assertTrue(any("'arayuz.yok'" in e for e in errors))
            self.assertTrue(any("'karakter.yok'" in e for e in errors))
            self.assertTrue(any('gets 1 argument' in e for e in errors))
            self.assertFalse(any('Idle' in e or 'Merhaba' in e or 'gets 2' in e for e in errors))
            self.assertEqual(len(errors), 3)

    def test_repository_sources(self):
        root = PATH.parents[1]
        texts = MODULE.read_texts(root / 'data/metin/metinler.csv')
        self.assertEqual(MODULE.validate_sources(root, texts), [])

    def test_repository_csv(self):
        self.assertEqual(MODULE.validate_file(PATH.parents[1] / 'data/metin/metinler.csv'), [])


if __name__ == '__main__':
    unittest.main()
