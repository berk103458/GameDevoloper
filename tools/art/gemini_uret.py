#!/usr/bin/env python3
"""gemini_uret.py -- assets/art/ altindaki yer tutucu PNG'leri Gemini ile uretilen
sanatla DEGISTIREN uretim hatti. Ayni dosya adi, ayni piksel boyutu (art bible 8.2).

Kullanim (depo kokunden):
    python3 tools/art/gemini_uret.py --kuru                 # istemleri ve boyutlari yaz
    python3 tools/art/gemini_uret.py                        # hepsini uret (API)
    python3 tools/art/gemini_uret.py --sadece 'char_miraen*' --yedek
    python3 tools/art/gemini_uret.py --el-ile               # tools/art/gelen/ -> assets/art/
    python3 tools/art/gemini_uret.py --istemler-md          # tools/art/istemler.md yaz
    python3 tools/art/gemini_uret.py --sinama GORSEL.png char_miraen_neutral_card

Anahtar: GEMINI_API_KEY ortam degiskeni ya da --anahtar DOSYA.

Son isleme (her modda ayni, bkz. son_isle()):
    1. Saydam hedeflerde #FF00FF arka plan anahtarlanir (tolerans + macenta tasmasi).
    2. Hedef boyuta kadraj: kapla (cover-crop), kart = alta dayali, diger saydamlar
       konunun sinir kutusuna gore sigdirilir.
    3. Her opak piksel art bible 4.1 paletine (hedefe gore alt kume) agirlikli RGB
       ile yapistirilir; alfa ikili (esik 128).

Bagimlilik: yalniz standart kutuphane (urllib) + Pillow.
"""

import argparse
import base64
import fnmatch
import io
import json
import math
import os
import shutil
import sys
import time
import urllib.error
import urllib.request

from PIL import Image, ImageChops, ImageFilter

# ---------------------------------------------------------------- yollar
BURASI = os.path.dirname(os.path.abspath(__file__))
KOK = os.path.abspath(os.path.join(BURASI, "..", ".."))
SANAT = os.path.join(KOK, "assets", "art")
YEDEK = os.path.join(BURASI, "yedek")
HAM = os.path.join(BURASI, "ham")
GELEN = os.path.join(BURASI, "gelen")
SINAMA = os.path.join(BURASI, "sinama")
ISTEMLER_MD = os.path.join(BURASI, "istemler.md")

VARSAYILAN_MODEL = "gemini-3.1-flash-image"
API = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent"

# ---------------------------------------------------------------- palet (art bible 4.1)
GECE = (0x0D, 0x0F, 0x14)
SOGUK = (0x4A, 0x6B, 0x8A)
AHSAP = (0x3D, 0x2E, 0x24)
MESALE = (0xC4, 0x84, 0x3A)
INK = (0x06, 0x07, 0x0A)
KUL = (0xB8, 0xC2, 0xCC)
DERIN = (0x24, 0x36, 0x4A)
PALET = [GECE, SOGUK, AHSAP, MESALE, INK, KUL, DERIN]

# Hedef bazinda alt kumeler. Kul dunyada yok (5.2, 4.4); arayuzde mesale yok (4.4).
P_DUNYA = [GECE, SOGUK, AHSAP, MESALE, INK, DERIN]
P_ARAYUZ = [GECE, INK, KUL]
P_KESE = [GECE, INK, KUL, AHSAP]  # rusvet kesesi govdesi ahsap (2.5)

MACENTA = (255, 0, 255)
ORANLAR = ["1:1", "2:3", "3:2", "3:4", "4:3", "4:5", "5:4", "9:16", "16:9", "21:9"]

# ---------------------------------------------------------------- stil bloklari
STIL_DUNYA = (
    "STYLE: flat 2D game illustration in a bold graphic-novel ink style. Thick, confident "
    "ink-black outlines: heaviest on the outer silhouette, about half as thick for interior "
    "details (folds, face lines). Flat solid colour fills only. NO gradients, no soft shading, "
    "no airbrush, no glow, no bloom, no rim light haze, no texture noise, no grain, no "
    "dithering, no painterly brush strokes, no photorealism, no anime, no 3D render. "
    "It is night and the only warm light is a single torch: wherever the torch light touches "
    "a surface it is a hard-edged flat patch of torch amber; everything else is cold blue and "
    "near-black. STRICT PALETTE, use only these colours: night near-black #0D0F14 (background, "
    "voids, shadow); cold blue #4A6B8A (sky, stone, cloth, distant figures, the unlit side of "
    "faces); deep blue #24364A (second depth layer, distant layers, darker cloth); wood brown "
    "#3D2E24 (wood, leather, everything human-made); torch amber #C4843A (ONLY the torch flame "
    "and the hard-edged patches its light makes); ink black #06070A (outlines). No skin tone "
    "colour: a lit face is torch amber, an unlit face is cold blue. "
    "SETTING: the year 1243 on the Anatolian frontier (Seljuk borderland) while people flee "
    "the Mongol invasion. People are tired: low shoulders, head bowed forward, heavy eyelids, "
    "weight on one leg, no heroic or action poses, no evil or villain faces. Clothing of the "
    "period only: wool hood, felt cap, linen tunic, wrapped wool kaftan closed with ties or a "
    "sash, leather belt, sleeveless felt cloak, loose trousers, leg wraps, rawhide sandals or "
    "cloth-wrapped feet. FORBIDDEN: any text, letters, numbers, runes, writing, signatures, "
    "watermarks, logos or inscriptions; modern items (caps with visors, coats with collars, "
    "zippers, rows of buttons, metal buckles); fantasy armour, plate armour, horned helmets; "
    "later Ottoman turbans or fez; the colours red, green, gold or pink."
)

