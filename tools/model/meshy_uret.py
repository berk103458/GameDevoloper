#!/usr/bin/env python3
"""Meshy AI 3D model hattı — oyunun tüm 3D modellerini üretir ve `assets/model/` altına indirir.

Kredi tasarrufu için:
- Tüm modeller `meshy-6-lite` ile üretilir (önizleme 5 kredi).
- Doku (refine, 10 kredi) yalnız karakterlerde ve `doku=True` olan yapılarda yapılır;
  diğer nesneler dokusuz gelir ve oyunda düz palet renkleriyle boyanır.
- İskelet (rig, 5 kredi) yalnız karakterlerde; yürüme ve koşma animasyonu bunun içinde gelir.
- Her adımın görev kimliği `tools/model/durum.json`a yazılır; betik yeniden çalışınca biten
  adımları atlar (kredi iki kez harcanmaz).

Kullanım:
    MESHY_API_KEY=... python3 tools/model/meshy_uret.py --kuru            # yalnız plan ve kredi tahmini
    MESHY_API_KEY=... python3 tools/model/meshy_uret.py --sadece asker    # tek model
    MESHY_API_KEY=... python3 tools/model/meshy_uret.py --butce 400       # hepsi, en çok 400 kredi
Anahtar `--anahtar DOSYA` ile de verilebilir. Anahtar asla repoya yazılmaz.
"""
import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request

KOK = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
CIKTI = os.path.join(KOK, "assets", "model")
DURUM = os.path.join(os.path.dirname(__file__), "durum.json")
API = "https://api.meshy.ai/openapi"
MODEL = "meshy-6-lite"
FIYAT = {"onizleme": 5, "doku": 10, "iskelet": 5}

STIL = ("Stylized low-poly game asset for a 13th-century Anatolian frontier setting (year 1243, Seljuk borderland). "
        "Simple clean shapes, readable silhouette, hand-made rustic materials, muted colours. No text, no modern items. ")
KARAKTER = ("Full body single character standing in A-pose, arms slightly away from body, feet apart, facing forward. "
            "Tired, humble refugee look. Period clothing: wool hood or felt cap, linen tunic, wrapped wool kaftan with sash, "
            "leather belt, loose trousers, leg wraps, simple leather shoes. No armour plates, no helmets with horns. ")

