# Parley Köy Diyalog Paneli (Görev 3)
# Köy yönetim sahnesinde köylü muhabbetini ve sekansları oyuncuya sunan arayüz.
class_name KoyDiyalogPaneli
extends PanelContainer

var yonetici: KoyDiyalogYoneticisi
var _konusan_label: Label
var _metin_label: Label
var _secenekler_kutusu: VBoxContainer
var _kapat_butonu: Button


static func ac(ekran: Control, y: KoyDiyalogYoneticisi) -> KoyDiyalogPaneli:
	var eski := ekran.get_node_or_null("KoyDiyalogPaneli")
	if eski != null and is_instance_valid(eski):
		ekran.remove_child(eski)
		eski.queue_free()
	var panel := KoyDiyalogPaneli.new()
	panel.name = "KoyDiyalogPaneli"
	panel.yonetici = y
	ekran.add_child(panel)
	panel._kur()
	return panel


func _kur() -> void:
	# Ekranın alt ortasına yerleşir
	set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	offset_left = 240.0
	offset_right = -240.0
	offset_top = -530.0
	offset_bottom = -276.0
	z_index = 120
	
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 15)
	margin.add_theme_constant_override("margin_bottom", 15)
	add_child(margin)
	
	var ana_kutu := VBoxContainer.new()
	ana_kutu.add_theme_constant_override("separation", 10)
	margin.add_child(ana_kutu)
	
	_konusan_label = Label.new()
	_konusan_label.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	_konusan_label.add_theme_font_size_override("font_size", Tema.GOVDE_PX)
	ana_kutu.add_child(_konusan_label)
	
	_metin_label = Label.new()
	_metin_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_metin_label.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	ana_kutu.add_child(_metin_label)
	
	_secenekler_kutusu = VBoxContainer.new()
	_secenekler_kutusu.add_theme_constant_override("separation", 6)
	ana_kutu.add_child(_secenekler_kutusu)
	
	_kapat_butonu = Button.new()
	_kapat_butonu.text = "Ayrıl / Kapat"
	_kapat_butonu.custom_minimum_size = Vector2(180, 42)
	_kapat_butonu.pressed.connect(_kapat)
	_kapat_butonu.hide()
	ana_kutu.add_child(_kapat_butonu)
	
	if yonetici:
		yonetici.replik_geldi.connect(_replik_goster)
		yonetici.diyalog_sonlandi.connect(_kapat)


func _replik_goster(konusan: String, metin: String, secenekler: Array) -> void:
	_konusan_label.text = konusan
	_metin_label.text = metin
	
	for c in _secenekler_kutusu.get_children():
		c.queue_free()
		
	if secenekler.is_empty():
		_kapat_butonu.show()
	else:
		_kapat_butonu.hide()
		for opt in secenekler:
			if opt is ParleyDialogueOptionNodeAst:
				var btn := Button.new()
				btn.text = "▸ " + (opt as ParleyDialogueOptionNodeAst).text
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.custom_minimum_size = Vector2(0, 44)
				btn.pressed.connect(func() -> void:
					if yonetici:
						yonetici.secenek_sec(opt)
				)
				_secenekler_kutusu.add_child(btn)
			elif opt is Dictionary:
				var btn := Button.new()
				btn.text = "▸ " + String(opt.get("metin", ""))
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.custom_minimum_size = Vector2(0, 44)
				var kimlik := String(opt.get("id", ""))
				btn.pressed.connect(func() -> void:
					if yonetici:
						yonetici.soz_secenek(kimlik)
				)
				_secenekler_kutusu.add_child(btn)


func _kapat() -> void:
	if yonetici and yonetici.calisiyor:
		yonetici.bitir()
	queue_free()
