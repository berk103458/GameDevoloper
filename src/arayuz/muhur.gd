## Mum mührü: halka, iç halka ve ortada yazı (heybe panelinde "Yalan yakalandı").
class_name Muhur
extends Control

const MUM := Color("#8e2a24")

var yazi: String = ""
var font_: Font


func _draw() -> void:
	var m := size / 2.0
	var r := minf(size.x, size.y) / 2.0 - 6.0
	var dis := PackedVector2Array()
	for i in 36:
		var a := TAU * i / 36.0
		dis.append(m + Vector2(cos(a), sin(a)) * (r + (5.0 if i % 2 == 0 else 0.0)))
	draw_colored_polygon(dis, Color(MUM, 0.88))
	draw_arc(m, r * 0.86, 0, TAU, 48, Color("#e8c9a0", 0.85), 3.0, true)
	draw_arc(m, r * 0.7, 0, TAU, 48, Color("#e8c9a0", 0.5), 1.5, true)
	if font_ != null:
		var px := 30
		var parcalar := yazi.split(" ")
		for i in parcalar.size():
			var y := m.y + (i - (parcalar.size() - 1) / 2.0) * px * 1.1 + px * 0.35
			draw_string(font_, Vector2(0, y), parcalar[i], HORIZONTAL_ALIGNMENT_CENTER, size.x, px, Color("#f3e3c8"))
