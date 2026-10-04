#!/usr/bin/env python3
"""uret_yer_tutucu.py -- STAND-IN (yer tutucu) 2D art generator.

What it is
    Generates every placeholder PNG the playable build needs under
    assets/art/ (env/, fx/, char/, ui/) purely from code, because no
    image-generation service is available. Run from anywhere:

        python3 tools/art/uret_yer_tutucu.py

    Re-runnable and deterministic (no randomness): the same input always
    produces byte-identical files.

PLACEHOLDERS
    Every file written here is a placeholder. It is meant to be REPLACED by
    hand-drawn art that keeps the SAME FILENAME (art bible 8.2), so nothing in
    the game has to change when the real art lands.

Rules followed (design/art/art-bible.md)
    * 7-colour palette only (4.1); flat fills, no gradients, no glow.
    * Torch light = hard-edged flat mesale polygons (1, 8.8); layer order
      fill -> light patch -> ink.
    * Authored at 2x and downscaled with LANCZOS (8.4); afterwards every pixel
      is snapped back to a palette colour chosen from the colours present in
      its 2x source block, so interior boundaries stay palette-pure and only
      the OUTER edge keeps LANCZOS alpha anti-aliasing (8.5).
    * Line weights at final size: card outer 6 / inner 3, village & env 2-3,
      far crowd no outline. No 1 px lines.
    * No text or digits in any image.

Requires Pillow (tested with 12.x). numpy is not used.
"""

import os
import sys

from PIL import Image, ImageChops, ImageDraw, ImageFilter

# ---------------------------------------------------------------- palette
GECE = (0x0D, 0x0F, 0x14)      # night
SOGUK = (0x4A, 0x6B, 0x8A)     # cold blue
AHSAP = (0x3D, 0x2E, 0x24)     # wood
MESALE = (0xC4, 0x84, 0x3A)    # torch (world only)
INK = (0x06, 0x07, 0x0A)       # ink
KUL = (0xB8, 0xC2, 0xCC)       # ash (UI only)
DERIN = (0x24, 0x36, 0x4A)     # deep blue
PALETTE = [GECE, SOGUK, AHSAP, MESALE, INK, KUL, DERIN]

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
OUT = os.path.join(ROOT, "assets", "art")

S = 2  # authoring scale (art bible 8.4)


def rgba(c):
    return c + (255,)


# ---------------------------------------------------------------- finalize
def _index_image(src):
    """Return an 'L' image of palette indices (255 = transparent)."""
    pal = Image.new("P", (1, 1))
    flat = []
    for c in PALETTE:
        flat += list(c)
    flat += list(PALETTE[0]) * (256 - len(PALETTE))
    pal.putpalette(flat)
    q = src.convert("RGB").quantize(palette=pal, dither=Image.Dither.NONE)
    idx = Image.frombytes("L", src.size, q.tobytes())
    solid = src.getchannel("A").point(lambda a: 255 if a >= 128 else 0)
    return Image.composite(idx, Image.new("L", src.size, 255), solid)


def finalize(src, size, opaque, path):
    """Downscale a 2x drawing with LANCZOS, snap to palette, save."""
    w, h = size
    W2, H2 = src.size
    assert (W2, H2) == (w * S, h * S), (path, src.size, size)
    dst = src.resize(size, Image.LANCZOS)
    dpx = dst.load()
    idx = _index_image(src)
    ib = idx.tobytes()
    mn = idx.filter(ImageFilter.MinFilter(5)).tobytes()
    mx = idx.filter(ImageFilter.MaxFilter(5)).tobytes()
    out = bytearray(w * h * 4)
    for y in range(h):
        sy = y * S
        for x in range(w):
            sx = x * S
            i = sy * W2 + sx
            o = (y * w + x) * 4
            if mn[i] == mx[i]:
                v = mn[i]
                if v == 255:
                    continue
                c = PALETTE[v]
                out[o:o + 4] = bytes((c[0], c[1], c[2], 255))
                continue
            cands = set()
            for yy in range(max(0, sy - 1), min(H2, sy + 3)):
                row = yy * W2
                for xx in range(max(0, sx - 1), min(W2, sx + 3)):
                    cands.add(ib[row + xx])
            has_t = 255 in cands
            cands.discard(255)
            r, g, b, a = dpx[x, y]
            if not cands:
                continue
            if has_t and not opaque:
                if a < 16:
                    continue
                if a > 239:
                    a = 255
            else:
                a = 255
            best = min(cands, key=lambda k: (PALETTE[k][0] - r) ** 2
                       + (PALETTE[k][1] - g) ** 2 + (PALETTE[k][2] - b) ** 2)
            c = PALETTE[best]
            out[o:o + 4] = bytes((c[0], c[1], c[2], a))
    img = Image.frombytes("RGBA", size, bytes(out))
    if opaque:
        img = img.convert("RGB")
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, optimize=True)
    return path


# ---------------------------------------------------------------- helpers
def new(size2, bg=None):
    if bg is None:
        return Image.new("RGBA", size2, (0, 0, 0, 0))
    return Image.new("RGBA", size2, rgba(bg))


def dilate(mask, r):
    for _ in range(r):
        mask = mask.filter(ImageFilter.MaxFilter(3))
    return mask


