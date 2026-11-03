## AYR-11: Bu ziyaretin konuşma akışı kaydırılır. Fare tekeri ve sağ çubuk ilk satıra dönebilir.
class_name KonusmaGecmisi
extends ScrollContainer

var _kutu: VBoxContainer
var _satirlar: Array[String] = []
var imlec := 0


func _ready() -> void:
	horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	if _kutu == null:
		_kutu = VBoxContainer.new()
		_kutu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(_kutu)


func satir_ekle(metin: String) -> void:
	_satirlar.append(metin)
	imlec = maxi(_satirlar.size() - 1, 0)
	var l := Label.new()
	l.text = metin
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if _kutu == null:
		_kutu = VBoxContainer.new()
		add_child(_kutu)
	_kutu.add_child(l)
	scroll_vertical = int(get_v_scroll_bar().max_value) if get_v_scroll_bar() != null else 0


func satir_sayisi() -> int:
	return _satirlar.size()


func ilk_satir() -> String:
	return "" if _satirlar.is_empty() else _satirlar[0]


func ilk_satira_don() -> void:
	imlec = 0
	scroll_vertical = 0


func _gui_input(olay: InputEvent) -> void:
	if olay is InputEventMouseButton and (olay as InputEventMouseButton).pressed:
		var dugme := (olay as InputEventMouseButton).button_index
		if dugme == MOUSE_BUTTON_WHEEL_UP or dugme == MOUSE_BUTTON_WHEEL_DOWN:
			ilk_satira_don()
			accept_event()
	if olay is InputEventJoypadMotion:
		var hareket := olay as InputEventJoypadMotion
		if hareket.axis == JOY_AXIS_RIGHT_Y and absf(hareket.axis_value) > 0.5:
			ilk_satira_don()
			accept_event()
