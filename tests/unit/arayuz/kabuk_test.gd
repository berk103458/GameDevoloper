extends SceneTree
## Kabuk ölçüleri, duraklat zemini, heybe-defter ayrımı ve dört düğme durumu.

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_kontrol(Kabuk.GOVDE == 26 and Tema.GOVDE_PX == Kabuk.GOVDE, "Gövde punto 26 ve Tema takma adı")
	_kontrol(Kabuk.KUCUK == 22 and Tema.KUCUK_PX == Kabuk.KUCUK, "Küçük punto 22")
	_kontrol(Kabuk.BASLIK == 34 and Tema.BASLIK_PX == Kabuk.BASLIK, "Başlık punto 34")
	var ayar := Ayarlar.new()
	var tema := Tema.olustur(ayar)
	for durum in ["normal", "hover", "pressed", "disabled"]:
		_kontrol(tema.get_stylebox(durum, "Button") != null, "Düğme durumu %s" % durum)
	for olcek in [100, 150]:
		for ekran in [Vector2(1920, 1080), Vector2(1600, 900), Vector2(1280, 720)]:
			var kutu := Kabuk.ipucu_kutusu(ekran, olcek)
			_kontrol(kutu.position.x >= 0.0 and kutu.position.y >= 0.0, "İpucu sol-üst %s @%d" % [ekran, olcek])
			_kontrol(kutu.end.x <= ekran.x and kutu.end.y <= ekran.y, "İpucu sağ-alt %s @%d" % [ekran, olcek])
	var heybe := Rect2(Vector2(0, 92), Vector2(1140, 988))
	var defter := Rect2(1172, 104, 716, 952)
	_kontrol(not heybe.intersects(defter), "Heybe defterle kesişmez")
	var bilgi := BilgiEkrani.new()
	bilgi.ayarlar = ayar
	bilgi.baslik = "Duraklat"
	bilgi.dugmeler = PackedStringArray(["Devam"])
	bilgi.arka_plan = ""
	root.add_child(bilgi)
	var zemin := bilgi.get_node_or_null("kabuk_zemin")
	_kontrol(zemin is ColorRect, "Duraklat zemini var")
	var satir := MenuSatiri.new()
	satir.disabled = true
	satir.text = "Devam"
	_kontrol(satir.visible, "Kapalı menü satırı görünür")
	await process_frame
	print("KABUK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
