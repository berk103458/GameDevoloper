extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_tekfur_ui.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog,1303)
		kayit = GuvenliKayit.new("user://unused_tekfur_ui.json")
		theme = Tema.olustur(ayarlar)
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	var y := o.yonetim
	y.kabul({"ad":"Heyet tanığı"})
	y.agalik = true
	y.gun = 5
	y.kaynaklar.ekle("gida",100)
	y.kaynaklar.ekle("su",100)
	var r := o.gece_sonu()
	var bulundu := false
	for olay in r.olaylar:
		if olay.has("tekfur_harac"):
			bulundu = IflasYoneticisi.olay_metin(olay).contains("buğday")
	assert(bulundu and y.gun==6 and y.harac_bekliyor)
	y.akce = y.a.harac_akce
	y.kaynaklar.stok["bugday"] = y.a.harac_gida-1
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	var ode := e.find_child("TekfurHaracOde",true,false) as Button
	assert(ode!=null and ode.disabled and e.find_children("TekfurHeyetiYerTutucu","",true,false).size()==1 and e.find_child("TekfurHeyetiYerTutucu",true,false).has_meta("kabuk_yer_tutucu"))
	y.kaynaklar.stok["bugday"] += 1
	e._yenile()
	await get_tree().process_frame
	ode = e.find_child("TekfurHaracOde",true,false) as Button
	assert(ode!=null and not ode.disabled)
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har03_heyet.png"))
	var para := o.muhafiz_akce
	ode.pressed.emit()
	await get_tree().process_frame
	assert(not y.harac_bekliyor and y.akce==0 and y.kaynaklar.miktar("bugday")==0 and o.muhafiz_akce==para and not e._bant.visible)
	o = Oturum.kayittan(ana.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
	ana.oturum = o
	y = o.yonetim
	y.harac_bekliyor = true
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran as KoyEkrani
	var red := e.find_child("TekfurHaracReddet",true,false) as Button
	assert(red!=null)
	red.pressed.emit()
	await get_tree().process_frame
	assert(y.tekfur_baski==1 and not y.harac_bekliyor and not e._bant.visible)
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("TEKFUR HEYET UI: GEÇTİ")
	await Ses.cik(0)
