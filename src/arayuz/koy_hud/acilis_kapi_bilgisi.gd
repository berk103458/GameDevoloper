## ACL-01: mevcut kaynak HUD'unda salt okunur ilk gün kapı durumu.
extends RefCounted

static func guncelle(hud: Hud, o: Oturum) -> void:
	var etiket := hud.find_child("acilis_kapi_durumu", true, false) as Label
	var kapali := preload("res://src/sistemler/acilis_senaryosu.gd").kapi_kapali(o)
	if etiket == null and kapali:
		etiket = Label.new()
		etiket.name = "acilis_kapi_durumu"
		etiket.add_theme_color_override("font_color", Hud.UYARI)
		hud.get_child(0).add_child(etiket)
	if etiket != null:
		etiket.text = TranslationServer.translate("acilis.kapi.kapali")
		etiket.visible = kapali