# ad: (tür, istem, doku, iskelet, yükseklik_m, poligon)
VARLIKLAR = {
    # Karakterler (doku + iskelet)
    "asker": ("karakter", KARAKTER + "A weary Seljuk frontier soldier with a quilted padded kaftan, a short spear held upright and a round wooden shield on his back.", True, True, 1.75, 8000),
    "esnaf": ("karakter", KARAKTER + "A craftsman refugee carrying a large cloth bundle on his back and a small hammer at his belt, felt cap.", True, True, 1.7, 8000),
    "ciftci": ("karakter", KARAKTER + "A thin peasant farmer with a sickle tucked in his sash and a grain sack on one shoulder, wool hood.", True, True, 1.7, 8000),
    "ciftci_kadin": ("karakter", KARAKTER + "A peasant woman in a long dress and a large headscarf tied under the chin, carrying a small bundle.", True, True, 1.6, 8000),
    "miraen": ("karakter", KARAKTER + "Miraen, a Georgian ex-cavalryman on foot: long-tailed felt cap with the tail falling behind his head, a curved sword scabbard that is broken, riding boots.", True, True, 1.8, 8000),
    "sorhan": ("karakter", KARAKTER + "Sorhan, a Kipchak horse trader: fur-trimmed steppe cap, coiled horse halter rope looped over one shoulder, a bundle on his back.", True, True, 1.75, 8000),
    "thessra": ("karakter", KARAKTER + "Thessra, a young Greek woman from Trebizond, healer's daughter: long headscarf with a long tail flowing back, holding a small wooden medicine box.", True, True, 1.62, 8000),
    "karaca_usta": ("karakter", KARAKTER + "Karaca Usta, a middle-aged Ahi tanner master: a rolled leather hide on his back, a wide cloth sash (shed) tied with a big knot at the waist with ends hanging.", True, True, 1.72, 8000),
    "aydogdu": ("karakter", KARAKTER + "Aydogdu, a young Turkmen archer: felt cloak over one shoulder, one forearm bandaged, a recurve bow and quiver on his back.", True, True, 1.75, 8000),
    "saruca_hatun": ("karakter", KARAKTER + "Saruca Hatun, a widowed farm woman: large triangular headscarf tied under the chin, a grain sack held low in front.", True, True, 1.6, 8000),
    "ayse_baci": ("karakter", KARAKTER + "Ayse Baci, a middle-aged weaver woman of the Anatolian sisterhood: headscarf, apron, a folded small wooden loom frame carried on her back.", True, True, 1.6, 8000),
    "hasan_celebi": ("karakter", KARAKTER + "Hasan Celebi, a scribe and tax clerk: well-sewn long kaftan, small turban wrap, ink-stained fingers, a saddlebag full of ledgers over his shoulder.", True, True, 1.72, 8000),
    "nogay": ("karakter", KARAKTER + "Nogay, a steppe interpreter who fled the Mongols: tall pointed steppe felt hat, long belted coat, quiet stance.", True, True, 1.75, 8000),
    "yusuf": ("karakter", KARAKTER + "Yusuf, a thin twelve-year-old shepherd boy holding an empty goat rope, simple tunic and wool cap.", True, True, 1.35, 6000),
    # Yapılar (doku: büyük, sahnede ön planda olanlar)
    "kapi": ("yapi", "A heavy double wooden fortress gate set in a short section of rough stone wall with a wooden lintel beam, iron-free wooden bolts, frontier palisade style, front view.", True, False, 0, 6000),
    "kervansaray": ("yapi", "A small rustic Seljuk caravanserai: low rectangular rough stone walls, a single arched stone portal with a wooden door, flat roof, courtyard hidden.", True, False, 0, 8000),
    "pazar_tezgahi": ("yapi", "A rustic market stall: four wooden posts, a sagging cloth awning, a wooden counter with a few clay jars and baskets.", True, False, 0, 4000),
    "ev": ("yapi", "A small rustic village hut: rough stone base, mud-brick walls, flat timber and earth roof, a low wooden door.", True, False, 0, 4000),
    "cadir": ("yapi", "A Turkmen nomad felt yurt tent, round, simple wooden door, felt covering tied with ropes.", True, False, 0, 3000),
    # Nesneler (dokusuz; oyunda düz renk)
    "mesale": ("nesne", "A simple wooden torch on a tall pole stuck in the ground, the head wrapped in cloth, no flame.", False, False, 0, 800),
    "kazik_cit": ("nesne", "A short straight section of a wooden palisade wall: sharpened vertical logs tied together, about five logs.", False, False, 0, 1500),
    "kuyu": ("nesne", "A rustic stone village well with a wooden crank frame and a bucket.", False, False, 0, 2000),
    "araba": ("nesne", "A simple two-wheeled wooden ox cart (kagni) with solid wooden wheels.", False, False, 0, 2500),
    "cuval_yigini": ("nesne", "A small pile of grain sacks and two clay storage jars.", False, False, 0, 1500),
    "agac": ("nesne", "A bare gnarled old walnut tree, low poly, few branches.", False, False, 0, 2000),
    "kaya": ("nesne", "A cluster of three rough grey rocks.", False, False, 0, 600),
}


def anahtar_al(dosya):
    if os.environ.get("MESHY_API_KEY"):
        return os.environ["MESHY_API_KEY"].strip()
    if dosya and os.path.exists(dosya):
        return open(dosya).read().strip()
    sys.exit("MESHY_API_KEY ortam değişkeni ya da --anahtar DOSYA gerekli.")


def istek(anahtar, yontem, yol, govde=None):
    veri = json.dumps(govde).encode() if govde is not None else None
    for deneme in range(6):
        req = urllib.request.Request(API + yol, data=veri, method=yontem, headers={
            "Authorization": "Bearer " + anahtar, "Content-Type": "application/json"})
        try:
            return json.load(urllib.request.urlopen(req, timeout=120))
        except urllib.error.HTTPError as e:
            govde_m = e.read()[:300]
            if e.code == 402:
                sys.exit("Meshy: kredi yetersiz (402). Abonelik ayarlarından kredi ekleyin.")
            if e.code in (429, 500, 502, 503) and deneme < 5:
                time.sleep(5 * (deneme + 1))
                continue
            raise RuntimeError("HTTP %d %s %s: %r" % (e.code, yontem, yol, govde_m))
        except urllib.error.URLError:
            if deneme < 5:
                time.sleep(5)
                continue
            raise


