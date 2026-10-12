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
	var zemin := ColorRect.new()
	zemin.color = Color("#0d1117")
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	zemin.mouse_filter = Control.MOUSE_FILTER_STOP
	katman.add_child(zemin)
	var yazi := Label.new()
	yazi.text = "Hazırlanıyor…"
	yazi.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	yazi.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	yazi.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	yazi.mouse_filter = Control.MOUSE_FILTER_STOP
	zemin.add_child(yazi)
	kok.add_child(katman)
	var kaynak := VarlikOnbellek.new()
	kaynak.akis_is = VarlikAkisDenetimi.basla()
	kaynak.katman = weakref(katman)
	var yazi_ref: WeakRef = weakref(yazi)
	var guncelle := func(biten: int, toplam: int) -> void:
		var etiket: Object = yazi_ref.get_ref()
		if is_instance_valid(etiket):
			etiket.text = "Hazırlanıyor… %d/%d" % [biten, toplam]
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
