## Ana menü satırı (referans: design/art/referans/menu_referans.webp): solda ikon, kremsi metin;
## odakta altın çift çerçeveli, uçları sivri koyu levha ve sağda ok; odak dışında altta ince çizgi.
## Button'dan türer (klavye, gamepad ve ekran okuyucu düğme olarak görür); metni kendisi çizer.
class_name MenuSatiri
extends Button

const ALTIN := Color("#C9A46A")
const KREM := Color("#EFE6D2")
const SOLUK := Color("#A9A396")
const LEVHA := Color(0.035, 0.035, 0.05, 0.86)

enum Ikon { AY, ISARET, CARK, KAPI, YOK }

var ikon: Ikon = Ikon.AY
var punto: int = 34
var font_: Font
## Çizilen ikon yerine doku (kapıdaki karar simgeleri gibi).
var doku: Texture2D
## Soldan girinti (takip soruları).
var girinti := 0.0
## Metnin altında küçük ikinci satır (tarafsız bilgi).
var alt_yazi := ""
var alt_punto := 18


func _ready() -> void:
	flat = true
	focus_mode = Control.FOCUS_ALL
	var bos := StyleBoxEmpty.new()
	for s in ["normal", "hover", "pressed", "hover_pressed", "focus", "disabled"]:
		add_theme_stylebox_override(s, bos)
	# Düğmenin kendi metni görünmez (erişilebilirlik için durur); metni _draw çizer.
	for c in ["font_color", "font_hover_color", "font_focus_color", "font_pressed_color", "font_hover_pressed_color", "font_disabled_color"]:
		add_theme_color_override(c, Color(0, 0, 0, 0))
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)
	resized.connect(queue_redraw)
	mouse_entered.connect(func() -> void:
		if not disabled:
			grab_focus()
	)


func _draw() -> void:
	var w := size.x
	var h := size.y
	var cy := h / 2.0
	var odak := has_focus()
	if odak:
		var u := 14.0
		var dis := PackedVector2Array([Vector2(u, 0), Vector2(w - u, 0), Vector2(w, cy), Vector2(w - u, h), Vector2(u, h), Vector2(0, cy)])
		draw_colored_polygon(dis, LEVHA)
		_cokgen(dis, ALTIN, 2.0)
		var ic := PackedVector2Array([Vector2(u + 4, 5), Vector2(w - u - 4, 5), Vector2(w - 7, cy), Vector2(w - u - 4, h - 5), Vector2(u + 4, h - 5), Vector2(7, cy)])
		_cokgen(ic, Color(ALTIN, 0.55), 1.0)
		# Uçlardaki küçük sivri çıkıntılar.
		for x in [-6.0, w + 6.0]:
			var y := 1.0 if x < 0 else -1.0
			draw_polyline(PackedVector2Array([Vector2(x + 6.0 * y, cy - 9), Vector2(x, cy), Vector2(x + 6.0 * y, cy + 9)]), ALTIN, 1.5, true)
		# Sağda ok.
		draw_polyline(PackedVector2Array([Vector2(w - 52, cy - 7), Vector2(w - 45, cy), Vector2(w - 52, cy + 7)]), KREM, 2.0, true)
	else:
		draw_line(Vector2(0, h - 1), Vector2(w - 30, h - 1), Color(ALTIN, 0.32), 1.0, true)
		MenuSusu.elmas(self, Vector2(w - 26, h - 1), 3.0, Color(ALTIN, 0.55), true)
	var renk := KREM if odak else (Color(SOLUK, 0.45) if disabled else SOLUK)
	var x := 104.0 + girinti
	if doku != null:
		var b := minf(h - 18.0, 44.0)
		draw_texture_rect(doku, Rect2(Vector2(48 + girinti - b / 2.0, cy - b / 2.0), Vector2(b, b)), false, renk)
	elif ikon == Ikon.YOK:
		x = 34.0 + girinti
	else:
		_ikon_ciz(Vector2(48 + girinti, cy), 13.0, renk)
	if font_ != null:
		var asc := font_.get_ascent(punto)
		var yuk := font_.get_height(punto)
		var genislik := w - x - 60.0
		if alt_yazi == "":
			draw_string(font_, Vector2(x, cy - yuk / 2.0 + asc), text, HORIZONTAL_ALIGNMENT_LEFT, genislik, punto, renk)
		else:
			draw_string(font_, Vector2(x, cy - 4.0 - yuk + asc), text, HORIZONTAL_ALIGNMENT_LEFT, genislik, punto, renk)
			draw_string(font_, Vector2(x, cy + 4.0 + font_.get_ascent(alt_punto)), alt_yazi, HORIZONTAL_ALIGNMENT_LEFT, genislik, alt_punto, Color(SOLUK, 0.8))


func _cokgen(n: PackedVector2Array, renk: Color, kalin: float) -> void:
	var k := n.duplicate()
	k.append(n[0])
	draw_polyline(k, renk, kalin, true)


func _ikon_ciz(m: Vector2, r: float, renk: Color) -> void:
	match ikon:
		Ikon.AY:
			draw_colored_polygon(_hilal(m, r), renk)
		Ikon.ISARET:
			draw_colored_polygon(PackedVector2Array([m + Vector2(-r * 0.7, -r), m + Vector2(r * 0.7, -r), m + Vector2(r * 0.7, r),
				m + Vector2(0, r * 0.45), m + Vector2(-r * 0.7, r)]), renk)
		Ikon.CARK:
			draw_arc(m, r * 0.62, 0, TAU, 24, renk, r * 0.42, true)
			for i in 8:
				var a := TAU * i / 8.0
				var d := Vector2(cos(a), sin(a))
				var t := Vector2(-d.y, d.x)
				draw_colored_polygon(PackedVector2Array([m + d * r * 0.7 + t * r * 0.22, m + d * r * 1.08 + t * r * 0.17,
					m + d * r * 1.08 - t * r * 0.17, m + d * r * 0.7 - t * r * 0.22]), renk)
		Ikon.YOK:
			pass
		Ikon.KAPI:
			draw_rect(Rect2(m + Vector2(-r * 0.75, -r), Vector2(r * 1.5, r * 2.0)), renk)
			draw_rect(Rect2(m + Vector2(-r * 0.75, -r), Vector2(r * 1.5, r * 2.0)), Color(0, 0, 0, 0.5), false, 1.0)
			draw_circle(m + Vector2(r * 0.4, r * 0.1), r * 0.14, Color(0.05, 0.05, 0.07))


## Hilal: iki çemberin farkı (kesişim noktalarından yaylarla çokgen).
func _hilal(m: Vector2, r: float) -> PackedVector2Array:
	var d := r * 0.55
	var r1 := r * 0.85
	var x := (d * d + r * r - r1 * r1) / (2.0 * d)
	var y := sqrt(maxf(r * r - x * x, 0.0))
	var phi := atan2(y, x)
	var psi := atan2(y, x - d)
	var n := PackedVector2Array()
	for i in 21:
		var a := lerpf(phi, TAU - phi, i / 20.0)
		n.append(m + Vector2(cos(a), sin(a)) * r)
	for i in 21:
		var a := lerpf(TAU - psi, psi, i / 20.0)
		n.append(m + Vector2(d, 0) + Vector2(cos(a), sin(a)) * r1)
	return n
