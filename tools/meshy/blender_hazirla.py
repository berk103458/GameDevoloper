"""Meshy GLB'sini oyuna hazırlar: hedef boya ölçekle, pivotu tabana/merkeze al, (statikte) üçgen sayısını düşür.

Blender 4.2+ ile başsız çalışır, dosyayı yerinde değiştirmez:
  blender -b --factory-startup -P tools/meshy/blender_hazirla.py -- \\
      --girdi assets/model/nesne/kuyu.glb --cikti /tmp/kuyu_hazir.glb --boy 1.2 [--ucgen 2500]

- `--boy`: dünya yüksekliği (metre). Model en yüksek Y'si bu olacak şekilde düzgün ölçeklenir.
- `--ucgen`: hedef üçgen sayısı. Yalnız iskeletsiz modellerde uygulanır (iskeletli karakterde deri
  ağırlıklarını bozmamak için atlanır; Meshy'de `target_polycount` ile çözülür).
- LOD üretilmez: Godot içe aktarıcısı `meshes/generate_lods=true` ile LOD'ları kendisi üretir.
- Animasyonlar ve iskelet olduğu gibi dışa aktarılır.
Çıktı `tools/meshy/glb_bilgi.py` ile ölçülür; sonucu manifeste meshy_hat.py yazar.
"""
import argparse
import sys

import bpy
from mathutils import Vector


def argumanlar():
    arg = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    p = argparse.ArgumentParser()
    p.add_argument("--girdi", required=True)
    p.add_argument("--cikti", required=True)
    p.add_argument("--boy", type=float)
    p.add_argument("--ucgen", type=int)
    return p.parse_args(arg)


def ucgen_say(nesneler):
    toplam = 0
    for o in nesneler:
        o.data.calc_loop_triangles()
        toplam += len(o.data.loop_triangles)
    return toplam


def sinir_kutusu(nesneler):
    bpy.context.view_layer.update()
    noktalar = [o.matrix_world @ Vector(k) for o in nesneler for k in o.bound_box]
    en_az = Vector((min(p.x for p in noktalar), min(p.y for p in noktalar), min(p.z for p in noktalar)))
    en_cok = Vector((max(p.x for p in noktalar), max(p.y for p in noktalar), max(p.z for p in noktalar)))
    return en_az, en_cok


def main():
    o = argumanlar()
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.import_scene.gltf(filepath=o.girdi)
    meshler = [x for x in bpy.context.scene.objects if x.type == "MESH"]
    iskeletli = any(x.type == "ARMATURE" for x in bpy.context.scene.objects)
    kokler = [x for x in bpy.context.scene.objects if x.parent is None]
    once = ucgen_say(meshler)

    if o.ucgen and not iskeletli and once > o.ucgen:
        oran = o.ucgen / once
        for m in meshler:
            d = m.modifiers.new("azalt", "DECIMATE")
            d.ratio = oran
            bpy.context.view_layer.objects.active = m
            bpy.ops.object.modifier_apply(modifier=d.name)

    if iskeletli:
        # Kök ölçeği deri bağlı köşelere ve yürüme kliplerinin konum izlerine tutarlı geçmez; iskeletli modelde
        # boy Meshy rigging `height_meters`, pivot `origin_at=bottom` ile çözülür, gerekirse Godot root_scale.
        print("BLENDER_HAZIRLA uyarı: iskeletli model; ölçek/pivot/azaltma atlandı, dosya olduğu gibi kopyalandı")
        bpy.ops.export_scene.gltf(filepath=o.cikti, export_format="GLB", export_animations=True, export_skins=True)
        return

    # Blender Z yukarı; glTF dışa aktarımı Y yukarıya çevirir.
    en_az, en_cok = sinir_kutusu(meshler)
    if o.boy:
        olcek = o.boy / max(en_cok.z - en_az.z, 1e-6)
        for k in kokler:
            k.scale = k.scale * olcek
            k.location = k.location * olcek
        en_az, en_cok = sinir_kutusu(meshler)
    kaydir = Vector(((en_az.x + en_cok.x) / -2, (en_az.y + en_cok.y) / -2, -en_az.z))
    for k in kokler:
        k.location = k.location + kaydir
    en_az, en_cok = sinir_kutusu(meshler)

    bpy.ops.export_scene.gltf(filepath=o.cikti, export_format="GLB", export_animations=True, export_skins=True,
                              export_apply=not iskeletli)
    print("BLENDER_HAZIRLA ucgen %d -> %d | boy %.3f m | taban %.3f | iskelet %s | %s"
          % (once, ucgen_say(meshler), en_cok.z - en_az.z, en_az.z, iskeletli, o.cikti))


main()
