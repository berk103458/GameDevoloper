## Heybe eşyalarının kodla çizilen simgeleri. `ciz(ci, id, merkez, r)`: r yaklaşık yarıçap (px).
## Sanat gelirse aynı id ile doku konabilir; çizim yer tutucudur.
class_name EsyaSimgesi
extends RefCounted

const MUREKKEP := Color("#0b0c10")
const GUMUS := Color("#c9ced6")
const GUMUS_KOYU := Color("#8a929e")
const CUVAL := Color("#b39b72")
const CUVAL_KOYU := Color("#7d6a4b")
const EKMEK := Color("#b07a3e")
const BAKIR := Color("#b8683a")
const KUMAS := Color("#6e3b3b")
const DERI := Color("#5a3a26")
const AHSAP := Color("#7a5634")
const DEMIR := Color("#9aa3ad")
const CAM := Color("#7fa3b8")
const ALTIN_TAS := Color("#c4843a")


static func ciz(ci: CanvasItem, id: String, m: Vector2, r: float, adet: int = 1) -> void:
	match id:
		"akce":
			_akce(ci, m, r, adet)
		"arpa":
			_cuval(ci, m, r, CUVAL, true)
		"tohum":
			_kese(ci, m, r * 0.85, CUVAL_KOYU, Color("#d9c27a"))
		"ekmek":
			_ekmek(ci, m, r)
		"tuz":
			_kese(ci, m, r * 0.85, DERI, Color("#eeeeea"))
		"kumas":
			_kumas(ci, m, r)
		"bakir":
			_tas(ci, m, r)
		"ok":
			_ok(ci, m, r)
		"hancer":
			_hancer(ci, m, r)
		"ilac":
			_sise(ci, m, r)
		"yuzuk":
			_yuzuk(ci, m, r)
		_:
			ci.draw_circle(m, r * 0.6, GUMUS_KOYU)


static func _kontur(ci: CanvasItem, n: PackedVector2Array, k: float = 2.0) -> void:
	var c := n.duplicate()
	c.append(n[0])
	ci.draw_polyline(c, MUREKKEP, k, true)


static func _elips(m: Vector2, rx: float, ry: float, adim: int = 24) -> PackedVector2Array:
	var n := PackedVector2Array()
	for i in adim:
		var a := TAU * i / adim
		n.append(m + Vector2(cos(a) * rx, sin(a) * ry))
	return n


## Akçe: gümüş sikke yığını; adet arttıkça yığın büyür (en çok 7 sikke çizilir).
static func _akce(ci: CanvasItem, m: Vector2, r: float, adet: int) -> void:
	var yigin := clampi(1 + adet / 3, 1, 7)
	var rx := r * 0.62
	var ry := r * 0.24
	var taban := m + Vector2(0, r * 0.45)
	for i in yigin:
		var c := taban - Vector2(((i * 37) % 5 - 2) * 0.6, i * r * 0.16)
		var yan := _elips(c + Vector2(0, ry * 0.5), rx, ry)
		ci.draw_colored_polygon(yan, GUMUS_KOYU)
		var ust := _elips(c, rx, ry)
		ci.draw_colored_polygon(ust, GUMUS)
		_kontur(ci, ust, 1.5)
	# Üstteki sikkenin kare zımbası (akçenin damgası).
	var tepe := taban - Vector2(0, (yigin - 1) * r * 0.16)
	ci.draw_rect(Rect2(tepe - Vector2(rx * 0.22, ry * 0.3), Vector2(rx * 0.44, ry * 0.6)), GUMUS_KOYU, false, 1.5)
	if adet > 7:
		var yan2 := m + Vector2(r * 0.55, r * 0.5)
		for i in mini(adet / 6, 4):
			var c := yan2 - Vector2(0, i * r * 0.14)
			var u := _elips(c, rx * 0.7, ry * 0.7)
			ci.draw_colored_polygon(u, GUMUS)
			_kontur(ci, u, 1.2)


