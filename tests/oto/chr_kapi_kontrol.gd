## Gerçek kapı UI'sında CHR adaptör kabul testi; kullanıcı kaydına dokunmaz.
extends Node

func _ready() -> void:
	get_tree().create_timer(20.0).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var ayarlar := Ayarlar.new()
	kok.theme = Tema.olustur(ayarlar)
	add_child(kok)
	var ekran := KapiEkrani.new()
	ekran.oturum = o
	ekran.ayarlar = ayarlar
	kok.add_child(ekran)
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	ekran._gelen = g
	ekran._ad.text = "Rüstem oğlu Hamza"
	ekran._sohbet_goster()
	await get_tree().process_frame
	assert(ekran._secenekler.get_child_count() == 1)
	var panel := ekran._secenekler.get_child(0)
	assert((panel.get_node("Secenek2") as Button).disabled)
	ekran._soru_sor(2)
	assert(g.chr_sorgusu().dugum_id == &"00")
	(ekran._eylemler.get_child(0) as Button).pressed.emit()
	await get_tree().process_frame
	var inceleme := ekran.get_node("ChrInceleme")
	(inceleme.get_child(0).get_child(1) as Button).pressed.emit()
	assert(not (panel.get_node("Secenek2") as Button).disabled)
	await _foto("inceleme")
	inceleme.queue_free()
	await get_tree().process_frame
	await _foto("diyalog")
	g.chr_sorgusu().tansiyon = 6
	ekran._soru_sor(2)
	assert(g.chr_sorgusu().bayraklar["Flag_Kilitlendi"])
	ekran._karar_goster()
	assert(ekran._karar_anahtarlari.has("kabul") and ekran._karar_anahtarlari.has("ret"))
	var kabul_indeksi := ekran._karar_anahtarlari.find("kabul")
	assert(ekran._karar_dugmeleri[kabul_indeksi].disabled)
	for i in ekran._karar_anahtarlari.size():
		if ekran._karar_anahtarlari[i] != "kabul":
			assert(ekran._karar_anahtarlari[i] in ["ret", "kisla", "rusvet"] and not ekran._karar_dugmeleri[i].disabled)
	var kamu := o.koy_akce
	ekran._karar_bas("kabul")
	assert(ekran._secili.is_empty())
	ekran._karar_ver("kabul")
	assert(ekran.evre == &"karar" and o.koy_akce == kamu)
	kok.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.8).timeout
	print("CHR KAPI UI: GEÇTİ")
	get_tree().quit(0)

func _foto(ad: String) -> void:
	var klasor := OS.get_environment("CHR_TEST_CIKTI")
	if klasor.is_empty() or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(klasor.path_join("chr_" + ad + ".png"))
