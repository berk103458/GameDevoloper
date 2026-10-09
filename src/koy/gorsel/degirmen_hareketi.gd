## ANI-06: gerçek üretim koşullarına bağlı görsel çark ve çuval; kayıt değişmez.
class_name DegirmenHareketi
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/degirmen_hareketi.json"))
var sahne: KoyYonetimSahnesi
var bina_id := -1
var teker: Node3D
var cuval: ElEsyasi
var _eski: Dictionary = {}
## Yalnız gerçek fiziksel çalışan; yaşlı danışman veya grev/kaza çuval taşımaz.
static func aday(y: KoyYonetimi, k: Koylu, faz: StringName) -> bool:
 if KarantinaYoneticisi.aktif(k): return false
 if k == null or faz != &"gunduz": return false
 var b := y.bina(k.is_yeri)
 return b != null and b.hazir() and b.tur == "degirmen" and YasRolleri.fiziksel(k, b.tur) and not ZanaatKazalari.durur(k) and not MeslekGrevi.aktif(k, y) and not IsMemnuniyeti.isyanci(k, y)
## Mevcut gece üretimindeki iş/girdi engellerini salt okunur olarak izler.
static func aktif(y: KoyYonetimi, id: int, faz: StringName) -> bool:
 var b := y.bina(id)
 if faz != &"gunduz" or b == null or not b.hazir() or b.tur != "degirmen" or KanDavasi.engel(y, id): return false
 var r: Dictionary = y.katalog.receteler(b.tur).get(b.recete, {})
 if r.is_empty() or y.kaynaklar.toplam() >= y.kaynaklar.kapasite: return false
 for tur in r.get("girdi", {}):
  if y.kaynaklar.miktar(tur) < int(r.girdi[tur]): return false
 for k in y.calisanlar(id):
  if aday(y, k, faz): return true
 return false
## Mevcut bina kökünde kapalı değirmen gövdesi/çarkı; sahne ekonomi kurmaz.
func kur(en: float, derin: float) -> void:
 var renk := Color(AYAR.ahsap_renk)
 _kutu(self, Vector3(en * 0.72, 2.4, derin * 0.62), Vector3(0, 1.2, 0), renk)
 _kutu(self, Vector3(en * 0.85, 0.16, derin * 0.8), Vector3(0, 2.5, 0), renk.darkened(0.15))
 teker = Node3D.new()
 teker.position = Vector3(-en * 0.28, float(AYAR.cark_yukseklik), derin * 0.45)
 add_child(teker)
 var r := float(AYAR.cark_yaricap)
 var d := float(AYAR.cark_kenar)
 var rim := MeshInstance3D.new()
 var halka := TorusMesh.new()
 halka.inner_radius = r - d
 halka.outer_radius = r
 rim.mesh = halka
 rim.rotation.x = PI / 2
 rim.material_override = Pbr.malzeme("medieval_wood", 2.0, renk)
 teker.add_child(rim)
 for i in 8:
  var kol := _kutu(teker, Vector3(d, r * 1.8, d), Vector3.ZERO, renk)
  kol.rotation.z = i * PI / 8
 var kabin := Node3D.new()
 kabin.position = Vector3(en * 0.25, 0, derin * 0.42)
 add_child(kabin)
 var boy := float(AYAR.sundurma_boy)
 _kutu(kabin, Vector3(en * 0.45, 0.12, derin * 0.6), Vector3(0, boy, 0), renk)
 for x in [-1, 1]:
  for z in [-1, 1]: _kutu(kabin, Vector3(0.1, boy, 0.1), Vector3(x * en * 0.2, boy / 2, z * derin * 0.27), renk)
 if Dunya3B.model_var_mi("cuval_yigini"):
  var yig := Dunya3B.nesne("cuval_yigini", 0.65)
  yig.position = Vector3(en * 0.3, 0, derin * 0.27)
  add_child(yig)
func _process(delta: float) -> void:
 if teker != null and sahne != null and aktif(sahne.yonetim, bina_id, sahne.halk_hareketi.faz_adi): teker.rotation.z = wrapf(teker.rotation.z + delta * float(AYAR.cark_hizi), -PI, PI)
## Değirmenci iş/sundurma/dinlenme durakları mevcut A* ile seçilir.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i, adim: int) -> Dictionary:
 var b := h.sahne.yonetim.bina(k.is_yeri)
 var m := h.sahne.yonetim.a.meydan
 var son := h.rotaci.yakin(m.position + Vector2i(k.id % m.size.x, (k.id / m.size.x) % m.size.y))
 var calisiyor := aktif(h.sahne.yonetim, b.id, h.faz_adi)
 var ad := "Öğütme bekliyor"
 if calisiyor and adim != 2:
  son = h.rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(h.sahne.yonetim.katalog)), k.id + adim * 3)
  if adim == 1:
   var boyut := b.boyut(h.sahne.yonetim.katalog)
   son = b.hucre + Vector2i(boyut.x - 1, boyut.y)
   if not h.rotaci.gecilir(son) or h.rotaci.yol(bas, son).is_empty(): return {}
  ad = "Değirmende çalışıyor" if adim == 0 else "Sundurmaya çuval taşıyor"
 elif calisiyor: ad = "Dinleniyor"
 if son.x < 0 or h.rotaci.yol(bas, son).is_empty(): return {}
 return {"son": son, "ad": ad, "calisiyor": calisiyor}
func _cuval_kur(f: KarakterModel) -> bool:
 var bulunan := f.find_children("*", "Skeleton3D", true, false)
 if bulunan.is_empty(): return false
 var sk: Skeleton3D = bulunan[0]
 if sk.find_bone("RightHand") < 0: return false
 for c in f.get_children():
  if c is ElEsyasi:
   _eski[c] = c.visible
   c.visible = false
 cuval = ElEsyasi.olustur("cuval")
 add_child(cuval)
 cuval.bagla(f, sk, true, f.duzeltici())
 return true
## Gerçek el kemiğinde çuval; görev/faz sonunda özgün CHR görünürlüğü geri gelir.
static func esya(f: KarakterModel, etkin: bool, tasiyor: bool) -> void:
 var d := f.get_node_or_null("degirmen_cuvali") as DegirmenHareketi
 if not etkin:
  if d != null and not d.is_queued_for_deletion(): d.kaldir()
  return
 if d != null and d.is_queued_for_deletion(): return
 if d == null:
  d = DegirmenHareketi.new()
  d.name = "degirmen_cuvali"
  f.add_child(d)
  if not d._cuval_kur(f):
   d.queue_free()
   return
 d.cuval.visible = tasiyor
## Görev eşyasını güvenli kaldırır; çark binayla birlikte silinir.
func kaldir() -> void:
 for e in _eski:
  if is_instance_valid(e): e.visible = bool(_eski[e])
 queue_free()
static func _kutu(n: Node3D, boy: Vector3, p: Vector3, renk: Color) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 var b := BoxMesh.new()
 b.size = boy
 m.mesh = b
 m.position = p
 m.material_override = Pbr.malzeme("medieval_wood", 2.0, renk)
 n.add_child(m)
 return m
