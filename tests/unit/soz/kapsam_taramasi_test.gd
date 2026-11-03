# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://data/soz/gecis.json", FileAccess.READ)
	if not dosya:
		hatalar.append("data/soz/gecis.json bulunamadı!")
		quit(1)
		return

	var parsed = JSON.parse_string(dosya.get_as_text())
	var karakterler: Dictionary = parsed.get("karakterler", {})
	if karakterler.size() < 30:
		hatalar.append("Kapsam taramasında 30 karakter bulunamadı: %d" % karakterler.size())

	# Söz dosyası ikinci motor açmaz kuralı
	var soz_motor_sinifi := "SozMotoru"
	if soz_motor_sinifi.is_empty():
		hatalar.append("Tekil SozMotoru sınıfı tanımlı değil!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: kapsam_taramasi_test.gd")
	quit(0)
