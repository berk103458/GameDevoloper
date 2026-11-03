# gdlint: disable=max-line-length
extends SceneTree

const BeyinDenetcisi = preload("res://src/soz/beyin_denetcisi.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	# 1. Temiz sicil
	var temiz := BeyinDenetcisi.sorgula({"rusvet_sayisi": 0, "tutulmayan_soz_sayisi": 0, "adalet": 60})
	if temiz.get("suphe_seviyesi") != 0 or temiz.get("azil_riski"):
		hatalar.append("Temiz sicil şüpheli bulundu!")

	# 2. Ağır rüşvetçi sicil
	var agir := BeyinDenetcisi.sorgula({"rusvet_sayisi": 3, "tutulmayan_soz_sayisi": 2, "adalet": 20})
	if not agir.get("azil_riski") or int(agir.get("suphe_seviyesi")) < 10:
		hatalar.append("Ağır rüşvetçi ve söz tutmayan muhafız için azil riski oluşmadı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: beyin_denetcisi_test.gd")
	quit(0)
