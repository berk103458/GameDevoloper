## Geçici ilk sorgu ipuçları; mevcut soru/heybe/karar arayüzünü değiştirmez.
extends RefCounted
const AK = preload("res://src/sistemler/kapi_acilis_olayi.gd")
static func kur(k: KapiEkrani) -> void:
	if not AK.aile_bekliyor(k.oturum) or k.has_node("AcilisOgretici"): return
	if not preload("res://src/sistemler/ipucu_anahtari.gd").gosterim_acik(k.ayarlar): return
	var kutu := VBoxContainer.new()
	kutu.name = "AcilisOgretici"
	kutu.position = Vector2(32, 192)
	kutu.size = Vector2(560, 152)
	k.add_child(kutu)
	var etiket := Label.new()
	etiket.name = "Adimlar"
	var satirlar := IlkSaat.kapi_acilis_satirlari(k.oturum)
	etiket.text = "\n".join(satirlar)
	var kimlikler := ["kapi_selam", "kapi_konu", "kapi_karar"]
	for i in mini(satirlar.size(), kimlikler.size()):
		if not satirlar[i].is_empty(): preload("res://src/debug/ilk_saat_kancasi.gd").ipucu(k.oturum, kimlikler[i])
	etiket.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	etiket.add_theme_font_size_override("font_size", 18)
	etiket.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	etiket.add_theme_constant_override("shadow_offset_x", 1)
	etiket.add_theme_constant_override("shadow_offset_y", 1)
	var kutu_stil := StyleBoxFlat.new()
	kutu_stil.bg_color = Color(0.05, 0.05, 0.07, 0.78)
	kutu_stil.border_color = Color(0.79, 0.64, 0.42, 0.45)
	kutu_stil.set_border_width_all(1)
	kutu_stil.set_content_margin_all(10)
	etiket.add_theme_stylebox_override("normal", kutu_stil)
	kutu.add_child(etiket)
	var atla := Button.new()
	atla.text = "Öğreticiyi atla · ailenin kararı yine gerekli"
	atla.custom_minimum_size.y = 44
	kutu.add_child(atla)
	atla.pressed.connect(func() -> void: kutu.queue_free())
