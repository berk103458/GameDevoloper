## B1: mühürlü yol tezkiresinin açılması. Metin Label ile gelir, kareye gömülmez.
class_name EvrakAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/ui/kapi/evrak/"
const PLAKA := ["kapali.png", "flap.png", "acik.png"]
const PLAKA_SURE: Array[float] = [0.0, 0.55, 1.35]

var _yazi: Label
var _kayit := ""


static func kagit_mi(metin: String) -> bool:
	var t := metin.to_lower()
	for k in ["kağıt", "kâğıt", "kagit", "ferman", "berat", "tezker", "mektup", "evrak", "parşömen", "parsomen", "yazı"]:
		if t.contains(k):
			return true
	return false


static func olustur(kayit_metni: String = "") -> EvrakAnimasyonu:
	var kareler: Array[Texture2D] = []
	for ad in PLAKA:
		var d := KodluSahneAnimasyonu.doku(KOK + ad)
		if d == null:
			return null
		kareler.append(d)
	var n := EvrakAnimasyonu.new()
	n._plakalar = kareler
	n._plaka_sure = PLAKA_SURE
	n._sure = 2.15
	n._kayit = kayit_metni
	return n


static func oynat(ebeveyn: Control, metin: String = "") -> void:
	if ebeveyn == null:
		return
	if not metin.is_empty() and not kagit_mi(metin):
		return
	var n := olustur(metin)
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, n, KodluSahneAnimasyonu.aninda_mi(ebeveyn))


func _sahne_kur() -> void:
	super._sahne_kur()
	_yazi = Label.new()
	_yazi.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_yazi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_yazi.add_theme_font_size_override("font_size", 26)
	_yazi.add_theme_color_override("font_color", Color(0.20, 0.14, 0.09, 1.0))
	_yazi.text = _kayit
	_yazi.modulate.a = 0.0
	add_child(_yazi)


func _uygula(t: float) -> void:
	_plaka_uygula(t)
	var sz := size if size.x >= 8.0 else Vector2(1152, 864)
	if _yazi:
		_yazi.position = Vector2(sz.x * 0.42, sz.y * 0.38)
		_yazi.size = Vector2(sz.x * 0.32, sz.y * 0.28)
		_yazi.modulate.a = 0.0 if t < 1.55 else clampf((t - 1.55) / 0.32, 0.0, 1.0)
