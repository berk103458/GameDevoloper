## ANI-08: mevcut üretime bağlı el aleti/tezgâh yer tutucuları; asset dosyası üretmez.
class_name ZanaatTezgahi
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/zanaat_tezgahi.json"))
var alet: ElEsyasi
var _eski: Dictionary = {}
var _tur := ""
var _uc: Node3D
var _karakter: KarakterModel
var _ekipman: KarakterEkipmanYoneticisi
## Mevcut hazır zanaat binasının fiziksel gündüz çalışanı.
static func aday(y: KoyYonetimi, k: Koylu, faz: StringName) -> bool:
 if k == null or faz != &"gunduz": return false
 var b := y.bina(k.is_yeri)
 return b != null and b.hazir() and AYAR.turler.has(b.tur) and YasRolleri.fiziksel(k, b.tur) and not ZanaatKazalari.durur(k) and not MeslekGrevi.aktif(k, y) and not IsMemnuniyeti.isyanci(k, y)
## Gerçek seçili reçete girdisi/depo/kan davası engeli; üretim tüketmez.
static func aktif(y: KoyYonetimi, k: Koylu) -> bool:
 var b := y.bina(k.is_yeri)
 if b == null or KanDavasi.engel(y, b.id) or y.kaynaklar.toplam() >= y.kaynaklar.kapasite: return false
 var r: Dictionary = y.katalog.receteler(b.tur).get(b.recete, {})
 if r.is_empty(): return false
 for tur in r.get("girdi", {}):
  if y.kaynaklar.miktar(tur) < int(r.girdi[tur]): return false
 return true
## Mevcut A* ile tezgâh ön durağı; kapalı durakta hareket başlatılmaz.
static func hedef(h: KoyHalkHareketi, k: Koylu, bas: Vector2i) -> Dictionary:
 var b := h.sahne.yonetim.bina(k.is_yeri)
 var boy := b.boyut(h.sahne.yonetim.katalog)
 var son := b.hucre + Vector2i(boy.x - 1, boy.y)
 if h.rotaci.yol(bas, son).is_empty(): return {}
 return {"son": son, "bak": h.sahne.alan_merkezi(b.hucre, boy) + Vector3((boy.x - 1) * h.sahne.HUCRE / 2, 0, boy.y * h.sahne.HUCRE / 2)}
## Tek noktadan değiştirilebilen düz renk kutu örs/fırın yer tutucusu.
static func kur(n: Node3D, tur: String, en: float, derin: float) -> void:
 if not AYAR.turler.has(tur): return
 var f: bool = AYAR.turler[tur] == "pisir"
 if not f:
  var ors := HazirEsyaHayvan.esya("ors", Vector3(AYAR.ors_boy[0], AYAR.ors_boy[1], AYAR.ors_boy[2]))
  if ors != null:
   ors.position = Vector3((en - KoyYonetimSahnesi.HUCRE) / 2, 0, derin / 2)
   n.add_child(ors)
   return
 var mesh := _kutu(AYAR.firin_boy if f else AYAR.ors_boy, Color(AYAR.tugla if f else AYAR.demir))
 mesh.name = "zanaat_tezgahi_yer_tutucu"
 mesh.position = Vector3((en - KoyYonetimSahnesi.HUCRE) / 2, mesh.mesh.size.y / 2, derin / 2)
 n.add_child(mesh)
