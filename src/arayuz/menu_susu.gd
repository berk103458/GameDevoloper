## Ana menü süsleri: ince altın çizgiler ve elmaslar (referans: design/art/referans/menu_referans.webp).
class_name MenuSusu
extends Control

enum Tur { UST, ALT, IPUCU }

var tur: Tur = Tur.UST
## UST'te elmasın x'i; IPUCU'da ortadaki metnin genişliği.
var konum: float = 170.0


func _draw() -> void:
	var y := size.y / 2.0
	var w := size.x
	var a := MenuSatiri.ALTIN
	match tur:
		Tur.UST:
			draw_line(Vector2(0, y), Vector2(w, y), Color(a, 0.45), 1.0, true)
			elmas(self, Vector2(konum, y), 4.0, a, true)
		Tur.ALT:
			var m := konum
			draw_line(Vector2(0, y), Vector2(m - 44, y), Color(a, 0.45), 1.0, true)
			draw_line(Vector2(m - 40, y), Vector2(m - 16, y), a, 2.5, true)
			draw_circle(Vector2(m - 30, y), 2.0, a)
			elmas(self, Vector2(m, y), 9.0, a, false)
			elmas(self, Vector2(m, y), 3.0, a, true)
			draw_line(Vector2(m + 16, y), Vector2(m + 40, y), a, 2.5, true)
			draw_circle(Vector2(m + 30, y), 2.0, a)
			draw_line(Vector2(m + 44, y), Vector2(w, y), Color(a, 0.45), 1.0, true)
		Tur.IPUCU:
			var b := (w - konum) / 2.0
			draw_line(Vector2(0, y), Vector2(b - 22, y), Color(a, 0.5), 1.0, true)
			elmas(self, Vector2(b - 14, y), 3.5, a, true)
			elmas(self, Vector2(w - b + 14, y), 3.5, a, true)
			draw_line(Vector2(w - b + 22, y), Vector2(w, y), Color(a, 0.5), 1.0, true)


## Ortası `m`, yarı köşegeni `r` olan elmas.
static func elmas(ci: CanvasItem, m: Vector2, r: float, renk: Color, dolu: bool) -> void:
	var n := PackedVector2Array([m + Vector2(0, -r), m + Vector2(r, 0), m + Vector2(0, r), m + Vector2(-r, 0)])
	if dolu:
		ci.draw_colored_polygon(n, renk)
	else:
		n.append(n[0])
		ci.draw_polyline(n, renk, 1.5, true)
