## ANI-04: mevcut odun/çekiş ekonomisine görsel rota ve araç adaptörü.
class_name OduncuRutini
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/oduncu_rutini.json"))
var balta: ElEsyasi
var elle: ElEsyasi
var okuz: Node3D
var yuk: Node3D
var _eski: Dictionary = {}
var _kesiyor := false
var _zaman := 0.0
var _balta_gorsel: Node3D
## Hızar alıcısı yoksa ikinci teslimat uydurmaz; eski iş rutini devam eder.
static func aday(y: KoyYonetimi, k: Koylu, faz: StringName) -> bool:
 if k == null or faz != &"gunduz": return false
 var b := y.bina(k.is_yeri)
 return b != null and b.hazir() and b.tur == "odunluk" and hizar(y) != null
## Kararlı sıradaki ilk tamamlanmış hızar.
static func hizar(y: KoyYonetimi) -> KoyBinasi:
 for b in y.binalar:
  if b.tur == "hizarhane" and b.hazir(): return b
 return null
## Gerçek öküz ve ahır kapasitesi sınırı; inek sahipliği sahte öküz üretmez.
static func okuz_ver(y: KoyYonetimi, id: int) -> bool:
 var sinir := mini(int(y.lojistik.hayvanlar.get("okuz", 0)), y.lojistik.kapasite(y))
 if sinir <= 0: return false
 var ids: Array[int] = []
 for k in y.koylular.slice(0, KoyYonetimSahnesi.AZAMI_KOYLU):
  if aday(y, k, &"gunduz"): ids.append(k.id)
 ids.sort()
 return ids.find(id) >= 0 and ids.find(id) < sinir
## Köşeler orman kuşağına komşudur; mevcut ızgara dışına sahte A* yolu yazılmaz.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i, adim: int) -> Dictionary:
 var y := h.sahne.yonetim
 var son := Vector2i(-1, -1)
 var ad := "Orman kenarında kesiyor"
 var bak := h.sahne.alan_merkezi(bas, Vector2i.ONE)
 if adim == 0:
  var koseler := MuhafizDevriyesi.kuleler(y)
  for i in koseler.size():
   var aday_h := h.rotaci.yakin(koseler[posmod(k.id + i, koseler.size())])
   if not h.rotaci.yol(bas, aday_h).is_empty():
    son = aday_h
    var hc: Vector2i = koseler[posmod(k.id + i, koseler.size())]
    bak = h.sahne.alan_merkezi(hc, Vector2i.ONE) + Vector3(-float(AYAR.orman_ofset) if hc.x == 0 else float(AYAR.orman_ofset), 0, -float(AYAR.orman_ofset) if hc.y == 0 else float(AYAR.orman_ofset))
    break
 else:
  var b := hizar(y) if adim == 1 else y.bina(k.is_yeri)
  if b != null:
   bak = h.sahne.alan_merkezi(b.hucre, b.boyut(y.katalog))
   for i in 32:
    var durak := h.rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(y.katalog)), k.id + i)
    if durak.x >= 0 and h.sahne.alan_merkezi(durak, Vector2i.ONE).distance_to(SulamaRutini.kuyu_konumu(h.sahne)) >= float(AYAR.kuyu_guvenlik_mesafe):
     son = durak
     break
  ad = "Hızarda tomruk boşaltıyor" if adim == 1 else "Kampta dinleniyor"
 if son.x < 0 or h.rotaci.yol(bas, son).is_empty(): return {}
 return {"son": son, "ad": ad, "bak": bak}
## Gerçek sağ el bağlantısı; kemiği olmayan fallback yalnız rota görseli kullanır.
func kur(f: KarakterModel) -> void:
 var bulunan := f.find_children("*", "Skeleton3D", true, false)
 if not bulunan.is_empty():
  var sk: Skeleton3D = bulunan[0]
  if sk.find_bone("RightHand") >= 0:
   for c in f.get_children():
    if c is ElEsyasi:
     _eski[c] = c.visible
     c.visible = false
   balta = ElEsyasi.new()
   balta.dik = true
   add_child(balta)
   _balta_gorsel = Node3D.new()
   balta.add_child(_balta_gorsel)
   var boy: Array = AYAR.balta_sap
   _kutu(_balta_gorsel, Vector3(boy[0], boy[1], boy[2]), Vector3(0, 0.15, 0), Color(AYAR.tomruk_renk))
   boy = AYAR.balta_bas
   _kutu(_balta_gorsel, Vector3(boy[0], boy[1], boy[2]), Vector3(0.07, 0.43, 0), Color(AYAR.balta_renk))
   balta.bagla(f, sk, true, f.duzeltici())
   elle = ElEsyasi.olustur("odun")
   add_child(elle)
   elle.bagla(f, sk, true, f.duzeltici())