STIL_ARAYUZ = (
    "STYLE: flat 2D game user-interface graphic. One bold, simple shape, readable at 48 pixels. "
    "Thick ink-black #06070A outline, flat solid fills, hard square corners where there are "
    "corners. NO gradients, no shading, no bevel, no gloss, no 3D, no drop shadow, no glow, no "
    "texture. Use only ash white #B8C2CC and ink black #06070A unless told otherwise. FORBIDDEN: "
    "any text, letters, numbers, writing, logos or watermarks; the colours red, green, gold, "
    "orange or pink."
)

ARKA_SAYDAM = (
    "BACKGROUND: the subject stands alone on a perfectly flat, uniform, pure magenta #FF00FF "
    "background that fills the whole image edge to edge. No shadow, no ground, no floor line, "
    "no vignette, no frame, no border, nothing else in the background. Never use magenta, pink "
    "or purple anywhere on the subject itself."
)

KART = (
    "FRAMING: character portrait card, chest-up (head, shoulders and upper chest), the figure "
    "centred and filling most of the image width, the chest cut off by the bottom edge of the "
    "image, a little empty space above the head. Three-quarter view toward the viewer. Tired "
    "neutral expression: heavy eyelids, a single ink line under each eye, mouth closed, head "
    "slightly bowed. LIGHT: one torch off to the left - the left half of the face and clothes is "
    "a flat hard-edged torch amber #C4843A patch, the right half of the face is flat cold blue "
    "#4A6B8A with ink-black shadow shapes; the boundary between them is one sharp line, no "
    "blending. Very thick outer outline, interior lines half as thick."
)

KOY = (
    "FRAMING: one small full-body standing figure for a village view, head to feet, front view, "
    "centred, feet at the bottom. It will be shown only about 100 pixels tall, so use very bold "
    "simple shapes: a readable silhouette, no facial features (the hood or headwear shape is "
    "enough), no folds, one thin uniform outline. A single hard-edged torch amber patch on the "
    "left side of the body, the rest cold blue, deep blue and wood brown."
)

# ---------------------------------------------------------------- konu tablosu
# ad -> (alt klasor, (gen, yuk), saydam, cerceve, capa, kenar, palet, konu)
#   cerceve: "kapla" (cover-crop) | "sigdir" (konu sinir kutusunu sigdir)
#   capa:    "orta" | "alt" | "solust"
#   kenar:   sigdir icin konu cevresinde birakilan pay (kisa kenar orani)

KISILER = {
    "miraen": (
        "Miraen, a Georgian former cavalryman in his forties: lean weathered face, short dark "
        "beard, tall felt cap whose LONG TAIL falls down behind his head and back (his signature "
        "shape, it must stick out of the silhouette), worn wool kaftan wrapped and belted, a "
        "BROKEN curved sabre scabbard - empty, snapped short, no blade - slung so it shows at "
        "his side/over the shoulder."),
    "sorhan": (
        "Sorhan, a Kipchak horse trader, middle-aged: broad face, wide cheekbones, drooping "
        "moustache, felt cap, a COILED HORSE HALTER ROPE hanging over one shoulder (his "
        "signature shape), a tied cloth bundle on his back rising above the other shoulder, "
        "plain wool kaftan."),
    "thessra": (
        "Thessra, a young Greek woman from Trebizond, about eighteen, a healer's daughter: "
        "narrow tired face, a LONG HEADSCARF whose long tail hangs down past one shoulder (her "
        "signature shape), plain linen dress under a wool overdress, holding a SMALL PLAIN "
        "WOODEN BOX (no markings) against her chest with both hands."),
    "karaca_usta": (
        "Karaca Usta, an older Ahi master tanner from Kayseri: grey short beard, felt cap, "
        "a ROLLED ANIMAL HIDE tied horizontally across his back so it rises above both "
        "shoulders, wool kaftan, and the Ahi guild SASH (sed): a wide cloth sash tied over the "
        "leather belt with a knot whose two ENDS STICK OUT sideways beyond the body outline. "
        "Frame slightly lower than usual so the sash knot at the waist is visible."),
    "aydogdu": (
        "Aydogdu, a young Turkmen archer: thin moustache, wool hood, one forearm wrapped in a "
        "pale cloth BANDAGE (that hand raised near the chest so it is visible), a felt cloak "
        "draped over ONE shoulder only, a recurved composite BOW and a QUIVER of arrows on his "
        "back with the bow tip and arrow ends rising above the shoulder."),
    "saruca_hatun": (
        "Saruca Hatun, a widowed farm woman in her fifties: lined face, a LARGE TRIANGULAR "
        "HEADSCARF tied under her chin (her signature shape), plain wool dress, a coarse cloth "
        "GRAIN SACK tied with rope held against her shoulder and chest."),
    "soldier_01": (
        "An ordinary frontier foot soldier: padded quilted kaftan as his only armour, a plain "
        "conical iron cap or wool hood, a long spear held upright over the right shoulder with "
        "the spearhead above his head, the edge of a round wooden shield at his left side."),
    "farmer_01": (
        "A male farmer: wool hood, plain tunic, a wooden carrying YOKE across both shoulders "
        "with ropes hanging down at each end - a wide horizontal shape."),
    "farmer_02": (
        "A female farmer: plain headscarf, wool dress, a SICKLE held low in one hand at her "
        "side."),
    "craftsman_01": (
        "A craftsman (not a guild master): wool hood, tunic, a leather strap across the chest "
        "to a tool bag on his hip with a small hammer handle sticking out, a tied bundle on his "
        "back rising above one shoulder."),
}


