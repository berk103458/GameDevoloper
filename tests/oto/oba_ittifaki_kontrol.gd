extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar=Ayarlar.new("user://unused_oba_ittifaki.cfg")
		katalog=Katalog.new()
		katalog.yukle()
		oturum=Oturum.new(katalog,1503)
		kayit=GuvenliKayit.new("user://unused_oba_ittifaki.json")
		theme=Tema.olustur(ayarlar)
func _ready() -> void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	get_tree().create_timer(45).timeout.connect(func() -> void: get_tree().quit(1))
	var ana:=TestAna.new()
	add_child(ana)
	var o:=ana.oturum
	var y:=o.yonetim
	y.kaynaklar.kapasite=300
	y.kaynaklar.stok.bugday=100
	var ahir:=KoyBinasi.new()
	ahir.id=801;ahir.tur="ahir"
	y.binalar.append(ahir)
	ana._koye_git()
	await get_tree().process_frame
	var e:=ana._ekran as KoyEkrani
	e._pazar_ac()
	await get_tree().process_frame
	var d:=e.find_child("oba_takas_at",true,false) as Button
	assert(d!=null and not d.disabled)
	d.grab_focus()
	var dizin:=OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name()!="headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("har07_oba.png"))
	var kamu:=y.akce
	var para:=o.muhafiz_akce
	d.pressed.emit()
	await get_tree().process_frame
	d=e.find_child("oba_takas_at",true,false) as Button
	var alp:=e.find_child("oba_takas_alp",true,false) as Button
	assert(d!=null and d.disabled and alp!=null and alp.disabled)
	assert(e.sahne3b.find_child("celep_beygir",true,false)!=null)
	assert(y.akce==kamu and o.muhafiz_akce==para and ObaIttifaki.muttefik(o) and y.kaynaklar.miktar("bugday")==80 and int(y.lojistik.hayvanlar.beygir)==1)
	e._kart_kapat()
	await get_tree().process_frame
	y.gun+=1
	var ev:=KoyBinasi.new()
	ev.id=802;ev.tur="kulube";ev.seviye=10
	y.binalar.append(ev)
	e._pazar_ac()
	await get_tree().process_frame
	alp=e.find_child("oba_takas_alp",true,false) as Button
	assert(alp!=null and not alp.disabled)
	var n:=y.nufus()
	alp.pressed.emit()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	assert(e.sahne3b.halk_hareketi.modeller.has((y.koylular.back() as Koylu).id))
	assert(y.nufus()==n+1 and y.kaynaklar.miktar("bugday")==50 and (y.koylular.back() as Koylu).sinif==&"asker")
	e._kart_kapat()
	await get_tree().process_frame
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.5).timeout
	print("OBA UI: GEÇTİ")
	await Ses.cik(0)
