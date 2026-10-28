## ANI-05: ağılın kurulum sürüsü; mevcut A* yolunu paylaşır, ikinci üretim hesaplamaz.
class_name CobanSurusu
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/coban_surusu.json"))
var halk: KoyHalkHareketi
var bina_id := -1
var coban_id := -1
var koyunlar: Array[Node3D] = []
var yol: Array[Vector3] = []
var adimlar: Array[int] = []
var yollar: Array[Array] = []
var kapali := true
var _zaman := 0.0
## CHR ağıl kimliği korunur; kurulum bedeline dört koyunluk başlangıç sürüsü dahildir.
static func ekle(turler: Dictionary) -> void:
 turler["agil"] = AYAR.agil.duplicate(true)
## CSV kilidinde mevcut yapı adı/açıklaması adaptörü için okunur metin.
static func ad(anahtar: String) -> String:
 return {"koy.yapi.agil": "Ağıl", "koy.yapi.agil_aciklama": "Dört koyunluk başlangıç sürüsü ve bir çoban yeri. Çoban başına temel 1 erzak; sabah otlak, akşam ağıla dönüş."}.get(anahtar, TranslationServer.translate(anahtar))
## İnşaat/farklı hayvan barınağı güvenli biçimde hariçtir.
static func hazir(b: KoyBinasi) -> bool:
 return b != null and b.tur == "agil" and b.hazir()
## Çoban için gündüz erişilebilir çayır, akşam/gece ağıl kapısı.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i) -> Dictionary:
 var b := h.sahne.yonetim.bina(k.is_yeri)
 if not hazir(b): return {}
 var en := b.boyut(h.sahne.yonetim.katalog)
 var kapi := b.hucre + Vector2i(en.x / 2, en.y)
 var son := kapi
 if h.faz_adi == &"gunduz":
  var u := int(AYAR.otlak_uzaklik)
  for fark in [Vector2i(0, u), Vector2i(u, 0), Vector2i(-u, 0), Vector2i(0, -u)]:
   var aday: Vector2i = kapi + fark
   if _otlak(h.rotaci, aday) and not h.rotaci.yol(bas, aday).is_empty():
    son = aday
    break
 if not h.rotaci.gecilir(son) or h.rotaci.yol(bas, son).is_empty(): return {}
 return {"son": son, "ad": "Sürüyü otlatıyor" if h.faz_adi == &"gunduz" else "Sürüyü ağıla götürüyor"}
static func _otlak(r: KoyRotasi, h: Vector2i) -> bool:
 for x in range(-1, 2):
  for z in range(-1, 2):
   if not r.gecilir(h + Vector2i(x, z)): return false
 return true
## Aynı bina için tek sürü; görünür dört ağıl bütçesi, atama/faz/yıkım temizliği.
static func yenile(h: KoyHalkHareketi) -> void:
 var secilen := {}
 for b in h.sahne.yonetim.binalar:
  if hazir(b) and secilen.size() < int(AYAR.suruler_azami): secilen[b.id] = -1
 for k in h.sahne.yonetim.koylular:
  var b := h.sahne.yonetim.bina(k.is_yeri)
  if hazir(b) and h.modeller.has(k.id) and secilen.has(b.id) and secilen[b.id] < 0: secilen[b.id] = k.id
 for n in h.get_children():
  if n is CobanSurusu and (not secilen.has(n.bina_id) or secilen[n.bina_id] != n.coban_id):
   n._kapi(false)
   n.queue_free()
 for id in secilen:
  var s := _bul(h, int(id))
  if s == null:
   s = CobanSurusu.new()
   s.halk = h
   s.bina_id = int(id)
   s.coban_id = int(secilen[id])
   h.add_child(s)
   for i in SamanBakimi.taban(h.sahne.yonetim.bina(s.bina_id)):
    var n := koyun()
    s.add_child(n)
    var b := h.sahne.yonetim.bina(s.bina_id)
    n.global_position = h.sahne.alan_merkezi(b.hucre, b.boyut(h.sahne.yonetim.katalog)) + s._fark(i)
    s.koyunlar.append(n)
    s.adimlar.append(0)
    s.yollar.append([])
  CanliHayvanSurusu.yenile(s)
  s._kapi(s.coban_id >= 0 and (h.faz_adi == &"gunduz" or not s.kapali))