def _tablo():
    t = {}
    for k, konu in KISILER.items():
        t["char_%s_neutral_card" % k] = ("char", (600, 760), True, "kapla", "alt", 0.0,
                                         P_DUNYA, STIL_DUNYA, KART, konu)
        t["char_%s_idle_village" % k] = ("char", (56, 120), True, "sigdir", "alt", 0.02,
                                         P_DUNYA, STIL_DUNYA, KOY, konu)
    t["crowd_tekfur_spear_01_far"] = (
        "char", (420, 80), True, "sigdir", "alt", 0.0, [SOGUK, DERIN], STIL_DUNYA, "",
        "A distant row of about fourteen foot soldiers of the Byzantine frontier lord (tekfur), "
        "seen from far away: flat silhouettes only, all one flat cold blue #4A6B8A with a few "
        "deep blue #24364A shapes, NO outlines, no faces, no interior detail. Evenly spaced in "
        "a regular rhythm, each with an upright spear whose tip repeats above the heads and the "
        "same round shield. One horizontal band of figures filling the image width. Organised "
        "and distant, not demonic.")
    t["fx_torch_village_01"] = (
        "fx", (40, 110), True, "sigdir", "alt", 0.02, [AHSAP, MESALE, INK], STIL_DUNYA, "",
        "A single standing wooden torch: a straight wooden pole with a cloth-wrapped head and a "
        "flat flame on top. The flame is one flat torch amber #C4843A shape with jagged hard "
        "edges, the pole wood brown #3D2E24, a thick ink outline around everything. Vertical, "
        "centred, filling the image height. No glow, no sparks, no smoke.")
    t["fx_torchlight_patch_village_01"] = (
        "fx", (260, 90), True, "sigdir", "orta", 0.0, [MESALE], STIL_DUNYA, "",
        "A single irregular blob of torchlight as it lies on flat ground, seen from a low angle: "
        "a wide, flattened horizontal shape with hard irregular edges, ONE flat colour torch "
        "amber #C4843A, no outline, no glow, no gradient, nothing else in the image.")
    t["env_gate_scene_bg"] = (
        "env", (1140, 1000), False, "kapla", "orta", 0.0, P_DUNYA, STIL_DUNYA, "",
        "First-person view from just inside a frontier palisade gate at night, looking out "
        "through the open gateway. Left and right image edges: thick vertical wooden gate posts "
        "made of planks; a heavy horizontal wooden beam across the top edge. A single torch fixed "
        "to the LEFT post: its flame torch amber, throwing one hard-edged flat amber patch onto "
        "the post and onto the ground at the lower left. Through the gateway: a dirt road "
        "narrowing to the horizon, flat layered cold blue and deep blue hills under a near-black "
        "sky, and far away on the road an irregular queue of tiny deep blue refugee silhouettes "
        "carrying bundles. Keep the centre calm and empty so a character can stand in front of "
        "it. Depth by flat tone layers only: no gradient sky, no stars, no moon.")
    t["env_menu_bg"] = (
        "env", (1920, 1080), False, "kapla", "orta", 0.0, P_DUNYA, STIL_DUNYA, "",
        "Wide night landscape for a title screen. The left two thirds: empty near-black sky over "
        "low deep blue ridges (room for a title that is added later in code - do not draw any "
        "text). The right third: a CLOSED heavy wooden frontier gate made of vertical planks "
        "between two plank posts under a top beam, a single torch on the left post, one "
        "hard-edged amber light patch on the post and on the ground below it. No people.")
    t["env_village_bg"] = (
        "env", (1920, 1000), False, "kapla", "orta", 0.0, P_DUNYA, STIL_DUNYA, "",
        "Wide side view of a small Seljuk-era frontier village at night, after the torches are "
        "lit. Centre-left: a small caravanserai - a closed square courtyard behind low, plain "
        "rubble-stone walls (cold blue with a few ink joint lines), ONE pointed-arch portal with "
        "wooden doors, above it an EMPTY blank inscription frame. Right side: an open market of a "
        "few wooden posts with stretched cloth awnings (deep blue) and low wooden tables. Flat "
        "cold blue ground across the lower half, deep blue distant ridges, near-black sky. Two "
        "or three small torches, each with a hard amber light patch. No people (they are added "
        "separately), no signs, organic layout, not a grid.")
    seg = ("A single vertical rectangular segment of a UI bar, like a flat stone slab, filling "
           "the ENTIRE image edge to edge, hard square corners. ")
    t["ui_bar_segment_full"] = ("ui", (22, 30), True, "sigdir", "orta", 0.0, P_ARAYUZ,
                                STIL_ARAYUZ, "", seg + "Solid ash white fill, thick ink border.")
    t["ui_bar_segment_cracked_01"] = (
        "ui", (22, 30), True, "sigdir", "orta", 0.0, P_ARAYUZ, STIL_ARAYUZ, "",
        seg + "Solid ash white fill, thick ink border, ONE thick ink crack line zig-zagging "
        "from the top edge to the bottom edge.")
    t["ui_bar_segment_cracked_02"] = (
        "ui", (22, 30), True, "sigdir", "orta", 0.0, P_ARAYUZ, STIL_ARAYUZ, "",
        seg + "Solid ash white fill, thick ink border, a thick ink crack from top to bottom with "
        "two side branches - the slab is about to split.")
    t["ui_bar_segment_empty"] = (
        "ui", (22, 30), True, "sigdir", "orta", 0.0, P_ARAYUZ, STIL_ARAYUZ, "",
        seg + "EMPTY: only a thick ash white outline frame, the inside is background.")
    ikon = "A square game icon, the pictogram centred and filling about 85% of the image. "
    t["icon_bribe_pouch_full_48"] = (
        "ui", (48, 48), True, "sigdir", "orta", 0.04, P_KESE, STIL_ARAYUZ, "",
        ikon + "A FULL, round leather coin pouch tied at the neck with a cord: pouch body wood "
        "brown #3D2E24, the tie ash white, thick ink outline.")
    t["icon_bribe_pouch_empty_48"] = (
        "ui", (48, 48), True, "sigdir", "orta", 0.04, P_ARAYUZ, STIL_ARAYUZ, "",
        ikon + "The same coin pouch but EMPTY and deflated, drawn only as a thick DASHED ash "
        "white outline with no fill (the inside is background).")
    t["icon_decision_accept_48"] = (
        "ui", (48, 48), True, "sigdir", "orta", 0.04, P_ARAYUZ, STIL_ARAYUZ, "",
        ikon + "An OPEN wooden gate: a gate frame with one leaf swung open inward.")
    t["icon_decision_reject_48"] = (
        "ui", (48, 48), True, "sigdir", "orta", 0.04, P_ARAYUZ, STIL_ARAYUZ, "",
        ikon + "A CLOSED wooden gate barred by one heavy horizontal crossbar.")
    t["icon_decision_bribe_48"] = (
        "ui", (48, 48), True, "sigdir", "orta", 0.04, P_ARAYUZ, STIL_ARAYUZ, "",
        ikon + "A coin pouch with one plain round coin beside it (no markings, no numbers).")
    t["icon_decision_barracks_48"] = (
        "ui", (48, 48), True, "sigdir", "orta", 0.04, P_ARAYUZ, STIL_ARAYUZ, "",
        ikon + "An upright spear with a round shield leaning against it.")
    t["ui_cursor_arrow_32"] = (
        "ui", (32, 32), True, "sigdir", "solust", 0.0, P_ARAYUZ, STIL_ARAYUZ, "",
        "A classic mouse pointer arrow pointing up-left, its sharp tip at the top-left corner "
        "of the image: ash white fill with a thick ink outline.")
    return t


