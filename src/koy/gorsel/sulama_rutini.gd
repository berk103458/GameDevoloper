## ANI-03: salt görsel su taşıma; üretim/RNG/kayıt mevcut ekonomiye aittir.
class_name SulamaRutini
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/sulama_rutini.json"))
var kova: ElEsyasi
var su: MeshInstance3D
var akis: MeshInstance3D
var _eski: Dictionary = {}
## Hazır tarla/bostan görevlisi yalnız gündüz su taşır.
static func aday(y: KoyYonetimi, k: Koylu, faz: StringName) -> bool:
 if k == null or faz != &"gunduz": return false
 var b := y.bina(k.is_yeri)
 return b != null and b.hazir() and b.tur in ["tarla", "bostan"] and not (y.mevsim() == 3 and y.katalog.veri(b.tur).get("kis_durur", false))
## Gerçek kuyuyla hareket hedefi aynı dış ayarı kullanır.
static func kuyu_konumu(s: KoyYonetimSahnesi) -> Vector3:
 var m := s.yonetim.a.meydan
 return s.alan_merkezi(m.position, m.size) + Vector3(AYAR.kuyu_ofset[0], 0, AYAR.kuyu_ofset[1])
## Mevcut A* ile kuyu → ark → dinlenme; kopuk hedefte boş sonuç döner.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i, adim: int) -> Dictionary:
 var s := h.sahne
 var b := s.yonetim.bina(k.is_yeri)
 var m := s.yonetim.a.meydan
 var bak := kuyu_konumu(s)
 var p := bak + Vector3(AYAR.kuyu_yaklasma[0], 0, AYAR.kuyu_yaklasma[1])
 var orta := Vector2(m.position) + Vector2(m.size) / 2.0
 var son := h.rotaci.yakin(Vector2i(floori(p.x / s.HUCRE + orta.x), floori(p.z / s.HUCRE + orta.y)))
 var ad := "Kuyudan su alıyor"
 if adim == 1:
  son = h.rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(s.yonetim.katalog)), k.id)
  bak = s.alan_merkezi(b.hucre, b.boyut(s.yonetim.katalog))
  ad = "Su arkını suluyor"
 elif adim == 2:
  son = h.rotaci.yakin(m.position + Vector2i(k.id % m.size.x, (k.id / m.size.x) % m.size.y))
  ad = "Dinleniyor"
 if son.x < 0 or h.rotaci.yol(bas, son).is_empty(): return {}
 return {"son": son, "bak": bak, "ad": ad}
## İş eşyası gerçek sağ el kemiğine bağlanır; eksik kemikte sahte soket kurulmaz.
func kur(f: KarakterModel) -> bool:
 var bulunan := f.find_children("*", "Skeleton3D", true, false)
 if bulunan.is_empty(): return false
 var sk: Skeleton3D = bulunan[0]
 if sk.find_bone("RightHand") < 0: return false
 for c in f.get_children():
  if c is ElEsyasi:
   _eski[c] = c.visible
   c.visible = false
 kova = ElEsyasi.olustur("kova")
 add_child(kova)
 kova.bagla(f, sk, true, f.duzeltici())
 su = _su(float(AYAR.kova_su_yaricap), 0.008, Vector3(0, float(AYAR.kova_su_y), 0))
 akis = _su(float(AYAR.akis_yaricap), float(AYAR.akis_boy), Vector3(float(AYAR.kova_su_yaricap), float(AYAR.kova_su_y) - float(AYAR.akis_boy) / 2, 0))
 akis.visible = false
 return true
## Görev/faz bittiğinde CHR eşyasını tam eski görünürlüğüyle geri verir.
func kaldir() -> void:
 for e in _eski:
  if is_instance_valid(e): e.visible = bool(_eski[e])
 queue_free()
## Sahne modeli ve aşamaya uyar; tekrar planlama çift kova oluşturmaz.
static func esya(f: KarakterModel, etkin: bool, adim: int) -> void:
 var d := f.get_node_or_null("sulama_rutini") as SulamaRutini
 if not etkin:
  if d != null and not d.is_queued_for_deletion(): d.kaldir()
  return
 if d != null and d.is_queued_for_deletion(): return
 if d == null:
  d = SulamaRutini.new()
  d.name = "sulama_rutini"
  f.add_child(d)
  if not d.kur(f):
   d.queue_free()
   return
 d.kova.visible = adim != 2
 d.su.visible = adim == 1
 d.akis.visible = false
## Ark durağına varınca su akışı görünür; yürürken akmaz.
static func varis(f: KarakterModel, suluyor: bool) -> void:
 var d := f.get_node_or_null("sulama_rutini") as SulamaRutini
 if d != null and not d.is_queued_for_deletion(): d.akis.visible = suluyor
func _su(yaricap: float, boy: float, p: Vector3) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 var b := CylinderMesh.new()
 b.top_radius = yaricap
 b.bottom_radius = yaricap
 b.height = boy
 m.mesh = b
 m.position = p
 m.material_override = Dunya3B.duz_malzeme(Color(AYAR.su_renk))
 kova.add_child(m)
 return m
## Hazır tarla görünümünde toprak kenarlı su arkları; doluluk ve üretim değişmez.
static func ark_kur(n: Node3D, en: float, derin: float) -> void:
 var adet := maxi(1, floori(en / float(AYAR.ark_aralik)))
 for i in adet:
  var x := (i + 0.5) * en / adet - en / 2
  _kutu(n, Vector3(float(AYAR.ark_genislik) * 2, 0.035, derin * 0.85), Vector3(x, 0.018, 0), Color(AYAR.toprak_renk))
  _kutu(n, Vector3(float(AYAR.ark_genislik), 0.012, derin * 0.85), Vector3(x, 0.043, 0), Color(AYAR.su_renk))
static func _kutu(n: Node3D, boy: Vector3, p: Vector3, renk: Color) -> void:
 var m := MeshInstance3D.new()
 var b := BoxMesh.new()
 b.size = boy
 m.mesh = b
 m.position = p
 m.material_override = Dunya3B.duz_malzeme(renk)
 n.add_child(m)
