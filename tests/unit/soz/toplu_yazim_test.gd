# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://data/diyalog/diyalog_01_20.json", FileAccess.READ)
	if not dosya:
		hatalar.append("data/diyalog/diyalog_01_20.json bulunamadı!")
		quit(1)
		return

	var parsed = JSON.parse_string(dosya.get_as_text())
	if not (parsed is Dictionary):
		hatalar.append("diyalog_01_20.json JSON olarak çözümlenemedi!")
		quit(1)
		return

	# 30 kapı diyaloğu mevcuttur (Görev 6 ile 30'a tamamlandı)
	var diyalog_sayisi := parsed.size()
	if diyalog_sayisi < 30:
		hatalar.append("Toplu yeniden yazımda diyalog sayısı 30'dan az: %d" % diyalog_sayisi)

	for i in range(1, 31):
		var k_id := "diyalog_%02d" % i
		if not parsed.has(k_id):
			hatalar.append("Diyalog '%s' eksik!" % k_id)

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: toplu_yazim_test.gd")
	quit(0)
