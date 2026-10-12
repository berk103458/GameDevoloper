extends SceneTree
## TEK-28: F1 ve ~ yalniz adminde. Admin HUD yokken hicbir sey acilmaz; kriter AdminHud icinde.
var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var kaynak := FileAccess.get_file_as_string("res://src/debug/admin_hud.gd")
	_kontrol(not kaynak.is_empty(), "admin_hud.gd okunur")
	var i := kaynak.find("_input")
	var blok := kaynak.substr(i, 220)
	_kontrol(blok.contains("if not arac_acik():"), "Kisayol isleyicisi admin kapisina bagli")
	_kontrol(blok.contains("KEY_F1") and blok.contains("KEY_QUOTELEFT") and blok.contains("unicode == 126"), "F1 ve ~ yalniz bu isleyicide")
	_kontrol(kaynak.count("KEY_F1") == 1 and kaynak.count("KEY_QUOTELEFT") == 1, "F1/~ baska yerde islenmez")
	# HUD ornegi kapaliyken hicbir kisayol etkisi yoktur.
	var hud := AdminHud.new()
	root.add_child(hud)
	var zaman := Engine.time_scale
	for tus in [KEY_F1, KEY_QUOTELEFT]:
		var olay := InputEventKey.new()
		olay.keycode = tus
		olay.pressed = true
		hud._input(olay)
		_kontrol(not hud.panel.visible and Engine.time_scale == zaman, "Kapaliyken kisayol etkisiz")
	hud.free()
	await process_frame
	await process_frame
	print("ADMIN HUD KISAYOL: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
