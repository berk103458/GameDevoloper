## Gerçek CHR kapı incelemesinde hava/kanıt/normal dönüş; kullanıcı kaydına yazmaz.
extends Node
func _ready() -> void:
	get_tree().create_timer(20.0).timeout.connect(func() -> void: get_tree().quit(1))
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 84)
	var ayar := Ayarlar.new()
	var kok := Control.new()
	kok.theme = Tema.olustur(ayar)
	add_child(kok)
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = ayar
	kok.add_child(e)
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	e._gelen = g
	IklimDeneyi.degistir(o, -1, "kar_firtinasi")
	e._sohbet_goster()
	await get_tree().process_frame
	var d := e._secenekler.get_child(0)
	assert((d.get_node("Secenek2") as Button).disabled)
	(e._eylemler.get_child(0) as Button).pressed.emit()
	await get_tree().process_frame
	var p := e.get_node("ChrInceleme") as Control
	var portre := p.find_child("GorselIz", true, false) as TextureButton
	var mat := portre.material as ShaderMaterial
	assert(mat != null and float(mat.get_shader_parameter("yaricap")) == 4.0)
	assert(p.find_child("KapiGorusUyarisi", true, false).visible)
	var sabit := o.kaydet()
	KapiGorusAdaptoru.uygula(p, o.yonetim)
	assert(portre.material == mat and o.kaydet() == sabit)
	portre.pressed.emit()
	assert(not (d.get_node("Secenek2") as Button).disabled)
	assert(not p.get("_aciklama").text.is_empty())
	(p.get_child(0).get_child(1) as Button).pressed.emit()
	assert(p.has_node("EsyaDetayKarti"))
	p.get_node("EsyaDetayKarti").queue_free()
	await get_tree().process_frame
	if DisplayServer.get_name() != "headless" and not OS.get_environment("ADMIN_TEST_CIKTI").is_empty():
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(OS.get_environment("ADMIN_TEST_CIKTI").path_join("mev09_kapi.png"))
	IklimDeneyi.degistir(o, -1, "sis")
	KapiGorusAdaptoru.uygula(p, o.yonetim)
	assert(float(mat.get_shader_parameter("yaricap")) == 2.5)
	var geri := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
	assert(KapiGorusAdaptoru.yaricap(geri.yonetim) == 2.5)
	IklimDeneyi.degistir(o, -1, "normal")
	KapiGorusAdaptoru.uygula(p, o.yonetim)
	assert(portre.material == null and not p.find_child("KapiGorusUyarisi", true, false).visible)
	assert(not (d.get_node("Secenek2") as Button).disabled)
	kok.queue_free()
	await get_tree().process_frame
	print("KAPI GÖRÜŞÜ UI: GEÇTİ")
	await Ses.cik(0)