HEDEFLER = _tablo()


class Hedef:
    def __init__(self, ad):
        (self.alt, boyut, self.saydam, self.cerceve, self.capa, self.kenar, self.palet,
         stil, cerceve_metni, konu) = HEDEFLER[ad]
        self.ad = ad
        self.yol = os.path.join(SANAT, self.alt, ad + ".png")
        self.boyut = boyut
        if os.path.exists(self.yol):
            gercek = Image.open(self.yol).size
            if gercek != boyut:
                print("UYARI: %s tabloda %s, diskte %s -- disktekini kullaniyorum"
                      % (ad, boyut, gercek), file=sys.stderr)
                self.boyut = gercek
        self.oran = en_yakin_oran(*self.boyut)
        yon = "landscape" if self.boyut[0] > self.boyut[1] else (
            "portrait" if self.boyut[0] < self.boyut[1] else "square")
        parcalar = [stil, cerceve_metni, "SUBJECT: " + konu,
                    ARKA_SAYDAM if self.saydam else "",
                    "IMAGE: aspect ratio %s (%s)." % (self.oran, yon)]
        self.istem = "\n\n".join(p for p in parcalar if p)


def en_yakin_oran(w, h):
    r = math.log(w / h)
    return min(ORANLAR, key=lambda o: abs(math.log(int(o.split(":")[0]) /
                                                   int(o.split(":")[1])) - r))


# ================================================================ son isleme
def anahtarla(img, tol=80, tasma=50):
    """Macenta arka plani saydam yap. Dondurur (RGBA, silinen oran)."""
    if img.mode in ("RGBA", "LA", "PA") or (img.mode == "P" and "transparency" in img.info):
        # Zaten saydam bir kaynak (el ile saydam kaydedilmis ya da sinama): once macentaya yay.
        rgba = img.convert("RGBA")
        zemin = Image.new("RGBA", rgba.size, MACENTA + (255,))
        img = Image.alpha_composite(zemin, rgba)
    rgb = img.convert("RGB")
    r, g, b = rgb.split()
    # 1) Guclu macenta: kutu toleransi. Palette macenta yok, konu asla silinmez.
    guclu = ImageChops.darker(ImageChops.darker(
        r.point(lambda v: 255 if v >= 255 - tol else 0),
        g.point(lambda v: 255 if v <= tol else 0)),
        b.point(lambda v: 255 if v >= 255 - tol else 0))
    # 2) Tasma: min(R,B) - G > esik. 7 palet rengi icin bu fark hep negatif; yalniz
    #    guclu macentaya 2 px komsu kenar pikselleri silinir (konu icindeki mor kalsin).
    fark = ImageChops.subtract(ImageChops.darker(r, b), g)
    tasan = fark.point(lambda v: 255 if v > tasma else 0)
    yakin = guclu.filter(ImageFilter.MaxFilter(5))
    arka = ImageChops.lighter(guclu, ImageChops.darker(tasan, yakin))
    alfa = ImageChops.invert(arka)
    out = rgb.convert("RGBA")
    out.putalpha(alfa)
    hist = arka.histogram()
    return out, hist[255] / float(arka.size[0] * arka.size[1])


def _konu_kutusu(img):
    a = img.getchannel("A").point(lambda v: 255 if v >= 128 else 0)
    a = a.filter(ImageFilter.MinFilter(3)).filter(ImageFilter.MaxFilter(3))  # kirpinti temizle
    return a.getbbox() or (0, 0, img.size[0], img.size[1])


