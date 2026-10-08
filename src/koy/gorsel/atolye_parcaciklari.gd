## ANI-15: gerçek çalışma duraklarına bağlı, uzaklık/düşük profil sınırlı kutu parçacıkları.
class_name AtolyeParcaciklari
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/atolye_parcaciklari.json"))
var sahne: KoyYonetimSahnesi
var bina_id := -1
var efektler: Dictionary = {}
var _zaman := 0.0

## Bina görünümüne tek adaptör; yalnız desteklenen hazır binalarda bir efekt grubu kurar.
static func kur(s: KoyYonetimSahnesi, n: Node3D, b: KoyBinasi) -> void:
 if not b.hazir() or not AYAR.turler.has(b.tur): return
 var fx := AtolyeParcaciklari.new()
 fx.name = "atolye_parcaciklari"
 fx.sahne = s
 fx.bina_id = b.id
 var boy := b.boyut(s.yonetim.katalog)
 for tur in AYAR.turler[b.tur]:
  var d: Dictionary = AYAR.efektler[tur]
  var p := CPUParticles3D.new()
  p.name = tur
  p.emitting = false
  p.amount = int(d.adet)
  p.lifetime = float(d.sure)
  p.fixed_fps = int(AYAR.fixed_fps)
  p.direction = Vector3(d.yon[0], d.yon[1], d.yon[2])
  p.gravity = Vector3.UP * float(d.yercekimi)
  p.initial_velocity_min = float(d.hiz[0])
  p.initial_velocity_max = float(d.hiz[1])
  p.spread = float(d.yayilim)
  p.color = Color(d.renk)
  p.local_coords = false
  p.use_fixed_seed = true
  p.seed = b.id
  p.mesh = _yer_tutucu(d)
  p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
  p.visibility_aabb = AABB(Vector3(-3, -2, -3), Vector3(6, 8, 6))
  p.position = Vector3((boy.x - 1) * s.HUCRE / 2, float(d.yukseklik), boy.y * s.HUCRE / 2)
  fx.efektler[tur] = p
  fx.add_child(p)
 n.add_child(fx)

## Görsel LOD bütçesi; grafik adaptörünün düşük profilde kapattığı katmanı açmaz.
static func katsayi(mesafe: float, katman: int) -> float:
 if katman == 0 or mesafe >= float(AYAR.uzak_mesafe): return 0.0
 return 1.0 if mesafe <= float(AYAR.yakin_mesafe) else float(AYAR.orta_carpan)

func _process(delta: float) -> void:
 _zaman += delta
 if _zaman < float(AYAR.kontrol_araligi): return
 _zaman = 0.0
 guncelle()

## Varış, reçete ve mevcut sulama aşaması okunur; üretim/RNG ilerletilmez.
func guncelle() -> void:
 var b := sahne.yonetim.bina(bina_id)
 var calisiyor := false
 if b != null and b.hazir():
  for k in sahne.yonetim.calisanlar(bina_id):
   var d: Dictionary = sahne.halk_hareketi._durum.get(k.id, {})
   if d.is_empty() or not d.get("is", false) or int(d.adim) < d.yol.size(): continue
   if b.tur in ["tarla", "bostan"]:
    if SulamaRutini.aday(sahne.yonetim, k, sahne.halk_hareketi.faz_adi) and d.get("sulama", false) and int(d.get("sulama_i", 0)) == 1:
     var f := sahne.halk_hareketi.modeller.get(k.id) as KarakterModel
     var su := f.get_node_or_null("sulama_rutini") as SulamaRutini if is_instance_valid(f) else null
     if su != null and is_instance_valid(su.akis) and su.akis.visible:
      calisiyor = true
      efektler.su.global_position = su.akis.global_position
   else:
    calisiyor = calisiyor or (ZanaatTezgahi.aday(sahne.yonetim, k, sahne.halk_hareketi.faz_adi) and ZanaatTezgahi.aktif(sahne.yonetim, k))
 for tur in efektler:
  var p: CPUParticles3D = efektler[tur]
  var oran := katsayi(sahne.kamera.global_position.distance_to(p.global_position), p.layers)
  var aktif := calisiyor and oran > 0 and not sahne.kamera.is_position_behind(p.global_position)
  if oran > 0:
   var adet := maxi(1, ceili(float(AYAR.efektler[tur].adet) * oran))
   if p.amount != adet: p.amount = adet
  p.emitting = aktif
  p.visible = aktif

static func _yer_tutucu(d: Dictionary) -> BoxMesh:
 var mesh := BoxMesh.new()
 mesh.size = Vector3(d.boy[0], d.boy[1], d.boy[2])
 var m := StandardMaterial3D.new()
 m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
 m.vertex_color_use_as_albedo = true
 m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
 mesh.material = m
 return mesh