static func _cuval(ci: CanvasItem, m: Vector2, r: float, renk: Color, bagli: bool) -> void:
	var n := PackedVector2Array([m + Vector2(-r * 0.3, -r * 0.7), m + Vector2(r * 0.3, -r * 0.7), m + Vector2(r * 0.55, -r * 0.2),
		m + Vector2(r * 0.7, r * 0.5), m + Vector2(r * 0.45, r * 0.8), m + Vector2(-r * 0.45, r * 0.8), m + Vector2(-r * 0.7, r * 0.5),
		m + Vector2(-r * 0.55, -r * 0.2)])
	ci.draw_colored_polygon(n, renk)
	_kontur(ci, n)
	if bagli:
		ci.draw_line(m + Vector2(-r * 0.32, -r * 0.5), m + Vector2(r * 0.32, -r * 0.5), MUREKKEP, 3.0, true)
		# Ağızdan taşan başaklar.
		for i in 3:
			var x := (i - 1) * r * 0.16
			ci.draw_line(m + Vector2(x, -r * 0.7), m + Vector2(x * 1.6, -r * 0.98), Color("#d9c27a"), 2.0, true)
	ci.draw_line(m + Vector2(-r * 0.3, r * 0.2), m + Vector2(r * 0.25, r * 0.35), Color(MUREKKEP, 0.4), 1.5, true)


static func _kese(ci: CanvasItem, m: Vector2, r: float, renk: Color, ic: Color) -> void:
	var g := _elips(m + Vector2(0, r * 0.2), r * 0.62, r * 0.6)
	ci.draw_colored_polygon(g, renk)
	_kontur(ci, g)
	var agiz := PackedVector2Array([m + Vector2(-r * 0.25, -r * 0.35), m + Vector2(r * 0.25, -r * 0.35), m + Vector2(r * 0.4, -r * 0.7), m + Vector2(-r * 0.4, -r * 0.7)])
	ci.draw_colored_polygon(agiz, renk.darkened(0.15))
	_kontur(ci, agiz, 1.5)
	ci.draw_line(m + Vector2(-r * 0.3, -r * 0.38), m + Vector2(r * 0.3, -r * 0.38), MUREKKEP, 2.5, true)
	for i in 5:
		ci.draw_circle(m + Vector2(-r * 0.3 + i * r * 0.15, -r * 0.62 + (i % 2) * 3.0), 2.2, ic)


static func _ekmek(ci: CanvasItem, m: Vector2, r: float) -> void:
	var g := _elips(m, r * 0.78, r * 0.42)
	ci.draw_colored_polygon(g, EKMEK)
	_kontur(ci, g)
	for i in 3:
		var x := (i - 1) * r * 0.36
		ci.draw_line(m + Vector2(x - r * 0.08, -r * 0.2), m + Vector2(x + r * 0.1, r * 0.12), MUREKKEP, 2.0, true)


static func _kumas(ci: CanvasItem, m: Vector2, r: float) -> void:
	var g := PackedVector2Array([m + Vector2(-r * 0.75, -r * 0.35), m + Vector2(r * 0.55, -r * 0.35), m + Vector2(r * 0.55, r * 0.35), m + Vector2(-r * 0.75, r * 0.35)])
	ci.draw_colored_polygon(g, KUMAS)
	_kontur(ci, g)
	var uc := _elips(m + Vector2(r * 0.55, 0), r * 0.18, r * 0.35)
	ci.draw_colored_polygon(uc, KUMAS.lightened(0.15))
	_kontur(ci, uc, 1.5)
	ci.draw_arc(m + Vector2(r * 0.55, 0), r * 0.1, 0, TAU * 0.8, 12, MUREKKEP, 1.5, true)
	for i in 3:
		var x := -r * 0.5 + i * r * 0.32
		ci.draw_line(m + Vector2(x, -r * 0.35), m + Vector2(x, r * 0.35), Color("#c9a46a", 0.6), 2.0, true)


static func _tas(ci: CanvasItem, m: Vector2, r: float) -> void:
	var n := PackedVector2Array()
	for i in 13:
		var a := PI * i / 12.0
		n.append(m + Vector2(cos(a) * r * 0.8, sin(a) * r * 0.55 - r * 0.05))
	ci.draw_colored_polygon(n, BAKIR)
	_kontur(ci, n)
	var agiz := _elips(m + Vector2(0, -r * 0.05), r * 0.8, r * 0.18)
	ci.draw_colored_polygon(agiz, BAKIR.darkened(0.35))
	_kontur(ci, agiz, 1.5)
	ci.draw_arc(m + Vector2(-r * 0.25, r * 0.15), r * 0.3, PI * 0.6, PI * 0.95, 8, Color.WHITE * Color(1, 1, 1, 0.5), 2.0, true)


