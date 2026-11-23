## B8: tansiyon eşiğinde çatlak; döngü değil. Origin tansiyon_catlak kareleri + sarsıntı.
class_name TansiyonCatlamasiAnimasyonu
extends KodluSahneAnimasyonu

const KOK := "res://assets/art/anim/"
const ADET := 4

var _ikon: TextureRect
var _kareler: Array[Texture2D] = []
var _toz: Array[ColorRect] = []


static func olustur() -> TansiyonCatlamasiAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler_on_ekli(KOK, "tansiyon_catlak_", ADET)
	if kareler.size() < 2:
		return null
	var n := TansiyonCatlamasiAnimasyonu.new()
	n._kareler = kareler
	n._sure = 1.15
	n._perde_alfa = 0.28
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	if KodluSahneAnimasyonu.aninda_mi(ebeveyn):
		return
	KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), false)


func _sahne_kur() -> void:
	_ikon = TextureRect.new()
	_ikon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ikon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_ikon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_ikon.size = Vector2(280, 280)
	if not _kareler.is_empty():
		_ikon.texture = _kareler[0]
	add_child(_ikon)
	for i in 6:
		var t := ColorRect.new()
		t.mouse_filter = Control.MOUSE_FILTER_IGNORE
		t.color = Color(0.75, 0.55, 0.25, 0.0)
		t.size = Vector2(5, 5)
		add_child(t)
		_toz.append(t)


func _uygula(t: float) -> void:
	var sz := size if size.x >= 8.0 else Vector2(1280, 720)
	var idx := clampi(int(t / 0.16), 0, _kareler.size() - 1)
	if t > 0.55:
		idx = _kareler.size() - 1
	if _ikon and idx < _kareler.size():
		_ikon.texture = _kareler[idx]
		var sars := Vector2.ZERO
		if t < 0.28:
			var amp := 8.0 * (1.0 - t / 0.28)
			sars = Vector2(amp * sin(t * 80.0), amp * 0.4 * cos(t * 66.0))
		_ikon.position = Vector2(sz.x * 0.5 - 140, sz.y * 0.42) + sars
	for i in _toz.size():
		var u := clampf((t - 0.08) / 0.70, 0.0, 1.0)
		var ang := float(i) * TAU / 6.0 + 0.4
		var dist := 20.0 + 70.0 * KodluSahneAnimasyonu.ease_out(u)
		_toz[i].position = Vector2(sz.x * 0.5, sz.y * 0.50) + Vector2(cos(ang), sin(ang)) * dist
		_toz[i].color.a = 0.0 if t < 0.08 else (0.7 * (1.0 - u))
		_toz[i].size = Vector2(4 + 6 * u, 4 + 6 * u)
