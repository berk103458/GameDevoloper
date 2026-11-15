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
	var incele_dugme: Button = null
	for c in ekran._eylemler.get_children():
		if c is Button and (c as Button).text == "Nişan ve yükü incele":
			incele_dugme = c as Button
			break
	_dene(incele_dugme != null, "chr_kapi_kontrol.gd:31 incele düğmesi bulunmalı")
	if incele_dugme != null:
		incele_dugme.pressed.emit()
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
	_ogr53_kontrol(katalog)
	await get_tree().create_timer(0.8).timeout
	print("CHR KAPI UI: GEÇTİ" if _hata == 0 else "CHR KAPI UI: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)

func _ogr53_kontrol(katalog: Katalog) -> void:
	for cekirdek in ["res://src/arayuz/ana.gd", "res://src/arayuz/kapi_ekrani.gd", "res://src/arayuz/koy_ekrani.gd", "res://src/arayuz/hud.gd"]:
		_dene(not FileAccess.get_file_as_string(cekirdek).to_lower().contains("ogretici"), "OGR-53: çekirdekte ogretici olmamalı: " + cekirdek)
	var ogr_ayar := Ayarlar.new()
	ogr_ayar.degerler[&"ipuclari"] = true
	var ogr_o := Oturum.new(katalog, 85)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(ogr_o)
	var acilis := preload("res://src/sistemler/kapi_acilis_olayi.gd")
	acilis.baslat(ogr_o)
	acilis.ulak_bitir(ogr_o)
	var ogr_kok := Control.new()
	ogr_kok.theme = Tema.olustur(ogr_ayar)
	add_child(ogr_kok)
	var ogr_kapi := KapiEkrani.new()
	ogr_kapi.oturum = ogr_o
	ogr_kapi.ayarlar = ogr_ayar
	ogr_kok.add_child(ogr_kapi)
	preload("res://src/arayuz/chr_kapi_adaptoru.gd").acilis_kur(ogr_kapi)
	_dene(ogr_kapi.get_node_or_null("AcilisOgretici") != null, "OGR-53: KapiEkrani açılış öğreticisi adaptör üzerinden kurulmalı")
	ogr_kok.free()

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
