class_name MevsimKarOrtusu
extends RefCounted
const YOL := "res://data/kar_ortusu.json"
const CATI := preload("res://src/koy/gorsel/cati_kar_ortusu.gdshader")
## Tek takvimden türetilen kozmetik örtü; kayıt, gün ve RNG değiştirmez.
static func oran(y: KoyYonetimi) -> float:
 var veri: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(YOL))
 if IklimDeneyi.hava(y) == "kar_firtinasi": return clampf(float(veri.firtina), 0.0, 1.0)
 if y.mevsim() != 3: return 0.0
 var sure := MevsimYoneticisi.sure(y.a.mevsim_gun)
 var ilerleme := float(MevsimYoneticisi.mevsim_gunu(y.gun, sure) - 1) / maxf(1.0, sure - 1.0)
 return clampf(lerpf(float(veri.ilk_gun), float(veri.son_gun), ilerleme), 0.0, 1.0)
## Mevcut yapı materyallerini koruyarak yalnız üst yüzeylere kar geçişi ekler.
static func catilar(s: KoyYonetimSahnesi, kar: float) -> void:
 var veri: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(YOL))
 for n in s._yapilar.find_children("*", "MeshInstance3D", true, false):
  var mi := n as MeshInstance3D
  if mi.mesh == null: continue
  if mi.has_meta(&"mevsim_kar_mat"):
   for mat in mi.get_meta(&"mevsim_kar_mat"): mat.set_shader_parameter("kar_ortusu", kar)
   continue
  if kar <= 0.0: continue
  var karlar: Array[ShaderMaterial] = []
  var adet := 1 if mi.material_override != null else mi.mesh.get_surface_count()
  for i in adet:
   var eski: Material = mi.material_override if mi.material_override != null else mi.get_active_material(i)
   var temel: Material = eski.duplicate(true) if eski != null else StandardMaterial3D.new()
   var kar_mat := ShaderMaterial.new()
   kar_mat.shader = CATI
   kar_mat.set_shader_parameter("kar_ortusu", kar)
   kar_mat.set_shader_parameter("yukari_esik", float(veri.yukari_esik))
   var son := temel
   while son.next_pass != null: son = son.next_pass
   son.next_pass = kar_mat
   karlar.append(kar_mat)
   if mi.material_override != null: mi.material_override = temel
   else: mi.set_surface_override_material(i, temel)
  mi.set_meta(&"mevsim_kar_mat", karlar)
