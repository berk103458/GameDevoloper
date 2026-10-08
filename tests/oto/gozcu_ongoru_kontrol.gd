extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar=Ayarlar.new("user://unused_gozcu.cfg")
		katalog=Katalog.new()
		katalog.yukle()
		oturum=Oturum.new(katalog,1603)
		kayit=GuvenliKayit.new("user://unused_gozcu.json")
		theme=Tema.olustur(ayarlar)
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana:=TestAna.new()
	add_child(ana)
	var o:=ana.oturum
	var y:=o.yonetim
	y.akce=100
	y.kaynaklar.kapasite=1000
	for tur in ["odun","tas","kereste","gida","su"]: y.kaynaklar.ekle(tur,100)
	var konum:=Vector2i(-1,-1)
	for yy in y.a.izgara_boyut.y:
		for x in y.a.izgara_boyut.x:
			if y.yerlesim(GozcuKulesi.TUR,Vector2i(x,yy)).olur: konum=Vector2i(x,yy); break
		if konum.x>=0: break
	var r:=y.bina_kur(GozcuKulesi.TUR,konum)
	assert(r.olur)
	var b:=y.bina(int(r.id))
	b.insa_kalan=0
	var k:=y.kabul({"ad":"Gözcü","sinif":"asker","stat":5})
	assert(y.ata(k.id,b.id))
	ana._koye_git()
	await get_tree().process_frame
	var e:=ana._ekran as KoyEkrani
	e._kategori="savunma"
	e._yapi_satirini_ciz()
	await get_tree().process_frame
	var kart: YapiKarti
	for c in e._yapi_satiri.get_children():
		if c is YapiKarti and c.tooltip_text==String(GozcuKulesi.AYAR.aciklama): kart=c
	assert(kart!=null and not kart.disabled)
	kart.pressed.emit()
	assert(e.kip=="insa" and e._insa_turu==GozcuKulesi.TUR)
	e._kip_sec("")
	var kutu:=e.sahne3b.find_child("GozcuKulesiYerTutucu",true,false) as MeshInstance3D
	assert(kutu!=null and kutu.mesh is BoxMesh)
	var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har06_kule.png"))
	var once:=JSON.stringify(o.kaydet())
	var harita:=HaritaBaglantisi.ac(e)
	assert(harita!=null and harita._bilgi.text.contains("Gözcü öngörüsü") and harita._bilgi.text.contains("İsim/sınıf yalnız yol gözlemidir"))
	assert(JSON.stringify(o.kaydet())==once)
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har06_ongoru.png"))
	harita.queue_free()
	await get_tree().process_frame
	k.bayrak_ekle("zindanda")
	harita=HaritaBaglantisi.ac(e)
	assert(harita!=null and harita._bilgi.text.contains("öngörüsü kapalı"))
	harita.queue_free()
	await get_tree().process_frame
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("GOZCU UI: GEÇTİ")
	await Ses.cik(0)
