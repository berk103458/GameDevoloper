## GIR-01, GIR-03, GIR-09: ayarlardaki kontroller sekmesi. Oynanış ayarı burada durmaz.
class_name KontrollerSekmesi
extends Control

var ayarlar: Ayarlar
var _dinlenen := ""
var _satir_etiket: Dictionary = {}
var _dugmeler: Array[Button] = []


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	zemin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(zemin)
	var kenar := MarginContainer.new()
	kenar.name = "Kenar"
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 80)
	kenar.add_theme_constant_override("margin_top", 48)
	kenar.add_theme_constant_override("margin_right", 80)
	kenar.add_theme_constant_override("margin_bottom", 48)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.name = "Liste"
	dikey.add_theme_constant_override("separation", 8)
	kenar.add_child(dikey)
	var baslik := Label.new()
	baslik.text = tr("arayuz.girdi.sekme")
	baslik.add_theme_font_size_override("font_size", 36)
	dikey.add_child(baslik)
	var kaydir := ScrollContainer.new()
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dikey.add_child(kaydir)
	var liste := VBoxContainer.new()
	liste.name = "Satirlar"
	liste.add_theme_constant_override("separation", 6)
	kaydir.add_child(liste)
	var bekleyen := Label.new()
	bekleyen.name = "Bekleyen"
	dikey.add_child(bekleyen)
	yenile()


func satir_kimlikleri() -> PackedStringArray:
	return GirdiEylemleri.eylem_kimlikleri()


func satir_metni(eylem: String) -> String:
	var etiket := tr("arayuz.girdi." + eylem)
	var metin := "%s  %s" % [etiket, GirdiEylemleri.tus_adi(eylem)]
	if GirdiEylemleri.cakisiyor(eylem):
		metin += "  " + tr("arayuz.girdi.cakisma")
	return metin


func dinle(eylem: String) -> void:
	_dinlenen = eylem
	var bekleyen := get_node_or_null("Kenar/Liste/Bekleyen") as Label
	if bekleyen != null:
		bekleyen.text = tr("arayuz.girdi.bekleniyor")


func olay_al(olay: InputEvent) -> bool:
	if _dinlenen == "":
		return false
	var eylem := _dinlenen
	var oldu := GirdiEylemleri.ata(eylem, olay)
	_dinlenen = ""
	if not oldu and olay is InputEventMouseButton:
		var bekleyen := get_node_or_null("Kenar/Liste/Bekleyen") as Label
		if bekleyen != null:
			bekleyen.text = tr("arayuz.girdi.fare_olmaz")
	else:
		var bekleyen := get_node_or_null("Kenar/Liste/Bekleyen") as Label
		if bekleyen != null:
			bekleyen.text = ""
	yenile()
	return oldu


func yenile() -> void:
	var liste := get_node_or_null("Kenar/Liste/Satirlar") as VBoxContainer
	if liste == null:
		return
	for cocuk in liste.get_children():
		cocuk.queue_free()
	_satir_etiket.clear()
	_dugmeler.clear()
	for id in GirdiEylemleri.eylem_kimlikleri():
		var yatay := HBoxContainer.new()
		yatay.add_theme_constant_override("separation", 12)
		var etiket := Label.new()
		etiket.name = "Ad"
		etiket.custom_minimum_size = Vector2(420, 0)
		etiket.text = satir_metni(id)
		yatay.add_child(etiket)
		var ata := Button.new()
		ata.text = tr("arayuz.girdi.ata")
		ata.focus_mode = Control.FOCUS_ALL
		ata.pressed.connect(dinle.bind(id))
		yatay.add_child(ata)
		liste.add_child(yatay)
		_satir_etiket[id] = etiket
		_dugmeler.append(ata)
	OdakHalkasi.bagla(_dugmeler)


func _input(olay: InputEvent) -> void:
	if not visible or _dinlenen == "":
		return
	if not olay.pressed:
		return
	if olay is InputEventKey and (olay as InputEventKey).echo:
		return
	if olay is InputEventKey or olay is InputEventJoypadButton or olay is InputEventMouseButton:
		olay_al(olay)
		get_viewport().set_input_as_handled()
