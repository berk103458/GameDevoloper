## Heybe panelinde bir eşya kartı: simge, ad, adet; astardan çıktıysa "beyan edilmedi" etiketi.
## Basınca alınacaklara gider/döner (panel yönetir). Akçede −/+ ile adet seçilir; klavyede ◀ ▶.
class_name EsyaKarti
extends Button

signal adet_istendi(degisim: int)

const BOYUT := Vector2(176, 150)

var esya: Dictionary
var ad: String = ""
var gizli_yazi: String = ""
var adet_yazi: String = "%d / %d"
var font_: Font


func _ready() -> void:
	custom_minimum_size = BOYUT
	size = BOYUT
	focus_mode = Control.FOCUS_ALL
	var bos := StyleBoxEmpty.new()
	for s in ["normal", "hover", "pressed", "hover_pressed", "focus", "disabled"]:
		add_theme_stylebox_override(s, bos)
	text = ""
	tooltip_text = ad
	focus_entered.connect(queue_redraw)
	focus_exited.connect(queue_redraw)
	mouse_entered.connect(func() -> void:
		grab_focus()
	)
	if esya["tur"] == "akce" and int(esya["adet"]) > 1:
		for i in 2:
			var b := Button.new()
			b.text = "−" if i == 0 else "+"
			b.focus_mode = Control.FOCUS_NONE
			b.size = Vector2(34, 30)
			b.position = Vector2(8 if i == 0 else BOYUT.x - 42, 8)
			b.add_theme_font_size_override("font_size", Kabuk.KUCUK)
			b.pressed.connect(func() -> void: adet_istendi.emit(-1 if i == 0 else 1))
			add_child(b)


func _gui_input(olay: InputEvent) -> void:
	if esya["tur"] != "akce":
		return
	if olay.is_action_pressed("ui_left") or (olay is InputEventMouseButton and olay.pressed and olay.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		adet_istendi.emit(-1)
		accept_event()
	elif olay.is_action_pressed("ui_right") or (olay is InputEventMouseButton and olay.pressed and olay.button_index == MOUSE_BUTTON_WHEEL_UP):
		adet_istendi.emit(1)
		accept_event()


func _draw() -> void:
	var r := Rect2(Vector2.ZERO, size)
	var gizli: bool = esya["gizli"]
	var alinan := int(esya["alinan"])
	draw_rect(r, Kabuk.zemin())
	var kenar := Renkler.MESALE if gizli else Renkler.KUL
	draw_rect(r.grow(-1), Color(kenar, 1.0 if has_focus() else 0.55), false, 4.0 if has_focus() else 2.0)
	if alinan > 0:
		draw_rect(r.grow(-6), Color(MenuSatiri.ALTIN, 0.8), false, 1.5)
	EsyaSimgesi.ciz(self, String(esya["id"]), Vector2(size.x / 2.0, 62), 38.0, int(esya["adet"]))
	if font_ == null:
		return
	var px := 19
	var satir := ad
	if int(esya["adet"]) > 1 or esya["tur"] == "akce":
		satir = "%d %s" % [esya["adet"], ad]
	draw_string(font_, Vector2(0, 122), satir, HORIZONTAL_ALIGNMENT_CENTER, size.x, px, Renkler.KUL)
	if esya["tur"] == "akce" and alinan > 0 and alinan < int(esya["adet"]):
		draw_string(font_, Vector2(0, 30), adet_yazi % [alinan, esya["adet"]], HORIZONTAL_ALIGNMENT_CENTER, size.x, 18, MenuSatiri.ALTIN)
	if gizli:
		draw_string(font_, Vector2(0, 143), gizli_yazi, HORIZONTAL_ALIGNMENT_CENTER, size.x, 16, Renkler.MESALE)
