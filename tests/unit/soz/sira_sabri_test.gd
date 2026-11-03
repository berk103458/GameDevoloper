# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_008",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam.",
				"secenekler": [
					{ "id": "s1", "hedef": "d1", "metin": "Soru 1", "konu_baslat": true, "sabir_harca": true },
					{ "id": "s2", "hedef": "d2", "metin": "Soru 2", "konu_baslat": true, "sabir_harca": true },
					{ "id": "s_veda", "hedef": "veda", "metin": "Veda", "konu_baslat": false, "sabir_harca": false }
				]
			},
			"d1": {
				"id": "d1",
				"satir": "Cevap 1",
				"secenekler": [
					{ "id": "s_geri", "hedef": "giris", "metin": "Geri dön" }
				]
			},
			"d2": { "id": "d2", "satir": "Cevap 2", "secenekler": [] },
			"veda": { "id": "veda", "satir": "Bitti", "secenekler": [] }
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)

	# Sabrı 1 yapalım
	motor.sabir = 1

	# Bir soru soralım, sabır 0'a düşmeli
	motor.sec("s1")
	if motor.sabir != 0:
		hatalar.append("Sabır harcanmadı! Kalan sabır: %d" % motor.sabir)

	# Geri dönelim
	motor.sec("s_geri")

	# Sabır bittiğinde yeni konu seçilemez (Kabul)
	var secenekler := motor.mevcut_secenekler()
	var sec_ids := secenekler.map(func(s): return s.get("id"))
	if "s1" in sec_ids or "s2" in sec_ids:
		hatalar.append("Sabır 0 iken yeni konu seçenekleri açık kaldı: %s" % str(sec_ids))
	if not ("s_veda" in sec_ids):
		hatalar.append("Sabır bitince veda seçeneği de kapandı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: sira_sabri_test.gd")
	quit(0)
