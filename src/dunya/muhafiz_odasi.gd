## ODA-01: tek iç mekân sahnesi; nesneler JSON'dan kutu yer tutucu, ekonomi mantığı yok.
class_name MuhafizOdasi
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_odasi.json"))

func _ready() -> void:
 var ortam:=WorldEnvironment.new()
 ortam.environment=Environment.new()
 ortam.environment.background_mode=Environment.BG_COLOR
 ortam.environment.background_color=Color("202329")
 ortam.environment.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR
 ortam.environment.ambient_light_color=Color("e5dac4")
 ortam.environment.ambient_light_energy=0.7
 add_child(ortam)
 var isik:=DirectionalLight3D.new()
 isik.rotation_degrees=Vector3(-50,-25,0)
 isik.light_energy=1.0
 add_child(isik)
 if Dunya3B.model_var_mi("muhafiz_odasi", "yapi"):
  var oda_glb := Dunya3B.nesne("muhafiz_odasi", 2.8, "yapi")
  oda_glb.name = "oda_kabugu"
  add_child(oda_glb)
 for p in AYAR.parcalar: _kutu(p)
 var kamera:=Camera3D.new()
 kamera.projection=Camera3D.PROJECTION_ORTHOGONAL
 kamera.size=float(AYAR.kamera_boyutu)
 add_child(kamera)
 kamera.position=_vektor(AYAR.kamera)
 kamera.look_at(Vector3.ZERO)
 kamera.current=true

func _kutu(p: Dictionary) -> void:
 if String(p.ad) in ["yatak", "masa"]:
  var hazir := HazirEsyaHayvan.esya(String(p.ad), _vektor(p.boyut))
  if hazir != null:
   hazir.name = String(p.ad)
   hazir.position = _vektor(p.yer) - Vector3(0, float(p.boyut[1]) / 2, 0)
   add_child(hazir)
   return
 var n:=MeshInstance3D.new()
 n.name=String(p.ad)
 var m:=BoxMesh.new()
 m.size=_vektor(p.boyut)
 n.mesh=m
 var renk:=StandardMaterial3D.new()
 renk.albedo_color=Color(String(p.renk))
 n.material_override=renk
 n.position=_vektor(p.yer)
 add_child(n)
 var ad_s := String(p.ad)
 if ad_s == "kabus_golgesi" and Dunya3B.model_var_mi("kabus_golgesi", "karakter"):
  renk.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
  renk.albedo_color = Color(0, 0, 0, 0)
  var kg := Dunya3B.nesne("kabus_golgesi", float(p.boyut[1]), "karakter")
  kg.position = Vector3(0, -float(p.boyut[1]) / 2.0, 0)
  n.add_child(kg)
  return
 var glb_ad: String = {"mesale": "mesale_el", "gizli_kasa": "kasa", "askilik": "askilik", "kutuphane": "kutuphane"}.get(ad_s, "")
 if not glb_ad.is_empty() and Dunya3B.model_var_mi(glb_ad):
  var glb := Dunya3B.nesne(glb_ad, float(p.boyut[1]))
  glb.position = Vector3(0, -float(p.boyut[1]) / 2.0, 0)
  n.add_child(glb)
  return
 if p.has("etiket"):
  var l:=Label3D.new()
  l.text=String(p.etiket)
  l.billboard=BaseMaterial3D.BILLBOARD_ENABLED
  l.no_depth_test=true
  l.font_size=40
  l.pixel_size=0.012
  l.position=Vector3(0,m.size.y/2+0.5,0)
  n.add_child(l)

func _vektor(a: Array) -> Vector3:
 return Vector3(float(a[0]),float(a[1]),float(a[2]))
