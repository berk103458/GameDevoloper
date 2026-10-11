"""Yetim .import denetimi (TEK-02 / TST-0005).

Kapsam yalnız maddenin kümesidir: `assets/model/karakter/*_yuru_Image_0.jpg.import` ve
`*_yuru_texture_0.png.import`. Bunlar Godot'nun `_yuru.glb` içinden dışarı çıkardığı dokuların
meta dosyalarıydı; kaynakları depoda yok, `.gitignore` artık onları dışarıda tutar.

DİKKAT (11 Ekim 2026, Claude): Kaynağı olmayan HER `.import` silinemez. Örneğin
`assets/model/yapi/kapi_0.jpg.import` kaynaksız görünür ama Godot önbelleğindeki dokuya
yönlendirir; silinince `kapi.glb` yüklenemez ve kapı sahnesi çöker. Kapsam dışı yetimler
ayrı bir maddede, modelin `.glb.import` ayarıyla birlikte ele alınmalı.
"""
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
KARAKTER = ROOT / "assets/model/karakter"
KALIPLAR = ("*_yuru_Image_0.jpg.import", "*_yuru_texture_0.png.import")


def _kapsamdaki_yetimler():
    for kalip in KALIPLAR:
        for yol in sorted(KARAKTER.glob(kalip)):
            if not yol.with_name(yol.name[: -len(".import")]).is_file():
                yield yol


class YetimImportTest(unittest.TestCase):
    def test_karakter_yuru_dokularinda_yetim_import_yok(self):
        yetim = [str(y.relative_to(ROOT)).replace("\\", "/") for y in _kapsamdaki_yetimler()]
        self.assertEqual([], yetim, "TEK-02 kapsamında yetim .import var:\n" + "\n".join(yetim))

    def test_karakter_klasoru_taranabiliyor(self):
        # Yol hatası olursa test sessizce geçmesin: klasörde yürüyüş modelleri bulunmalı.
        self.assertGreater(len(list(KARAKTER.glob("*_yuru.glb"))), 20)

    def test_gitignore_cikarilan_dokulari_dislar(self):
        gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8")
        for kalip in ("_yuru_Image_0.jpg", "_yuru_texture_0.png"):
            self.assertIn(kalip, gitignore)


if __name__ == "__main__":
    unittest.main()
