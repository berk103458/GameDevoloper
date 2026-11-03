# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://data/soz/gecis.json", FileAccess.READ)
	if not dosya:
		hatalar.append("gecis.json dosyası bulunamadı!")
		quit(1)
		return

	var parsed = JSON.parse_string(dosya.get_as_text())
	if not (parsed is Dictionary):
		hatalar.append("gecis.json JSON olarak çözümlenemedi!")
		quit(1)
		return

	var karakterler: Dictionary = parsed.get("karakterler", {})
	# Otuz adlı karakter yeni motordan konuşur (Kabul)
	if karakterler.size() < 30:
		hatalar.append("Geçiş tablosunda 30 karakter bulunamadı! (Bulunan: %d)" % karakterler.size())

	for i in range(1, 31):
		var chr_id := "chr_%03d" % i
		if not karakterler.has(chr_id):
			hatalar.append("%s geçiş tablosunda eksik!" % chr_id)
			continue
		var k_veri: Dictionary = karakterler[chr_id]
		# Eski yola çağrı 0'dır (Kabul)
		if not k_veri.get("yeni_motor", false):
			hatalar.append("%s yeni motor olarak işaretlenmemiş!" % chr_id)
		if int(k_veri.get("eski_cagri", -1)) != 0:
			hatalar.append("%s eski çağrı sayısı 0 değil: %s" % [chr_id, str(k_veri.get("eski_cagri"))])

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: gecis_test.gd")
	quit(0)
