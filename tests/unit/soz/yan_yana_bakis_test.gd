# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya_var := FileAccess.file_exists("res://tools/metin_karsilastir.py")
	if not dosya_var:
		hatalar.append("tools/metin_karsilastir.py bulunamadı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: yan_yana_bakis_test.gd")
	quit(0)