def bekle(anahtar, yol):
    while True:
        g = istek(anahtar, "GET", yol)
        d = g.get("status")
        if d == "SUCCEEDED":
            return g
        if d in ("FAILED", "CANCELED", "EXPIRED"):
            raise RuntimeError("%s başarısız: %s" % (yol, g.get("task_error")))
        time.sleep(8)


def indir(url, hedef):
    os.makedirs(os.path.dirname(hedef), exist_ok=True)
    with urllib.request.urlopen(url, timeout=300) as r, open(hedef, "wb") as f:
        f.write(r.read())


def maliyet(ad):
    tur, _, doku, iskelet, _, _ = VARLIKLAR[ad]
    return FIYAT["onizleme"] + (FIYAT["doku"] if doku else 0) + (FIYAT["iskelet"] if iskelet else 0)


def uret(anahtar, ad, durum):
    tur, istem, doku, iskelet, boy, poli = VARLIKLAR[ad]
    d = durum.setdefault(ad, {})
    if "onizleme" not in d:
        govde = {"mode": "preview", "prompt": (STIL + istem)[:800], "ai_model": MODEL,
                 "should_remesh": True, "topology": "triangle", "target_polycount": poli, "target_formats": ["glb"]}
        if tur == "karakter":
            govde["pose_mode"] = "a-pose"
        d["onizleme"] = istek(anahtar, "POST", "/v2/text-to-3d", govde)["result"]
        kaydet(durum)
    g = bekle(anahtar, "/v2/text-to-3d/" + d["onizleme"])
    son = g
    if doku:
        if "doku" not in d:
            d["doku"] = istek(anahtar, "POST", "/v2/text-to-3d", {
                "mode": "refine", "preview_task_id": d["onizleme"], "enable_pbr": False,
                "target_formats": ["glb"]})["result"]
            kaydet(durum)
        son = bekle(anahtar, "/v2/text-to-3d/" + d["doku"])
    indir(son["model_urls"]["glb"], os.path.join(CIKTI, tur, ad + ".glb"))
    if iskelet:
        if "iskelet" not in d:
            d["iskelet"] = istek(anahtar, "POST", "/v1/rigging", {
                "input_task_id": d.get("doku", d["onizleme"]), "height_meters": boy})["result"]
            kaydet(durum)
        r = bekle(anahtar, "/v1/rigging/" + d["iskelet"])["result"]
        indir(r["rigged_character_glb_url"], os.path.join(CIKTI, tur, ad + "_iskelet.glb"))
        indir(r["basic_animations"]["walking_glb_url"], os.path.join(CIKTI, tur, ad + "_yuru.glb"))
    d["bitti"] = True
    kaydet(durum)


def kaydet(durum):
    with open(DURUM, "w") as f:
        json.dump(durum, f, indent=1, ensure_ascii=False)


def main():
    a = argparse.ArgumentParser()
    a.add_argument("--anahtar")
    a.add_argument("--sadece", nargs="*")
    a.add_argument("--butce", type=int, default=10**9, help="bu çalıştırmada harcanacak en çok kredi")
    a.add_argument("--kuru", action="store_true")
    o = a.parse_args()
    durum = json.load(open(DURUM)) if os.path.exists(DURUM) else {}
    adlar = o.sadece or list(VARLIKLAR)
    bekleyen = [x for x in adlar if not durum.get(x, {}).get("bitti")]
    toplam = sum(maliyet(x) for x in bekleyen)
    print("Bekleyen %d model, tahmini %d kredi" % (len(bekleyen), toplam))
    for x in bekleyen:
        print("  %-14s %3d kredi" % (x, maliyet(x)))
    if o.kuru:
        return
    anahtar = anahtar_al(o.anahtar)
    bakiye = istek(anahtar, "GET", "/v1/balance")["balance"]
    print("Bakiye:", bakiye)
    harcanan = 0
    for x in bekleyen:
        m = maliyet(x)
        if harcanan + m > o.butce:
            print("Bütçe doldu; %s atlandı." % x)
            continue
        print("Üretiliyor:", x, flush=True)
        try:
            uret(anahtar, x, durum)
            harcanan += m
            print("  bitti:", x, flush=True)
        except RuntimeError as e:
            print("  HATA:", x, e, flush=True)
    print("Son bakiye:", istek(anahtar, "GET", "/v1/balance")["balance"])


if __name__ == "__main__":
    main()
