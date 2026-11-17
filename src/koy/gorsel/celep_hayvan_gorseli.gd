## TUC-02: satın alınmış hayvanların barınak içindeki düz kutu yer tutucuları.
class_name CelepHayvanGorseli
extends RefCounted
## Mevcut bina düğümüne eklenir; kayıt, üretim ve hareket sistemi kurmaz.
static func kur(s: KoyYonetimSahnesi, n: Node3D, b: KoyBinasi) -> void:
 if not b.hazir(): return
 var i := 0
 var cfg: Dictionary = CelepHamdullah.AYAR.gorsel
 for tur in CelepHamdullah.barindir(s.yonetim, b.id):
  if CanliHayvanSurusu.surude(s.yonetim, b.id, tur): continue
  if i >= int(cfg.azami): break
  var m := _yer_tutucu(tur)
  m.position = Vector3((i - 0.5) * float(cfg.aralik), float(cfg.boyut[1]) / 2.0, 0)
  n.add_child(m)
  i += 1
## Gerçek model geldiğinde değiştirilecek tek merkez.
static func _yer_tutucu(tur: String) -> Node3D:
 var meshy_harita := {
  "at": ["td_k05", 1.60],
  "beygir": ["td_k05", 1.55],
  "koyun": ["td_k13", 0.78],
  "keci": ["td_a163", 0.80],
  "okuz": ["td_a172", 1.45],
  "esek": ["td_a157", 1.20],
  "tavuk": ["td_a146", 0.40],
 }
 if tur == "inek":
  var model := HazirEsyaHayvan.hayvan(tur)
  if model != null:
   # Eski çağıran tabanı değil kutu merkezini yerleştirir; merkez ofsetini dengeler.
   model.position.y = -float(CelepHamdullah.AYAR.gorsel.boyut[1]) / 2
   var kap := Node3D.new()
   kap.name = "celep_" + tur
   kap.set_meta("hayvan_turu", tur)
   kap.add_child(model)
   return kap
 if meshy_harita.has(tur):
  var bilgi: Array = meshy_harita[tur]
  if Dunya3B.model_var_mi(String(bilgi[0])):
   var anim_model := Dunya3B.nesne(String(bilgi[0]), float(bilgi[1]))
   anim_model.position.y = -float(CelepHamdullah.AYAR.gorsel.boyut[1]) / 2
   var kap := Node3D.new()
   kap.name = "celep_" + tur
   kap.set_meta("hayvan_turu", tur)
   kap.add_child(anim_model)
   return kap
 var n := MeshInstance3D.new()
 n.name = "celep_" + tur
 n.set_meta("hayvan_turu", tur)
 var box := BoxMesh.new()
 var a: Array = CelepHamdullah.AYAR.gorsel.boyut
 box.size = Vector3(a[0], a[1], a[2])
 n.mesh = box
 var mat := StandardMaterial3D.new()
 var model := HazirEsyaHayvan.hayvan(tur)
 if model != null:
  mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
  mat.albedo_color = Color(0, 0, 0, 0)
  n.material_override = mat
  model.position.y = -box.size.y / 2
  n.add_child(model)
  return n
 mat.albedo_color = Color(CelepHamdullah.AYAR.hayvanlar[tur].renk)
 n.material_override = mat
 HazirSahneModeli.etiket(n, String(CelepHamdullah.AYAR.hayvanlar[tur].ad), box.size.y / 2 + 0.25)
 return n
