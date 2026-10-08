extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_sancak_asker.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog,1403)
		kayit = GuvenliKayit.new("user://unused_sancak_asker.json")
		theme = Tema.olustur(ayarlar)
func dugme(e: KoyEkrani,s: String) -> Button:
	for b in e.find_children("*","Button",true,false):
		if b.text.contains(s) and not b.is_queued_for_deletion(): return b
	return null
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	for i in 5: y.kabul({"ad":"Levent %d"%i})
	y.kaynaklar.ekle("gida",150)
	y.kaynaklar.ekle("su",150)
	y.gun = 7
	o.gece_sonu()
	assert(y.gun==8 and SancakAskerTalebi.oku(o.sancak_asker_talebi).bekliyor)
	ana.oturum = Oturum.kayittan(ana.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
	o = ana.oturum
	y = o.yonetim
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	var olay := SancakAskerTalebi.olay(o)
	e._olay_goster(olay,{})
	var al := dugme(e,"Uygun iş gücünden")
	var asi := dugme(e,"Açık iş reddi adaylarından")
	assert(al!=null and not al.disabled and asi!=null and asi.disabled)
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har04_ferman.png"))
	var para := o.muhafiz_akce
	var kamu := y.akce
	al.pressed.emit()
	await get_tree().process_frame
	assert(y.nufus()==3 and o.koy.toplam()==3 and o.muhafiz_akce==para and y.akce==kamu and not SancakAskerTalebi.oku(o.sancak_asker_talebi).bekliyor)
	var once := JSON.stringify(o.kaydet())
	assert(not o.olay_uygula(olay,0).ok and JSON.stringify(o.kaydet())==once)
	var bitir := dugme(e,"Devam")
	assert(bitir!=null)
	# Fermanın kapanış sözleşmesini izole et; kapının ayrı async varlık yüklemesini başlatma.
	for c in e.devam_istendi.get_connections(): e.devam_istendi.disconnect(c.callable)
	var devam := [false]
	e.devam_istendi.connect(func(_r: Dictionary) -> void: devam[0]=true)
	bitir.pressed.emit()
	await get_tree().process_frame
	assert(devam[0] and e._ust_kart==null)
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("SANCAK ASKER UI: GEÇTİ")
	await Ses.cik(0)