func _kur(f: KarakterModel, tur: String) -> bool:
 var sks := f.find_children("*", "Skeleton3D", true, false)
 if sks.is_empty(): return false
 var sk: Skeleton3D = sks[0]
 if sk.find_bone("RightHand") < 0: return false
 for c in f.get_children():
  if c is ElEsyasi:
   _eski[c] = c.visible
   c.visible = false
 _tur = tur
 _karakter = f
 alet = ElEsyasi.new()
 alet.name = "zanaat_aleti_yer_tutucu"
 alet.dik = true
 add_child(alet)
 _uc = Node3D.new()
 _uc.name = "alet_uc"
 alet.add_child(_uc)
 var hazir_cekic := HazirEsyaHayvan.esya("cekic") if AYAR.turler[tur] != "pisir" else null
 if hazir_cekic != null:
  hazir_cekic.position.y = -float(AYAR.sap_boy[1])
  _uc.add_child(hazir_cekic)
 else:
  var sap := _kutu(AYAR.sap_boy, Color(AYAR.ahsap))
  sap.position.y = -float(AYAR.sap_boy[1]) / 2
  _uc.add_child(sap)
  var pisir: bool = AYAR.turler[tur] == "pisir"
  var bas := _kutu(AYAR.kurek_boy if pisir else AYAR.cekic_boy, Color(AYAR.ahsap if pisir else AYAR.demir))
  bas.position.y = -float(AYAR.sap_boy[1])
  _uc.add_child(bas)
 _ekipman = KarakterEkipmanYoneticisi.al(f)
 if _ekipman == null: return false
 alet = _ekipman.tak(tur, alet, self)
 _uc = alet.get_node("alet_uc")
 _uc.transform = Transform3D.IDENTITY
 if AYAR.turler[tur] != "pisir":
  var ses = preload("res://src/ses/hazir_ors_sesi.gd").new()
  ses.karakter = f
  add_child(ses)
 return true
func _exit_tree() -> void:
 if is_instance_valid(_ekipman): _ekipman.depoladir(self)
func _process(_delta: float) -> void:
 if _karakter == null or _uc == null: return
 var d := _karakter.duzeltici()
 if d == null: return
 var t := d._zaman + d.faz
 if d.surekli == &"dov": _uc.rotation.x = sin(t * float(AYAR.vurus_hizi)) * float(AYAR.cekic_aci)
 elif d.surekli == &"pisir":
  _uc.rotation.x = float(AYAR.kurek_aci)
  _uc.position.z = sin(t * float(AYAR.kurek_hizi)) * float(AYAR.kurek_ilerleme)
## Görev/faz değişiminde özgün CHR eşyasını geri verir; tek alet kurar.
static func esya(f: KarakterModel, tur: String) -> void:
 var d := f.get_node_or_null("zanaat_tezgahi") as ZanaatTezgahi
 if tur.is_empty():
  if d != null and not d.is_queued_for_deletion():
   for e in d._eski:
    if is_instance_valid(e): e.visible = bool(d._eski[e])
   d.queue_free()
  return
 if d != null and d._tur != tur:
  esya(f, "")
  f.remove_child(d)
  d = null
 if d != null: return
 d = ZanaatTezgahi.new()
 d.name = "zanaat_tezgahi"
 f.add_child(d)
 if not d._kur(f, tur): d.queue_free()
## Mevcut iskelet değiştiricisinde çekiç/kürek kol döngüsü; ayrı klip dosyası yok.
static func kol(yan: float, zaman: float, hareket: StringName) -> Array[Vector3]:
 if hareket == &"pisir":
  var s := sin(zaman * float(AYAR.kurek_hizi)) * float(AYAR.kurek_genlik)
  return [Vector3(yan * AYAR.pisir_kol[0], AYAR.pisir_kol[1], AYAR.pisir_kol[2]), Vector3(yan * AYAR.pisir_onkol[0], AYAR.pisir_onkol[1], AYAR.pisir_onkol[2] + s)]
 var s := sin(zaman * float(AYAR.vurus_hizi)) * float(AYAR.vurus_genlik)
 if yan < 0: return [Vector3(AYAR.dov_sag_kol[0], AYAR.dov_sag_kol[1] + s, AYAR.dov_sag_kol[2]), Vector3(AYAR.dov_sag_onkol[0], AYAR.dov_sag_onkol[1] + s, AYAR.dov_sag_onkol[2])]
 return [Vector3(AYAR.dov_sol_kol[0], AYAR.dov_sol_kol[1], AYAR.dov_sol_kol[2]), Vector3(AYAR.dov_sol_onkol[0], AYAR.dov_sol_onkol[1], AYAR.dov_sol_onkol[2])]
static func _kutu(boy: Array, renk: Color) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 var b := BoxMesh.new()
 b.size = Vector3(boy[0], boy[1], boy[2])
 m.mesh = b
 m.material_override = Dunya3B.duz_malzeme(renk)
 return m
