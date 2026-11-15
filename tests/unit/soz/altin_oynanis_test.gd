# gdlint: disable=max-line-length
extends SceneTree
## KAY-24 / KAY-54: Yusuf altın kayıtları satır kimliğiyle yeniden oynanır. Yeni cümle yazılmaz.
## DIY-16: Yusuf altın oynanış testi.

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	# 1. Cursor KAY-24 / KAY-54 Testi
	var ham := FileAccess.get_file_as_string("res://tests/fixtures/kayit/yusuf_altin.json")
	var paket: Variant = JSON.parse_string(ham)
	dene(paket is Dictionary and paket.get("kisi") == "yusuf", "Yusuf için en az bir altın kayıt")
	var oynanislar: Array = paket.get("oynanislar", []) if paket is Dictionary else []
	dene(oynanislar.size() == 15, "DYL-16 Yusuf paketi 15 oynanış")
	var bas := Time.get_ticks_usec()
	var tamam := 0
	for kayit in oynanislar:
		if not kayit is Dictionary:
			dene(false, "Oynanış kaydı sözlük")
			continue
		var satirlar := SozMotoru.oynat(kayit)
		var beklenen: PackedStringArray = PackedStringArray()
		for satir in kayit.get("satirlar", []):
			beklenen.append(String(satir))
		dene(satirlar == beklenen, "Satır kimlikleri birebir: tohum %s" % str(kayit.get("tohum", "")))
		dene(SozMotoru.etkiler_ayni(kayit.get("etki", {}), kayit.get("etki", {})), "Kayıtlı etki aynı")
		var bozuk: Dictionary = (kayit.get("etki", {}) as Dictionary).duplicate(true)
		bozuk["guven"] = 99
		dene(not SozMotoru.etkiler_ayni(kayit.get("etki", {}), bozuk), "Bozulan etki sapar")
		tamam += 1
	var sure_ms := (Time.get_ticks_usec() - bas) / 1000.0
	print("KAY-54 sure_ms=%.2f tamam=%d/15" % [sure_ms, tamam])
	dene(tamam == 15, "15/15 oynanış biter")

	# 2. Antigravity DIY-16 Testi
	var dosya := FileAccess.open("res://data/soz/ornek_durust.json", FileAccess.READ)
	if dosya:
		var motor := SozMotoru.new()
		motor.yukle(JSON.parse_string(dosya.get_as_text()))

		var altin_dosya := FileAccess.open("res://tests/soz/altin/yusuf_altin_01.json", FileAccess.READ)
		if altin_dosya:
			var altin: Dictionary = JSON.parse_string(altin_dosya.get_as_text())
			var secimler: Array = altin.get("secim_dizisi", [])
			var beklenen_satirlar: Array = altin.get("beklenen_satirlar", [])

			var gerceklesen_satirlar: Array[String] = []
			gerceklesen_satirlar.append(motor.mevcut_satir())

			for s_id in secimler:
				var _sonuc := motor.sec(str(s_id))
				gerceklesen_satirlar.append(motor.mevcut_satir())

			dene(gerceklesen_satirlar.size() == beklenen_satirlar.size(), "Altın oynanış satır sayısı uyuşmuyor")
			for i in range(mini(gerceklesen_satirlar.size(), beklenen_satirlar.size())):
				dene(gerceklesen_satirlar[i] == beklenen_satirlar[i], "Adım %d satırı uyuşmuyor" % i)
			await _cilali_kapi_satirlari(secimler, gerceklesen_satirlar)

	print("ALTIN OYNANIŞ: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)


func _cilali_kapi_satirlari(secimler: Array, temel_satirlar: Array[String]) -> void:
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	await kapi.gelen_yaklas("chr_012")
	var model := kapi._gelen
	dene(KapiKameraVurgu.kadrajda_mi(kapi.kamera, model.global_position),
		"SAH-80: gerçek kapı kadrajı etkin")
	dene(kapi.gelen_hareket_var("konus"), "SAH-80: gerçek konuşma klibi yüklü")
	kapi.gelen_konus(5.0)
	await process_frame
	dene(model._oynatici.current_animation == model._klipler.get("konus", ""),
		"SAH-80: konuşma klibi oynuyor")
	var motor := SozMotoru.new()
	motor.yukle(JSON.parse_string(FileAccess.get_file_as_string("res://data/soz/ornek_durust.json")))
	var satirlar: Array[String] = [motor.mevcut_satir()]
	for secim in secimler:
		motor.sec(str(secim))
		satirlar.append(motor.mevcut_satir())
	dene(satirlar == temel_satirlar, "SAH-80: kamera ve klip altın satırları değiştirmedi")
	print("SAH-80 cila açık: %d satır" % satirlar.size())
	kapi.free()
