## GIR-01, GIR-03, GIR-09: ayarlardaki kontroller sekmesi. Oynanış ayarı burada durmaz.
class_name KontrollerSekmesi
extends Control

var ayarlar: Ayarlar
var _dinlenen := ""
var _satir_etiket: Dictionary = {}
var _dugmeler: Array[Button] = []


func _ready() -> void:
	var gomulu := (name == "GomuluKontroller")
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	if gomulu:
		custom_minimum_size = Vector2(0, 560)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	zemin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	zemin.visible = not gomulu
	add_child(zemin)
	var kenar := MarginContainer.new()
	kenar.name = "Kenar"
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 12 if gomulu else 80)
	kenar.add_theme_constant_override("margin_top", 6 if gomulu else 48)
	kenar.add_theme_constant_override("margin_right", 12 if gomulu else 80)
	kenar.add_theme_constant_override("margin_bottom", 6 if gomulu else 48)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.name = "Liste"
	dikey.add_theme_constant_override("separation", 10)
	kenar.add_child(dikey)
	var baslik := Label.new()
	baslik.text = tr("arayuz.girdi.sekme")
	var baslik_px := ayarlar.boyut(Tema.GOVDE_PX) if ayarlar != null else Tema.GOVDE_PX
	baslik.add_theme_font_size_override("font_size", baslik_px if gomulu else 36)
	if gomulu:
		baslik.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	dikey.add_child(baslik)
	var kaydir := ScrollContainer.new()
	kaydir.name = "Kaydir"
	kaydir.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	dikey.add_child(kaydir)
	var liste := VBoxContainer.new()
	liste.name = "Satirlar"
	liste.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	liste.add_theme_constant_override("separation", 8)
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
	var liste := find_child("Satirlar", true, false) as VBoxContainer
	if liste == null:
		return
	for cocuk in liste.get_children():
		cocuk.queue_free()
	_satir_etiket.clear()
	_dugmeler.clear()
	for id in GirdiEylemleri.eylem_kimlikleri():
		var yatay := HBoxContainer.new()
		yatay.add_theme_constant_override("separation", 14)
		var etiket := Label.new()
		etiket.name = "Ad"
		etiket.custom_minimum_size = Vector2(360, 42)
		etiket.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		etiket.text = tr("arayuz.girdi." + id)
		yatay.add_child(etiket)
		var tus_lbl := Label.new()
		tus_lbl.name = "Tus"
		tus_lbl.custom_minimum_size = Vector2(260, 42)
		tus_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		tus_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		var cakisma := GirdiEylemleri.cakisiyor(id)
		var tus_metin := GirdiEylemleri.tus_adi(id)
		if cakisma:
			tus_metin += "  " + tr("arayuz.girdi.cakisma")
		tus_lbl.text = tus_metin
		tus_lbl.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
		yatay.add_child(tus_lbl)
		var ata := Button.new()
		ata.text = tr("arayuz.girdi.ata")
		ata.custom_minimum_size = Vector2(160, 42)
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
