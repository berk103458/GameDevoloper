## AYR-15, AYR-21: Tansiyon üç kademede üç çizgi. Sessizken kademe geçişi bir kez yanıp söner.
extends RefCounted


static func cizgi_sayisi(kademe: int) -> int:
	return clampi(kademe, 0, 2) + 1


static func cizgiler(kademe: int) -> String:
	return "|".repeat(cizgi_sayisi(kademe))


static func uygula(gosterge: Node, kademe: int) -> void:
	if gosterge == null:
		return
	gosterge.set_meta(&"cizgi_sayisi", cizgi_sayisi(kademe))
	var etiket := gosterge.get_node_or_null("bicim") as Label
	if etiket == null:
		etiket = Label.new()
		etiket.name = "bicim"
		etiket.mouse_filter = Control.MOUSE_FILTER_IGNORE
		gosterge.add_child(etiket)
	etiket.text = cizgiler(kademe)


static func kademe_gecti(gosterge: Node, kademe: int, ses_ana: int) -> int:
	if gosterge == null:
		return 0
	var eski := int(gosterge.get_meta(&"son_kademe", -1))
	gosterge.set_meta(&"son_kademe", kademe)
	if ses_ana != 0 or eski < 0 or eski == kademe:
		return 0
	var adet := int(gosterge.get_meta(&"yanip", 0)) + 1
	gosterge.set_meta(&"yanip", adet)
	return 1
