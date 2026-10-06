"""SYS-09 regression fixtures: quoting, key conventions and invalid input."""
import importlib.util
import unittest
from pathlib import Path

PATH = Path(__file__).resolve().parents[2] / "tools/metin_dogrula.py"
SPEC = importlib.util.spec_from_file_location("metin_dogrula", PATH)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class TranslationCSVTest(unittest.TestCase):
    def test_valid_keys_and_quoted_multiline_text(self):
        text = ('keys,tr,en\n'
                'arayuz.menu,"Bir, iki",Menu\n'
                'CHR_001_DUGUM_00_REPLIK,"Birinci\nikinci",Reply\n'
                'CHR_030_DUGUM_03_SEC_2_METIN,"""Alıntı""",Choice\n'
                'CLUE_CHR015_BENT_CAPASI_BASLIK,Çapa,Hoe\n'
                'CLUE_CHR015_BENT_CAPASI_TANIM,Bir çapa,\n')
        self.assertEqual(MODULE.validate_text(text), [])

    def test_bom(self):
        self.assertEqual(MODULE.validate_text('\ufeffkeys,tr\na,A\n'), [])

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

    def test_repository_csv(self):
        self.assertEqual(MODULE.validate_file(PATH.parents[1] / 'data/metin/metinler.csv'), [])


if __name__ == '__main__':
    unittest.main()
