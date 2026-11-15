class_name CatiKarRutini
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/cati_kar_rutini.json"))
var _eski := {}
var _kurek: ElEsyasi
var _yonetici: KarakterEkipmanYoneticisi
var _karakter: KarakterModel
## Mevcut A* ile çatı dışına gider; ekonomi yalnız gerçek gece çözümündedir.
static func hedef(h: KoyHalkHareketi, k: Koylu, d: Dictionary, bas: Vector2i, normal: Vector2i) -> Vector2i:
 var f: KarakterModel = h.modeller[k.id]
 var gorev := CatiKarBakimi.gorevler(h.sahne.yonetim, h.rotaci)
 var son := normal
 var etkin := h.faz_adi == &"gunduz" and gorev.has(k.id)
 if etkin:
  var b := h.sahne.yonetim.bina(int(gorev[k.id]))
  son = h.rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(h.sahne.yonetim.katalog)), k.id)
  etkin = son.x >= 0 and not h.rotaci.yol(bas, son).is_empty()
  if etkin:
   for alan in ["is", "dinlen", "siginma", "sinsi", "ates_basi", "coban", "zanaat", "sulama", "oduncu", "degirmenci"]: d[alan] = false
   d.devriye = true
   d.devriye_ad = "Çatı karını kürekle temizliyor"
   d.bak = h.sahne.alan_merkezi(b.hucre, b.boyut(h.sahne.yonetim.katalog))
 esya(f, etkin)
 return son if etkin else normal
## Tek gerçek RightHand soketi ve düz kutu kürek; eksik kemikte sahte soket yok.
static func esya(f: KarakterModel, etkin: bool) -> void:
 var mevcut := f.get_node_or_null("cati_kar_rutini") as CatiKarRutini
 if not etkin:
  if mevcut != null and not mevcut.is_queued_for_deletion(): mevcut.kaldir()
  return
 if mevcut != null: return
 var yonetici := KarakterEkipmanYoneticisi.al(f)
 if yonetici == null: return
 var r := CatiKarRutini.new()
 r.name = "cati_kar_rutini"
 r._karakter = f
 r._yonetici = yonetici
 f.add_child(r)
 var yeni := ElEsyasi.new()
 r.add_child(yeni)
 r._kurek = yeni
 for c in f.get_children():
  if c is ElEsyasi:
   r._eski[c] = c.visible
   c.visible = false
 if Dunya3B.model_var_mi("kurek"):
  var glb_kurek := Dunya3B.nesne("kurek", 1.1)
  yeni.add_child(glb_kurek)
 else:
  for alan in ["sap", "agiz"]:
   var mesh := MeshInstance3D.new()
   var kutu := BoxMesh.new()
   var boy: Array = AYAR[alan]
   kutu.size = Vector3(boy[0], boy[1], boy[2])
   mesh.mesh = kutu
   mesh.material_override = Dunya3B.duz_malzeme(Color("#705035") if alan == "sap" else Color("#9ca4ab"))
   mesh.position.y = 0.3 if alan == "sap" else 0.65
   yeni.add_child(mesh)
 r._kurek = yonetici.tak("kar_kuregi", yeni, r)
## Faz/görev bitince eski CHR eşya görünürlüğü döner.
func kaldir() -> void:
 if is_instance_valid(_yonetici): _yonetici.depoladir(self)
 for e in _eski:
  if is_instance_valid(e): e.visible = bool(_eski[e])
 queue_free()
func _process(_delta: float) -> void:
 if _kurek != null and is_instance_valid(_karakter): _kurek.global_basis = _karakter.global_basis.orthonormalized() * Basis(Vector3.RIGHT, sin(Time.get_ticks_msec() * 0.001 * float(AYAR.hiz)) * float(AYAR.genlik))