def kadrajla(img, hedef):
    """Kaynak goruntuyu hedef boyuta getir (LANCZOS, RGBA on-carpimli)."""
    tw, th = hedef.boyut
    sw, sh = img.size
    if hedef.cerceve == "kapla":
        olcek = max(tw / sw, th / sh)
        ww, wh = tw / olcek, th / olcek
        if hedef.saydam and hedef.capa == "alt":
            x0b, _, x1b, _ = _konu_kutusu(img)
            cx = (x0b + x1b) / 2.0
        else:
            cx = sw / 2.0
        x0 = min(max(cx - ww / 2.0, 0.0), sw - ww)
        y0 = {"alt": sh - wh, "solust": 0.0}.get(hedef.capa, (sh - wh) / 2.0)
        return img.resize((tw, th), Image.LANCZOS, box=(x0, y0, x0 + ww, y0 + wh))
    # sigdir: konu kutusunu (+pay) hedef oranli bir pencereye yerlestir
    x0, y0, x1, y1 = _konu_kutusu(img)
    bw, bh = x1 - x0, y1 - y0
    pay = hedef.kenar * min(bw, bh)
    bw, bh = bw + 2 * pay, bh + 2 * pay
    hedef_oran = tw / th
    if bw / bh > hedef_oran:
        ww, wh = bw, bw / hedef_oran
    else:
        ww, wh = bh * hedef_oran, bh
    if hedef.capa == "alt":
        px0, py0 = (x0 + x1) / 2.0 - ww / 2.0, y1 + pay - wh
    elif hedef.capa == "solust":
        px0, py0 = x0 - pay, y0 - pay
    else:
        px0, py0 = (x0 + x1) / 2.0 - ww / 2.0, (y0 + y1) / 2.0 - wh / 2.0
    # Pencere goruntu disina tasabilir: tam sayi kirpma saydam doldurur.
    kx0, ky0 = int(math.floor(px0)), int(math.floor(py0))
    kx1, ky1 = int(math.ceil(px0 + ww)), int(math.ceil(py0 + wh))
    parca = img.crop((kx0, ky0, kx1, ky1))
    return parca.resize((tw, th), Image.LANCZOS,
                        box=(px0 - kx0, py0 - ky0, px0 - kx0 + ww, py0 - ky0 + wh))


# Agirlikli RGB (2,4,3): kanallari sqrt(w/4) ile olcekleyip Pillow'un C'deki en-yakin
# renk aramasina (Oklid) veriyoruz -- piksel basina Python dongusu yok.
_AG = (math.sqrt(2 / 4.0), 1.0, math.sqrt(3 / 4.0))


def palete_yapistir(img, palet):
    """RGB(A) -> palet renklerinden olusan RGB. Alfa dokunulmaz (cagiran halleder)."""
    rgb = img.convert("RGB")
    lut = []
    for k in range(3):
        lut += [int(round(v * _AG[k])) for v in range(256)]
    olcekli = rgb.point(lut)
    pal = Image.new("P", (1, 1))
    duz = []
    for c in palet:
        duz += [int(round(c[k] * _AG[k])) for k in range(3)]
    duz += duz[:3] * (256 - len(palet))
    pal.putpalette(duz)
    q = olcekli.quantize(palette=pal, dither=Image.Dither.NONE)
    idx = Image.frombytes("L", rgb.size, q.tobytes())
    n = len(palet)
    kanallar = [idx.point([palet[i if i < n else 0][k] for i in range(256)]) for k in range(3)]
    return Image.merge("RGB", kanallar)


def son_isle(kaynak, hedef, tol=80, tasma=50):
    """Tum son isleme. Dondurur (sonuc Image, rapor sozlugu)."""
    rapor = {}
    img = kaynak
    if hedef.saydam:
        img, oran = anahtarla(img, tol, tasma)
        rapor["silinen_arka"] = oran
        if oran < 0.03:
            rapor["uyari"] = "macenta arka plan neredeyse yok -- istem tutmamis olabilir"
        # Kaynak cozunurlukte bir kez palete yapistir: YZ gurultusunu kadrajdan once temizler.
        temiz = palete_yapistir(img, hedef.palet).convert("RGBA")
        temiz.putalpha(img.getchannel("A"))
        img = temiz
    else:
        img = palete_yapistir(img.convert("RGB"), hedef.palet)
    kucuk = kadrajla(img.convert("RGBA") if hedef.saydam else img, hedef)
    sonuc = palete_yapistir(kucuk, hedef.palet)
    if hedef.saydam:
        alfa = kucuk.getchannel("A").point(lambda v: 255 if v >= 128 else 0)
        sonuc = sonuc.convert("RGBA")
        sonuc.putalpha(alfa)
        bos = Image.new("RGBA", sonuc.size, (0, 0, 0, 0))
        sonuc = Image.composite(sonuc, bos, alfa)
    return sonuc, rapor


def denetle(img, palet):
    """Gozlem: boyut, renkler, palet disi piksel, ikili olmayan alfa."""
    rgba = img.convert("RGBA")
    renkler = rgba.getcolors(1 << 24) or []
    izinli = set(palet)
    disi = sum(n for n, (r, g, b, a) in renkler if a > 0 and (r, g, b) not in izinli)
    yari = sum(n for n, (r, g, b, a) in renkler if 0 < a < 255)
    gorunen = sorted({(r, g, b) for n, (r, g, b, a) in renkler if a > 0})
    adlar = {GECE: "gece", SOGUK: "soguk", AHSAP: "ahsap", MESALE: "mesale", INK: "murekkep",
             KUL: "kul", DERIN: "derin"}
    saydam = sum(n for n, (r, g, b, a) in renkler if a == 0)
    return {"boyut": img.size, "kip": img.mode, "palet_disi": disi, "yari_alfa": yari,
            "saydam_oran": saydam / float(img.size[0] * img.size[1]),
            "renkler": [adlar.get(c, "#%02X%02X%02X" % c) for c in gorunen]}


