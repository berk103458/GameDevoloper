extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar=Ayarlar.new("user://unused_cete_anlasmasi.cfg")
		katalog=Katalog.new()
		katalog.yukle()
		oturum=Oturum.new(katalog,1503)
		kayit=GuvenliKayit.new("user://unused_cete_anlasmasi.json")
		theme=Tema.olustur(ayarlar)
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana:=TestAna.new()
	add_child(ana)
	var o:=ana.oturum
	var y:=o.yonetim
	y.akce=10
	o.muhafiz_akce=100
	ana._koye_git()
	await get_tree().process_frame
	var e:=ana._ekran as KoyEkrani
	e._pazar_ac()
	await get_tree().process_frame
	var d:=e.find_child("cete_anlasma_ode",true,false) as Button
	assert(d!=null and not d.disabled)
	d.grab_focus()
	var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har08_cete.png"))
	var rng:=y._rng.state
	d.pressed.emit()
	await get_tree().process_frame
	d=e.find_child("cete_anlasma_ode",true,false) as Button
	assert(d!=null and d.disabled and y.akce==0 and o.muhafiz_akce==100 and CeteAnlasmasi.aktif(y) and y._rng.state==rng)
	var once:=JSON.stringify(o.kaydet())
	d.pressed.emit()
	assert(JSON.stringify(o.kaydet())==once)
	e._kart_kapat()
	await get_tree().process_frame
	y.gun=30
	e._pazar_ac()
	await get_tree().process_frame
	d=e.find_child("cete_anlasma_ode",true,false) as Button
	assert(d!=null and d.disabled and not CeteAnlasmasi.aktif(y))
	e._kart_kapat()
	await get_tree().process_frame
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("CETE UI: GEÇTİ")
	await Ses.cik(0)
