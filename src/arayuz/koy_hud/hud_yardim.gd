## Köy HUD'unun ortak parçaları: simge, sayı etiketi, fark etiketi.
class_name HudYardim
extends RefCounted

const IKON_KOK := "res://assets/arayuz/ikon/"


## Bronz tonlu simge (game-icons.net, CC BY 3.0).
static func simge(ad: String, boy: float = 34.0, renk: Color = Renkler.BRONZ_ACIK) -> TextureRect:
	var r := TextureRect.new()
	var yol := IKON_KOK + ad + ".svg"
	if ResourceLoader.exists(yol):
		r.texture = load(yol)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.custom_minimum_size = Vector2(boy, boy)
	r.modulate = renk
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r


static func etiket(metin: String, tur: StringName = &"", boyut: int = 0) -> Label:
	var l := Label.new()
	l.text = metin
	if tur != &"":
		l.theme_type_variation = tur
	if boyut > 0:
		l.add_theme_font_size_override("font_size", boyut)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


## Farkı yazar: +n yeşil, −n kırmızı, 0 gizli.
static func fark_yaz(l: Label, fark: int) -> void:
	l.visible = fark != 0
	l.text = ("+%d" % fark) if fark > 0 else ("−%d" % -fark)
	l.add_theme_color_override("font_color", Renkler.ARTI if fark > 0 else Renkler.EKSI)