def kaydet(img, hedef, cikti_kok, yedekle):
    yol = os.path.join(cikti_kok, hedef.alt, hedef.ad + ".png")
    os.makedirs(os.path.dirname(yol), exist_ok=True)
    if yedekle and os.path.exists(yol):
        os.makedirs(YEDEK, exist_ok=True)
        y = os.path.join(YEDEK, hedef.ad + ".yer_tutucu.png")
        if not os.path.exists(y):  # ilk yer tutucuyu koru, sonraki uretimler ezmesin
            shutil.copy2(yol, y)
    gecici = yol + ".tmp.png"
    img.save(gecici, optimize=True)
    os.replace(gecici, yol)
    return yol


# ================================================================ ag
class KotaHatasi(Exception):
    pass


class ApiHatasi(Exception):
    pass


KOTA_MESAJI = (
    "Gemini gorsel kotasi YOK (HTTP 429, limit 0). Ucretsiz katmanda gorsel modeli icin kota "
    "sifir. Cozum: Google AI Studio'da (https://aistudio.google.com) bu anahtarin projesi icin "
    "faturalandirmayi acin (Settings -> Billing / 'Set up billing'), birkac dakika bekleyip "
    "tekrar deneyin. Gemini uygulamasi (Pro) aboneligi API kotasi VERMEZ; abonelikle el ile "
    "uretmek icin: --el-ile (bkz. tools/art/BENIOKU.md).")


def anahtar_oku(dosya):
    if dosya:
        with open(dosya, encoding="utf-8") as f:
            return f.read().strip()
    k = os.environ.get("GEMINI_API_KEY", "").strip()
    if not k:
        raise ApiHatasi("Anahtar yok: GEMINI_API_KEY ortam degiskenini ayarlayin ya da "
                        "--anahtar DOSYA verin.")
    return k


def _bekleme_suresi(govde, baslik, deneme, taban):
    ra = baslik.get("Retry-After") if baslik else None
    if ra:
        try:
            return float(ra)
        except ValueError:
            pass
    try:
        for d in json.loads(govde).get("error", {}).get("details", []):
            if "retryDelay" in d:
                return float(str(d["retryDelay"]).rstrip("s"))
    except (ValueError, AttributeError):
        pass
    return min(taban * (2 ** deneme), 120.0)


def gorsel_iste(istem, oran, anahtar, model, deneme_sayisi=5, taban=4.0, zaman_asimi=180):
    """Gemini'den tek gorsel ister; ham bayt doner. 429/5xx'te geri cekilerek yeniden dener."""
    govde = json.dumps({
        "contents": [{"parts": [{"text": istem}]}],
        "generationConfig": {"responseModalities": ["IMAGE"], "imageConfig": {"aspectRatio": oran}},
    }).encode("utf-8")
    url = API % model
    for deneme in range(deneme_sayisi):
        istek = urllib.request.Request(url, data=govde, method="POST", headers={
            "Content-Type": "application/json", "x-goog-api-key": anahtar})
        try:
            with urllib.request.urlopen(istek, timeout=zaman_asimi) as yanit:
                veri = json.loads(yanit.read().decode("utf-8"))
            return _gorseli_cikar(veri)
        except urllib.error.HTTPError as e:
            metin = e.read().decode("utf-8", "replace")
            if e.code == 429 and ("limit: 0" in metin or "limit:0" in metin):
                raise KotaHatasi(KOTA_MESAJI)
            if e.code in (429, 500, 502, 503, 504) and deneme + 1 < deneme_sayisi:
                s = _bekleme_suresi(metin, e.headers, deneme, taban)
                print("  HTTP %d, %.0f sn sonra yeniden (%d/%d)" % (e.code, s, deneme + 2,
                                                                    deneme_sayisi))
                time.sleep(s)
                continue
            if e.code == 429:
                raise KotaHatasi(KOTA_MESAJI + "\nSunucu yaniti: " + metin[:400])
            ipucu = {400: "istek gecersiz (anahtar ya da govde)",
                     403: "anahtar reddedildi / API etkin degil",
                     404: "model bulunamadi -- --model ile adi kontrol edin"}.get(e.code, "")
            raise ApiHatasi("HTTP %d %s\n%s" % (e.code, ipucu, metin[:600]))
        except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
            if deneme + 1 < deneme_sayisi:
                s = min(taban * (2 ** deneme), 120.0)
                print("  ag hatasi (%s), %.0f sn sonra yeniden" % (e, s))
                time.sleep(s)
                continue
            raise ApiHatasi("Ag hatasi: %s" % e)
    raise ApiHatasi("deneme hakki bitti")


def _gorseli_cikar(veri):
    adaylar = veri.get("candidates") or []
    if not adaylar:
        neden = (veri.get("promptFeedback") or {}).get("blockReason", "bilinmiyor")
        raise ApiHatasi("Yanitta aday yok (engelleme: %s)" % neden)
    parcalar = (adaylar[0].get("content") or {}).get("parts") or []
    for p in parcalar:
        ic = p.get("inlineData") or p.get("inline_data")
        if ic and ic.get("data"):
            return base64.b64decode(ic["data"])
    metin = " ".join(p.get("text", "") for p in parcalar)[:300]
    raise ApiHatasi("Yanitta gorsel yok (finishReason=%s) %s"
                    % (adaylar[0].get("finishReason"), metin))


