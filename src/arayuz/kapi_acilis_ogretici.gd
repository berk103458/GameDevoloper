## Geçici ilk sorgu ipuçları; mevcut soru/heybe/karar arayüzünü değiştirmez.
extends RefCounted
const AK = preload("res://src/sistemler/kapi_acilis_olayi.gd")
static func kur(k: KapiEkrani) -> void:
	if not AK.aile_bekliyor(k.oturum) or k.has_node("AcilisOgretici"): return
	if not preload("res://src/sistemler/ipucu_anahtari.gd").gosterim_acik(k.ayarlar): return
	var kutu := VBoxContainer.new()
	kutu.name = "AcilisOgretici"
	kutu.position = Vector2(32, 130)
	kutu.size = Vector2(850, 240)
	k.add_child(kutu)
	var etiket := Label.new()
	etiket.name = "Adimlar"
	var satirlar := PackedStringArray()
	for anahtar: String in AK.AYAR.ogretici:
		satirlar.append(IlkSaat.ipucu_metni(anahtar))
	etiket.text = "\n".join(satirlar)
	etiket.add_theme_font_size_override("font_size", 22)
	kutu.add_child(etiket)
	var atla := Button.new()
	atla.text = "Öğreticiyi atla · ailenin kararı yine gerekli"
	kutu.add_child(atla)
	atla.pressed.connect(func() -> void: kutu.queue_free())
