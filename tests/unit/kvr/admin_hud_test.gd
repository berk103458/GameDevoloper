extends SceneTree
## Admin konsolu: mekanik + SRM-04 kapisi (TEK-27/TEK-28). Kriter tek yerde: AdminHud.arac_acik().
var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var hud := AdminHud.new()
	root.add_child(hud)
	_kontrol(not hud.panel.visible and not hud.is_processing(), "Kapali konsol bosta islem yapmaz")
	var olay := InputEventKey.new()
	olay.keycode = KEY_F1
	olay.pressed = true
	var hiz := Engine.time_scale
	hud._input(olay)
	if AdminHud.arac_acik():
		_kontrol(hud.panel.visible and hud.is_processing() and not paused and Engine.time_scale == hiz, "F1 acikken ayri katmani acar; oyun saati ve pause degismez")
		_kontrol(hud.giris.has_focus(), "Acilinca klavye odagi konsola gecer")
	else:
		_kontrol(not hud.panel.visible and Engine.time_scale == hiz, "Bayrak kapaliyken F1 hicbir sey acmaz")
	# Konsol mekanigi bayraktan bagimsiz ayni kalir.
	hud.ac(true)
	_kontrol(hud.panel.visible and hud.is_processing(), "Mekanik: konsol acilir")
	_kontrol(hud.giris.has_focus(), "Mekanik: acilinca odak konsola gecer")
	var kare := Engine.get_process_frames()
	await process_frame
	await process_frame
	_kontrol(Engine.get_process_frames() > kare, "Konsol acikken oyun kareleri ilerler")
	if AdminHud.arac_acik():
		olay.echo = true
		hud._input(olay)
		_kontrol(hud.panel.visible, "Tus tekrari konsolu kapatmaz")
		olay.echo = false
		olay.keycode = KEY_ESCAPE
		hud._input(olay)
		_kontrol(not hud.panel.visible, "ESC konsolu kapatir")
		olay.keycode = KEY_QUOTELEFT
		hud._input(olay)
		_kontrol(hud.panel.visible, "Tilde tusu acar")
		hud.ac(false)
	hud._komut("yardim")
	hud._komut("durum")
	_kontrol(hud.cikti.text.contains("Oturum yok"), "Oturumsuz menu durumu guvenlidir")
	for i in 150:
		hud.yaz(str(i))
	_kontrol(hud._gecmis.size() == 100 and not hud.cikti.text.begins_with("0\n"), "Konsol gecmisi sinirlidir")
	hud._komut("temizle")
	_kontrol(hud.cikti.text.is_empty(), "Temizle yalniz konsol gecmisini siler")
	hud.free()
	await process_frame
	await process_frame
	print("ADMIN HUD: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
