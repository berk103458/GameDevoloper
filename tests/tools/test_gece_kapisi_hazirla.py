"""Regression checks for chroma alpha, padding and fixed nine-slice corners."""
import importlib.util
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("gece_hazirla", ROOT / "tools/art/gece_kapisi_hazirla.py")
module = importlib.util.module_from_spec(spec)
try:
    import numpy as np
    from PIL import Image
    spec.loader.exec_module(module)
except ModuleNotFoundError as error:
    raise unittest.SkipTest("Optional asset preparation dependency absent: " + error.name) from error


class AssetPreparationTest(unittest.TestCase):
    def test_chroma_removes_ground_and_preserves_cool_iron(self):
        for method, color in (("green", (0,255,0)), ("magenta", (255,0,255))):
            im = Image.new("RGB", (80,60), color)
            im.paste((88,97,106), (20,10,60,50))
            result, _ = module.remove_background(im, method)
            self.assertEqual(0, result.getpixel((0,0))[3])
            self.assertEqual((88,97,106,255), result.getpixel((40,30)))

    def test_padding_and_nine_slice_keep_corner_color(self):
        im = Image.new("RGBA", (100,80), "#30251F")
        im.paste((200,138,67,255), (0,0,10,10))
        result, _ = module.prepare(im, (160,100), {"source":[10,10], "target":[10,10]})
        alpha = np.asarray(result.getchannel("A"))
        self.assertFalse(alpha[:16].any())
        self.assertFalse(alpha[-16:].any())
        self.assertFalse(alpha[:,:16].any())
        self.assertFalse(alpha[:,-16:].any())
        self.assertEqual((200,138,67,255), result.getpixel((20,20)))

    def test_impossible_padding_is_rejected(self):
        with self.assertRaisesRegex(ValueError, "too small"):
            module.prepare(Image.new("RGBA", (20,20), "white"), (32,32))


if __name__ == "__main__":
    unittest.main()
