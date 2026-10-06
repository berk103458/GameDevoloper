## HUD yalnız görünür bir uyarıyı canlandırırken kare başı çalışır.
extends RefCounted

static func uygula(hud: Hud) -> void:
	var aktif := false
	if hud._oturum != null:
		var y := hud._oturum.yonetim
		var gida := y.gida_gunu() < 2.0 and y.nufus() > 0
		var asayis := y.asayis_riski >= Hud.ASAYIS_KRITIK
		var isyan := y.isyan_kalan >= 0
		aktif = hud.is_visible_in_tree() and (gida or asayis or isyan)
		if not gida:
			(hud._stok_etiketleri["gida"] as KaynakGostergesi).modulate.a = 1.0
		if not asayis:
			hud._asayis.modulate.a = 1.0
		if not isyan:
			hud._huzur_etiket.modulate.a = 1.0
	hud.set_process(aktif)
