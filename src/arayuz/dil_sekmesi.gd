## YER-01: ayarlardaki dil satırı. İkinci dil dosyası yoksa tek seçenek çizilir.
class_name DilSekmesi
extends RefCounted


static func ekle(kok: Control, ayarlar: Ayarlar) -> void:
	if kok == null or ayarlar == null or kok.find_child("DilSekmesiDugmesi", true, false) != null:
		return
	var kutu := kok.find_child("VBoxContainer", true, false)
	var hedef: Node = kutu if kutu != null else kok
	var dugme := Button.new()
	dugme.name = "DilSekmesiDugmesi"
	dugme.text = TranslationServer.translate("arayuz.dil.baslik")
	dugme.set_meta(&"metin_anahtari", "arayuz.dil.baslik")
	dugme.pressed.connect(func() -> void: _ac(kok, ayarlar))
	hedef.add_child(dugme)
	if not ayarlar.degisti.is_connected(_yenile):
		ayarlar.degisti.connect(_yenile.bind(kok))


static func _ac(kok: Control, ayarlar: Ayarlar) -> void:
	var eski := kok.get_node_or_null("DilListesi")
	if eski != null:
		eski.queue_free()
		return
	var liste := VBoxContainer.new()
	liste.name = "DilListesi"
	for kod in DilAyari.diller():
		var satir := Button.new()
		satir.text = TranslationServer.translate("arayuz.dil." + kod)
		satir.pressed.connect(func() -> void:
			DilAyari.sec(ayarlar, kod)
			liste.queue_free()
		)
		liste.add_child(satir)
	kok.add_child(liste)


static func _yenile(anahtar: StringName, kok: Node) -> void:
	if anahtar != &"dil" and anahtar != &"":
		return
	_yuru(kok)


static func _yuru(n: Node) -> void:
	if n.has_meta(&"metin_anahtari"):
		var anahtar := str(n.get_meta(&"metin_anahtari"))
		if n is Label:
			var etiket := n as Label
			etiket.text = DilAyari.gorunen("ayarlar", etiket.text, anahtar)
		elif n is Button:
			var dugme := n as Button
			dugme.text = DilAyari.gorunen("ayarlar", dugme.text, anahtar)
	for cocuk in n.get_children():
		_yuru(cocuk)
