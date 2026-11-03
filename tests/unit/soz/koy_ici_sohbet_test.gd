# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var beklenen_ds_dosyalari := [
		"res://data/parley/koy/koylu_muhabbet_genel.ds",
		"res://data/parley/koy/koylu_muhabbet_yusuf.ds",
		"res://data/parley/koy/sekans_degirmen_kitlik.ds",
		"res://data/parley/koy/sekans_meydan_atesi.ds"
	]

	for yol in beklenen_ds_dosyalari:
		if not FileAccess.file_exists(yol):
			hatalar.append("Köy içi sohbet dosyası eksik: %s" % yol)

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: koy_ici_sohbet_test.gd")
	quit(0)
