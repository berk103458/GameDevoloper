"""Yetim .import denetimi (TEK-02 / TST-0005).

Kapsam yalnız maddenin kümesidir: `assets/model/karakter/*_yuru_Image_0.jpg.import` ve
`*_yuru_texture_0.png.import`. Bunlar Godot'nun `_yuru.glb` içinden dışarı çıkardığı dokuların
meta dosyalarıydı; kaynakları depoda yok, `.gitignore` artık onları dışarıda tutar.

Kapsam 2 (BUG-0021, 12 Ekim 2026): `assets/model/nesne/*_0.jpg.import` ve
`assets/model/yapi/*_0.jpg.import`. Godot bu `.jpg`leri modellerin `.glb`si içinden çıkarır;
`.jpg` `.gitignore`'da olduğu için depoda yoktu ama `.import` dosyaları depoda kalmıştı.
Godot kaynağı olmayan bu `.import`i hayalet kaynak sayıp yüklüyor, temiz klonda içe aktarma
12 ERROR satırı basıyordu. Çözüm: dokular modelin `.glb`si içinde gömülü tutulur
(`gltf/embedded_image_handling=2|3`) ve yetim `.import` dosyaları depodan çıkarılır.
DİKKAT (11 Ekim 2026, Claude): Kaynağı olmayan HER `.import` silinemez; örneğin dokuyu dışa
çıkaran bir modelde `.import` silinirse o model yüklenemez. Silmeden önce modelin
`.glb.import` ayarına bakılmalı.
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


# BUG-0021: dokusu `.glb` içinde gömülü tutulan modeller ve çıkarılan doku meta dosyaları
YAPI_NESNE_MODELLERI = (
    ("assets/model/nesne/okuz.glb.import", "assets/model/nesne/okuz_0.jpg.import"),
    ("assets/model/yapi/cadir.glb.import", "assets/model/yapi/cadir_0.jpg.import"),
    ("assets/model/yapi/ev.glb.import", "assets/model/yapi/ev_0.jpg.import"),
    ("assets/model/yapi/kapi.glb.import", "assets/model/yapi/kapi_0.jpg.import"),
    ("assets/model/yapi/kervansaray.glb.import", "assets/model/yapi/kervansaray_0.jpg.import"),
    ("assets/model/yapi/pazar_tezgahi.glb.import", "assets/model/yapi/pazar_tezgahi_0.jpg.import"),
)
# 1 = dokuları dışa çıkar (temiz klonda hayalet kaynak yaratır), 2 = Basis Universal (gömülü),
# 3 = sıkıştırılmamış (gömülü).
GOMULU_KODLARI = ("2", "3")
METIN_CEVIRISI = ROOT / "data/metin/metinler.tr.translation"

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


class YapiNesneDokuTest(unittest.TestCase):
    """BUG-0021: yapı/nesne dokuları modelin `.glb`si içinde kalır; hayalet `.import` yok."""

    def test_yapi_nesne_dokularinda_yetim_import_yok(self):
        yetim = [yol for _, yol in YAPI_NESNE_MODELLERI if (ROOT / yol).exists()]
        self.assertEqual([], yetim, "BUG-0021 kapsamında yetim .import var:\n" + "\n".join(yetim))

    def test_yapi_nesne_modelleri_doku_ayarini_gomulu_tutar(self):
        for glb_import, _ in YAPI_NESNE_MODELLERI:
            satirlar = (ROOT / glb_import).read_text(encoding="utf-8").splitlines()
            kod = [s.split("=", 1)[1].strip() for s in satirlar if s.startswith("gltf/embedded_image_handling")]
            self.assertEqual(1, len(kod), "%s: embedded_image_handling tek satır olmalı" % glb_import)
            self.assertIn(kod[0], GOMULU_KODLARI, "%s: dokular gömülü olmalı (bulunan: %s)" % (glb_import, kod[0]))


class MetinCevirisiTest(unittest.TestCase):
    """BUG-0021: `project.godot` üretilen çeviriyi gösterir; dosya depoda olmazsa temiz klonda
    editör açılışta 4 ERROR satırı basar (içe aktarma dosyayı henüz üretmemiştir)."""

    def test_metin_cevirisi_depoda_ve_izleniyor(self):
        self.assertTrue(METIN_CEVIRISI.is_file(), "data/metin/metinler.tr.translation depoda olmalı")
        kurallar = [s.strip() for s in (ROOT / ".gitignore").read_text(encoding="utf-8").splitlines()]
        self.assertNotIn("data/metin/*.translation", kurallar, "çeviri dosyası .gitignore'da olmamalı")


if __name__ == "__main__":
    unittest.main()
