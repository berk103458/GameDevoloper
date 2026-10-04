## Açık deri heybe çizimi (heybe paneli). `acik` kapağın açıklığı (0..1), `yirtik` astar yırtığı (0..1),
## `sarsinti` yatay sarsıntı (px). Tween'lerle canlandırılır.
class_name HeybeCizimi
extends Control

const DERI := Color("#6b4630")
const DERI_KOYU := Color("#3f281a")
const DIKIS := Color("#c9a46a")
const IC := Color("#1a110b")
const ASTAR := Color("#8c7b5a")

var acik := 0.0:
	set(v):
		acik = v
		queue_redraw()
var yirtik := 0.0:
	set(v):
		yirtik = v
		queue_redraw()
var sarsinti := 0.0:
	set(v):
		sarsinti = v
		queue_redraw()


## Astar şeridinin (yırtığın) panel içindeki orta noktası.
func astar_merkezi() -> Vector2:
	return position + Vector2(size.x / 2.0, 540)


## Heybe ağzının orta noktası (eşyalar buradan dökülür).
func agiz_merkezi() -> Vector2:
	return position + Vector2(size.x / 2.0, 130)


func _draw() -> void:
	draw_set_transform(Vector2(sarsinti, 0))
	var w := size.x
	var kapak_boy := lerpf(230.0, -110.0, acik)
	if kapak_boy < 0.0:
		_kapak(w, kapak_boy)
	var govde := _govde(w)
	draw_colored_polygon(govde, DERI)
	_kontur(govde, DERI_KOYU, 4.0)
	_dikis(_govde(w, 16.0))
	# Ağız: içi karanlık.
	var agiz := PackedVector2Array()
	for i in 25:
		var a := TAU * i / 24.0
		agiz.append(Vector2(w / 2.0 + cos(a) * (w / 2.0 - 70.0), 128.0 + sin(a) * 34.0))
	draw_colored_polygon(agiz, IC)
	_kontur(agiz, DERI_KOYU, 3.0)
	# Astar şeridi ve yırtığı.
	var astar := Rect2(80, 515, w - 160, 54)
	draw_rect(astar, ASTAR)
	draw_rect(astar, DERI_KOYU, false, 2.0)
	var x := astar.position.x + 10.0
	while x < astar.end.x - 14.0:
		draw_line(Vector2(x, astar.position.y + 8), Vector2(x + 8, astar.position.y + 8), DERI_KOYU, 2.0)
		draw_line(Vector2(x, astar.end.y - 8), Vector2(x + 8, astar.end.y - 8), DERI_KOYU, 2.0)
		x += 16.0
	if yirtik > 0.0:
		var orta := astar.get_center()
		var yari := (astar.size.x / 2.0 - 20.0) * yirtik
		var n := PackedVector2Array()
		var adim := 14
		for i in adim + 1:
			var t := float(i) / adim
			n.append(Vector2(orta.x - yari + t * yari * 2.0, orta.y - 6.0 - (10.0 if i % 2 == 0 else 2.0) * yirtik))
		for i in range(adim, -1, -1):
			var t := float(i) / adim
			n.append(Vector2(orta.x - yari + t * yari * 2.0, orta.y + 6.0 + (10.0 if i % 2 == 1 else 3.0) * yirtik))
		draw_colored_polygon(n, IC)
		_kontur(n, DERI_KOYU, 2.0)
	# Askı kayışı.
	draw_line(Vector2(40, 140), Vector2(-10, 40), DERI_KOYU, 10.0, true)
	draw_line(Vector2(w - 40, 140), Vector2(w + 10, 40), DERI_KOYU, 10.0, true)
	if kapak_boy >= 0.0:
		_kapak(w, kapak_boy)
	draw_set_transform(Vector2.ZERO)


func _govde(w: float, iceri: float = 0.0) -> PackedVector2Array:
	var n := PackedVector2Array()
	var sol := 30.0 + iceri
	var sag := w - 30.0 - iceri
	var ust := 120.0 + iceri
	var alt := 590.0 - iceri
	var r := 70.0
	n.append(Vector2(sol + 10, ust))
	n.append(Vector2(sag - 10, ust))
	for i in 9:
		var a := lerpf(0.0, PI / 2.0, i / 8.0)
		n.append(Vector2(sag - r + cos(a) * r, alt - r + sin(a) * r))
	for i in 9:
		var a := lerpf(PI / 2.0, PI, i / 8.0)
		n.append(Vector2(sol + r + cos(a) * r, alt - r + sin(a) * r))
	return n


func _kapak(w: float, boy: float) -> void:
	var ust := 112.0
	var n := PackedVector2Array([Vector2(46, ust), Vector2(w - 46, ust), Vector2(w - 70, ust + boy * 0.85),
		Vector2(w / 2.0, ust + boy * 1.1), Vector2(70, ust + boy * 0.85)])
	draw_colored_polygon(n, DERI.darkened(0.12 if boy >= 0.0 else 0.3))
	_kontur(n, DERI_KOYU, 4.0)
	# Toka.
	var uc := Vector2(w / 2.0, ust + boy * 1.0)
	draw_rect(Rect2(uc - Vector2(16, 12), Vector2(32, 24)), DIKIS.darkened(0.3))
	draw_rect(Rect2(uc - Vector2(16, 12), Vector2(32, 24)), DERI_KOYU, false, 2.0)


func _dikis(n: PackedVector2Array) -> void:
	for i in n.size():
		var a := n[i]
		var b := n[(i + 1) % n.size()]
		draw_dashed_line(a, b, DIKIS, 2.0, 9.0, true)


func _kontur(n: PackedVector2Array, renk: Color, k: float) -> void:
	var c := n.duplicate()
	c.append(n[0])
	draw_polyline(c, renk, k, true)
