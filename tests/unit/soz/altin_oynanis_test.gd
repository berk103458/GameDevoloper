# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://data/soz/ornek_durust.json", FileAccess.READ)
	if not dosya:
		hatalar.append("ornek_durust.json açılamadı!")
		quit(1)
		return

	var motor := SozMotoru.new()
	motor.yukle(JSON.parse_string(dosya.get_as_text()))

	var altin_dosya := FileAccess.open("res://tests/soz/altin/yusuf_altin_01.json", FileAccess.READ)
	if not altin_dosya:
		hatalar.append("yusuf_altin_01.json açılamadı!")
		quit(1)
		return

	var altin: Dictionary = JSON.parse_string(altin_dosya.get_as_text())
	var secimler: Array = altin.get("secim_dizisi", [])
	var beklenen_satirlar: Array = altin.get("beklenen_satirlar", [])

	var gerceklesen_satirlar: Array[String] = []
	gerceklesen_satirlar.append(motor.mevcut_satir())

	for s_id in secimler:
		var sonuc := motor.sec(str(s_id))
		gerceklesen_satirlar.append(motor.mevcut_satir())

	if gerceklesen_satirlar.size() != beklenen_satirlar.size():
		hatalar.append("Altın oynanış satır sayısı uyuşmuyor: beklenen %d, gerçekleşen %d" % [beklenen_satirlar.size(), gerceklesen_satirlar.size()])

	for i in range(mini(gerceklesen_satirlar.size(), beklenen_satirlar.size())):
		if gerceklesen_satirlar[i] != beklenen_satirlar[i]:
			hatalar.append("Adım %d satırı uyuşmuyor: '%s' != '%s'" % [i, gerceklesen_satirlar[i], beklenen_satirlar[i]])

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: altin_oynanis_test.gd")
	quit(0)
