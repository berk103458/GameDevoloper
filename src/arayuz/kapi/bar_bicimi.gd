## AYR-15: Bar adı renkle birlikte bir harf taşır.
extends RefCounted

const SIRALI := ["H", "A", "M", "B"]


static func harf(ad: String) -> String:
	var temiz := ad.strip_edges()
	if temiz.is_empty():
		return ""
	return temiz.substr(0, 1).to_upper()


static func isaretle(kok: Node) -> void:
	if kok == null:
		return
	_tara(kok, [0])


static func _tara(n: Node, sayac: Array) -> void:
	if n is ProgressBar:
		var ad := String(n.name)
		var yazi := ""
		if ad.is_empty() or ad.begins_with("@"):
			yazi = SIRALI[int(sayac[0]) % SIRALI.size()]
			sayac[0] = int(sayac[0]) + 1
		else:
			yazi = harf(ad)
		n.set_meta(&"harf", yazi)
		var etiket := n.get_node_or_null("harf") as Label
		if etiket == null:
			etiket = Label.new()
			etiket.name = "harf"
			etiket.mouse_filter = Control.MOUSE_FILTER_IGNORE
			n.add_child(etiket)
		etiket.add_theme_font_size_override("font_size", 11)
		etiket.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		etiket.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
		etiket.offset_left = 4
		etiket.text = yazi
	for cocuk in n.get_children():
		_tara(cocuk, sayac)
