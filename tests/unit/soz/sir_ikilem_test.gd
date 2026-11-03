# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_011",
		"cekirdek": "koruma_yalani",
		"ipucu_id": "clue_011",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Giriş",
				"secenekler": [
					{ "id": "sec_yuzles", "hedef": "yuzlesme", "metin": "Yüzleş" }
				]
			},
			"yuzlesme": {
				"id": "yuzlesme",
				"satir": "Sırrım açığa çıktı... Mecburdum!",
				"secenekler": [
					{ "id": "sec_ikilem_merhamet", "hedef": "veda", "metin": "Seni anlıyorum, canını korumuşsun." },
					{ "id": "sec_ikilem_adalet", "hedef": "veda", "metin": "Yalan yalandır, kanun affetmez." }
				]
			},
			"veda": { "id": "veda", "satir": "Son", "secenekler": [] }
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)

	# 1. Yüzleşmeye geç
	motor.sec("sec_yuzles")

	# Sır açılınca ikilem seçenekleri gelir (Kabul)
	var secenekler := motor.mevcut_secenekler()
	var sec_ids := secenekler.map(func(s): return s.get("id"))
	if not ("sec_ikilem_merhamet" in sec_ids) or not ("sec_ikilem_adalet" in sec_ids):
		hatalar.append("Sır açıldıktan sonra ikilem seçenekleri gelmedi: %s" % str(sec_ids))

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: sir_ikilem_test.gd")
	quit(0)