static func _ok(ci: CanvasItem, m: Vector2, r: float) -> void:
	for i in 4:
		var y := (i - 1.5) * r * 0.16
		var a := m + Vector2(-r * 0.8, y + r * 0.1)
		var b := m + Vector2(r * 0.7, y - r * 0.1)
		ci.draw_line(a, b, AHSAP, 3.0, true)
		var yon := (b - a).normalized()
		var dik := Vector2(-yon.y, yon.x)
		ci.draw_colored_polygon(PackedVector2Array([b + yon * 10, b + dik * 4, b - dik * 4]), DEMIR)
		ci.draw_colored_polygon(PackedVector2Array([a, a + yon * 14 + dik * 6, a + yon * 18, a + yon * 14 - dik * 6]), Color("#d8d2c4"))
	ci.draw_line(m + Vector2(-r * 0.15, -r * 0.4), m + Vector2(-r * 0.05, r * 0.4), DERI, 5.0, true)


static func _hancer(ci: CanvasItem, m: Vector2, r: float) -> void:
	var bicak := PackedVector2Array([m + Vector2(-r * 0.15, -r * 0.08), m + Vector2(r * 0.8, -r * 0.2), m + Vector2(r * 0.95, -r * 0.3),
		m + Vector2(r * 0.8, -r * 0.02), m + Vector2(-r * 0.15, r * 0.08)])
	ci.draw_colored_polygon(bicak, DEMIR)
	_kontur(ci, bicak, 1.5)
	ci.draw_line(m + Vector2(-r * 0.15, -r * 0.3), m + Vector2(-r * 0.15, r * 0.3), ALTIN_TAS.darkened(0.2), 5.0, true)
	ci.draw_line(m + Vector2(-r * 0.18, 0), m + Vector2(-r * 0.75, r * 0.12), DERI, 9.0, true)
	ci.draw_circle(m + Vector2(-r * 0.8, r * 0.13), 5.0, ALTIN_TAS.darkened(0.2))


static func _sise(ci: CanvasItem, m: Vector2, r: float) -> void:
	var g := PackedVector2Array([m + Vector2(-r * 0.4, -r * 0.1), m + Vector2(r * 0.4, -r * 0.1), m + Vector2(r * 0.45, r * 0.75), m + Vector2(-r * 0.45, r * 0.75)])
	ci.draw_colored_polygon(g, CAM)
	ci.draw_colored_polygon(PackedVector2Array([m + Vector2(-r * 0.4, r * 0.25), m + Vector2(r * 0.42, r * 0.25), m + Vector2(r * 0.45, r * 0.75), m + Vector2(-r * 0.45, r * 0.75)]), Color("#4f6f3c"))
	_kontur(ci, g)
	var boyun := PackedVector2Array([m + Vector2(-r * 0.15, -r * 0.5), m + Vector2(r * 0.15, -r * 0.5), m + Vector2(r * 0.15, -r * 0.1), m + Vector2(-r * 0.15, -r * 0.1)])
	ci.draw_colored_polygon(boyun, CAM)
	_kontur(ci, boyun, 1.5)
	ci.draw_rect(Rect2(m + Vector2(-r * 0.18, -r * 0.72), Vector2(r * 0.36, r * 0.24)), AHSAP)


static func _yuzuk(ci: CanvasItem, m: Vector2, r: float) -> void:
	ci.draw_arc(m + Vector2(0, r * 0.15), r * 0.5, 0, TAU, 32, MUREKKEP, r * 0.24, true)
	ci.draw_arc(m + Vector2(0, r * 0.15), r * 0.5, 0, TAU, 32, GUMUS, r * 0.16, true)
	var tas := PackedVector2Array([m + Vector2(0, -r * 0.62), m + Vector2(r * 0.2, -r * 0.42), m + Vector2(0, -r * 0.22), m + Vector2(-r * 0.2, -r * 0.42)])
	ci.draw_colored_polygon(tas, Color("#7a2f3a"))
	_kontur(ci, tas, 1.5)
	ci.draw_circle(m + Vector2(-r * 0.05, -r * 0.48), 2.5, Color(1, 1, 1, 0.8))
