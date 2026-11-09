## Gerçek kapı UI'sında CHR adaptör kabul testi; kullanıcı kaydına dokunmaz.
extends Node

var _hata := 0

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
	_dene(ekran._secenekler.get_child_count() == 1, "chr_kapi_kontrol.gd:24")
	var panel := ekran._secenekler.get_child(0)
	_dene((panel.get_node("Secenek2") as Button).disabled, "chr_kapi_kontrol.gd:26")
	ekran._soru_sor(2)
	_dene(g.chr_sorgusu().dugum_id == &"00", "chr_kapi_kontrol.gd:28")
	(ekran._eylemler.get_child(0) as Button).pressed.emit()
	await get_tree().process_frame
	var inceleme := ekran.get_node("ChrInceleme")
	(inceleme.get_child(0).get_child(1) as Button).pressed.emit()
	_dene(not (panel.get_node("Secenek2") as Button).disabled, "chr_kapi_kontrol.gd:33")
	await _foto("inceleme")
	inceleme.queue_free()
	await get_tree().process_frame
	await _foto("diyalog")
	g.chr_sorgusu().tansiyon = 6
	ekran._soru_sor(2)
	_dene(g.chr_sorgusu().bayraklar["Flag_Kilitlendi"], "chr_kapi_kontrol.gd:40")
	ekran._karar_goster()
	_dene(ekran._karar_anahtarlari.has("kabul") and ekran._karar_anahtarlari.has("ret"), "chr_kapi_kontrol.gd:42")
	var kabul_indeksi := ekran._karar_anahtarlari.find("kabul")
	_dene(ekran._karar_dugmeleri[kabul_indeksi].disabled, "chr_kapi_kontrol.gd:44")
	for i in ekran._karar_anahtarlari.size():
		if ekran._karar_anahtarlari[i] != "kabul":
			_dene(ekran._karar_anahtarlari[i] in ["ret", "kisla", "rusvet"] and not ekran._karar_dugmeleri[i].disabled, "chr_kapi_kontrol.gd:47")
	var kamu := o.koy_akce
	ekran._karar_bas("kabul")
	_dene(ekran._secili.is_empty(), "chr_kapi_kontrol.gd:50")
	ekran._karar_ver("kabul")
	_dene(ekran.evre == &"karar" and o.koy_akce == kamu, "chr_kapi_kontrol.gd:52")
	kok.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.8).timeout
	print("CHR KAPI UI: GEÇTİ" if _hata == 0 else "CHR KAPI UI: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)

func _foto(ad: String) -> void:
	var klasor := OS.get_environment("CHR_TEST_CIKTI")
	if klasor.is_empty() or DisplayServer.get_name() == "headless":
		return
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(klasor.path_join("chr_" + ad + ".png"))


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
