## TUC-02: satın alınmış hayvanların barınak içindeki düz kutu yer tutucuları.
class_name CelepHayvanGorseli
extends RefCounted
## Mevcut bina düğümüne eklenir; kayıt, üretim ve hareket sistemi kurmaz.
static func kur(s: KoyYonetimSahnesi, n: Node3D, b: KoyBinasi) -> void:
 if not b.hazir(): return
 var i := 0
 var cfg: Dictionary = CelepHamdullah.AYAR.gorsel
 for tur in CelepHamdullah.barindir(s.yonetim, b.id):
  if i >= int(cfg.azami): break
  var m := _yer_tutucu(tur)
  m.position = Vector3((i - 0.5) * float(cfg.aralik), float(cfg.boyut[1]) / 2.0, 0)
  n.add_child(m)
  i += 1
## Gerçek model geldiğinde değiştirilecek tek merkez.
static func _yer_tutucu(tur: String) -> MeshInstance3D:
 var n := MeshInstance3D.new()
 n.name = "celep_" + tur
 n.set_meta("hayvan_turu", tur)
 var box := BoxMesh.new()
 var a: Array = CelepHamdullah.AYAR.gorsel.boyut
 box.size = Vector3(a[0], a[1], a[2])
 n.mesh = box
 var mat := StandardMaterial3D.new()
 mat.albedo_color = Color(CelepHamdullah.AYAR.hayvanlar[tur].renk)
 n.material_override = mat
 return n
