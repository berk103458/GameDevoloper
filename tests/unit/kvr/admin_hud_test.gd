extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var hud := AdminHud.new()
	root.add_child(hud)
	_kontrol(not hud.panel.visible and not hud.is_processing(), "Kapalı konsol boşta işlem yapmaz")
	var olay := InputEventKey.new()
	olay.keycode = KEY_F1
	olay.pressed = true
	var hiz := Engine.time_scale
	hud._input(olay)
	_kontrol(hud.panel.visible and hud.is_processing() and not paused and Engine.time_scale == hiz, "F1 ayrı katmanı açar; oyun saati ve pause değişmez")
	_kontrol(hud.giris.has_focus(), "Açılınca klavye odağı konsola geçer")
	var kare := Engine.get_process_frames()
	await process_frame
	await process_frame
	_kontrol(Engine.get_process_frames() > kare, "Konsol açıkken oyun kareleri ilerler")
	olay.echo = true
	hud._input(olay)
	_kontrol(hud.panel.visible, "Tuş tekrarı konsolu kapatmaz")
	olay.echo = false
	olay.keycode = KEY_ESCAPE
	hud._input(olay)
	_kontrol(not hud.panel.visible, "ESC konsolu kapatır")
	olay.keycode = KEY_QUOTELEFT
	hud._input(olay)
	_kontrol(hud.panel.visible, "Tilde tuşu açar")
	hud._komut("yardim")
	hud._komut("durum")
	_kontrol(hud.cikti.text.contains("Oturum yok"), "Oturumsuz menü durumu güvenlidir")
	for i in 150:
		hud.yaz(str(i))
	_kontrol(hud._gecmis.size() == 100 and not hud.cikti.text.begins_with("0\n"), "Konsol geçmişi sınırlıdır")
	hud._komut("temizle")
	_kontrol(hud.cikti.text.is_empty(), "Temizle yalnız konsol geçmişini siler")
	hud.free()
	print("ADMIN HUD: GEÇTİ" if hata == 0 else "ADMIN HUD: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