def outline_layer(img, r):
    """Put an ink ring of r px (2x pixels) behind everything opaque in img."""
    a = img.getchannel("A").point(lambda v: 255 if v else 0)
    ring = dilate(a, r)
    base = Image.new("RGBA", img.size, rgba(INK))
    base.putalpha(ring)
    base.alpha_composite(img)
    return base


class Layer:
    """Drawing surface with clipped hard light patches (fill->patch->ink)."""

    def __init__(self, size2, inner=6, bg=None):
        self.size = size2
        self.img = new(size2, bg)
        self.d = ImageDraw.Draw(self.img)
        self.inner = inner

    def _mask(self, kind, geo):
        m = Image.new("L", self.size, 0)
        md = ImageDraw.Draw(m)
        if kind == "poly":
            md.polygon(geo, fill=255)
        else:
            md.ellipse(geo, fill=255)
        return m

    def _light(self, m, light):
        if not light:
            return
        lm = Image.new("L", self.size, 0)
        ImageDraw.Draw(lm).polygon(light, fill=255)
        self.img.paste(rgba(MESALE), (0, 0) + self.size, ImageChops.multiply(m, lm))

    def poly(self, pts, fill, light=None, ow=None):
        m = self._mask("poly", pts)
        self.img.paste(rgba(fill), (0, 0) + self.size, m)
        self._light(m, light)
        ow = self.inner if ow is None else ow
        if ow:
            self.d.polygon(pts, outline=rgba(INK), width=ow)

    def ellipse(self, box, fill, light=None, ow=None):
        m = self._mask("ell", box)
        self.img.paste(rgba(fill), (0, 0) + self.size, m)
        self._light(m, light)
        ow = self.inner if ow is None else ow
        if ow:
            self.d.ellipse(box, outline=rgba(INK), width=ow)

    def line(self, pts, w=None, col=INK):
        self.d.line(pts, fill=rgba(col), width=w or self.inner, joint="curve")

    def ring(self, box, thick, fill):
        x0, y0, x1, y1 = box
        self.d.ellipse(box, outline=rgba(fill), width=thick)
        self.d.ellipse(box, outline=rgba(INK), width=self.inner)
        t = thick - self.inner // 2
        self.d.ellipse((x0 + t, y0 + t, x1 - t, y1 - t), outline=rgba(INK), width=self.inner)


# ======================================================================
# CHARACTER CARDS  (600x760 final, 1200x1520 authoring)
# ======================================================================
CW, CH = 1200, 1520
RIM = [(0, 0), (490, 0), (455, 400), (370, 800), (290, 930), (0, 930)]
FACE_LIGHT = [(0, 0), (668, 0), (640, 1520), (0, 1520)]
FACE = [(560, 470), (700, 450), (770, 520), (792, 620), (772, 720), (722, 792),
        (642, 812), (580, 772), (550, 682), (545, 562)]
HOOD_IN = [(528, 438), (720, 408), (812, 498), (834, 640), (804, 782), (722, 846),
           (600, 852), (528, 792), (502, 662), (508, 520)]
HOOD = [(560, 236), (700, 268), (832, 360), (884, 520), (904, 700), (990, 860),
        (800, 900), (650, 960), (500, 900), (380, 860), (398, 620), (430, 420)]
BODY = [(250, 880), (420, 820), (600, 840), (840, 820), (1000, 870), (1070, 980),
        (1100, 1520), (120, 1520), (160, 1000)]
BELT = [(150, 1330), (1088, 1310), (1092, 1390), (142, 1410)]


def card_body(f, coat=DERIN, tunic=SOGUK, belt=True):
    f.poly(BODY, coat, light=RIM)
    f.poly([(560, 842), (770, 842), (706, 1322), (640, 1322)], tunic)
    f.line([(706, 870), (770, 1520)])
    f.line([(310, 1010), (272, 1480)])
    f.line([(950, 1010), (988, 1480)])
    if belt:
        f.poly(BELT, AHSAP)


def card_hood(f, fill=SOGUK):
    f.poly(HOOD, fill, light=RIM)
    f.line([(560, 250), (610, 420)])


def card_face(f, beard=False, female=False, hood_inner=True):
    if hood_inner:
        f.poly(HOOD_IN, GECE, ow=0)
    f.poly(FACE, SOGUK, light=FACE_LIGHT)
    if beard:
        f.poly([(574, 742), (640, 760), (700, 748), (770, 716), (760, 800),
                (700, 870), (630, 880), (582, 820)], INK, ow=0)
    # heavy lids, under-eye lines, nose, mouth (inner ink, 3 px final)
    f.line([(584, 600), (614, 588), (642, 597)], 10)
    f.line([(596, 624), (632, 626)])
    f.line([(700, 594), (728, 584), (754, 594)], 10)
    f.line([(708, 620), (742, 620)])
    f.line([(672, 600), (692, 680), (668, 694)])
    if not beard:
        f.line([(628, 744), (662, 738), (702, 746)])
    if female:
        f.line([(640, 768), (684, 768)])