# ================================================================ modlar
def secili_hedefler(desen):
    adlar = sorted(HEDEFLER)
    if desen:
        desenler = [d.strip() for d in desen.split(",") if d.strip()]
        adlar = [a for a in adlar if any(fnmatch.fnmatch(a, d) or fnmatch.fnmatch(a + ".png", d)
                                         for d in desenler)]
    return [Hedef(a) for a in adlar]


def kapsama_denetle():
    """assets/art'taki her PNG'nin tabloda istemi olmali (ve tersi)."""
    disk = set()
    for kok, _, dosyalar in os.walk(SANAT):
        for d in dosyalar:
            if d.endswith(".png"):
                disk.add(os.path.splitext(d)[0])
    eksik_istem = sorted(disk - set(HEDEFLER))
    eksik_dosya = sorted(set(HEDEFLER) - disk)
    for a in eksik_istem:
        print("UYARI: assets/art'ta istemi olmayan dosya: %s" % a, file=sys.stderr)
    for a in eksik_dosya:
        print("Bilgi: tabloda olup diskte olmayan hedef (tablo boyutu kullanilir): %s" % a,
              file=sys.stderr)


def rapor_yaz(ad, yol, d, ek=None):
    s = "%-38s %4dx%-4d %-4s palet_disi=%d yari_alfa=%d saydam=%.0f%% renkler=%s" % (
        ad, d["boyut"][0], d["boyut"][1], d["kip"], d["palet_disi"], d["yari_alfa"],
        d["saydam_oran"] * 100, ",".join(d["renkler"]))
    if ek:
        if "silinen_arka" in ek:
            s += " arka_silinen=%.0f%%" % (ek["silinen_arka"] * 100)
        if "uyari" in ek:
            s += "  UYARI: " + ek["uyari"]
    print(s)
    print("    -> %s" % os.path.relpath(yol, KOK))


def mod_kuru(hedefler):
    for h in hedefler:
        print("=" * 78)
        print("%s  %dx%d  oran=%s  %s  cerceve=%s/%s  palet=%d renk"
              % (h.ad, h.boyut[0], h.boyut[1], h.oran, "saydam" if h.saydam else "opak",
                 h.cerceve, h.capa, len(h.palet)))
        print("-> %s" % os.path.relpath(h.yol, KOK))
        print(h.istem)
    print("=" * 78)
    print("%d hedef. Ag istegi yapilmadi (--kuru)." % len(hedefler))
    return 0


def mod_api(hedefler, a):
    anahtar = anahtar_oku(a.anahtar)
    hatali = []
    for i, h in enumerate(hedefler, 1):
        print("[%d/%d] %s (%s)" % (i, len(hedefler), h.ad, h.oran))
        try:
            ham = gorsel_iste(h.istem, h.oran, anahtar, a.model)
        except KotaHatasi as e:
            print("\nHATA: " + str(e), file=sys.stderr)
            return 3
        except ApiHatasi as e:
            print("  HATA: %s" % e, file=sys.stderr)
            hatali.append(h.ad)
            continue
        kaynak = Image.open(io.BytesIO(ham))
        kaynak.load()
        os.makedirs(HAM, exist_ok=True)
        kaynak.save(os.path.join(HAM, h.ad + "_raw_01.png"))  # art bible 8.2: ham cikti eki
        sonuc, ek = son_isle(kaynak, h, a.tolerans, a.tasma)
        yol = kaydet(sonuc, h, a.cikti or SANAT, a.yedek)
        rapor_yaz(h.ad, yol, denetle(sonuc, h.palet), ek)
        if i < len(hedefler):
            time.sleep(a.ara)
    if hatali:
        print("Uretilemeyen: %s" % ", ".join(hatali), file=sys.stderr)
        return 1
    return 0


UZANTILAR = (".png", ".jpg", ".jpeg", ".webp")


def mod_el_ile(klasor, hedefler, a):
    if not os.path.isdir(klasor):
        print("HATA: klasor yok: %s" % klasor, file=sys.stderr)
        return 2
    istenen = {h.ad: h for h in hedefler}
    bulunan, eslesmeyen = {}, []
    for d in sorted(os.listdir(klasor)):
        kok, uz = os.path.splitext(d)
        if uz.lower() not in UZANTILAR:
            continue
        if kok in HEDEFLER:
            if kok in istenen:
                if kok in bulunan:
                    print("UYARI: %s icin birden fazla dosya; %s kullaniliyor"
                          % (kok, bulunan[kok]), file=sys.stderr)
                    continue
                bulunan[kok] = d
        else:
            eslesmeyen.append(d)
    for kok, d in sorted(bulunan.items()):
        h = istenen[kok]
        kaynak = Image.open(os.path.join(klasor, d))
        kaynak.load()
        sonuc, ek = son_isle(kaynak, h, a.tolerans, a.tasma)
        yol = kaydet(sonuc, h, a.cikti or SANAT, a.yedek)
        rapor_yaz(h.ad, yol, denetle(sonuc, h.palet), ek)
    eksik = sorted(set(istenen) - set(bulunan))
    print("\n%d islendi, %d eksik, %d eslesmeyen." % (len(bulunan), len(eksik), len(eslesmeyen)))
    for d in eslesmeyen:
        print("  ESLESMEYEN (hedef adi degil, atlandi): %s" % d)
    for k in eksik:
        print("  EKSIK (klasorde yok): %s" % k)
    return 0


