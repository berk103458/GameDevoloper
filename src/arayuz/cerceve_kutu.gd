## Koyu, yarı saydam dolgu ve altın çift çerçeveli kutu (kapı defteri, konuşma kutusu, isim levhası).
class_name CerceveKutu
extends Control

var dolgu := Color(0.03, 0.035, 0.05, 0.88)
var kenar := MenuSatiri.ALTIN
## Köşe süsü (küçük elmaslar).
var susle := true


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	resized.connect(queue_redraw)


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	draw_rect(r, dolgu)
	draw_rect(r.grow(-1), Color(kenar, 0.85), false, 2.0)
	draw_rect(r.grow(-6), Color(kenar, 0.35), false, 1.0)
	if susle:
		for k in [r.position, Vector2(r.end.x, r.position.y), r.end, Vector2(r.position.x, r.end.y)]:
			MenuSusu.elmas(self, k, 5.0, kenar, true)
