## OGR-35: Duraklat menüsünün tek kaydırılabilir yardım sayfası.
extends PanelContainer

signal kapandi

const KONULAR := ["kapi", "koy", "zar", "bar", "heybe"]
const SATIR_SAYISI := 5
const BASLIK := "arayuz.duraklat.kapi_usulu"

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var kenar := MarginContainer.new()
	for yon in ["left", "right", "top", "bottom"]:
		kenar.add_theme_constant_override("margin_" + yon, 32)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 12)
	kenar.add_child(dikey)
	var baslik := Label.new()
	baslik.text = tr(BASLIK)
	baslik.add_theme_font_size_override("font_size", Tema.BASLIK_PX)
	dikey.add_child(baslik)
	var kaydir := ScrollContainer.new()
	kaydir.name = "UsulKaydirma"
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	kaydir.focus_mode = Control.FOCUS_ALL
	dikey.add_child(kaydir)
	var liste := VBoxContainer.new()
	liste.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaydir.add_child(liste)
	for konu in KONULAR:
		if konu != KONULAR[0]: liste.add_child(HSeparator.new())
		for i in range(1, SATIR_SAYISI + 1):
			var anahtar := "ogretici.usul.%s.%d" % [konu, i]
			var satir := Label.new()
			satir.set_meta(&"usul_anahtari", anahtar)
			satir.text = tr(anahtar)
			satir.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			liste.add_child(satir)
	var geri := Button.new()
	geri.text = tr("arayuz.ayarlar.geri")
	geri.pressed.connect(func() -> void: kapandi.emit())
	dikey.add_child(geri)
	kaydir.grab_focus.call_deferred()

func _unhandled_input(olay: InputEvent) -> void:
	if olay.is_action_pressed("geri"):
		get_viewport().set_input_as_handled()
		kapandi.emit()
