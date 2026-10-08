## CAS-05: tek mevcut meydanda geçici masa/sıra kutuları; model/asset üretimi yok.
class_name DivanMeydani
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/divan_meydani.json"))
## Bir divan; eski oyun aktörleri/ızgara/ekonomi değişmez. Kaldırılınca tüm geçici kutular birlikte temizlenir.
static func kur(s: KoyYonetimSahnesi) -> Node3D:
 var n := Node3D.new()
 n.name = "divan_meydani"
 s.add_child(n)
 var m := s.yonetim.a.meydan
 n.position = s.alan_merkezi(m.position,m.size)+Vector3(float(AYAR.ofset[0]),float(AYAR.ofset[1]),float(AYAR.ofset[2]))
 _kutu(n,AYAR.masa,Vector3(0,0.45,0))
 _kutu(n,AYAR.sira,Vector3(0,0.2,2))
 _kutu(n,AYAR.sira,Vector3(0,0.2,4))
 return n
## Asset yer değiştirme noktası; yalnız basit BoxMesh.
static func _kutu(n: Node3D,boy: Array,yer: Vector3) -> void:
 var k := MeshInstance3D.new()
 var mesh := BoxMesh.new()
 mesh.size = Vector3(float(boy[0]),float(boy[1]),float(boy[2]))
 k.mesh = mesh
 var mat := StandardMaterial3D.new()
 mat.albedo_color = Color(String(AYAR.renk))
 k.material_override = mat
 k.position = yer
 n.add_child(k)

## Var olan kişi görselini duruşma boyunca masanın önüne getirir; görev/rota/veri değişmez.
static func goster(s: KoyYonetimSahnesi,n: Node3D,id: int) -> void:
 temizle(s,n)
 var f: KarakterModel = s.halk_hareketi.modeller.get(id)
 if f == null: return
 n.set_meta("pozlar",{id:f.global_transform})
 n.set_meta("gorunumler",{id:f.visible})
 f.visible=true
 f.global_position = n.to_global(Vector3(0,0,1.0))
 f.look_at(n.global_position,Vector3.UP,true)
## Önceki gerçek kişi dönüşümü; yeni/çift figür yaratılmaz.
static func temizle(s: KoyYonetimSahnesi,n: Node3D) -> void:
 for id in n.get_meta("pozlar",{}):
  var f: KarakterModel = s.halk_hareketi.modeller.get(id)
  if is_instance_valid(f):
   f.global_transform = n.get_meta("pozlar")[id]
   f.visible=bool(n.get_meta("gorunumler",{}).get(id,f.visible))
 n.set_meta("pozlar",{})
 n.set_meta("gorunumler",{})
