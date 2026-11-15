"""Topluluk GLB'lerini rapordaki üçgen hedefine indirir ve dokuları 1024 JPEG ile sınırlar.

Blender 4.x başsız çalışır. Dosyayı aynı yola yazar. 50.000 üçgenin altındaki geometriye dokunulmaz.
Hedef, docs/meshy/TOPLULUK_INCELEME.md A tablosundaki aralığın üst ucudur; hiçbiri 60.000 üçgeni geçmez.
İskelet, skin ağırlığı veya klip bozulursa dosya eski hâline döner ve satır atlanır.

    python3 tools/varlik/meshy_incelt.py
    BLENDER=/yol/blender python3 tools/varlik/meshy_incelt.py --yalniz assets/meshy/dogrudan/a211_orak.glb
"""
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile

KOK = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RAPOR = os.path.join(KOK, "docs", "meshy", "TOPLULUK_INCELEME.md")
MESHY = os.path.join(KOK, "assets", "meshy")
TAVAN = 60000
ALT_SINIR = 50000
SONUC = os.environ.get("MESHY_INCELT_SONUC", "/tmp/meshy_incelt_sonuc.json")


def hedef_oku(hucre):
    """'12–25 bin' → 25000. Aralık yoksa None."""
    m = re.search(r"(\d+)\s*[–\-]\s*(\d+)", hucre or "")
    if not m:
        return None
    return min(int(m.group(2)) * 1000, TAVAN)


def sayi_oku(hucre):
    temiz = (hucre or "").replace(".", "").replace("\u00a0", "").strip()
    return int(temiz) if temiz.isdigit() else None


def tablo_oku():
    """Bayt boyutu → rapor satırı. A tablosu dosya adıyla değil boyutla eşlenir."""
    satirlar = {}
    icinde = False
    with open(RAPOR, encoding="utf-8") as f:
        for satir in f:
            if satir.startswith("## A."):
                icinde = True
                continue
            if icinde and satir.startswith("## "):
                break
            if not icinde or not satir.startswith("| `"):
                continue
            hucre = [x.strip() for x in satir.strip().strip("|").split("|")]
            if len(hucre) < 11:
                continue
            boyut = sayi_oku(hucre[1])
            if not boyut:
                continue
            doku = hucre[7]
            satirlar[boyut] = {
                "dosya_adi": hucre[0].strip("`"),
                "ucgen": sayi_oku(hucre[5]),
                "hedef": hedef_oku(hucre[10]),
                "buyuk_doku": any(x in doku for x in ("2048", "4096", "8192")),
                "iskelet": "Yok" not in hucre[8],
            }
    return satirlar


def glb_ozet(yol):
    with open(yol, "rb") as f:
        bas = f.read(12)
        if len(bas) < 12 or bas[:4] != b"glTF":
            return None
        uzunluk, tur = struct.unpack("<I4s", f.read(8))
        if tur != b"JSON":
            return None
        gltf = json.loads(f.read(uzunluk))
    erisim = gltf.get("accessors", [])
    tris = 0
    skin = False
    for mesh in gltf.get("meshes", []):
        for p in mesh.get("primitives", []):
            if p.get("mode", 4) != 4:
                continue
            if "indices" in p:
                tris += erisim[p["indices"]]["count"] // 3
            elif "POSITION" in p.get("attributes", {}):
                tris += erisim[p["attributes"]["POSITION"]]["count"] // 3
            if "JOINTS_0" in p.get("attributes", {}):
                skin = True
    return {
        "ucgen": tris,
        "skin": skin or bool(gltf.get("skins")),
        "anim": len(gltf.get("animations", [])),
        "iskelet": len(gltf.get("skins", [])),
    }


