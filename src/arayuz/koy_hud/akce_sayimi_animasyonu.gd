## B5: kese açılır, akçe iki yığına seker. Origin kese_sikkesi kareleri + kodlu fizik.
class_name AkceSayimiAnimasyonu
extends KodluSahneAnimasyonu

const KESE_KOK := "res://assets/art/anim/"
const AKCE_YOL := "res://assets/ui/koy/akce_sayimi/akce.png"
const KESE_ADET := 4
const PARA_ADET := 10

var _kese: TextureRect
var _paralar: Array[TextureRect] = []
var _kese_kare: Array[Texture2D] = []
var _tohum := 11


static func olustur(tohum: int = 11) -> AkceSayimiAnimasyonu:
	var kareler := KareAnimasyonKabuk.yukle_kareler_on_ekli(KESE_KOK, "kese_sikkesi_", KESE_ADET)
	if kareler.size() < 2:
		return null
	if KodluSahneAnimasyonu.doku(AKCE_YOL) == null:
		return null
	var n := AkceSayimiAnimasyonu.new()
	n._kese_kare = kareler
	n._tohum = tohum
	n._sure = 1.95
	n._perde_alfa = 0.62
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	await KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


static func para_ornek(i: int, t: float, tohum: int = 11) -> Dictionary:
	var r := RandomNumberGenerator.new()
	r.seed = tohum + i * 17
	var sol := i < PARA_ADET / 2
	var x0 := 0.50
	var y0 := 0.46
	var vx := (-0.28 if sol else 0.28) + r.randf_range(-0.08, 0.08)
	var vh := 0.55 + r.randf() * 0.45
	var gecik := 0.22 + i * 0.045
	var yerel := maxf(t - gecik, 0.0)
	var g := 2.8
	# iniş + 2 sekişme
	var h := vh * yerel - 0.5 * g * yerel * yerel
	var x := x0 + vx * yerel
	var y := y0
	var taban := 0.62 + r.randf_range(-0.03, 0.03)
	if h < 0.0:
		# sekişme 1
		var t1 := (vh + sqrt(maxf(vh * vh, 0.0))) / g
		var rest := 0.42
		var yerel2 := yerel - t1
		var vh2 := vh * rest
		h = vh2 * yerel2 - 0.5 * g * yerel2 * yerel2
		y = taban
		if h < 0.0:
			var t2 := t1 + (vh2 + sqrt(maxf(vh2 * vh2, 0.0))) / g
			var yerel3 := yerel - t2
			var vh3 := vh2 * 0.35
			h = vh3 * yerel3 - 0.5 * g * yerel3 * yerel3
			if h < 0.0:
				h = 0.0
	else:
		y = taban
	# hedef yığın x
	var hedef := (0.38 if sol else 0.62)
	var kar := clampf(yerel / 0.85, 0.0, 1.0)
	x = lerpf(x0 + vx * yerel, hedef + r.randf_range(-0.03, 0.03), KodluSahneAnimasyonu.ease_out(kar) * 0.55)
	return {"x": x, "y": y - maxf(h, 0.0) * 0.28, "h": maxf(h, 0.0), "gorunur": t >= gecik}


func _sahne_kur() -> void:
	_kese = TextureRect.new()
	_kese.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_kese.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_kese.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_kese.custom_minimum_size = Vector2(280, 280)
	_kese.size = Vector2(280, 280)
	if not _kese_kare.is_empty():
		_kese.texture = _kese_kare[0]
	add_child(_kese)
	var akce := KodluSahneAnimasyonu.doku(AKCE_YOL)
	for i in PARA_ADET:
		var p := TextureRect.new()
		p.mouse_filter = Control.MOUSE_FILTER_IGNORE
		p.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		p.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		p.texture = akce
		p.size = Vector2(36, 36)
		p.visible = false
		add_child(p)
		_paralar.append(p)


func _uygula(t: float) -> void:
	var sz := size if size.x >= 8.0 else Vector2(1280, 720)
	# kese kareleri ağır geçiş: 0, 0.18, 0.40, 0.70
	var idx := 0
	if t >= 0.70:
		idx = mini(3, _kese_kare.size() - 1)
	elif t >= 0.40:
		idx = mini(2, _kese_kare.size() - 1)
	elif t >= 0.18:
		idx = mini(1, _kese_kare.size() - 1)
	if _kese and idx < _kese_kare.size():
		_kese.texture = _kese_kare[idx]
		_kese.position = Vector2(sz.x * 0.50 - 140, sz.y * 0.32)
	for i in _paralar.size():
		var s := para_ornek(i, t, _tohum)
		_paralar[i].visible = bool(s["gorunur"])
		_paralar[i].position = Vector2(sz.x * float(s["x"]) - 18, sz.y * float(s["y"]) - 18)
