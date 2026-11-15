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
		secim.text = TranslationServer.translate("arayuz.dil." + kod)
		secim.set_meta(&"metin_anahtari", "arayuz.dil." + kod)
		secim.pressed.connect(func() -> void: DilAyari.sec(ayarlar, kod))
		sayfa.add_child(secim)
