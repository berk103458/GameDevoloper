## ANI-11: mevcut zanaat aletinin tek kemik soketi ve salt görsel stok sahibi.
class_name KarakterEkipmanYoneticisi
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/karakter_ekipman.json"))
var soket: BoneAttachment3D
var depo: Node3D
var stok: Dictionary = {}
var _karakter: KarakterModel
var _iskelet: Skeleton3D
var _aktif: ElEsyasi
var _sahip: Node
## Aynı modele tek yönetici; gerçek el kemiği yoksa eski fallback güvenle korunur.
static func al(f: KarakterModel) -> KarakterEkipmanYoneticisi:
 var mevcut := f.get_node_or_null("karakter_ekipman_yoneticisi") as KarakterEkipmanYoneticisi
 if mevcut != null: return mevcut
 var sks := f.find_children("*", "Skeleton3D", true, false)
 if sks.is_empty() or not f.is_inside_tree(): return null
 var sk: Skeleton3D = sks[0]
 if sk.find_bone(AYAR.el) < 0: return null
 var d := KarakterEkipmanYoneticisi.new()
 d.name = "karakter_ekipman_yoneticisi"
 d._karakter = f
 d._iskelet = sk
 f.add_child(d)
 d.depo = Node3D.new()
 d.depo.name = "gorsel_alet_stogu"
 d.add_child(d.depo)
 d.soket = BoneAttachment3D.new()
 d.soket.name = "zanaat_el_soketi"
 d.add_child(d.soket)
 d.soket.external_skeleton = d.soket.get_path_to(sk)
 d.soket.use_external_skeleton = true
 d.soket.bone_name = AYAR.el
 d.soket.override_pose = false
 sk.skeleton_updated.connect(d._guncelle)
 return d
## Yeni yer tutucuyu kabul eder veya aynı türün saklanmış nesnesini geri kullanır.
func tak(tur: String, yeni: ElEsyasi, sahip: Node) -> ElEsyasi:
 if not AYAR.turler.has(tur): return null
 if _aktif != null: depoladir(_sahip)
 var anahtar: String = AYAR.turler[tur]
 if stok.has(anahtar):
  _aktif = stok[anahtar]
  if yeni != _aktif: yeni.queue_free()
 else:
  stok[anahtar] = yeni
  _aktif = yeni
 _sahip = sahip
 _aktif.reparent(soket, false)
 _aktif.top_level = true
 _aktif.visible = true
 _guncelle()
 return _aktif
## Mola/gece/görev kalkışı aynı nesneyi gizli stoka taşır; ekonomik alet sayısı değişmez.
func depoladir(sahip: Node) -> void:
 if _aktif == null or sahip != _sahip: return
 if is_instance_valid(_aktif):
  _aktif.visible = false
  _aktif.reparent(depo, false)
  _aktif.top_level = false
 _aktif = null
 _sahip = null
func _guncelle() -> void:
 if not is_instance_valid(_aktif) or not is_instance_valid(_iskelet) or not is_inside_tree(): return
 # BoneAttachment3D kemik dönüşünü kopyalar; override kapalı, modifier pozu ezilmez.
 soket.on_skeleton_update()
 var avuc: Variant = null
 var d := _karakter.duzeltici()
 if d != null: avuc = d.avuc(AYAR.el)
 if avuc != null:
  _aktif.global_position = soket.global_transform * (avuc as Vector3)
 else:
  var bilek := soket.global_position
  var dirsek: Vector3 = _iskelet.global_transform * _iskelet.get_bone_global_pose(_iskelet.find_bone(AYAR.onkol)).origin if _iskelet.find_bone(AYAR.onkol) >= 0 else bilek + Vector3.UP
  _aktif.global_position = bilek + (bilek - dirsek).normalized() * float(AYAR.avuc)
 # Meshy el eksenleri farklıdır: tutma noktası kemikte, yön mevcut karakter yaw'ında.
 var ileri := -_karakter.global_basis.z
 ileri.y = 0.0
 ileri = ileri.normalized() if ileri.length() > 0.01 else Vector3.FORWARD
 _aktif.global_basis = Basis(Vector3.UP.cross(ileri).normalized(), Vector3.UP, -ileri)
