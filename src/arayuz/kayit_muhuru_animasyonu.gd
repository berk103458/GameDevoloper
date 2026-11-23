## B6: resmi mum mührün kayıt kâğıdına basılması. Yazı yok, yalan mühründen sakin.
class_name KayitMuhuruAnimasyonu
extends KodluSahneAnimasyonu

const KAGIT := "res://assets/ui/koy/kayit_muhuru/masa.png"
const MUHUR := "res://assets/ui/koy/kayit_muhuru/muhur.png"

var _muhur: TextureRect
var _kagit_tr: TextureRect


static func olustur() -> KayitMuhuruAnimasyonu:
	if KodluSahneAnimasyonu.doku(KAGIT) == null or KodluSahneAnimasyonu.doku(MUHUR) == null:
		return null
	var n := KayitMuhuruAnimasyonu.new()
	n._sure = 1.55
	n._perde_alfa = 0.50
	return n


static func oynat(ebeveyn: Control) -> void:
	if ebeveyn == null:
		return
	# Beklemeden de çalışır (kayıt yazımı senkron).
	KodluSahneAnimasyonu.oynat_uzerinde(ebeveyn, olustur(), KodluSahneAnimasyonu.aninda_mi(ebeveyn))


static func muhur_ornek(t: float) -> Dictionary:
	var u := clampf(t / 0.72, 0.0, 1.0)
	var y := lerpf(-0.28, 0.0, u * u)  # hızlanarak iner
	var squash := 1.0
	var sars := 0.0
	var parilti := 0.0
	if t >= 0.72 and t < 0.90:
		var d := (t - 0.72) / 0.18
		squash = lerpf(0.78, 1.0, d)
		sars = 6.0 * (1.0 - d)
		parilti = 1.0 - d
	return {"y": y, "olcek": 1.0 + (0.18 if u < 1.0 else 0.0) * (1.0 - u), "squash": squash, "sars": sars, "parilti": parilti}


func _sahne_kur() -> void:
	_kagit_tr = _katman(KodluSahneAnimasyonu.doku(KAGIT))
	add_child(_kagit_tr)
	_muhur = TextureRect.new()
	_muhur.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_muhur.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_muhur.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_muhur.texture = KodluSahneAnimasyonu.doku(MUHUR)
	_muhur.size = Vector2(128, 128)
	add_child(_muhur)


func _uygula(t: float) -> void:
	var s := muhur_ornek(t)
	var sz := size if size.x >= 8.0 else Vector2(1152, 864)
	# hedef: kâğıdın sağ-alt köşesi (masa.png'deki mum yeri)
	var hx := sz.x * 0.62
	var hy := sz.y * 0.58
	if _kagit_tr:
		_kagit_tr.position = Vector2(s["sars"] * sin(t * 55.0), 0)
	if _muhur:
		_muhur.scale = Vector2(float(s["olcek"]), float(s["olcek"]) * float(s["squash"]))
		_muhur.position = Vector2(hx - 64.0, hy - 64.0 + sz.y * float(s["y"]))
		_muhur.modulate = Color(1, 1, 1, 1).lerp(Color(1.0, 0.92, 0.75, 1.0), float(s["parilti"]) * 0.6)
