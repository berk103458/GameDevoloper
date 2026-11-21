## GRV-25: mevcut kontroller ve dil işlevleri aynı ayar sekmesine yerleşir.
extends RefCounted


static func bagla(sayfa: Control, kimlik: StringName, ayarlar: Ayarlar) -> void:
	if kimlik not in [&"kontroller", &"dil"]:
		return
	for cocuk in sayfa.get_children():
		sayfa.remove_child(cocuk)
		cocuk.queue_free()
	sayfa.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if kimlik == &"kontroller":
		var kontroller := KontrollerSekmesi.new()
		kontroller.name = "GomuluKontroller"
		kontroller.ayarlar = ayarlar
		kontroller.size_flags_vertical = Control.SIZE_EXPAND_FILL
		sayfa.add_child(kontroller)
		return
	for kod in DilAyari.diller():
		var secim := Button.new()
		secim.name = "Dil_" + kod
		secim.custom_minimum_size = Vector2(320, 50)
		secim.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		secim.set_meta(&"dil_kodu", kod)
		secim.set_meta(&"metin_anahtari", "arayuz.dil." + kod)
		secim.pressed.connect(func() -> void:
			DilAyari.sec(ayarlar, kod)
			_dil_dugmelerini_yenile(sayfa)
		)
		sayfa.add_child(secim)
	_dil_dugmelerini_yenile(sayfa)


static func _dil_dugmelerini_yenile(sayfa: Control) -> void:
	var aktif_dil := TranslationServer.get_locale()
	for c in sayfa.get_children():
		if c is Button and c.has_meta(&"dil_kodu"):
			var dugme := c as Button
			var kod := String(dugme.get_meta(&"dil_kodu"))
			var secili := aktif_dil.begins_with(kod)
			var metin := TranslationServer.translate("arayuz.dil." + kod)
			dugme.text = ("▸ " + metin) if secili else metin
			var renk := Kabuk.BAR_DOLU if secili else Kabuk.yazi()
			for prop in ["font_color", "font_hover_color", "font_focus_color"]:
				dugme.add_theme_color_override(prop, renk)
