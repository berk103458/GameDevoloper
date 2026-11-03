# gdlint: disable=max-line-length
extends SceneTree

const KararDonusu = preload("res://src/soz/karar_donusu.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	# 1. 2 gün geçmeden dönüş olmaz
	var erken := KararDonusu.donus_hesapla({"karar": "ret"}, 1)
	if erken.get("donus_var", true):
		hatalar.append("2 gün geçmeden erken dönüş tetiklendi!")

	# 2. Ret ve yalan yakalanmışsa çete intikam haberi döner
	var intikam := KararDonusu.donus_hesapla({"karar": "ret", "yalan_yakalandi": true}, 3)
	if not intikam.get("donus_var") or intikam.get("tur") != "intikam_haberi":
		hatalar.append("Yalanı yakalanıp kovulanın intikam haberi dönmedi!")

	# 3. Kabul edilen köylünün akraba gelişi tetiklenir
	var kabul_donus := KararDonusu.donus_hesapla({"karar": "kabul"}, 3)
	if not kabul_donus.get("donus_var") or kabul_donus.get("tur") != "akraba_gelisi":
		hatalar.append("Kabul edilen köylünün akraba gelişi tetiklenmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: karar_donusu_test.gd")
	quit(0)
