extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar=Ayarlar.new("user://unused_goc_yolu.cfg")
		katalog=Katalog.new()
		katalog.yukle()
		oturum=Oturum.new(katalog,1503)
		kayit=GuvenliKayit.new("user://unused_goc_yolu.json")
		theme=Tema.olustur(ayarlar)
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana:=TestAna.new()
	add_child(ana)
	var o:=ana.oturum
	var y:=o.yonetim
	for i in 2:
		var k:=y.kabul({"ad":"Yol nöbetçisi %d"%i,"sinif":"asker","stat":5})
		y.muhafiz_ata(k.id)
	y.husumet.puan=y.a.sizma_esigi
	ana._koye_git()
	await get_tree().process_frame
	var e:=ana._ekran as KoyEkrani
	e._pazar_ac()
	await get_tree().process_frame
	var d:=e.find_child("goc_yolu_temizle",true,false) as Button
	assert(d!=null and not d.disabled)
	d.grab_focus()
	var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har05_goc_yolu.png"))
	var kamu:=y.akce
	var para:=o.muhafiz_akce
	d.pressed.emit()
	await get_tree().process_frame
	d=e.find_child("goc_yolu_temizle",true,false) as Button
	assert(d!=null and d.disabled and y.akce==kamu and o.muhafiz_akce==para and GocYoluGuvenligi.oku(o.goc_yolu_guvenligi).bekleyen==2)
	e._kart_kapat()
	await get_tree().process_frame
	var once:=JSON.stringify(o.kaydet())
	var harita:=HaritaBaglantisi.ac(e)
	assert(harita!=null)
	harita.bolge_sec("goc_yolu")
	assert(harita._bilgi.text.contains("bekleyen ek göç ziyareti 2") and JSON.stringify(o.kaydet())==once)
	harita.queue_free()
	await get_tree().process_frame
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("GOC YOLU UI: GEÇTİ")
	await Ses.cik(0)
