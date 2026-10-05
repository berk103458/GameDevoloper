#!/usr/bin/env python3
"""Poly Haven (CC0) varlıklarını indirir: taranmış PBR dokular, HDRI gökyüzü ve glTF modeller.

Hepsi CC0 (kamu malı): atıf zorunlu değil; yine de assets/ph/KAYNAK.md'ye kaynak yazılır.
Kullanım:
    python3 tools/varlik/polyhaven_indir.py            # listedekilerin hepsi (var olanı atlar)
    python3 tools/varlik/polyhaven_indir.py castle_wall_varriation
Çıktı: assets/ph/doku/<id>/<id>_{diff,nor_gl,rough}_<çöz>.jpg · assets/ph/gok/<id>_<çöz>.hdr · assets/ph/model/<id>/
"""
import json
import os
import sys
import urllib.request

KOK = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
CIKTI = os.path.join(KOK, "assets", "ph")
API = "https://api.polyhaven.com"
# Poly Haven varsayılan Python kimliğini reddeder (403); proje adıyla kimlik verilir.
BASLIK = {"User-Agent": "GameDevoloper-asset-fetch/1.0"}

# (id, tür, çözünürlük): kameraya en yakın yüzeyler 4K, gerisi 2K.
VARLIKLAR = [
    ("muddy_tracks", "doku", "2k"),             # yol: tekerlek izli çamur
    ("brown_mud_rocks_01", "doku", "2k"),       # arazi
    ("snow_02", "doku", "2k"),                  # kırağı lekeleri
    ("castle_wall_varriation", "doku", "4k"),   # taş sur (kamera dibinde)
    ("medieval_wood", "doku", "4k"),            # kapı direkleri ve kalaslar (kamera dibinde)
    ("bark_willow", "doku", "2k"),              # kütük direkler (sur 0)
    ("satara_night_no_lamps", "gok", "4k"),     # yıldızlı gece gökyüzü
    ("large_castle_door", "model", "2k"),       # kapı kanatları (sur 1+)
    ("dead_tree_trunk_02", "model", "2k"),      # kuru ağaç
    ("wooden_barrels_01", "model", "1k"),
    ("wooden_crate_01", "model", "1k"),
    ("boulder_01", "model", "1k"),
    ("rock_moss_set_01", "model", "1k"),
    ("dry_branches_medium_01", "model", "1k"),
]
HARITALAR = {"Diffuse": "diff", "nor_gl": "nor_gl", "Rough": "rough"}


def json_al(yol):
    with urllib.request.urlopen(urllib.request.Request(API + yol, headers=BASLIK), timeout=60) as r:
        return json.load(r)


def indir(url, hedef):
    if os.path.exists(hedef):
        return False
    os.makedirs(os.path.dirname(hedef), exist_ok=True)
    with urllib.request.urlopen(urllib.request.Request(url, headers=BASLIK), timeout=600) as r, \
            open(hedef + ".part", "wb") as f:
        while True:
            parca = r.read(1 << 20)
            if not parca:
                break
            f.write(parca)
    os.replace(hedef + ".part", hedef)
    return True


def main(secilen):
    kaynak = []
    for kimlik, tur, coz in VARLIKLAR:
        if secilen and kimlik not in secilen:
            continue
        dosyalar = json_al("/files/" + kimlik)
        if tur == "doku":
            for anahtar, ek in HARITALAR.items():
                url = dosyalar[anahtar][coz]["jpg"]["url"]
                indir(url, os.path.join(CIKTI, "doku", kimlik, "%s_%s_%s.jpg" % (kimlik, ek, coz)))
        elif tur == "gok":
            indir(dosyalar["hdri"][coz]["hdr"]["url"], os.path.join(CIKTI, "gok", "%s_%s.hdr" % (kimlik, coz)))
        else:
            g = dosyalar["gltf"][coz]["gltf"]
            klasor = os.path.join(CIKTI, "model", kimlik)
            indir(g["url"], os.path.join(klasor, kimlik + ".gltf"))
            for ad, bilgi in g["include"].items():
                indir(bilgi["url"], os.path.join(klasor, ad))
        kaynak.append("- `%s` (%s, %s) — https://polyhaven.com/a/%s" % (kimlik, tur, coz, kimlik))
        print("tamam:", kimlik, flush=True)
    if not secilen:
        with open(os.path.join(CIKTI, "KAYNAK.md"), "w", encoding="utf-8") as f:
            f.write("# Poly Haven varlıkları\n\nHepsi CC0 (kamu malı). İndirici: `tools/varlik/polyhaven_indir.py`.\n\n")
            f.write("\n".join(kaynak) + "\n")


if __name__ == "__main__":
    main(set(sys.argv[1:]))
