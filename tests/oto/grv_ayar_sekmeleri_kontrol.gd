extends Node

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	var kok := Control.new()
	kok.size = Vector2(1600, 900)
	var ayar := Ayarlar.new("user://grv25_kullanilmaz.cfg")
	AyarlarEk.bagla(ayar)
	kok.theme = Tema.olustur(ayar)
	add_child(kok)
	var ekran := AyarlarEkrani.new()
	ekran.ayarlar = ayar
	kok.add_child(ekran)
	var sekmeler := ekran.get_node("AyarSekmeleri") as AyarSekmeleri
	for i in [0, 3, 1, 4, 5, 4, 0]:
		sekmeler._ac(i)
		await get_tree().process_frame
		await get_tree().process_frame
		_kontrol(kok.find_children("*", "AyarlarEkrani", true, false).size() == 1, "tek ayar ekranı")
		_kontrol(sekmeler._icerik.get_child_count() == 1, "tek etkin sekme")
		var gomulu := sekmeler._icerik.find_child("GomuluKontroller", true, false) as KontrollerSekmesi
		_kontrol((gomulu != null) == (i == 4), "kontroller yalnız kendi sekmesinde")
		_kontrol(not ekran.get_node("KontrollerSekmesi").visible, "eski tam ekran kontroller penceresi açılmaz")
		if gomulu != null:
			_kontrol(gomulu.is_visible_in_tree() and gomulu.ayarlar == ayar, "gerçek kontroller aynı ayar nesnesine bağlı")
			_kontrol(not gomulu.satir_kimlikleri().is_empty(), "gerçek tuş eşleme satırları")
		if i == 5:
			for kod in DilAyari.diller():
				var dugme := sekmeler._icerik.find_child("Dil_" + kod, true, false) as Button
				_kontrol(dugme != null and dugme.is_visible_in_tree(), "dil seçeneği aynı kabukta")
	_kontrol(ekran.get_node_or_null("DilListesi") == null, "ayrı dil penceresi açılmaz")
	kok.free()
	await get_tree().process_frame
	print("GRV-25 %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(0 if _hata == 0 else 1)


func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		_hata += 1
		push_error(mesaj)
