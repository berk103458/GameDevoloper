## Beş UI adayının aynı kadrajda görüntüsü. Ana sahnenin yerine geçmez.
## godot --path . res://src/arayuz/ui_adaylari/onizleme.tscn -- --onizleme-foto <klasor>
extends Control

const ADAYLAR := [
	{
		"dosya": "01_menu_lamoot.png",
		"ad": "Lamoot ahşap",
		"ekran": "Ana menü",
		"tema": "res://assets/ui_adaylari/lamoot_ahsap/tema.tres",
	},
	{
		"dosya": "02_heybe_itsmars.png",
		"ad": "itsmars envanter",
		"ekran": "Heybe",
		"tema": "res://assets/ui_adaylari/itsmars_envanter/tema.tres",
		"izgara": "res://assets/ui_adaylari/itsmars_envanter/izgara.png",
	},
	{
		"dosya": "03_koy_kenney_rpg.png",
		"ad": "Kenney RPG",
		"ekran": "Köy paneli",
		"tema": "res://assets/ui_adaylari/kenney_rpg/tema.tres",
	},
	{
		"dosya": "04_bilgi_crisp.png",
		"ad": "Crisp Quest",
		"ekran": "Bilgi ekranı",
		"tema": "res://assets/ui_adaylari/crisp_quest/tema.tres",
	},
	{
		"dosya": "05_divan_kenney_macera.png",
		"ad": "Kenney macera",
		"ekran": "Divan",
		"tema": "res://assets/ui_adaylari/kenney_macera/tema.tres",
	},
]


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var args := OS.get_cmdline_user_args()
	var i := args.find("--onizleme-foto")
	if i >= 0 and i + 1 < args.size():
		_hepsini_kaydet(args[i + 1])
	else:
		_kur(ADAYLAR[0])


func _hepsini_kaydet(klasor: String) -> void:
	DirAccess.make_dir_recursive_absolute(klasor)
	for aday in ADAYLAR:
		_temizle()
		_kur(aday)
		await RenderingServer.frame_post_draw
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		img.save_png(klasor.path_join(str(aday.dosya)))
	get_tree().quit(0)


func _temizle() -> void:
	var eski := get_children()
	for c in eski:
		remove_child(c)
		c.free()


func _kur(aday: Dictionary) -> void:
	var zemin := ColorRect.new()
	zemin.color = Color("14110e")
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	zemin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(zemin)
	var kok := MarginContainer.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.add_theme_constant_override("margin_left", 48)
	kok.add_theme_constant_override("margin_right", 48)
	kok.add_theme_constant_override("margin_top", 36)
	kok.add_theme_constant_override("margin_bottom", 36)
	kok.theme = load(str(aday.tema))
	add_child(kok)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 16)
	kok.add_child(dikey)
	var baslik := Label.new()
	baslik.text = "%s  ·  %s" % [aday.ekran, aday.ad]
	baslik.add_theme_font_size_override("font_size", 34)
	baslik.add_theme_color_override("font_color", Color("f3ead8"))
	dikey.add_child(baslik)
	var sekmeler := TabContainer.new()
	sekmeler.custom_minimum_size = Vector2(0, 150)
	sekmeler.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dikey.add_child(sekmeler)
	for ad in ["Kapı", "Köy"]:
		var sayfa := Label.new()
		sayfa.name = ad
		sayfa.text = "Şüpheli yük. Işık zayıf, çuval ağır. İçeri alış bu gece yazılır."
		sayfa.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		sekmeler.add_child(sayfa)
	var panel := PanelContainer.new()
	dikey.add_child(panel)
	var ic := VBoxContainer.new()
	ic.add_theme_constant_override("separation", 8)
	panel.add_child(ic)
	var notu := Label.new()
	notu.text = "Kapı kapalı. Gelenin adı deftere işlenmedi; bu yalnız kabuk."
	notu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ic.add_child(notu)
	if aday.has("izgara"):
		var izgara := TextureRect.new()
		izgara.texture = load(str(aday.izgara))
		izgara.custom_minimum_size = Vector2(0, 220)
		izgara.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		izgara.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		ic.add_child(izgara)
	var yatay := HBoxContainer.new()
	yatay.add_theme_constant_override("separation", 12)
	dikey.add_child(yatay)
	for yazi in ["İçeri al", "Geri çevir", "Kapalı"]:
		var d := Button.new()
		d.text = yazi
		d.custom_minimum_size = Vector2(220, 64)
		d.disabled = yazi == "Kapalı"
		yatay.add_child(d)