def blender_isle():
    import bpy

    argv = sys.argv[sys.argv.index("--") + 1:]
    girdi, cikti = argv[0], argv[1]
    hedef = int(argv[2])
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=girdi)
    meshler = [o for o in bpy.context.scene.objects if o.type == "MESH"]
    iskelet = any(o.type == "ARMATURE" for o in bpy.context.scene.objects)
    anim_once = len(bpy.data.actions)

    def ucgen():
        n = 0
        for o in meshler:
            if o.type != "MESH" or o.data is None:
                continue
            o.data.calc_loop_triangles()
            n += len(o.data.loop_triangles)
        return n

    once = ucgen()
    if hedef and once > ALT_SINIR and once > hedef:
        oran = hedef / float(once)
        for m in meshler:
            bpy.ops.object.select_all(action="DESELECT")
            m.select_set(True)
            bpy.context.view_layer.objects.active = m
            mod = m.modifiers.new("incelt", "DECIMATE")
            mod.decimate_type = "COLLAPSE"
            mod.ratio = max(oran, 1e-6)
            mod.use_collapse_triangulate = True
            while m.modifiers[0].name != "incelt":
                bpy.ops.object.modifier_move_up(modifier="incelt")
            bpy.ops.object.modifier_apply(modifier="incelt")
    doku = False
    for img in bpy.data.images:
        if img.size[0] < 2:
            continue
        w, h = img.size
        if max(w, h) <= 1024:
            continue
        carpan = 1024.0 / max(w, h)
        img.scale(max(1, int(w * carpan)), max(1, int(h * carpan)))
        doku = True
    sonra = ucgen()
    bpy.ops.export_scene.gltf(
        filepath=cikti,
        export_format="GLB",
        export_animations=True,
        export_skins=True,
        export_morph=True,
        export_image_format="JPEG" if doku else "AUTO",
        export_jpeg_quality=82,
        export_yup=True,
    )
    print("INCELT_JSON " + json.dumps({
        "once": once, "sonra": sonra, "iskelet": iskelet, "anim": anim_once, "doku": doku,
    }))


def calistir_blender(blender, girdi, hedef):
    fd, cikti = tempfile.mkstemp(suffix=".glb")
    os.close(fd)
    cmd = [blender, "-b", "--factory-startup", "-P", os.path.abspath(__file__), "--", girdi, cikti, str(hedef or 0)]
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=900)
    except subprocess.TimeoutExpired:
        os.unlink(cikti)
        return None, "zaman aşımı"
    satir = ""
    for line in (p.stdout or "").splitlines():
        if line.startswith("INCELT_JSON "):
            satir = line[len("INCELT_JSON "):]
    if p.returncode != 0 or not satir or not os.path.isfile(cikti) or os.path.getsize(cikti) < 32:
        kuyruk = (p.stderr or p.stdout or "")[-400:].replace("\n", " ")
        with contextlib_suppress(cikti):
            pass
        if os.path.isfile(cikti):
            os.unlink(cikti)
        return None, "blender çıkış %s %s" % (p.returncode, kuyruk)
    return (cikti, json.loads(satir)), ""


def contextlib_suppress(yol):
    return None


def kabul(once_ozet, sonra_yol, rapor):
    sonra = glb_ozet(sonra_yol)
    if sonra is None:
        return False, "çıktı GLB okunamadı"
    if sonra["ucgen"] <= 0:
        return False, "üçgen kalmadı"
    if rapor["hedef"] and once_ozet["ucgen"] > ALT_SINIR and sonra["ucgen"] > TAVAN:
        return False, "hâlâ %d üçgen" % sonra["ucgen"]
    if once_ozet["skin"] and (not sonra["skin"] or sonra["iskelet"] < once_ozet["iskelet"]):
        return False, "iskelet veya skin düştü"
    if once_ozet["anim"] and sonra["anim"] < once_ozet["anim"]:
        return False, "klip düştü (%d → %d)" % (once_ozet["anim"], sonra["anim"])
    return True, sonra


