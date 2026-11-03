# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var karakter_varyantlari := {
		"chr_001": [
			{ "tohum": 101, "cekirdek": "durust" },
			{ "tohum": 202, "cekirdek": "koruma_yalani" }
		]
	}

	var v_liste: Array = karakter_varyantlari.get("chr_001", [])
	if v_liste.size() < 2:
		hatalar.append("Aynı karakter için 2 çekirdek varyantı bulunamadı!")
	elif v_liste[0].get("cekirdek") == v_liste[1].get("cekirdek"):
		hatalar.append("Farklı tohumlarda aynı çekirdek üretildi, varyant oluşmadı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: cekirdek_varyant_test.gd")
	quit(0)
