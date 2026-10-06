## Köy saati denetimi: duraklat, 1×, 2×, 3× ve "Geceye geç". Hız `Engine.time_scale` ile verilir;
## yüksek hızda fizik adımı kaçmasın diye `max_physics_steps_per_frame` 8'e çıkar. Köyden çıkınca 1× olur.
class_name ZamanKontrol
extends PanelContainer

signal geceye_gec_istendi

const HIZLAR := [0.0, 1.0, 2.0, 3.0]

var _dugmeler: Array[Button] = []
var _grup := ButtonGroup.new()


func _ready() -> void:
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 8)
	add_child(kenar)
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	kenar.add_child(h)
	for i in HIZLAR.size():
		var b := Button.new()
		b.toggle_mode = true
		b.button_group = _grup
		b.text = "II" if i == 0 else "%d×" % int(HIZLAR[i])
		b.tooltip_text = tr("arayuz.zaman.duraklat") if i == 0 else ""
		b.custom_minimum_size = Vector2(64, 52)
		b.add_theme_constant_override("h_separation", 0)
		b.toggled.connect(func(acik: bool) -> void:
			if acik:
				hiz_ayarla(HIZLAR[i]))
		h.add_child(b)
		_dugmeler.append(b)
	var g := Button.new()
	g.text = tr("arayuz.zaman.geceye_gec")
	g.custom_minimum_size = Vector2(0, 52)
	g.pressed.connect(func() -> void:
		_dugmeler[1].button_pressed = true
		geceye_gec_istendi.emit())
	h.add_child(g)
	Engine.max_physics_steps_per_frame = 8
	_dugmeler[1].set_pressed_no_signal(true)
	hiz_ayarla(1.0)


func hiz_ayarla(hiz: float) -> void:
	Engine.time_scale = hiz


func _exit_tree() -> void:
	Engine.time_scale = 1.0
