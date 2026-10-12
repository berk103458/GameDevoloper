extends SceneTree
## TEK-27 + TEK-28: Admin HUD oyuncu surumunde dogmaz; F1/~ yalniz adminde. Kriter tek yerde (AdminHud.arac_acik, SRM-04).
var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	_kontrol(AdminHud.arac_acik(PackedStringArray()) == false, "Bayraksiz surecte kriter kapali")
	_kontrol(AdminHud.arac_acik(PackedStringArray(["--bridge-port", "9000"])) == false, "Baska bayrak debug aracini acmaz")
	_kontrol(AdminHud.arac_acik(PackedStringArray(["--debug-arac"])) == true, "Yalniz --debug-arac acar")
	# Kabul (TEK-27): kapali surumde AdminHud kurulmaz; ana.gd kurulumu kriter arkasinda tutar.
	var kaynak := FileAccess.get_file_as_string("res://src/arayuz/ana.gd")
	_kontrol(not kaynak.is_empty(), "ana.gd okunur")
	_kontrol(kaynak.count("AdminHud.new()") == 1, "AdminHud tek yerde kurulur")
	var i := kaynak.find("AdminHud.new()")
	var blok := kaynak.substr(maxi(i - 120, 0), 400)
	_kontrol(blok.contains("if AdminHud.arac_acik():") and blok.contains("add_child(admin)"), "Kurulum admin kapisi ardinda ve add_child kapiya bagli")
	if AdminHud.arac_acik():
		# Surec gelistirici bayragiyla acildiysa oyuncu-sayisi iddiasi kapsam disidir.
		print("ADMIN HUD OYUNCU SURUMU: ATLANDI (debug-arac acik)")
		quit(0)
		return
	# Kabul (TEK-28): HUD yokken F1/~ hicbir seyi acmaz; ayni kriter kapaliyken de oyle.
	var hud := AdminHud.new()
	root.add_child(hud)
	_kontrol(not hud.panel.visible and not hud.is_processing(), "Kapali konsol bos durur")
	var zaman := Engine.time_scale
	for tus in [KEY_F1, KEY_QUOTELEFT]:
		var olay := InputEventKey.new()
		olay.keycode = tus
		olay.pressed = true
		hud._input(olay)
		_kontrol(not hud.panel.visible, "Kapaliyken kisayol konsolu acmaz")
		_kontrol(Engine.time_scale == zaman, "Kapaliyken kisayol oyun hizini degistirmez")
	hud.free()
	await process_frame
	await process_frame
	print("ADMIN HUD OYUNCU SURUMU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
