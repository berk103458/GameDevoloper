## İkon, stok ve günlük net değişimi tek bir okunabilir kaynak kartında gösterir.
class_name KaynakGostergesi
extends PanelContainer

const BRONZ := Kabuk.BAR_DOLU
const ARTIS := Kabuk.MORAL
var _miktar: Label
var _net: Label

## Kartı kaynak adıyla oluşturur; etiketler yalnız veri değişiminde güncellenir.
func kur(tur: String, punto: int) -> void:
	focus_mode = Control.FOCUS_ALL
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 0)
	add_child(v)
	var ad := Label.new()
	ad.text = "Saman" if tur == "saman" else "Su" if tur == "su" else DemirZinciri.ad("koy.kaynak." + tur)
	ad.add_theme_font_size_override("font_size", punto)
	ad.add_theme_color_override("font_color", BRONZ)
	v.add_child(ad)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 8)
	v.add_child(h)
	h.add_child(ikon(tur, 30))
	_miktar = Label.new()
	_miktar.add_theme_font_size_override("font_size", punto + 7)
	h.add_child(_miktar)
	_net = Label.new()
	_net.add_theme_font_size_override("font_size", punto)
	h.add_child(_net)
	tip_bildir(tur)

## Kaynak kartının erişilebilir açıklamasını kurar.
func tip_bildir(tur: String) -> void:
	tooltip_text = "Saman" if tur == "saman" else "Su" if tur == "su" else DemirZinciri.ad("koy.kaynak." + tur)

## Stok, net değişim ve kritik durum rengini günceller.
func guncelle(miktar: int, net: int, kritik: bool = false) -> void:
	_miktar.text = str(miktar)
	_net.text = "%+d" % net if net != 0 else "—"
	_net.add_theme_color_override("font_color", ARTIS if net > 0 else (Hud.UYARI if net < 0 else Kabuk.SOLUK))
	_miktar.add_theme_color_override("font_color", Hud.UYARI if kritik else Renkler.KUL)

## Hazır lisanslı SVG ikonunu belirtilen boyutta kurar.
static func ikon(tur: String, boy: int) -> TextureRect:
	var r := TextureRect.new()
	if not GezginStokIkonu.ikon(r, tur): r.texture = load("res://assets/ui/koy/%s.svg" % tur)
	r.custom_minimum_size = Vector2(boy, boy)
	r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	r.modulate = BRONZ
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return r