func _okuz_kur() -> void:
 if Dunya3B.model_var_mi("okuz"):
  okuz = Dunya3B.nesne("okuz", float(AYAR.okuz_boy))
  okuz.position.x = float(AYAR.okuz_yan)
  okuz.rotation_degrees.y = float(AYAR.okuz_donus)
  add_child(okuz)
  yuk = Node3D.new()
  okuz.add_child(yuk)
  for i in int(AYAR.tomruk_sayi):
   var m := MeshInstance3D.new()
   var b := CylinderMesh.new()
   b.top_radius = float(AYAR.tomruk_yaricap)
   b.bottom_radius = b.top_radius
   b.height = float(AYAR.tomruk_boy)
   m.mesh = b
   m.rotation.x = PI / 2
   m.position = Vector3((i - 0.5) * float(AYAR.tomruk_yaricap) * 2, float(AYAR.okuz_boy), 0)
   m.material_override = Dunya3B.duz_malzeme(Color(AYAR.tomruk_renk))
   yuk.add_child(m)
## Görev/faz kalkınca CHR eşyaları eski görünürlüğüne döner.
func kaldir() -> void:
 for e in _eski:
  if is_instance_valid(e): e.visible = bool(_eski[e])
 queue_free()
## İnsan ve öküz aynı mevcut hareket dönüşümünü paylaşır; hayvan çoğaltılmaz.
static func esya(f: KarakterModel, y: KoyYonetimi, id: int, etkin: bool, adim: int) -> void:
 var d := f.get_node_or_null("oduncu_rutini") as OduncuRutini
 if not etkin:
  if d != null and not d.is_queued_for_deletion(): d.kaldir()
  return
 if d != null and d.is_queued_for_deletion(): return
 if d == null:
  d = OduncuRutini.new()
  d.name = "oduncu_rutini"
  f.add_child(d)
  d.kur(f)
 var izin := okuz_ver(y, id)
 if izin and d.okuz == null: d._okuz_kur()
 var hayvanli := izin and d.okuz != null
 d._kesiyor = false
 if d._balta_gorsel != null: d._balta_gorsel.rotation.z = 0.0
 if d.balta != null: d.balta.visible = adim == 0
 if d.elle != null: d.elle.visible = adim == 1 and not hayvanli
 if d.okuz != null: d.okuz.visible = hayvanli and adim != 2
 if d.yuk != null: d.yuk.visible = adim == 1
## Yürürken sallanmaz; orman durağına varınca balta döngüsünü başlatır.
static func varis(f: KarakterModel, kesiyor: bool) -> void:
 var d := f.get_node_or_null("oduncu_rutini") as OduncuRutini
 if d != null and not d.is_queued_for_deletion(): d._kesiyor = kesiyor
func _process(delta: float) -> void:
 if not _kesiyor or _balta_gorsel == null: return
 _zaman += delta
 _balta_gorsel.rotation.z = sin(_zaman * float(AYAR.balta_hiz)) * float(AYAR.balta_salininim)
## Orman kenarı hedeflerinin yanında hazır ağaç görseli; arazi/ekonomi değişmez.
static func orman_kur(s: KoyYonetimSahnesi, kok: Node3D) -> void:
 var var_mi := false
 for k in s.yonetim.koylular:
  if aday(s.yonetim, k, &"gunduz"): var_mi = true
 if not var_mi or not Dunya3B.model_var_mi("agac"): return
 for h in MuhafizDevriyesi.kuleler(s.yonetim):
  var n := Dunya3B.nesne("agac", float(AYAR.agac_boy))
  n.position = s.alan_merkezi(h, Vector2i.ONE) + Vector3(-float(AYAR.orman_ofset) if h.x == 0 else float(AYAR.orman_ofset), 0, -float(AYAR.orman_ofset) if h.y == 0 else float(AYAR.orman_ofset))
  n.position.y = s.arazi.yukseklik_burada(n.position.x, n.position.z)
  kok.add_child(n)
static func _kutu(n: Node3D, boy: Vector3, p: Vector3, renk: Color) -> void:
 var m := MeshInstance3D.new()
 var b := BoxMesh.new()
 b.size = boy
 m.mesh = b
 m.position = p
 m.material_override = Dunya3B.duz_malzeme(renk)
 n.add_child(m)