def mod_sinama(gorsel, ad, a):
    if ad not in HEDEFLER:
        print("HATA: bilinmeyen hedef: %s" % ad, file=sys.stderr)
        return 2
    h = Hedef(ad)
    kaynak = Image.open(gorsel)
    kaynak.load()
    sonuc, ek = son_isle(kaynak, h, a.tolerans, a.tasma)
    yol = os.path.join(a.cikti or SINAMA, ad + ".png")
    os.makedirs(os.path.dirname(yol), exist_ok=True)
    sonuc.save(yol, optimize=True)
    d = denetle(sonuc, h.palet)
    rapor_yaz(ad, yol, d, ek)
    tamam = d["boyut"] == h.boyut and d["palet_disi"] == 0 and d["yari_alfa"] == 0
    print("SINAMA %s" % ("GECTI" if tamam else "KALDI"))
    return 0 if tamam else 1


MD_BASLIK = """# El ile üretim istemleri (Gemini uygulaması)

Bu dosya `tools/art/gemini_uret.py --istemler-md` ile **üretilir**; elle düzenlemeyin,
istemleri betikteki tablodan değiştirip yeniden üretin.

Gemini Pro aboneliği API kotası vermez; görselleri uygulamada el ile üretirsiniz:

1. https://gemini.google.com adresini açın (görsel üretimi açık bir model seçin).
2. Aşağıdan bir bölümün istemini kod bloğundan **olduğu gibi** kopyalayıp yapıştırın.
   Uygulama en-boy seçimi sunuyorsa bölümde yazan oranı seçin.
3. Çıkan görseli indirin (PNG, JPG ya da WEBP olabilir).
4. Dosyayı bölümde yazan **dosya adıyla** yeniden adlandırın (uzantı serbest)
   ve `tools/art/gelen/` klasörüne koyun.
5. Hepsi (ya da bir kısmı) hazır olunca depo kökünden çalıştırın:
   `python3 tools/art/gemini_uret.py --el-ile --yedek`
   Betik macenta arka planı siler, tam boyuta kırpar, palete oturtur ve sonucu
   `assets/art/` altına yazar. Eksik ve eşleşmeyen dosyaları raporlar.

Macenta (#FF00FF) arka plan istenen görsellerde arka plan **düz** ve **tek renk**
olmalı; gölge ya da zemin çizgisi varsa görseli yeniden üretin.
"""


def mod_istemler_md(hedefler):
    satirlar = [MD_BASLIK]
    for h in hedefler:
        satirlar.append("\n## %s\n" % h.ad)
        satirlar.append("- Kaydedilecek ad: `tools/art/gelen/%s.png` (`.jpg`/`.webp` da olur)" % h.ad)
        satirlar.append("- Hedef: `assets/art/%s/%s.png`, %d x %d piksel"
                        % (h.alt, h.ad, h.boyut[0], h.boyut[1]))
        satirlar.append("- İstenecek oran: **%s**" % h.oran)
        satirlar.append("- Arka plan: %s\n" % ("düz macenta #FF00FF (betik siler)" if h.saydam
                                               else "opak sahne (silinmez)"))
        satirlar.append("```text\n%s\n```" % h.istem)
    with open(ISTEMLER_MD, "w", encoding="utf-8") as f:
        f.write("\n".join(satirlar) + "\n")
    print("Yazildi: %s (%d hedef)" % (os.path.relpath(ISTEMLER_MD, KOK), len(hedefler)))
    return 0


def main(argv=None):
    p = argparse.ArgumentParser(description="assets/art yer tutucularini Gemini sanatiyla degistir.")
    p.add_argument("--anahtar", metavar="DOSYA", help="API anahtari dosyasi (yoksa GEMINI_API_KEY)")
    p.add_argument("--model", default=VARSAYILAN_MODEL)
    p.add_argument("--sadece", metavar="DESEN", help="ad deseni, virgulle coklu (or. 'char_*_card')")
    p.add_argument("--kuru", action="store_true", help="istem ve boyutlari yaz, ag yok")
    p.add_argument("--yedek", action="store_true",
                   help="eski dosyayi tools/art/yedek/AD.yer_tutucu.png olarak sakla")
    p.add_argument("--sinama", nargs=2, metavar=("GORSEL", "HEDEF"),
                   help="agsiz son isleme sinamasi; cikti tools/art/sinama/")
    p.add_argument("--el-ile", nargs="?", const=GELEN, metavar="KLASOR",
                   help="Gemini uygulamasindan indirilen gorselleri isle (varsayilan tools/art/gelen/)")
    p.add_argument("--istemler-md", action="store_true", help="tools/art/istemler.md yaz")
    p.add_argument("--cikti", metavar="KLASOR", help="assets/art yerine buraya yaz (sinama icin)")
    p.add_argument("--tolerans", type=int, default=80, help="macenta kutu toleransi (0-255)")
    p.add_argument("--tasma", type=int, default=50, help="macenta tasma esigi: min(R,B)-G")
    p.add_argument("--ara", type=float, default=2.0, help="istekler arasi bekleme (sn)")
    a = p.parse_args(argv)

    if a.sinama:
        return mod_sinama(a.sinama[0], a.sinama[1], a)
    kapsama_denetle()
    hedefler = secili_hedefler(a.sadece)
    if not hedefler:
        print("HATA: desene uyan hedef yok: %s" % a.sadece, file=sys.stderr)
        return 2
    if a.istemler_md:
        return mod_istemler_md(hedefler)
    if a.kuru:
        return mod_kuru(hedefler)
    if a.el_ile:
        return mod_el_ile(a.el_ile, hedefler, a)
    try:
        return mod_api(hedefler, a)
    except ApiHatasi as e:
        print("HATA: %s" % e, file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