def finish_card(f, name):
    img = outline_layer(f.img, 6)  # +6 behind the 6 px inner stroke = 12 px (6 final)
    return finalize(img, (CW // S, CH // S), False,
                    os.path.join(OUT, "char", "char_%s_neutral_card.png" % name))


def card_miraen():
    f = Layer((CW, CH))
    # signature: long felt-cap tail falling behind the head (outside silhouette)
    f.poly([(498, 300), (440, 320), (340, 560), (270, 900), (340, 920), (420, 640),
            (520, 380)], DERIN, light=RIM)
    card_body(f)
    f.poly([(470, 440), (520, 420), (540, 820), (480, 800), (452, 640)], INK, ow=0)
    card_face(f, hood_inner=False)
    f.poly([(466, 520), (474, 380), (520, 290), (600, 236), (690, 230), (760, 270),
            (800, 380), (806, 520)], DERIN, light=RIM)
    f.poly([(462, 470), (812, 470), (816, 530), (458, 530)], SOGUK, light=RIM)
    # soldier cue: broken curved scabbard at the belt, poking out to the left
    f.poly([(330, 1330), (230, 1400), (110, 1440), (40, 1452), (64, 1420), (34, 1400),
            (90, 1390), (210, 1350), (300, 1300)], AHSAP)
    return finish_card(f, "miraen")


def card_sorhan():
    f = Layer((CW, CH))
    # bundle on the back, above the left shoulder
    f.ellipse((110, 620, 500, 1010), AHSAP, light=RIM)
    f.line([(160, 700), (440, 940)])
    card_body(f)
    card_hood(f, DERIN)
    card_face(f)
    # signature: coiled halter rope over the right shoulder
    f.ring((820, 690, 1130, 1090), 44, AHSAP)
    f.ring((850, 740, 1100, 1060), 30, AHSAP)
    return finish_card(f, "sorhan")


def card_thessra():
    f = Layer((CW, CH))
    # signature: long headscarf tail flowing back
    f.poly([(520, 380), (380, 420), (220, 500), (60, 560), (80, 640), (250, 600),
            (440, 540), (500, 520)], SOGUK, light=RIM)
    card_body(f, coat=DERIN, tunic=SOGUK)
    f.poly([(470, 560), (500, 360), (600, 286), (722, 296), (806, 380), (838, 560),
            (870, 780), (930, 860), (760, 910), (650, 950), (520, 910), (360, 860),
            (420, 760)], SOGUK, light=RIM)
    card_face(f, female=True)
    # small wooden box held at the chest
    f.poly([(560, 1060), (800, 1050), (806, 1220), (566, 1230)], AHSAP)
    f.line([(562, 1100), (802, 1092)])
    f.ellipse((500, 1110, 600, 1220), SOGUK, light=FACE_LIGHT)
    f.ellipse((772, 1100, 872, 1210), SOGUK)
    return finish_card(f, "thessra")


def card_karaca_usta():
    f = Layer((CW, CH))
    # signature: rolled leather hide carried across the back
    f.poly([(120, 700), (1080, 700), (1080, 860), (120, 860)], AHSAP, light=RIM)
    f.ellipse((40, 700, 200, 860), AHSAP, light=RIM)
    f.ellipse((1000, 700, 1160, 860), AHSAP)
    f.ellipse((80, 740, 160, 820), AHSAP)
    f.ellipse((1040, 740, 1120, 820), AHSAP)
    card_body(f)
    card_hood(f, DERIN)
    card_face(f, beard=True)
    # Ahi cue: sed sash over the belt, knot ends sticking out at the waist
    f.poly([(150, 1270), (1086, 1250), (1088, 1316), (148, 1336)], SOGUK)
    f.ellipse((860, 1240, 960, 1330), SOGUK)
    f.poly([(930, 1300), (1180, 1400), (1160, 1440), (900, 1330)], SOGUK)
    f.poly([(910, 1320), (1120, 1500), (1080, 1520), (890, 1340)], SOGUK)
    return finish_card(f, "karaca_usta")


def card_aydogdu():
    f = Layer((CW, CH))
    # bow and quiver behind the right shoulder
    f.poly([(840, 520), (930, 500), (1000, 820), (910, 840)], AHSAP)
    for i, x in enumerate((850, 885, 920)):
        f.poly([(x, 520 - i * 6), (x + 22, 380 + i * 10), (x + 44, 512 - i * 6)], DERIN)
    f.d.arc((780, 160, 1180, 1400), 280, 80, fill=rgba(INK), width=58)
    f.d.arc((786, 166, 1174, 1394), 281, 79, fill=rgba(AHSAP), width=46)
    f.line([(1048, 188), (1048, 1372)], 6)
    card_body(f)
    card_hood(f, DERIN)
    card_face(f)
    # signature: felt cloak thrown over the left shoulder, flaring outside
    f.poly([(420, 820), (600, 850), (520, 1060), (420, 1520), (40, 1520), (60, 1200),
            (120, 980), (250, 860)], SOGUK, light=RIM)
    f.line([(380, 900), (250, 1500)])
    # bandaged right forearm in a sling
    f.poly([(600, 1130), (960, 1060), (990, 1180), (630, 1250)], SOGUK)
    for x in (680, 760, 840, 910):
        f.line([(x, 1110), (x + 20, 1220)])
    return finish_card(f, "aydogdu")


def card_saruca_hatun():
    f = Layer((CW, CH))
    card_body(f)
    # signature: large triangular headscarf tied under the chin
    f.poly([(620, 200), (1010, 700), (960, 760), (900, 880), (330, 880), (280, 760),
            (240, 700)], DERIN, light=RIM)
    card_face(f, female=True)
    f.poly([(650, 820), (720, 820), (760, 900), (700, 930), (640, 900)], DERIN)
    f.poly([(700, 900), (660, 1010), (700, 1020), (730, 910)], DERIN)
    # farmer cue: grain sack held low, poking out to the left
    f.poly([(40, 1250), (260, 1200), (520, 1240), (560, 1520), (20, 1520)], AHSAP)
    f.line([(120, 1260), (90, 1520)])
    return finish_card(f, "saruca_hatun")


def card_soldier_01():
    f = Layer((CW, CH))
    f.ellipse((20, 900, 400, 1560), DERIN, light=RIM)  # round shield edge
    f.ellipse((80, 960, 340, 1500), DERIN)
    card_body(f)
    card_hood(f, DERIN)
    card_face(f)
    # spear on the right shoulder
    f.poly([(1010, 1520), (1048, 1520), (1092, 230), (1056, 230)], AHSAP)
    f.poly([(1074, 60), (1112, 170), (1080, 260), (1046, 170)], SOGUK)
    return finish_card(f, "soldier_01")


def card_farmer_01():
    f = Layer((CW, CH))
    # yoke across the shoulders with hanging ropes
    f.poly([(16, 800), (1184, 780), (1184, 840), (16, 860)], AHSAP)
    f.line([(60, 860), (60, 1300)], 10)
    f.line([(1140, 840), (1140, 1300)], 10)
    card_body(f, coat=SOGUK, tunic=DERIN)
    card_hood(f, DERIN)
    card_face(f, beard=False)
    return finish_card(f, "farmer_01")


def card_farmer_02():
    f = Layer((CW, CH))
    card_body(f)
    f.poly([(470, 560), (500, 360), (600, 286), (722, 296), (806, 380), (838, 560),
            (900, 860), (760, 910), (650, 950), (520, 910), (330, 860), (420, 760)],
           SOGUK, light=RIM)
    card_face(f, female=True)
    # sickle held at the left side
    f.poly([(330, 1140), (370, 1130), (420, 1340), (380, 1350)], AHSAP)
    f.d.arc((80, 900, 420, 1240), 180, 330, fill=rgba(INK), width=46)
    f.d.arc((86, 906, 414, 1234), 181, 329, fill=rgba(SOGUK), width=34)
    return finish_card(f, "farmer_02")


def card_craftsman_01():
    f = Layer((CW, CH))
    card_body(f)
    card_hood(f, SOGUK)
    card_face(f)
    # strap across the chest and tool bag on the right hip with a hammer
    f.poly([(300, 900), (360, 880), (1000, 1250), (960, 1290)], AHSAP)
    f.poly([(1080, 1060), (1120, 1050), (1150, 1260), (1110, 1270)], AHSAP)
    f.poly([(1040, 1040), (1170, 1020), (1180, 1080), (1050, 1100)], SOGUK)
    f.poly([(900, 1200), (1180, 1180), (1190, 1460), (910, 1480)], AHSAP)
    f.line([(910, 1260), (1182, 1240)])
    return finish_card(f, "craftsman_01")


# ======================================================================
# VILLAGE FIGURES  (56x120 final, 112x240 authoring, 2 px outline)
# ======================================================================
VW, VH = 112, 240


def v_base(f, coat=DERIN, hood=SOGUK, head=True, belt=True):
    f.poly([(36, 168), (52, 168), (52, 226), (34, 226)], DERIN, ow=0)
    f.poly([(58, 168), (76, 168), (78, 226), (58, 226)], DERIN, ow=0)
    f.poly([(36, 58), (74, 58), (82, 74), (84, 150), (80, 172), (30, 172), (28, 150),
            (30, 74)], coat, ow=0)
    if belt:
        f.poly([(29, 118), (83, 118), (83, 126), (29, 126)], AHSAP, ow=0)
    if head:
        f.poly([(50, 14), (66, 24), (72, 44), (72, 64), (38, 64), (38, 40)], hood, ow=0)


def finish_village(f, name):
    img = outline_layer(f.img, 4)  # 4 px at 2x = 2 px final
    return finalize(img, (VW // S, VH // S), False,
                    os.path.join(OUT, "char", "char_%s_idle_village.png" % name))


def vil(name):
    f = Layer((VW, VH), inner=0)
    if name == "soldier_01":
        v_base(f)
        f.poly([(90, 20), (94, 20), (94, 226), (90, 226)], AHSAP, ow=0)
        f.poly([(92, 4), (98, 20), (92, 30), (86, 20)], SOGUK, ow=0)
        f.poly([(30, 124), (12, 160), (18, 164), (36, 130)], AHSAP, ow=0)
    elif name == "farmer_01":
        f.poly([(6, 62), (106, 60), (106, 68), (6, 70)], AHSAP, ow=0)
        f.poly([(8, 68), (12, 68), (12, 110), (8, 110)], AHSAP, ow=0)
        f.poly([(100, 66), (104, 66), (104, 110), (100, 110)], AHSAP, ow=0)
        f.poly([(4, 108), (18, 108), (16, 126), (6, 126)], AHSAP, ow=0)
        f.poly([(94, 108), (108, 108), (106, 126), (96, 126)], AHSAP, ow=0)
        v_base(f, coat=SOGUK, hood=DERIN)
    elif name == "farmer_02":
        v_base(f, head=False)
        f.poly([(54, 14), (70, 26), (76, 60), (80, 76), (32, 76), (34, 40)], SOGUK, ow=0)
        f.poly([(26, 120), (30, 120), (28, 150), (24, 150)], AHSAP, ow=0)
        f.poly([(6, 104), (26, 98), (28, 106), (12, 112)], SOGUK, ow=0)
    elif name == "craftsman_01":
        v_base(f)
        f.poly([(82, 124), (104, 122), (106, 160), (84, 162)], AHSAP, ow=0)
        f.poly([(94, 104), (98, 104), (98, 124), (94, 124)], AHSAP, ow=0)
        f.poly([(88, 98), (104, 98), (104, 106), (88, 106)], SOGUK, ow=0)
    elif name == "miraen":
        f.poly([(46, 20), (36, 24), (20, 70), (16, 110), (24, 110), (30, 72), (46, 30)],
               DERIN, ow=0)
        v_base(f, head=False)
        f.poly([(40, 44), (72, 44), (72, 64), (40, 64)], SOGUK, ow=0)
        f.poly([(40, 46), (42, 20), (56, 10), (68, 18), (72, 46)], DERIN, ow=0)
        f.poly([(30, 124), (10, 150), (6, 146), (12, 158), (34, 132)], AHSAP, ow=0)
    elif name == "sorhan":
        f.ellipse((8, 52, 44, 112), AHSAP, ow=0)
        v_base(f)
        f.d.ellipse((66, 46, 100, 96), outline=rgba(AHSAP), width=8)
    elif name == "thessra":
        f.poly([(42, 24), (24, 32), (6, 44), (8, 52), (28, 46), (42, 40)], SOGUK, ow=0)
        v_base(f, head=False)
        f.poly([(54, 14), (70, 26), (74, 60), (78, 72), (34, 72), (36, 40)], SOGUK, ow=0)
        f.poly([(56, 98), (84, 96), (86, 118), (58, 120)], AHSAP, ow=0)
    elif name == "karaca_usta":
        f.poly([(14, 50), (98, 50), (98, 70), (14, 70)], AHSAP, ow=0)
        f.ellipse((6, 50, 26, 70), AHSAP, ow=0)
        f.ellipse((88, 50, 108, 70), AHSAP, ow=0)
        v_base(f, coat=DERIN)
        f.poly([(29, 110), (83, 110), (83, 118), (29, 118)], SOGUK, ow=0)
        f.poly([(80, 112), (102, 132), (98, 136), (78, 120)], SOGUK, ow=0)
        f.poly([(78, 116), (94, 146), (90, 148), (76, 122)], SOGUK, ow=0)
    elif name == "aydogdu":
        f.d.arc((52, 2, 108, 150), 280, 80, fill=rgba(AHSAP), width=6)
        f.poly([(72, 30), (82, 28), (90, 90), (80, 92)], AHSAP, ow=0)
        v_base(f)
        f.poly([(36, 56), (52, 58), (40, 100), (36, 176), (10, 176), (12, 110), (20, 70)],
               SOGUK, ow=0)
    elif name == "saruca_hatun":
        v_base(f, head=False)
        f.poly([(54, 8), (84, 64), (80, 74), (30, 74), (26, 62)], DERIN, ow=0)
        f.poly([(50, 72), (60, 72), (58, 86), (52, 86)], DERIN, ow=0)
        f.poly([(6, 160), (24, 146), (48, 150), (52, 196), (8, 198)], AHSAP, ow=0)
    else:
        raise ValueError(name)
    return finish_village(f, name)


# ======================================================================
# FAR CROWD  (420x80 final, no outline)
# ======================================================================
def crowd_tekfur():
    W, H = 840, 160
    f = Layer((W, H), inner=0)
    for i in range(14):
        x = 30 + i * 58
        f.poly([(x + 28, 6), (x + 33, 22), (x + 28, 30), (x + 23, 22)], SOGUK, ow=0)
        f.poly([(x + 26, 24), (x + 30, 24), (x + 30, 156), (x + 26, 156)], SOGUK, ow=0)
        f.ellipse((x + 2, 52, x + 22, 74), SOGUK, ow=0)
        f.poly([(x - 6, 74), (x + 28, 74), (x + 30, 156), (x - 8, 156)], SOGUK, ow=0)
        f.ellipse((x - 20, 86, x + 8, 130), SOGUK, ow=0)  # same shield shape for all
    return finalize(f.img, (W // S, H // S), False,
                    os.path.join(OUT, "char", "crowd_tekfur_spear_01_far.png"))


# ======================================================================
# FX
# ======================================================================
FLAME = [(40, 92), (22, 80), (16, 56), (26, 30), (32, 44), (38, 12), (48, 36),
         (56, 22), (62, 52), (58, 80)]


def fx_torch():
    W, H = 80, 220
    f = Layer((W, H), inner=0)
    f.poly([(34, 84), (48, 84), (46, 216), (36, 216)], AHSAP, ow=0)
    f.poly([(28, 84), (54, 84), (52, 100), (30, 100)], AHSAP, ow=0)
    f.poly(FLAME, MESALE, ow=0)
    img = outline_layer(f.img, 4)
    return finalize(img, (W // S, H // S), False,
                    os.path.join(OUT, "fx", "fx_torch_village_01.png"))


PATCH = [(30, 96), (70, 50), (150, 26), (250, 14), (330, 22), (420, 36), (488, 70),
         (506, 104), (470, 140), (380, 164), (290, 170), (190, 162), (100, 150),
         (40, 128)]


def fx_patch():
    W, H = 520, 180
    f = Layer((W, H), inner=0)
    f.poly(PATCH, MESALE, ow=0)
    return finalize(f.img, (W // S, H // S), False,
                    os.path.join(OUT, "fx", "fx_torchlight_patch_village_01.png"))


# ======================================================================
# ENVIRONMENTS
# ======================================================================
def plank_post(f, x0, x1, y0, y1, light=None, planks=2):
    f.poly([(x0, y0), (x1, y0), (x1, y1), (x0, y1)], AHSAP, light=light)
    step = (x1 - x0) / (planks + 1)
    for k in range(1, planks + 1):
        x = int(x0 + step * k)
        f.line([(x, y0 + 6), (x, y1 - 6)], 4)


def torch_on(f, cx, top):
    """Torch with flame centred at cx, flame top at `top` (2x px)."""
    f.poly([(cx - 14, top + 150), (cx + 14, top + 150), (cx + 10, top + 400),
            (cx - 10, top + 400)], AHSAP, ow=6)
    f.poly([(cx - 34, top + 340), (cx + 34, top + 340), (cx + 34, top + 372),
            (cx - 34, top + 372)], AHSAP, ow=6)
    pts = [(cx + (x - 40) * 2.2, top + y * 1.8) for x, y in
           [(40, 92), (22, 80), (16, 56), (26, 30), (32, 44), (38, 12), (48, 36),
            (56, 22), (62, 52), (58, 80)]]
    f.poly(pts, MESALE, ow=6)


def env_gate_scene():
    W, H = 2280, 2000
    HZ = 930
    f = Layer((W, H), bg=GECE)
    f.poly([(0, HZ), (0, 840), (180, 820), (380, 860), (560, 800), (760, 845), (980, 790),
            (1180, 830), (1400, 780), (1620, 835), (1840, 800), (2060, 850), (2280, 815),
            (2280, HZ)], DERIN, ow=0)
    f.poly([(0, HZ), (W, HZ), (W, H), (0, H)], DERIN, ow=0)
    f.poly([(0, 1180), (300, 1150), (700, 1190), (1100, 1140), (1500, 1180), (1900, 1150),
            (2280, 1190), (W, H), (0, H)], SOGUK, ow=0)
    road = [(1220, HZ), (1260, HZ), (2000, H), (420, H)]
    f.poly(road, SOGUK, ow=0)
    f.line([(1220, HZ), (420, H)], 6, DERIN)
    f.line([(1260, HZ), (2000, H)], 6, DERIN)
    f.line([(1234, 1000), (1000, H)], 6, DERIN)
    f.line([(1250, 1000), (1500, H)], 6, DERIN)
    # far queue on the road (derin mavi, no outline, irregular rhythm)
    for x, h, load in [(1208, 30, 1), (1228, 36, 0), (1250, 26, 1), (1274, 34, 0),
                       (1236, 44, 1), (1268, 48, 0), (1200, 52, 1)]:
        base = HZ + 10 + (h - 26) * 2
        hw = h // 4
        f.poly([(x - hw, base), (x + hw, base), (x + hw // 2, base - h * 3 // 4),
                (x - hw // 2, base - h * 3 // 4)], DERIN, ow=0)
        f.ellipse((x - hw // 2 - 1, base - h, x + hw // 2 + 1, base - h * 3 // 4 + 2),
                  DERIN, ow=0)
        if load:
            f.ellipse((x - hw - 6, base - h * 3 // 4, x, base - h // 3), DERIN, ow=0)
    # torch light on the ground (hard patch)
    f.poly([(0, 1640), (180, 1600), (420, 1660), (560, 1760), (470, 1880), (540, 2000),
            (0, 2000)], MESALE, ow=0)
    # gate: top beam then posts (ink 3 px final)
    f.poly([(0, 0), (W, 0), (W, 190), (0, 190)], AHSAP)
    f.line([(0, 96), (W, 96)], 4)
    post_light = [(30, 380), (250, 330), (250, 1300), (130, 1220), (60, 1000), (20, 700)]
    plank_post(f, -10, 250, 150, H + 10, light=post_light)
    plank_post(f, 2030, W + 10, 150, H + 10)
    f.poly([(0, 150), (300, 150), (300, 230), (0, 230)], AHSAP)
    f.poly([(1980, 150), (W, 150), (W, 230), (1980, 230)], AHSAP)
    torch_on(f, 140, 420)
    return finalize(f.img, (W // S, H // S), True,
                    os.path.join(OUT, "env", "env_gate_scene_bg.png"))


def env_menu():
    W, H = 3840, 2160
    f = Layer((W, H), bg=GECE)
    f.poly([(0, 1780), (500, 1740), (1100, 1790), (1700, 1730), (2300, 1780), (2900, 1740),
            (3840, 1770), (W, H), (0, H)], DERIN, ow=0)
    f.poly([(2200, 1840), (2420, 1800), (2620, 1830), (2700, 1960), (2560, 2060),
            (2300, 2040), (2140, 1950)], MESALE, ow=0)
    f.poly([(2560, 420), (W + 10, 420), (W + 10, 600), (2560, 600)], AHSAP)
    f.line([(2560, 510), (W, 510)], 4)
    # closed gate leaves between the posts
    f.poly([(2900, 600), (3600, 600), (3600, H + 10), (2900, H + 10)], AHSAP)
    for x in range(3040, 3600, 140):
        f.line([(x, 606), (x, H)], 4)
    f.poly([(2900, 1260), (3600, 1260), (3600, 1340), (2900, 1340)], AHSAP)
    post_light = [(2640, 760), (2900, 700), (2900, 1380), (2780, 1520), (2640, 1640)]
    plank_post(f, 2640, 2900, 420, H + 10, light=post_light)
    plank_post(f, 3600, W + 10, 420, H + 10)
    torch_on(f, 2770, 760)
    return finalize(f.img, (W // S, H // S), True,
                    os.path.join(OUT, "env", "env_menu_bg.png"))


def env_village():
    W, H = 3840, 2000
    HZ = 980
    f = Layer((W, H), inner=4, bg=GECE)
    f.poly([(0, HZ), (0, 820), (300, 760), (700, 800), (1100, 730), (1500, 790),
            (1900, 740), (2300, 800), (2700, 720), (3100, 780), (3500, 750), (3840, 800),
            (3840, HZ)], DERIN, ow=0)
    f.poly([(0, HZ), (W, HZ), (W, H), (0, H)], SOGUK, ow=0)
    f.line([(0, HZ), (W, HZ)], 4)
    # kervansaray: low stone walls, side face in shadow, one arched portal
    f.poly([(1700, 860), (1900, 800), (1900, 1040), (1700, 1090)], DERIN)
    f.poly([(600, 860), (1700, 860), (1700, 1090), (600, 1090)], SOGUK)
    f.poly([(600, 830), (1700, 830), (1700, 860), (600, 860)], DERIN)
    f.poly([(1000, 700), (1300, 700), (1300, 1090), (1000, 1090)], SOGUK)
    f.poly([(1060, 1090), (1060, 860), (1150, 770), (1240, 860), (1240, 1090)], GECE)
    f.poly([(1080, 1090), (1080, 900), (1150, 900), (1150, 1090)], AHSAP)
    f.poly([(1150, 1090), (1150, 900), (1220, 900), (1220, 1090)], AHSAP)
    # pazar: wooden posts with flat cloth awnings and low tables
    for x0, w, top in [(2500, 340, 820), (2900, 300, 850), (3260, 320, 830)]:
        f.poly([(x0, top + 60), (x0 + 16, top + 60), (x0 + 16, 1090), (x0, 1090)], AHSAP)
        f.poly([(x0 + w - 16, top + 60), (x0 + w, top + 60), (x0 + w, 1090),
                (x0 + w - 16, 1090)], AHSAP)
        f.poly([(x0 - 40, top + 80), (x0 + 20, top), (x0 + w - 20, top),
                (x0 + w + 40, top + 80)], DERIN)
        f.poly([(x0 + 30, 990), (x0 + w - 30, 990), (x0 + w - 30, 1030),
                (x0 + 30, 1030)], AHSAP)
    return finalize(f.img, (W // S, H // S), True,
                    os.path.join(OUT, "env", "env_village_bg.png"))


# ======================================================================
# UI  (gece / ink / kul only -- the pouch body may use ahsap, art bible 2.5)
# ======================================================================
def ui_segments():
    W, H = 44, 60
    paths = []
    for state in ("full", "cracked_01", "cracked_02", "empty"):
        f = Layer((W, H), inner=4)
        box = [(2, 2), (W - 3, 2), (W - 3, H - 3), (2, H - 3)]
        if state == "empty":
            f.d.polygon(box, outline=rgba(KUL), width=4)
        else:
            f.poly(box, KUL)
        if state == "cracked_01":
            f.line([(24, 4), (18, 20), (26, 32), (19, 56)], 4)
        if state == "cracked_02":
            f.line([(24, 4), (18, 20), (26, 32), (19, 56)], 4)
            f.line([(18, 20), (6, 28)], 4)
            f.line([(26, 32), (38, 44)], 4)
        paths.append(finalize(f.img, (W // S, H // S), False,
                              os.path.join(OUT, "ui", "ui_bar_segment_%s.png" % state)))
    return paths


POUCH = [(30, 34), (66, 34), (60, 44), (78, 58), (86, 78), (78, 90), (18, 90),
         (10, 78), (18, 58), (36, 44)]


def icons():
    paths = []
    # bribe pouch, full: ahsap body, kul tie
    f = Layer((96, 96), inner=4)
    f.poly(POUCH, AHSAP)
    f.poly([(28, 38), (68, 38), (68, 46), (28, 46)], KUL)
    f.poly([(40, 18), (56, 18), (66, 34), (30, 34)], AHSAP)
    paths.append(finalize(outline_layer(f.img, 2), (48, 48), False,
                          os.path.join(OUT, "ui", "icon_bribe_pouch_full_48.png")))
    # bribe pouch, empty: deflated, dashed 3 px kul outline
    f = Layer((96, 96), inner=6)
    flat = [(34, 46), (62, 46), (58, 56), (78, 72), (82, 88), (14, 88), (18, 72), (38, 56)]
    pts = flat + [flat[0]]
    for i in range(len(pts) - 1):
        (x0, y0), (x1, y1) = pts[i], pts[i + 1]
        n = max(1, int(((x1 - x0) ** 2 + (y1 - y0) ** 2) ** 0.5 // 10))
        for k in range(n):
            if k % 2 == 0:
                a, b = k / n, min(1.0, (k + 1) / n)
                f.line([(x0 + (x1 - x0) * a, y0 + (y1 - y0) * a),
                        (x0 + (x1 - x0) * b, y0 + (y1 - y0) * b)], 6, KUL)
    paths.append(finalize(f.img, (48, 48), False,
                          os.path.join(OUT, "ui", "icon_bribe_pouch_empty_48.png")))

    def icon(name, draw):
        g = Layer((96, 96), inner=4)
        draw(g)
        paths.append(finalize(outline_layer(g.img, 2), (48, 48), False,
                              os.path.join(OUT, "ui", "icon_decision_%s_48.png" % name)))

    def accept(g):  # open gate leaf
        g.poly([(10, 8), (20, 8), (20, 90), (10, 90)], KUL)
        g.poly([(76, 8), (86, 8), (86, 90), (76, 90)], KUL)
        g.poly([(10, 6), (86, 6), (86, 16), (10, 16)], KUL)
        g.poly([(20, 22), (44, 32), (44, 84), (20, 88)], KUL)

    def reject(g):  # closed gate with crossbar
        g.poly([(12, 10), (84, 10), (84, 90), (12, 90)], KUL)
        g.line([(48, 12), (48, 88)])
        g.poly([(4, 46), (92, 46), (92, 58), (4, 58)], KUL)

    def bribe(g):  # pouch + coin
        g.poly([(p[0] - 6, p[1]) for p in POUCH], KUL)
        g.poly([(34, 18), (50, 18), (60, 34), (24, 34)], KUL)
        g.ellipse((58, 54, 92, 88), KUL)
        g.ellipse((66, 62, 84, 80), KUL)

    def barracks(g):  # upright spear + shield edge
        g.poly([(62, 22), (74, 22), (74, 92), (62, 92)], KUL)
        g.poly([(68, 2), (78, 20), (68, 30), (58, 20)], KUL)
        g.ellipse((6, 30, 58, 90), KUL)
        g.ellipse((24, 50, 40, 70), KUL)

    icon("accept", accept)
    icon("reject", reject)
    icon("bribe", bribe)
    icon("barracks", barracks)
    return paths


def cursor():
    f = Layer((64, 64), inner=0)
    f.poly([(6, 4), (50, 34), (32, 36), (44, 56), (34, 60), (24, 40), (10, 52)], KUL, ow=0)
    img = outline_layer(f.img, 4)
    return finalize(img, (32, 32), False, os.path.join(OUT, "ui", "ui_cursor_arrow_32.png"))


# ======================================================================
# PALETTE CHECK
# ======================================================================
def palette_check(path):
    img = Image.open(path).convert("RGBA")
    pal = set(PALETTE)
    bad_opaque = bad_edge = warm = opaque = 0
    data = img.get_flattened_data() if hasattr(img, "get_flattened_data") else img.getdata()
    for r, g, b, a in data:
        if a == 0:
            continue
        if a == 255:
            opaque += 1
            if (r, g, b) not in pal:
                bad_opaque += 1
            if (r, g, b) == MESALE:
                warm += 1
        elif (r, g, b) not in pal:
            bad_edge += 1
    return bad_opaque, bad_edge, (warm / opaque if opaque else 0.0)


def main():
    files = []
    files += [env_gate_scene(), env_menu(), env_village()]
    files += [fx_torch(), fx_patch()]
    for fn in (card_miraen, card_sorhan, card_thessra, card_karaca_usta, card_aydogdu,
               card_saruca_hatun, card_soldier_01, card_farmer_01, card_farmer_02,
               card_craftsman_01):
        files.append(fn())
    for n in ("soldier_01", "farmer_01", "farmer_02", "craftsman_01", "miraen", "sorhan",
              "thessra", "karaca_usta", "aydogdu", "saruca_hatun"):
        files.append(vil(n))
    files.append(crowd_tekfur())
    files += ui_segments()
    files += icons()
    files.append(cursor())
    total_bad = 0
    for p in files:
        bo, be, warm = palette_check(p)
        total_bad += bo + be
        size = Image.open(p).size
        print("%-60s %4dx%-4d off-palette opaque=%d edge=%d warm=%.1f%%"
              % (os.path.relpath(p, ROOT), size[0], size[1], bo, be, warm * 100))
    print("TOTAL off-palette pixels:", total_bad)
    return 0 if total_bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
