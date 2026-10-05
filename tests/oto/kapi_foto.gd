extends Node
## Kapı ekranı fotoğrafı (kanıt için; menüsüz kurulum). ENV: GECE, PERDE, SUR, BEKLE, CIKTI, ARAYUZ=0 (yalnız 3D).
## Forward+ için: VK_ICD_FILENAMES=.../lvp_icd.json godot --rendering-driver vulkan --resolution 3840x2160 tests/oto/kapi_foto.tscn
func _ready() -> void:
	TranslationServer.set_locale("tr")
	var ayarlar := Ayarlar.new()
	var katalog := Katalog.new()
	katalog.yukle()
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kok.theme = Tema.olustur(ayarlar)
	add_child(kok)
	var o := Oturum.new(katalog, 4)
	o.gun = int(OS.get_environment("GECE"))
	o.perde = int(OS.get_environment("PERDE"))
	o.perde2_gece = int(OS.get_environment("GECE"))
	o.yapilar[&"sur"] = int(OS.get_environment("SUR"))
	var k := KapiEkrani.new()
	k.oturum = o
	k.ayarlar = ayarlar
	kok.add_child(k)
	k.gece_baslat()
	await get_tree().create_timer(float(OS.get_environment("BEKLE"))).timeout
	if OS.get_environment("ARAYUZ") == "0":
		for c in k.get_children():
			if c is CanvasItem and not c is TextureRect:
				c.visible = false
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(OS.get_environment("CIKTI"))
	get_tree().quit()
