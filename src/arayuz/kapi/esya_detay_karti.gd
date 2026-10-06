## Kaynak fiziksel açıklaması için modal kart; yeni ipucu üretmez.
extends Control

var baslik: String = ""
var aciklama: String = ""

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	z_index = 30
	var perde := ColorRect.new()
	perde.color = Color(0.02, 0.02, 0.03, 0.85)
	perde.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(perde)
	var merkez := CenterContainer.new()
	merkez.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	merkez.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(merkez)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(780, 470)
	merkez.add_child(panel)
	var kenar := MarginContainer.new()
	for yon in ["left", "top", "right", "bottom"]:
		kenar.add_theme_constant_override("margin_" + yon, 24)
	panel.add_child(kenar)
	var kutu := VBoxContainer.new()
	kutu.add_theme_constant_override("separation", 20)
	kenar.add_child(kutu)
	var ad := Label.new()
	ad.name = "Baslik"
	ad.text = baslik
	ad.add_theme_font_size_override("font_size", 28)
	kutu.add_child(ad)
	var cizgi := HSeparator.new()
	kutu.add_child(cizgi)
	var metin := RichTextLabel.new()
	metin.name = "FizikselAciklama"
	metin.text = aciklama
	metin.bbcode_enabled = false
	metin.custom_minimum_size = Vector2(700, 280)
	metin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	metin.add_theme_font_size_override("normal_font_size", 24)
	kutu.add_child(metin)
	var kapat := Button.new()
	kapat.text = "İncelemeye dön"
	kapat.custom_minimum_size.y = 60
	kapat.pressed.connect(queue_free)
	kutu.add_child(kapat)
	kapat.grab_focus()

func _unhandled_input(olay: InputEvent) -> void:
	if olay.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		queue_free()
