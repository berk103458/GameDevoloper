## Oyunun tek Theme kaynağını kurar (sanat kitabı 7.3, 7.11). Metin ölçeği ayardan gelir.
class_name Tema
extends RefCounted

## Sayılar Kabuk'tadır. Seçilen tema bu sabitleri ezmez; kabuk ölçüleri tek yerden okunur.
const GOVDE_PX := Kabuk.GOVDE
const KUCUK_PX := Kabuk.KUCUK
const BASLIK_PX := Kabuk.BASLIK
## Sanat kitabı 7.4: hümanist serif (Alegreya, SIL OFL). Değişken font; ağırlık wght ekseninden.
const FONT_DIK := "res://assets/font/Alegreya-wght.ttf"
const FONT_ITALIK := "res://assets/font/Alegreya-Italic-wght.ttf"


## Verilen ayarlara göre tema üretir.
static func olustur(ayarlar: Ayarlar) -> Theme:
	var t := Theme.new()
	t.default_font = font(400)
	t.default_font_size = ayarlar.boyut(GOVDE_PX)
	t.set_font("italics_font", "RichTextLabel", font(400, true))
	t.set_font("bold_font", "RichTextLabel", font(700))
	t.set_font("bold_italics_font", "RichTextLabel", font(700, true))
	for tur in ["Label", "Button", "RichTextLabel"]:
		t.set_color("font_color", tur, Renkler.KUL)
	t.set_color("default_color", "RichTextLabel", Renkler.KUL)
	t.set_font_size("normal_font_size", "RichTextLabel", ayarlar.boyut(GOVDE_PX))
	t.set_font_size("italics_font_size", "RichTextLabel", ayarlar.boyut(GOVDE_PX))
	t.set_font_size("bold_font_size", "RichTextLabel", ayarlar.boyut(GOVDE_PX))
	t.set_constant("line_separation", "RichTextLabel", 8)
	var normal := _kutu(Renkler.GECE, Renkler.MUREKKEP, 3)
	var odak := _kutu(Renkler.GECE, Renkler.KUL, 4)
	odak.draw_center = false  # odak yalnız çerçevedir; seçili ters çevirmeyi örtmez
	var secili := _kutu(Renkler.KUL, Renkler.KUL, 4)
	var pasif := _kutu(Renkler.GECE, Renkler.DERIN_MAVI, 3)
	t.set_stylebox("normal", "Button", normal)
	t.set_stylebox("hover", "Button", normal)  # tek odak: hover normal ile aynı (Girdi GDD kural 5)
	t.set_stylebox("focus", "Button", odak)
	t.set_stylebox("pressed", "Button", secili)
	t.set_stylebox("hover_pressed", "Button", secili)
	t.set_stylebox("disabled", "Button", pasif)
	t.set_color("font_hover_color", "Button", Renkler.KUL)
	t.set_color("font_focus_color", "Button", Renkler.KUL)
	t.set_color("font_pressed_color", "Button", Renkler.GECE)
	t.set_color("font_hover_pressed_color", "Button", Renkler.GECE)
	t.set_color("font_disabled_color", "Button", Renkler.DERIN_MAVI)
	t.set_color("icon_normal_color", "Button", Renkler.KUL)
	t.set_color("icon_pressed_color", "Button", Renkler.GECE)
	t.set_stylebox("panel", "Panel", _kutu(Renkler.GECE, Renkler.MUREKKEP, 6))
	t.set_stylebox("panel", "PanelContainer", _kutu(Renkler.GECE, Renkler.MUREKKEP, 6))
	var bos := StyleBoxEmpty.new()
	t.set_stylebox("normal", "RichTextLabel", bos)
	t.set_stylebox("focus", "RichTextLabel", bos)
	_menu_dugmesi(t, ayarlar)
	return t


## Verilen ağırlıkta (400–900) Alegreya. Font dosyası yoksa null (motor varsayılanına düşer).
static func font(agirlik: int, italik: bool = false) -> Font:
	var yol := FONT_ITALIK if italik else FONT_DIK
	if not ResourceLoader.exists(yol):
		return null
	var f := FontVariation.new()
	f.base_font = load(yol)
	f.variation_opentype = {TextServerManager.get_primary_interface().name_to_tag("wght"): agirlik}
	return f


## Ana menü düğmesi (7.9): kutusuz kül metin; odakta kül çerçeve, seçimde ters çevirme.
static func _menu_dugmesi(t: Theme, ayarlar: Ayarlar) -> void:
	t.add_type("MenuDugmesi")
	t.set_type_variation("MenuDugmesi", "Button")
	var normal := _kutu(Renkler.GECE, Renkler.KUL, 0)
	normal.draw_center = false
	var odak := _kutu(Renkler.GECE, Renkler.KUL, 3)
	odak.draw_center = false
	t.set_stylebox("normal", "MenuDugmesi", normal)
	t.set_stylebox("hover", "MenuDugmesi", normal)
	t.set_stylebox("disabled", "MenuDugmesi", normal)
	t.set_stylebox("focus", "MenuDugmesi", odak)
	t.set_font_size("font_size", "MenuDugmesi", ayarlar.boyut(32))


static func _kutu(dolgu: Color, kenar: Color, kalinlik: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = dolgu
	s.border_color = kenar
	s.set_border_width_all(kalinlik)
	s.set_corner_radius_all(0)
	s.shadow_size = 0
	s.content_margin_left = 20
	s.content_margin_right = 20
	s.content_margin_top = 12
	s.content_margin_bottom = 12
	return s


## Köy panelleri Kabuk'tan gelir. Görünüm seçilince yalnız Kabuk.panel() değişir.
static func koy_paneli() -> StyleBoxFlat:
	return Kabuk.panel()

## Köy başlıklarında kullanılan SIL OFL lisanslı Cinzel.
static func koy_baslik_fontu() -> Font:
	return load("res://assets/font/Cinzel-wght.ttf")
