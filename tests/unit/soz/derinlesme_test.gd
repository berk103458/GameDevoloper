# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_007",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam muhafız.",
				"secenekler": [
					{ "id": "sec_nereden_1", "hedef": "d_nereden_k0", "metin": "Nereden gelirsin?" }
				]
			},
			"d_nereden_k0": {
				"id": "d_nereden_k0",
				"konu": "nereden",
				"satir": "Karaköy'den.",
				"secenekler": [
					{ "id": "sec_nereden_2", "hedef": "d_nereden_k1", "metin": "Karaköy'de kimler kaldı?" }
				]
			},
			"d_nereden_k1": {
				"id": "d_nereden_k1",
				"konu": "nereden",
				"satir": "Kimse kalmadı, harami bastı.",
				"secenekler": [
					{ "id": "sec_veda", "hedef": "veda", "metin": "Tamam." }
				]
			},
			"veda": {
				"id": "veda",
				"satir": "Veda.",
				"secenekler": []
			}
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)

	# 1. İlk soru katman 0
	motor.sec("sec_nereden_1")
	if motor.aktif_dugum.katman != 1:
		hatalar.append("İlk konu sorusu katman 1 olarak sayılmadı! Katman: %d" % motor.aktif_dugum.katman)

	# 2. İkinci kez aynı konu sorulunca katman 1 satırı gelir (Kabul)
	motor.sec("sec_nereden_2")
	if motor.aktif_dugum.katman != 2:
		hatalar.append("İkinci konu sorusu katman 2 olmadı! Katman: %d" % motor.aktif_dugum.katman)
	if motor.mevcut_satir() != "Kimse kalmadı, harami bastı.":
		hatalar.append("Katman 1 derinleşme satırı doğru gelmedi: '%s'" % motor.mevcut_satir())

	# 3. Sabır sıfırken derinleşme 0 düğümdür (Kabul)
	motor.sabir = 0
	var secenekler := motor.mevcut_secenekler()
	var konu_acici_var := false
	for s in secenekler:
		if s.get("konu_baslat", false):
			konu_acici_var = true
	if konu_acici_var:
		hatalar.append("Sabır sıfırken yeni konu/derinleşme seçeneği açıldı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: derinlesme_test.gd")
	quit(0)
