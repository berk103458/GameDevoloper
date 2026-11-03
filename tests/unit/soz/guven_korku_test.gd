# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_012",
		"cekirdek": "koruma_yalani",
		"ipucu_id": "clue_012",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam.",
				"secenekler": [
					{ "id": "s_normal", "hedef": "d_normal", "metin": "Normal soru" }
				]
			},
			"d_normal": { "id": "d_normal", "satir": "Cevap", "secenekler": [] },
			"yuzlesme": { "id": "yuzlesme", "satir": "İtiraf ediyorum...", "secenekler": [] }
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)

	# 1. Güven 6 iken itiraf düğmesi 0'dır (Kabul)
	motor.guven = 6
	var sec_g6 := motor.mevcut_secenekler()
	var g6_ids := sec_g6.map(func(s): return s.get("id"))
	if "sec_itiraf" in g6_ids:
		hatalar.append("Güven 6 iken itiraf düğmesi göründü! (Beklenen: 0)")

	# 2. Güven 7 iken itiraf düğmesi 1'dir (Kabul)
	motor.guven = 7
	var sec_g7 := motor.mevcut_secenekler()
	var g7_ids := sec_g7.map(func(s): return s.get("id"))
	if not ("sec_itiraf" in g7_ids):
		hatalar.append("Güven 7 iken itiraf düğmesi görünmedi! (Beklenen: 1)")

	# 3. İtiraf düğmesi seçildiğinde zarsız yüzleşme açılır
	var itiraf_sonuc := motor.sec("sec_itiraf")
	if not itiraf_sonuc.get("itiraf", false) or motor.aktif_dugum.id != "yuzlesme":
		hatalar.append("İtiraf seçeneği yüzleşmeyi zarsız açamadı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: guven_korku_test.gd")
	quit(0)
