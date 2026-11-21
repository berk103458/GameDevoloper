## ISG-03: olayla yenilenen mevcut HUD nüfus sütunu.
extends RefCounted

static func guncelle(h: Hud, y: KoyYonetimi) -> void:
	var ust := h._nufus.get_parent()
	var l := ust.get_node_or_null("BostaSayisi") as Label
	if l == null:
		l = h._etiket(ust, 15)
		l.name = "BostaSayisi"
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	l.text = TranslationServer.translate("koy.bosta.hud") % preload("res://src/koy/bosta_kalma.gd").sayi(y)