def isle(blender, yol, rapor):
    once_boyut = os.path.getsize(yol)
    once = glb_ozet(yol)
    if once is None:
        return {"dosya": yol, "durum": "atlandi", "not": "GLB okunamadı", "once_ucgen": None,
                "sonra_ucgen": None, "once_bayt": once_boyut, "sonra_bayt": once_boyut}
    hedef = rapor["hedef"] if once["ucgen"] > ALT_SINIR else None
    if hedef is None and not rapor["buyuk_doku"]:
        return {"dosya": os.path.relpath(yol, KOK), "durum": "dokunulmadi", "not": "50 bin altı, doku küçük",
                "once_ucgen": once["ucgen"], "sonra_ucgen": once["ucgen"],
                "once_bayt": once_boyut, "sonra_bayt": once_boyut}
    yedek = yol + ".ham-yedek"
    shutil.copy2(yol, yedek)
    paket, hata = calistir_blender(blender, yol, hedef or 0)
    if paket is None:
        os.unlink(yedek)
        return {"dosya": os.path.relpath(yol, KOK), "durum": "atlandi", "not": hata,
                "once_ucgen": once["ucgen"], "sonra_ucgen": once["ucgen"],
                "once_bayt": once_boyut, "sonra_bayt": once_boyut}
    cikti, _bilgi = paket
    tamam, sonuc = kabul(once, cikti, {"hedef": hedef})
    if not tamam:
        os.unlink(cikti)
        os.unlink(yedek)
        return {"dosya": os.path.relpath(yol, KOK), "durum": "atlandi", "not": sonuc,
                "once_ucgen": once["ucgen"], "sonra_ucgen": once["ucgen"],
                "once_bayt": once_boyut, "sonra_bayt": once_boyut}
    os.replace(cikti, yol)
    os.unlink(yedek)
    notlar = []
    if hedef:
        notlar.append("geometri %d" % hedef)
    else:
        notlar.append("geometri durdu")
    if rapor["buyuk_doku"]:
        notlar.append("doku ≤1024")
    return {"dosya": os.path.relpath(yol, KOK), "durum": "inceltildi", "not": ", ".join(notlar),
            "once_ucgen": once["ucgen"], "sonra_ucgen": sonuc["ucgen"],
            "once_bayt": once_boyut, "sonra_bayt": os.path.getsize(yol)}


def glb_liste(yalniz):
    if yalniz:
        return [os.path.join(KOK, y) if not os.path.isabs(y) else y for y in yalniz]
    bulunan = []
    for kok, _d, dosyalar in os.walk(MESHY):
        if os.path.basename(kok) == "gelen":
            continue
        for ad in sorted(dosyalar):
            if ad.lower().endswith(".glb"):
                bulunan.append(os.path.join(kok, ad))
    return bulunan


def orkestr():
    blender = os.environ.get("BLENDER", "blender")
    yalniz = []
    if "--yalniz" in sys.argv:
        yalniz = sys.argv[sys.argv.index("--yalniz") + 1:]
    tablo = tablo_oku()
    sonuclar = []
    if os.path.isfile(SONUC) and not yalniz:
        sonuclar = json.load(open(SONUC, encoding="utf-8"))
    biten = {s["dosya"] for s in sonuclar}
    for yol in glb_liste(yalniz):
        goreli = os.path.relpath(yol, KOK)
        if goreli in biten and not yalniz:
            continue
        boyut = os.path.getsize(yol)
        rapor = tablo.get(boyut)
        if rapor is None:
            # İnceltilmiş dosya yeniden boyutlanmıştır; sonuç dosyasında varsa atla.
            print("TABLO YOK", goreli, boyut)
            sonuclar.append({"dosya": goreli, "durum": "atlandi", "not": "rapor satırı yok",
                             "once_ucgen": None, "sonra_ucgen": None, "once_bayt": boyut, "sonra_bayt": boyut})
        else:
            print("İŞ", goreli, "hedef", rapor["hedef"], flush=True)
            satir = isle(blender, yol, rapor)
            print("  ", satir["durum"], satir["not"], satir.get("sonra_ucgen"), flush=True)
            sonuclar.append(satir)
        if not yalniz:
            with open(SONUC, "w", encoding="utf-8") as f:
                json.dump(sonuclar, f, ensure_ascii=False, indent=1)
                f.write("\n")
    print(json.dumps(sonuclar, ensure_ascii=False, indent=1))


if __name__ == "__main__":
    try:
        import bpy  # Blender içinden
    except ImportError:
        bpy = None
    if bpy is not None and "--" in sys.argv:
        blender_isle()
    elif bpy is None:
        orkestr()
