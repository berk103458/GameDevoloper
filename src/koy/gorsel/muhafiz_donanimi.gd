## ANI-01: mevcut ElEsyasi soketinde görev donanımı; kalıcı modeli değiştirmez.
class_name MuhafizDonanimi
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_donanimi.json"))
var silah: ElEsyasi
var kalkan: ElEsyasi
var mesale: ElEsyasi
var isik: OmniLight3D
var _eski: Dictionary = {}
var _gece := false
var _isik_acik := false
var _zaman := 0.0
## Gerçek el kemikleri varsa mevcut bağlantı API'siyle kurar; fallback'a sahte kemik eklemez.
func kur(f: KarakterModel, id: int) -> bool:
 var bulunan := f.find_children("*", "Skeleton3D", true, false)
 if bulunan.is_empty(): return false
 var sk: Skeleton3D = bulunan[0]
 if sk.find_bone("RightHand") < 0 or sk.find_bone("LeftHand") < 0: return false
 for c in f.get_children():
  if c is ElEsyasi:
   _eski[c] = c.visible
   c.visible = false
 silah = _esya("kilic" if id % 2 == 0 else "mizrak", f, sk, true)
 kalkan = _esya("kalkan", f, sk, false)
 mesale = _esya("mesale", f, sk, false)
 isik = OmniLight3D.new()
 isik.light_color = Color(AYAR.renk_isik)
 isik.omni_range = float(AYAR.isik_menzil)
 isik.light_energy = float(AYAR.isik_gucu)
 isik.shadow_enabled = false
 isik.position = Vector3(0, 0.62, 0)
 mesale.add_child(isik)
 faz(&"gunduz", false)
 return true
## Geceleri sol el meşaleyi taşır; gölgesiz dinamik ışık sahne bütçesine uyar.
func faz(ad: StringName, izin: bool) -> void:
 if mesale == null: return
 _gece = String(ad) in AYAR.gece_fazlari
 _isik_acik = _gece and izin
 mesale.visible = _gece
 kalkan.visible = not _gece
 isik.visible = _isik_acik
 isik.light_energy = float(AYAR.isik_gucu) if _isik_acik else 0.0
## Görev kalkınca mevcut CHR taşıma eşyalarını geri görünür yapar.
func kaldir() -> void:
 for e in _eski:
  if is_instance_valid(e): e.visible = bool(_eski[e])
 queue_free()
func _process(delta: float) -> void:
 if not _isik_acik or isik == null: return
 _zaman += delta
 isik.light_energy = float(AYAR.isik_gucu) * (1.0 + float(AYAR.titresim) * sin(_zaman * float(AYAR.titresim_hizi)))
func _esya(tur: String, f: KarakterModel, sk: Skeleton3D, sag: bool) -> ElEsyasi:
 var e := ElEsyasi.new()
 e.name = tur
 e.dik = true
 add_child(e)
 for p in AYAR.parcalar[tur]:
  var mesh: Mesh
  if p.tur == "kutu":
   var b := BoxMesh.new()
   b.size = Vector3(p.boyut[0], p.boyut[1], p.boyut[2])
   mesh = b
  elif p.tur == "alev":
   var b := SphereMesh.new()
   b.radius = float(p.yaricap)
   b.height = float(p.boy)
   mesh = b
  else:
   var b := CylinderMesh.new()
   b.top_radius = float(p.yaricap)
   b.bottom_radius = float(p.yaricap)
   b.height = float(p.boy)
   b.radial_segments = 12
   mesh = b
  var m := MeshInstance3D.new()
  m.mesh = mesh
  var malzeme := Dunya3B.duz_malzeme(Color(p.renk))
  if p.tur == "alev":
   malzeme.emission_enabled = true
   malzeme.emission = Color(p.renk)
  m.material_override = malzeme
  m.position = Vector3(p.konum[0], p.konum[1], p.konum[2])
  if p.has("donus"): m.rotation_degrees = Vector3(p.donus[0], p.donus[1], p.donus[2])
  e.add_child(m)
 e.bagla(f, sk, sag, f.duzeltici())
 return e
## Mevcut halk modellerini görev/fazla eşler; aynı modele çift donanım kurmaz.
static func yenile(h: Node) -> void:
 var isik_sayisi := 0
 for id in h.modeller:
  var f: KarakterModel = h.modeller[id]
  var k: Koylu = h.sahne.yonetim.koylu(id)
  var d := f.get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
  if k == null or not MuhafizMaasi.aday(k, h.sahne.yonetim):
   if d != null and not d.is_queued_for_deletion(): d.kaldir()
   continue
  if d != null and d.is_queued_for_deletion(): continue
  if d == null:
   d = MuhafizDonanimi.new()
   d.name = "muhafiz_donanimi"
   f.add_child(d)
   if not d.kur(f, int(id)):
    d.queue_free()
    continue
  d.faz(h.faz_adi, isik_sayisi < int(AYAR.azami_isik))
  isik_sayisi += 1
