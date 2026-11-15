"""Bağımlılıksız GLB / glTF muayenesi: üçgen sayısı, sınır kutusu (metre), iskelet, animasyon, doku.

Gözlem verir, hüküm vermez: `dogrula()` yalnız hedefle karşılaştırma satırları döndürür; kararı kullanan verir.
Sınır kutusu, POSITION erişimcisinin min/max değerleri düğüm dönüşümleriyle sahneye taşınarak hesaplanır
(deri/iskelet pozları hesaba katılmaz; A-poz karakterde boy için yeterli yaklaşıklıktır).

Kullanım:
    python3 tools/meshy/glb_bilgi.py assets/model/nesne/kuyu.glb [...]
"""
import json
import math
import os
import struct
import sys


def _glb_json(yol):
    with open(yol, "rb") as f:
        bas = f.read(12)
        if len(bas) < 12 or bas[:4] != b"glTF":
            raise ValueError("GLB imzası yok")
        surum = struct.unpack("<I", bas[4:8])[0]
        if surum != 2:
            raise ValueError("glTF sürümü 2 değil: %d" % surum)
        uzunluk, tur = struct.unpack("<I4s", f.read(8))
        if tur != b"JSON":
            raise ValueError("ilk parça JSON değil")
        return json.loads(f.read(uzunluk))


def _gltf_json(yol):
    with open(yol, encoding="utf-8") as f:
        return json.load(f)


def _carp(a, b):
    return [sum(a[r + 4 * k] * b[k + 4 * c] for k in range(4)) for c in range(4) for r in range(4)]


def _yerel_matris(dugum):
    if "matrix" in dugum:
        return list(dugum["matrix"])
    tx, ty, tz = dugum.get("translation", [0, 0, 0])
    x, y, z, w = dugum.get("rotation", [0, 0, 0, 1])
    sx, sy, sz = dugum.get("scale", [1, 1, 1])
    r = [1 - 2 * (y * y + z * z), 2 * (x * y + z * w), 2 * (x * z - y * w),
         2 * (x * y - z * w), 1 - 2 * (x * x + z * z), 2 * (y * z + x * w),
         2 * (x * z + y * w), 2 * (y * z - x * w), 1 - 2 * (x * x + y * y)]
    return [r[0] * sx, r[1] * sx, r[2] * sx, 0,
            r[3] * sy, r[4] * sy, r[5] * sy, 0,
            r[6] * sz, r[7] * sz, r[8] * sz, 0,
            tx, ty, tz, 1]


def _uygula(m, p):
    return [m[0] * p[0] + m[4] * p[1] + m[8] * p[2] + m[12],
            m[1] * p[0] + m[5] * p[1] + m[9] * p[2] + m[13],
            m[2] * p[0] + m[6] * p[1] + m[10] * p[2] + m[14]]


def incele(yol):
    """Dosyayı okur; hata varsa {'gecerli': False, 'hata': ...} döner."""
    sonuc = {"dosya": yol, "bayt": os.path.getsize(yol) if os.path.exists(yol) else 0}
    try:
        g = _glb_json(yol) if yol.lower().endswith(".glb") else _gltf_json(yol)
    except (OSError, ValueError, json.JSONDecodeError) as e:
        sonuc.update(gecerli=False, hata=str(e))
        return sonuc
    erisim = g.get("accessors", [])
    meshler = g.get("meshes", [])
    ucgen = 0
    for mesh in meshler:
        for p in mesh.get("primitives", []):
            if p.get("mode", 4) != 4:
                continue
            if "indices" in p:
                ucgen += erisim[p["indices"]]["count"] // 3
            elif "POSITION" in p.get("attributes", {}):
                ucgen += erisim[p["attributes"]["POSITION"]]["count"] // 3
    dugumler = g.get("nodes", [])
    en_kucuk = [math.inf] * 3
    en_buyuk = [-math.inf] * 3

    def gez(i, ust):
        d = dugumler[i]
        m = _carp(ust, _yerel_matris(d))
        if "mesh" in d:
            # glTF: deri bağlı mesh düğümünün dönüşümü yok sayılır; köşeler bağlama (rest) uzayındadır.
            mm = birim if "skin" in d else m
            for p in meshler[d["mesh"]].get("primitives", []):
                a = p.get("attributes", {}).get("POSITION")
                if a is None or "min" not in erisim[a]:
                    continue
                mn, mx = erisim[a]["min"], erisim[a]["max"]
                for kx in (mn[0], mx[0]):
                    for ky in (mn[1], mx[1]):
                        for kz in (mn[2], mx[2]):
                            q = _uygula(mm, [kx, ky, kz])
                            for e in range(3):
                                en_kucuk[e] = min(en_kucuk[e], q[e])
                                en_buyuk[e] = max(en_buyuk[e], q[e])
        for c in d.get("children", []):
            gez(c, m)

    birim = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    sahneler = g.get("scenes", [])
    kokler = sahneler[g.get("scene", 0)].get("nodes", []) if sahneler else range(len(dugumler))
    for k in kokler:
        gez(k, birim)
    if en_kucuk[0] is math.inf:
        boyut, taban_y = [0.0, 0.0, 0.0], 0.0
    else:
        boyut = [round(en_buyuk[e] - en_kucuk[e], 3) for e in range(3)]
        taban_y = round(en_kucuk[1], 3)
    sonuc.update(
        gecerli=True,
        ucgen=ucgen,
        mesh=len(meshler),
        boyut_m=boyut,
        taban_y=taban_y,
        iskelet=len(g.get("skins", [])),
        kemik=sum(len(s.get("joints", [])) for s in g.get("skins", [])),
        animasyon=[a.get("name", "") for a in g.get("animations", [])],
        malzeme=len(g.get("materials", [])),
        doku=len(g.get("images", [])),
        uretici=g.get("asset", {}).get("generator", ""),
    )
    return sonuc


def dogrula(bilgi, hedef):
    """Hedefle karşılaştırma gözlemleri: [(alan, durum 'tamam'|'uyari', açıklama)]."""
    satirlar = []
    if not bilgi.get("gecerli"):
        return [("dosya", "uyari", "geçersiz GLB: %s" % bilgi.get("hata"))]
    poly = hedef.get("poly_hedef")
    if poly:
        oran = bilgi["ucgen"] / float(poly)
        satirlar.append(("ucgen", "tamam" if oran <= 1.15 else "uyari",
                         "%d üçgen, hedef %d (oran %.2f)" % (bilgi["ucgen"], poly, oran)))
    boy = hedef.get("boy_m")
    if boy:
        y = bilgi["boyut_m"][1]
        sapma = abs(y - boy) / boy
        satirlar.append(("boy", "tamam" if sapma <= 0.10 else "uyari",
                         "yükseklik %.2f m, hedef %.2f m (sapma %%%d)" % (y, boy, round(sapma * 100))))
    satirlar.append(("taban", "tamam" if abs(bilgi["taban_y"]) <= 0.05 else "uyari",
                     "en alt nokta y=%.3f (pivot ayak tabanında olmalı)" % bilgi["taban_y"]))
    if hedef.get("iskelet"):
        satirlar.append(("iskelet", "tamam" if bilgi["iskelet"] else "uyari", "%d deri, %d kemik" % (bilgi["iskelet"], bilgi["kemik"])))
    if hedef.get("doku"):
        satirlar.append(("doku", "tamam" if bilgi["doku"] else "uyari", "%d gömülü görsel" % bilgi["doku"]))
    return satirlar


if __name__ == "__main__":
    for y in sys.argv[1:]:
        print(json.dumps(incele(y), ensure_ascii=False))
