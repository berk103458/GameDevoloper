## C5: perde sonu defteri kapanır ve mühürlenir (A6 açılışının tersi). Özet Label'dır.
class_name PerdeDefteriAnimasyonu
extends KodluSahneAnimasyonu

const PLAKALAR: Array[String] = [
	"res://assets/ui/koy/sabah_defteri/acik.png",
	"res://assets/ui/koy/sabah_defteri/kapali.png",
	"res://assets/ui/koy/perde_defteri/muhurlu.png",
]
const PLAKA_SURE: Array[float] = [0.0, 1.20, 2.10]

var _yazi: Label
var _satirlar: PackedStringArray = PackedStringArray()


static func olustur(satirlar: PackedStringArray = PackedStringArray()) -> PerdeDefteriAnimasyonu:
	var n := PerdeDefteriAnimasyonu.new()
	for yol in PLAKALAR:
		var d := KodluSahneAnimasyonu.doku(yol)
		if d == null:
			return null
		n._plakalar.append(d)
	n._plaka_sure = PLAKA_SURE.duplicate()
	n._sure = 3.05
	n._perde_alfa = 0.56
	n._satirlar = satirlar
	return n


static func oynat(ebeveyn: Control, satirlar: PackedStringArray = PackedStringArray()) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(satirlar), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _sahne_kur() -> void:
	super._sahne_kur()
	_yazi = Label.new()
	_yazi.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_yazi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_yazi.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	_yazi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_yazi.text = "\n".join(_satirlar)
	_yazi.add_theme_font_size_override("font_size", 22)
	_yazi.add_theme_color_override("font_color", Color(0.90, 0.87, 0.78, 1.0))
	_yazi.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.7))
	_yazi.add_theme_constant_override("shadow_offset_y", 2)
	_yazi.set_anchors_preset(Control.PRESET_FULL_RECT)
	_yazi.offset_left = 80
	_yazi.offset_right = -80
	_yazi.offset_top = 0
	_yazi.offset_bottom = -48
	_yazi.modulate.a = 0.0
	add_child(_yazi)


static func yazi_alfa(t: float) -> float:
	# mühür oturduktan sonra satırlar belirir
	return clampf((t - 2.15) / 0.45, 0.0, 1.0)


func _uygula(t: float) -> void:
	_plaka_uygula(t)
	if _yazi != null:
		_yazi.modulate.a = yazi_alfa(t)