## Çobanın hedefini ve mevcut A* grafiğini paylaşır; sürü yoldayken faz değişimi güvenlidir.
static func plan(h: KoyHalkHareketi, k: Koylu, rota: Array) -> void:
 var s := _bul(h, k.is_yeri)
 if s == null or s.coban_id != k.id: return
 s.yol.clear()
 if h._durum[k.id].get("coban_ad", "") != "Sürü yolu kapalı":
  for p in rota: s.yol.append(p)
 var m := h.sahne.yonetim.a.meydan
 var orta := Vector2(m.position) + Vector2(m.size) / 2.0
 var b := h.sahne.yonetim.bina(s.bina_id)
 var kapi := b.hucre + Vector2i(b.boyut(h.sahne.yonetim.katalog).x / 2, b.boyut(h.sahne.yonetim.katalog).y)
 for i in s.adimlar.size():
  s.adimlar[i] = 0
  s.yollar[i] = []
  if s.yol.is_empty(): continue
  var p := s.koyunlar[i].global_position
  var hucre := Vector2i(floori(p.x / h.sahne.HUCRE + orta.x), floori(p.z / h.sahne.HUCRE + orta.y))
  var bas := h.rotaci.yakin(hucre)
  var hedef_p := s.yol[-1]
  var son := Vector2i(floori(hedef_p.x / h.sahne.HUCRE + orta.x), floori(hedef_p.z / h.sahne.HUCRE + orta.y))
  if int(h.sahne.yonetim.izgara.dolu.get(hucre, -1)) == s.bina_id:
   bas = kapi
  # Aynı A* grafiği: faz sürü yoldayken değişse de binaların içinden kestirme yok.
  for cell in h.rotaci.yol(bas, son): s.yollar[i].append(h.sahne.alan_merkezi(cell, Vector2i.ONE))
 s.kapali = false
 s._kapi(true)
static func _bul(h: KoyHalkHareketi, id: int) -> CobanSurusu:
 for n in h.get_children():
  if n is CobanSurusu and n.bina_id == id and not n.is_queued_for_deletion(): return n
 return null
func _fark(i: int) -> Vector3:
 return Vector3((i % 2 - 0.5) * 0.55, 0, (i / 2 - 0.5) * 0.65)
func _process(delta: float) -> void:
 if halk == null: return
 var b := halk.sahne.yonetim.bina(bina_id)
 if not hazir(b): return
 _zaman += delta
 var tamam := true
 for i in koyunlar.size():
  var n := koyunlar[i]
  var hedef_p := n.global_position
  var gidiyor := false
  if adimlar[i] < yollar[i].size():
   hedef_p = yollar[i][adimlar[i]] + _fark(i)
   gidiyor = true
   if n.global_position.distance_to(hedef_p) <= float(AYAR.varis_mesafesi): adimlar[i] += 1
  elif coban_id >= 0 and halk.faz_adi == &"gunduz" and not yol.is_empty():
   hedef_p = yol[-1] + Vector3((i % 2 - 0.5) * float(AYAR.otlama_aralik[0]), 0, (i / 2 - 0.5) * float(AYAR.otlama_aralik[1]))
  elif coban_id < 0 or (halk.faz_adi != &"gunduz" and not yollar[i].is_empty()):
   hedef_p = halk.sahne.alan_merkezi(b.hucre, b.boyut(halk.sahne.yonetim.katalog)) + _fark(i)
   gidiyor = n.global_position.distance_to(hedef_p) > float(AYAR.varis_mesafesi)
  var fark := hedef_p - n.global_position
  if fark.length() > 0.01:
   n.rotation.y = atan2(-fark.x, -fark.z)
   n.global_position = n.global_position.move_toward(hedef_p, float(AYAR.yurume_hizi) * delta)
  var bas := n.get_node("bas") as Node3D
  bas.rotation.x = 0.0 if gidiyor else -0.35 + sin(_zaman * 1.4 + i) * 0.1
  if gidiyor or (coban_id >= 0 and halk.faz_adi != &"gunduz" and yollar[i].is_empty()): tamam = false
 kapali = tamam and (coban_id < 0 or halk.faz_adi != &"gunduz")
 _kapi(not kapali)
func _kapi(acik: bool) -> void:
 if halk == null: return
 for n in halk.sahne._yapilar.get_children():
  if int(n.get_meta("bina_id", -1)) == bina_id and not n.is_queued_for_deletion():
   var kapi := n.get_node_or_null("agil_kapisi") as Node3D
   if kapi != null: kapi.rotation.y = PI / 2 if acik else 0.0
