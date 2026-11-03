## AYR-08, AYR-13, AYR-14, AYR-16, AYR-19: renk paleti.
## `src/arayuz/tema/` seçilmemiş şablon kaynağıdır; palet oraya konmaz.
## `tema.gd` ve `renkler.gd` değişmez; bu dosya onların üstüne yazar.
extends RefCounted

const YOL := "res://data/arayuz/paletler.json"
const SATIR_NORMAL := 8
const SATIR_GENIS_EK := 6


static func tablo() -> Dictionary:
	var veri = JSON.parse_string(FileAccess.get_file_as_string(YOL))
	return veri if veri is Dictionary else {}


static func palet_adi(a: Ayarlar) -> String:
	if a == null:
		return "olagan"
	return String(a.degerler.get(&"renk_paleti", &"olagan"))


static func _palet(a: Ayarlar) -> Dictionary:
	var tum := tablo()
	var ad := palet_adi(a)
	var secim: Variant = tum.get(ad, tum.get("olagan", {}))
	return secim if secim is Dictionary else {}


static func bar_rengi(a: Ayarlar, indeks: int) -> Color:
	var liste: Array = _palet(a).get("bar", [])
	if liste.is_empty():
		return Renkler.KUL
	return Color(String(liste[clampi(indeks, 0, liste.size() - 1)]))


static func tansiyon_rengi(a: Ayarlar, kademe: int) -> Color:
	var liste: Array = _palet(a).get("tansiyon", [])
	if liste.is_empty():
		return Renkler.KUL
	return Color(String(liste[clampi(kademe, 0, liste.size() - 1)]))


static func kaynak_rengi(a: Ayarlar) -> Color:
	return Color(String(_palet(a).get("kaynak", "#0072B2")))


static func zar_rengi(a: Ayarlar) -> Color:
	return Color(String(_palet(a).get("zar", "#CC79A7")))


static func satir_araligi_px(a: Ayarlar) -> int:
	if a != null and a.degerler.get(&"satir_araligi", &"normal") == &"genis":
		return SATIR_NORMAL + SATIR_GENIS_EK
	return SATIR_NORMAL


static func govde_agirligi(a: Ayarlar) -> int:
	if a == null:
		return 400
	return int(a.degerler.get(&"metin_agirligi", 400))


static func odak_kalinligi(a: Ayarlar) -> int:
	if a != null and a.degerler.get(&"odak_cercevesi", &"normal") == &"kalin":
		return 3
	return 1


static func metin_rengi(a: Ayarlar) -> Color:
	if a != null and bool(a.degerler.get(&"yuksek_kontrast", false)):
		return Color.WHITE
	return Renkler.KUL


static func uygula(tema: Theme, a: Ayarlar) -> void:
	if tema == null or a == null:
		return
	var yazi := metin_rengi(a)
	var agirlik := govde_agirligi(a)
	var font := Tema.font(agirlik)
	if font != null:
		tema.default_font = font
	for tur in ["Label", "Button", "RichTextLabel"]:
		tema.set_color("font_color", tur, yazi)
	tema.set_color("default_color", "RichTextLabel", yazi)
	tema.set_constant("line_separation", "RichTextLabel", satir_araligi_px(a))
	var dolgu := Renkler.GECE
	var kenar := Color.WHITE if bool(a.degerler.get(&"yuksek_kontrast", false)) else Renkler.MUREKKEP
	var kalinlik := 7 if bool(a.degerler.get(&"yuksek_kontrast", false)) else 6
	tema.set_stylebox("panel", "Panel", _kutu(dolgu, kenar, kalinlik))
	tema.set_stylebox("panel", "PanelContainer", _kutu(dolgu, kenar, kalinlik))
	var odak := _kutu(dolgu, yazi, odak_kalinligi(a))
	odak.draw_center = false
	tema.set_stylebox("focus", "Button", odak)


static func _kutu(dolgu: Color, kenar: Color, kalinlik: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = dolgu
	s.border_color = kenar
	s.set_border_width_all(kalinlik)
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	return s


static func delta_e(a: Color, b: Color) -> float:
	var la := _lab(a)
	var lb := _lab(b)
	return sqrt(pow(la.x - lb.x, 2) + pow(la.y - lb.y, 2) + pow(la.z - lb.z, 2))


static func kontrast(yazi: Color, zemin: Color) -> float:
	var l1 := _luma(yazi)
	var l2 := _luma(zemin)
	return (maxf(l1, l2) + 0.05) / (minf(l1, l2) + 0.05)


static func _luma(c: Color) -> float:
	return 0.2126 * _lin(c.r) + 0.7152 * _lin(c.g) + 0.0722 * _lin(c.b)


static func _lin(c: float) -> float:
	return c / 12.92 if c <= 0.04045 else pow((c + 0.055) / 1.055, 2.4)


static func _lab(c: Color) -> Vector3:
	var r := _lin(c.r)
	var g := _lin(c.g)
	var b := _lin(c.b)
	var x := (r * 0.4124 + g * 0.3576 + b * 0.1805) / 0.95047
	var y := r * 0.2126 + g * 0.7152 + b * 0.0722
	var z := (r * 0.0193 + g * 0.1192 + b * 0.9505) / 1.08883
	return Vector3(116.0 * _f(y) - 16.0, 500.0 * (_f(x) - _f(y)), 200.0 * (_f(y) - _f(z)))


static func _f(t: float) -> float:
	return pow(t, 1.0 / 3.0) if t > 0.008856 else 7.787 * t + 16.0 / 116.0
