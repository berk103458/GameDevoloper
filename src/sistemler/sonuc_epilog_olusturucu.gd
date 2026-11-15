## ANL-EPI-01: Mevcut sonuç ekranının kaydırılan alanına kişisel akıbet kartlarını ekler.
extends RefCounted


static func kur(ekran: Control, oturum: Oturum, son: StringName) -> void:
	if oturum == null or son == &"demo":
		return
	var kaydir := ekran.find_child("epilogue_kaydir", true, false) as ScrollContainer
	if kaydir == null:
		return
	var icerik := kaydir.get_child(0) as VBoxContainer
	var kartlar := VBoxContainer.new()
	kartlar.name = "kisisel_akibet_kartlari"
	kartlar.add_theme_constant_override("separation", int(MuhafizEpilogu.AYAR.ayrim_px))
	icerik.add_child(kartlar)
	for veri in EpilogMetinVerisi.tum_kartlar(oturum):
		var kart := VBoxContainer.new()
		kart.name = String(veri.id)
		kartlar.add_child(kart)
		var baslik := _etiket(ekran, String(veri.baslik_anahtari), int(MuhafizEpilogu.AYAR.baslik_px))
		baslik.name = "Baslik"
		kart.add_child(baslik)
		var metin := _etiket(ekran, String(veri.metin_anahtari), int(MuhafizEpilogu.AYAR.metin_px))
		metin.name = "Metin"
		kart.add_child(metin)


static func _etiket(ekran: Control, anahtar: String, boyut: int) -> Label:
	var etiket := Label.new()
	etiket.text = GuvenliMetin.metin(anahtar)
	etiket.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var ayar := ekran.get("ayarlar") as Ayarlar
	etiket.add_theme_font_size_override("font_size", ayar.boyut(boyut) if ayar != null else boyut)
	return etiket
