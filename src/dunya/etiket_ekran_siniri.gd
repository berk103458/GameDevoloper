## Kapı kadrajındaki Label3D'yi ekranın yatay sınırları içinde tutar; kenara taşan etiket
## kamera derinliğini koruyarak içeri kaydırılır, taşmayan etiketin yeri değişmez.
class_name EtiketEkranSiniri
extends Node

const PAY := 12.0

var _etiket: Label3D
var _kamera: Camera3D
var _yerel: Vector3


static func bagla(etiket: Label3D, kamera: Camera3D) -> EtiketEkranSiniri:
	var s := EtiketEkranSiniri.new()
	s.name = "EtiketEkranSiniri"
	s._etiket = etiket
	s._kamera = kamera
	s._yerel = etiket.position
	etiket.add_child(s)
	return s


## Etiketin ekrandaki yarı genişliği (piksel), iki dünya noktasının izdüşümünden.
func yari_genislik() -> float:
	var font := _etiket.font if _etiket.font != null else ThemeDB.fallback_font
	var dunya := font.get_string_size(_etiket.text, HORIZONTAL_ALIGNMENT_LEFT, -1, _etiket.font_size).x * _etiket.pixel_size * 0.5
	var merkez := _etiket.global_position
	var sag := _kamera.global_transform.basis.x.normalized() * dunya
	return absf(_kamera.unproject_position(merkez + sag).x - _kamera.unproject_position(merkez).x)


func _process(_delta: float) -> void:
	sinirla()


func sinirla() -> void:
	if _etiket == null or _kamera == null or not is_instance_valid(_kamera) or not _etiket.is_inside_tree():
		return
	_etiket.position = _yerel
	var merkez := _etiket.global_position
	if _kamera.is_position_behind(merkez):
		return
	var ekran := _kamera.unproject_position(merkez)
	var genislik := _kamera.get_viewport().get_visible_rect().size.x
	var yari := yari_genislik()
	var x := clampf(ekran.x, yari + PAY, maxf(yari + PAY, genislik - yari - PAY))
	if is_equal_approx(x, ekran.x):
		return
	var derinlik := -(_kamera.global_transform.affine_inverse() * merkez).z
	_etiket.global_position = _kamera.project_position(Vector2(x, ekran.y), derinlik)
