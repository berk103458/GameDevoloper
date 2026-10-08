## ANI-14: mevcut köylü seçiminin kamerası ve tek salt okunur 3B durum etiketi.
class_name KoyluTakibi
extends Node3D
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koylu_takibi.json"))
var sahne: KoyYonetimSahnesi
var kisi := -1
var takip := false
var etiket: Label3D

## Mevcut kart seçimine bağlanır; sahne sınırı dışındaki kişi için takip kurulmaz.
static func sec(s: KoyYonetimSahnesi, id: int) -> void:
 if not is_instance_valid(s) or not is_instance_valid(s.halk_hareketi) or not s.halk_hareketi.modeller.has(id): return
 var n := s.get_node_or_null("koylu_takibi") as KoyluTakibi
 if n == null:
  n = KoyluTakibi.new()
  n.name = "koylu_takibi"
  n.sahne = s
  s.add_child(n)
 n.kisi = id
 n.takip = true
 s.uzaklik = minf(s.uzaklik, float(AYAR.kamera_uzaklik))
 n.guncelle()

## Sağ tık veya kaldırılan kişi: yüzen etiketi kapatır; kamera bulunduğu yerde kalır.
static func temizle(s: KoyYonetimSahnesi) -> void:
 if not is_instance_valid(s): return
 var n := s.get_node_or_null("koylu_takibi") as KoyluTakibi
 if n != null:
  n.kisi = -1
  n.takip = false
  n.etiket.visible = false

## Yerleştirme/yıkım sırasında hareketli kamerayla hedef kaymasını önler.
static func kip(s: KoyYonetimSahnesi, ad: String) -> void:
 if not ad.is_empty(): temizle(s)

func _ready() -> void:
 etiket = Label3D.new()
 etiket.name = "koylu_durum_etiketi"
 etiket.font = Tema.font(600)
 etiket.font_size = int(AYAR.font_size)
 etiket.pixel_size = float(AYAR.pixel_size)
 etiket.outline_size = int(AYAR.outline_size)
 etiket.billboard = BaseMaterial3D.BILLBOARD_ENABLED
 etiket.fixed_size = true
 etiket.no_depth_test = false
 etiket.visible = false
 add_child(etiket)

func _process(_delta: float) -> void:
 var odak := get_tree().root.gui_get_focus_owner()
 if not (odak is LineEdit or odak is TextEdit):
  for tus in [KEY_W, KEY_A, KEY_S, KEY_D, KEY_Q, KEY_E, KEY_ESCAPE]:
   if Input.is_physical_key_pressed(tus): takip = false
 guncelle()

## Yalnız ad/zanaat ve mevcut görsel eylem okunur; atama, kayıt veya RNG değiştirmez.
func guncelle() -> void:
 if kisi < 0: return
 var k := sahne.yonetim.koylu(kisi)
 var f := sahne.halk_hareketi.modeller.get(kisi) as KarakterModel
 if k == null or not is_instance_valid(f) or f.is_queued_for_deletion():
  temizle(sahne)
  return
 etiket.global_position = f.global_position + Vector3.UP * float(AYAR.etiket_yukseklik)
 etiket.text = "%s · %s\n%s" % [TranslationServer.translate(k.ad), ZanaatTuru.ad(k.zanaat_turu), sahne.halk_hareketi.eylem(kisi)]
 etiket.visible = not sahne.kamera.is_position_behind(etiket.global_position)
 if takip:
  sahne.hedef = f.position
  sahne._kamera_yerlestir()
