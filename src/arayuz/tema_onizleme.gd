## ARY-01: üç görsel dil şablonunun önizlemesi (sorgu, harita, köylü kartı yer tutucuları).
## Geliştirici aracıdır; ana.tscn yerine geçmez ve oyunun temasını değiştirmez. Değerler
## data/arayuz/tema_sablonlari.json'dadır; doku ve yazı tipi üretilmez, yer tutucu StyleBoxFlat.
## Görüntü almak için: godot --path . res://src/arayuz/tema_onizleme.tscn -- --onizleme-foto <yol.png>
class_name TemaOnizleme
extends Control

const VERI := "res://data/arayuz/tema_sablonlari.json"
const DUGME_DURUMLARI := ["normal", "ustunde", "basili", "kapali"]
const FONTLAR := {"Alegreya": "res://assets/font/Alegreya-wght.ttf", "Cinzel": "res://assets/font/Cinzel-wght.ttf"}

var veri: Dictionary = {}
var ekranlar: Array[Control] = []


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veri = oku()
	var satir := HBoxContainer.new()
	satir.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	satir.add_theme_constant_override("separation", 12)
	add_child(satir)
	for s in veri.get("sablonlar", []):
		satir.add_child(_sutun(s))
	var args := OS.get_cmdline_user_args()
	var i := args.find("--onizleme-foto")
	if i >= 0 and i + 1 < args.size():
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(args[i + 1])
		await Ses.cik()


static func oku() -> Dictionary:
	var v: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI))
	return v if v is Dictionary else {}


static func kutu(zemin: String, kenar: String, kalinlik: int, kose: int, golge := 0) -> StyleBoxFlat:
	var k := StyleBoxFlat.new()
	k.bg_color = Color(zemin)
	k.border_color = Color(kenar)
	k.set_border_width_all(kalinlik)
	k.set_corner_radius_all(kose)
	k.shadow_size = golge
	k.content_margin_left = 12
	k.content_margin_right = 12
	k.content_margin_top = 8
	k.content_margin_bottom = 8
	return k


func _font(ad: String) -> Font:
	return load(FONTLAR.get(ad, FONTLAR["Alegreya"])) as Font


func _yazi(metin: String, s: Dictionary, boyut: int, baslik := false, renk := "metin", sar := true) -> Label:
	var l := Label.new()
	l.text = metin
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if sar else TextServer.AUTOWRAP_OFF
	l.add_theme_color_override("font_color", Color(s.renk[renk]))
	l.add_theme_font_override("font", _font(s.yazi.baslik if baslik else s.yazi.govde))
	l.add_theme_font_size_override("font_size", boyut)
	return l


func _sutun(s: Dictionary) -> Control:
	var zemin := PanelContainer.new()
	zemin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	zemin.add_theme_stylebox_override("panel", kutu(s.renk.zemin, s.renk.zemin, 0, 0))
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 10)
	zemin.add_child(dikey)
	dikey.add_child(_yazi(String(s.ad), s, 30, true, "zemin_metin"))
	for ad in ["sorgu", "harita", "kart"]:
		var e := _ekran(ad, s)
		e.name = "%s_%s" % [s.kimlik, ad]
		ekranlar.append(e)
		dikey.add_child(e)
	return zemin


func _ekran(ad: String, s: Dictionary) -> Control:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", kutu(s.renk.panel, s.renk.cerceve, int(s.cerceve.kalinlik), int(s.cerceve.kose), int(s.panel.golge)))
	var v := VBoxContainer.new()
	p.add_child(v)
	var o: Dictionary = veri.get("ornek", {})
	match ad:
		"sorgu":
			v.add_child(_yazi(String(o.get("sorgu_kisi", "")), s, 24, true))
			v.add_child(_yazi(String(o.get("sorgu_soz", "")), s, 22))
			var secenekler: Array = o.get("secenekler", [])
			for i in DUGME_DURUMLARI.size():
				v.add_child(_dugme(String(secenekler[i % secenekler.size()]) if not secenekler.is_empty() else "", s, DUGME_DURUMLARI[i]))
		"harita":
			v.add_child(_yazi(String(o.get("harita_baslik", "")), s, 24, true))
			var izgara := GridContainer.new()
			izgara.columns = 2
			izgara.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			for yer in o.get("harita_yerler", []):
				var nokta := PanelContainer.new()
				nokta.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				nokta.add_theme_stylebox_override("panel", kutu(s.renk.panel, s.renk.vurgu, 1, int(s.cerceve.kose)))
				nokta.add_child(_yazi(String(yer), s, 20, false, "metin", false))
				izgara.add_child(nokta)
			v.add_child(izgara)
		"kart":
			v.add_child(_yazi(String(o.get("kart_ad", "")), s, 24, true))
			for satir in o.get("kart_satirlar", []):
				v.add_child(_yazi(String(satir), s, 22))
	return p


func _dugme(metin: String, s: Dictionary, durum: String) -> Button:
	var b := Button.new()
	b.text = metin
	b.add_theme_font_override("font", _font(s.yazi.govde))
	b.add_theme_font_size_override("font_size", 22)
	var godot_adi := {"normal": ["normal", "font_color"], "ustunde": ["hover", "font_hover_color"],
		"basili": ["pressed", "font_pressed_color"], "kapali": ["disabled", "font_disabled_color"]}
	for d in DUGME_DURUMLARI:
		var r: Dictionary = s.dugme[d]
		b.add_theme_stylebox_override(godot_adi[d][0], kutu(r.zemin, r.kenar, int(s.cerceve.kalinlik), int(s.cerceve.kose)))
		b.add_theme_color_override(godot_adi[d][1], Color(r.metin))
	# Önizleme her durumu yan yana gösterir: bu düğme verilen durumun kutusunu "normal" olarak çizer.
	var r2: Dictionary = s.dugme[durum]
	b.add_theme_stylebox_override("normal", kutu(r2.zemin, r2.kenar, int(s.cerceve.kalinlik), int(s.cerceve.kose)))
	b.add_theme_color_override("font_color", Color(r2.metin))
	b.tooltip_text = durum
	b.name = "dugme_" + durum
	return b
