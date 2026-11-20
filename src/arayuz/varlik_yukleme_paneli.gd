## Kaynaklar hazır olana kadar input alan, arayüzü canlı tutan geçiş katmanı.
class_name VarlikYuklemePaneli
extends CanvasLayer

func _input(_olay: InputEvent) -> void:
	get_viewport().set_input_as_handled()

static func hazirla(kok: Node, yollar: Array[String]) -> VarlikOnbellek:
	var agac := kok.get_tree()
	var katman := VarlikYuklemePaneli.new()
	katman.process_mode = Node.PROCESS_MODE_ALWAYS
	katman.layer = 100
	var zemin := GeceKapisiCerceve.yukleme_arkasi()
	zemin.name = "kabuk_zemin"
	katman.add_child(zemin)
	var cubuk := ProgressBar.new()
	cubuk.name = "ilerleme"
	cubuk.min_value = 0
	cubuk.max_value = 1
	cubuk.value = 0
	cubuk.show_percentage = false
	cubuk.custom_minimum_size = Vector2(640, 56)
	cubuk.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	cubuk.offset_left = -320
	cubuk.offset_right = 320
	cubuk.offset_top = -128
	cubuk.offset_bottom = -72
	var iz := GeceKapisiCerceve.kutu("loading_track")
	var dolu := GeceKapisiCerceve.kutu("loading_fill")
	if iz != null and dolu != null:
		cubuk.add_theme_stylebox_override("background", iz)
		cubuk.add_theme_stylebox_override("fill", dolu)
	zemin.add_child(cubuk)
	var yazi := Label.new()
	yazi.text = TranslationServer.translate("arayuz.yukleme.hazirlaniyor")
	yazi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	yazi.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	yazi.add_theme_font_size_override("font_size", Kabuk.BASLIK)
	yazi.add_theme_color_override("font_color", Kabuk.yazi())
	yazi.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	yazi.offset_left = -520
	yazi.offset_right = 520
	yazi.offset_top = -180
	yazi.offset_bottom = -130
	zemin.add_child(yazi)
	var ipucu := Label.new()
	ipucu.name = "ipucu"
	ipucu.text = YuklemeIpucu.metin()
	ipucu.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ipucu.add_theme_font_size_override("font_size", Kabuk.GOVDE)
	ipucu.add_theme_color_override("font_color", Kabuk.SOLUK)
	ipucu.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	ipucu.offset_left = -560
	ipucu.offset_right = 560
	ipucu.offset_top = -80
	ipucu.offset_bottom = -28
	zemin.add_child(ipucu)
	kok.add_child(katman)
	var kaynak := VarlikOnbellek.new()
	kaynak.akis_is = VarlikAkisDenetimi.basla()
	kaynak.katman = weakref(katman)
	var yazi_ref: WeakRef = weakref(yazi)
	var guncelle := func(biten: int, toplam: int) -> void:
		var etiket: Object = yazi_ref.get_ref()
		if is_instance_valid(etiket):
			etiket.text = TranslationServer.translate("arayuz.yukleme.ilerleme") % [biten, toplam]
		if is_instance_valid(zemin):
			var bar := zemin.get_node_or_null("ilerleme")
			if bar is ProgressBar and toplam > 0:
				(bar as ProgressBar).max_value = toplam
				(bar as ProgressBar).value = biten
	kaynak.ilerledi.connect(guncelle)
	await agac.process_frame
	await kaynak.yukle(agac, yollar)
	kaynak.ilerledi.disconnect(guncelle)
	return kaynak

static func bitir(kok: Node, kaynak: VarlikOnbellek) -> void:
	# Kurulan gerçek 3B sahne örtünün altında çizilir: ilk pipeline/texture hazırlığı
	# etkileşim açılmadan render edilebilir. Her GPU için sıfır takılma garantisi değildir.
	for i in 2:
		if not is_instance_valid(kok) or not kok.is_inside_tree():
			break
		if DisplayServer.get_name() == "headless":
			await kok.get_tree().process_frame
		else:
			await RenderingServer.frame_post_draw
	var katman: Object = kaynak.katman.get_ref() if kaynak.katman != null else null
	if is_instance_valid(katman):
		katman.queue_free()
	kaynak.bosalt()
	VarlikAkisDenetimi.bitir(kaynak.akis_is)
