## Oyunun tek Theme kaynağını kurar. Metin ölçeği ayardan gelir.
## Görünüm (6 Ekim 2026): tütsülenmiş koyu ahşap paneller, bronz kenarlar; başlık ve sayılar Cinzel,
## gövde metni Alegreya (Google Fonts, OFL — `assets/arayuz/yazi/`).
class_name Tema
extends RefCounted

const GOVDE_PX := 26
const KUCUK_PX := 22
const BASLIK_PX := 34
const YAZI_KOK := "res://assets/arayuz/yazi/"


## Verilen ayarlara göre tema üretir.
static func olustur(ayarlar: Ayarlar) -> Theme:
	var t := Theme.new()
	t.default_font_size = ayarlar.boyut(GOVDE_PX)
	var govde := govde_yazisi()
	if govde != null:
		t.default_font = govde
	for tur in ["Label", "Button", "RichTextLabel"]:
		t.set_color("font_color", tur, Renkler.PARSOMEN)
	t.set_color("default_color", "RichTextLabel", Renkler.PARSOMEN)
	t.set_font_size("normal_font_size", "RichTextLabel", ayarlar.boyut(GOVDE_PX))
	t.set_font_size("italics_font_size", "RichTextLabel", ayarlar.boyut(GOVDE_PX))
	t.set_font_size("bold_font_size", "RichTextLabel", ayarlar.boyut(GOVDE_PX))
	t.set_constant("line_separation", "RichTextLabel", 8)
	var normal := _kutu(Renkler.TUTSU_KOYU, Renkler.BRONZ.darkened(0.35), 2)
	var odak := _kutu(Renkler.TUTSU_KOYU, Renkler.BRONZ_ACIK, 3)
	odak.draw_center = false  # odak yalnız çerçevedir; seçili ters çevirmeyi örtmez
	var secili := _kutu(Renkler.BRONZ, Renkler.BRONZ_ACIK, 3)
	var pasif := _kutu(Color(0.06, 0.055, 0.05, 0.7), Color(0.3, 0.26, 0.2, 0.6), 2)
	t.set_stylebox("normal", "Button", normal)
	t.set_stylebox("hover", "Button", normal)  # tek odak: hover normal ile aynı (Girdi GDD kural 5)
	t.set_stylebox("focus", "Button", odak)
	t.set_stylebox("pressed", "Button", secili)
	t.set_stylebox("hover_pressed", "Button", secili)
	t.set_stylebox("disabled", "Button", pasif)
	t.set_color("font_hover_color", "Button", Renkler.PARSOMEN)
	t.set_color("font_focus_color", "Button", Renkler.BRONZ_ACIK.lightened(0.3))
	t.set_color("font_pressed_color", "Button", Renkler.TUTSU_KOYU)
	t.set_color("font_hover_pressed_color", "Button", Renkler.TUTSU_KOYU)
	t.set_color("font_disabled_color", "Button", Color(0.5, 0.46, 0.4))
	t.set_color("icon_normal_color", "Button", Renkler.PARSOMEN)
	t.set_color("icon_pressed_color", "Button", Renkler.TUTSU_KOYU)
	var panel := _kutu(Renkler.TUTSU, Renkler.BRONZ, 2)
	panel.set_corner_radius_all(4)
	panel.shadow_color = Color(0, 0, 0, 0.45)
	panel.shadow_size = 8
	t.set_stylebox("panel", "Panel", panel)
	t.set_stylebox("panel", "PanelContainer", panel)
	var bos := StyleBoxEmpty.new()
	t.set_stylebox("normal", "RichTextLabel", bos)
	t.set_stylebox("focus", "RichTextLabel", bos)
	# İlerleme çubukları (barlar, ambar)
	var cubuk_zemin := _kutu(Color(0.03, 0.03, 0.025, 0.9), Renkler.BRONZ.darkened(0.4), 1)
	_bosluk(cubuk_zemin, 0)
	var cubuk_dolu := _kutu(Renkler.BRONZ, Renkler.BRONZ, 0)
	_bosluk(cubuk_dolu, 0)
	t.set_stylebox("background", "ProgressBar", cubuk_zemin)
	t.set_stylebox("fill", "ProgressBar", cubuk_dolu)
	t.set_color("font_color", "ProgressBar", Renkler.PARSOMEN)
	# Başlık türü: Cinzel
	var baslik := baslik_yazisi()
	t.add_type("Baslik")
	t.set_type_variation("Baslik", "Label")
	if baslik != null:
		t.set_font("font", "Baslik", baslik)
	t.set_color("font_color", "Baslik", Renkler.BRONZ_ACIK)
	t.set_font_size("font_size", "Baslik", ayarlar.boyut(BASLIK_PX))
	t.add_type("Sayi")
	t.set_type_variation("Sayi", "Label")
	if baslik != null:
		t.set_font("font", "Sayi", baslik)
	t.set_font_size("font_size", "Sayi", ayarlar.boyut(GOVDE_PX))
	return t


## Gövde yazısı (Alegreya); dosya yoksa null (motor yazısı kullanılır).
static func govde_yazisi() -> Font:
	return _yazi("Alegreya.ttf", 450)


## Başlık ve sayı yazısı (Cinzel, kalın).
static func baslik_yazisi() -> Font:
	return _yazi("Cinzel.ttf", 700)


static var _yazilar: Dictionary = {}


static func _yazi(dosya: String, kalinlik: int) -> Font:
	var anahtar := "%s:%d" % [dosya, kalinlik]
	if _yazilar.has(anahtar):
		return _yazilar[anahtar]
	var f: Font = null
	if ResourceLoader.exists(YAZI_KOK + dosya):
		var v := FontVariation.new()
		v.base_font = load(YAZI_KOK + dosya)
		v.variation_opentype = {TextServerManager.get_primary_interface().name_to_tag("wght"): kalinlik}
		f = v
	_yazilar[anahtar] = f
	return f


static func _kutu(dolgu: Color, kenar: Color, kalinlik: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = dolgu
	s.border_color = kenar
	s.set_border_width_all(kalinlik)
	s.set_corner_radius_all(2)
	s.shadow_size = 0
	s.content_margin_left = 20
	s.content_margin_right = 20
	s.content_margin_top = 12
	s.content_margin_bottom = 12
	return s


static func _bosluk(s: StyleBox, m: int) -> void:
	s.content_margin_left = m
	s.content_margin_right = m
	s.content_margin_top = m
	s.content_margin_bottom = m