## Prosedürel düşük poligon koyun: dış ölçü/renk ayarları, ek ücretli varlık yoktur.
static func koyun() -> Node3D:
 var hazir := HazirEsyaHayvan.hayvan("koyun")
 if hazir != null:
  # Vertexcat statik: mevcut rota sürer; baş eğimi için ayrı rig yoktur.
  var bas_soketi := Node3D.new()
  bas_soketi.name = "bas"
  hazir.add_child(bas_soketi)
  hazir.set_meta("statik_hayvan", true)
  return hazir
 var n := Node3D.new()
 _top(n, Vector3(0, float(AYAR.govde_y), 0), AYAR.govde_olcek, Color(AYAR.yun_renk))
 var bas := Node3D.new()
 bas.name = "bas"
 bas.position = Vector3(0, float(AYAR.bas_y), float(AYAR.bas_z))
 n.add_child(bas)
 _top(bas, Vector3.ZERO, AYAR.bas_olcek, Color(AYAR.deri_renk))
 for x in [-1, 1]:
  _top(bas, Vector3(x * 0.18, 0.06, 0), AYAR.kulak_olcek, Color(AYAR.deri_renk))
  var goz := float(AYAR.goz_yaricap)
  _top(bas, Vector3(x * 0.12, 0.05, -0.08), [goz, goz, goz], Color("#171411"))
 for i in 9:
  var t := float(AYAR.yun_tutam)
  _top(n, Vector3((i % 3 - 1) * 0.22, float(AYAR.govde_y) + 0.17, (i / 3 - 1) * 0.28), [t, t, t], Color(AYAR.yun_renk))
 for x in [-1, 1]:
  for z in [-1, 1]:
   _kutu(n, Vector3(float(AYAR.bacak_yaricap) * 2, float(AYAR.bacak_boy), float(AYAR.bacak_yaricap) * 2), Vector3(x * 0.2, float(AYAR.bacak_boy) / 2, z * 0.3), Color(AYAR.deri_renk))
 return n
static func _top(n: Node3D, p: Vector3, olcek: Array, renk: Color) -> void:
 var m := MeshInstance3D.new()
 var b := SphereMesh.new()
 b.radius = 1.0
 b.height = 2.0
 b.radial_segments = 12
 b.rings = 6
 m.mesh = b
 m.position = p
 m.scale = Vector3(olcek[0], olcek[1], olcek[2])
 m.material_override = Dunya3B.duz_malzeme(renk)
 n.add_child(m)
## Mevcut bina kökünde kapılı ahşap ağıl; kapı yalnız sürü dönünce kapanır.
static func agil_kur(n: Node3D, en: float, derin: float) -> void:
 var boy := float(AYAR.cit_boy)
 var d := float(AYAR.cit_kalinlik)
 var renk := Color(AYAR.cit_renk)
 for y in [boy * 0.3, boy * 0.8]:
  _kutu(n, Vector3(en, d, d), Vector3(0, y, -derin / 2), renk)
  for x in [-1, 1]: _kutu(n, Vector3(d, d, derin), Vector3(x * en / 2, y, 0), renk)
  var parca := (en - float(AYAR.kapi_genislik)) / 2
  for x in [-1, 1]: _kutu(n, Vector3(parca, d, d), Vector3(x * (en + float(AYAR.kapi_genislik)) / 4, y, derin / 2), renk)
 for x in [-1, 1]:
  for z in [-1, 1]: _kutu(n, Vector3(d, boy, d), Vector3(x * en / 2, boy / 2, z * derin / 2), renk)
 var kapi := Node3D.new()
 kapi.name = "agil_kapisi"
 kapi.position = Vector3(-float(AYAR.kapi_genislik) / 2, 0, derin / 2)
 n.add_child(kapi)
 for y in [boy * 0.3, boy * 0.8]: _kutu(kapi, Vector3(float(AYAR.kapi_genislik), d, d), Vector3(float(AYAR.kapi_genislik) / 2, y, 0), renk)
static func _kutu(n: Node3D, boy: Vector3, p: Vector3, renk: Color) -> void:
 var m := MeshInstance3D.new()
 var b := BoxMesh.new()
 b.size = boy
 m.mesh = b
 m.position = p
 m.material_override = Dunya3B.duz_malzeme(renk)
 n.add_child(m)
