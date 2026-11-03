# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://tests/fixtures/pilot_karakterler.json", FileAccess.READ)
	if not dosya:
		hatalar.append("tests/fixtures/pilot_karakterler.json bulunamadı!")
		quit(1)
		return

	var parsed = JSON.parse_string(dosya.get_as_text())
	var pilotlar: Array = parsed.get("pilotlar", [])

	# Sivaslı rençber ve iki karakter daha (en az 3 pilot)
	if pilotlar.size() < 3:
		hatalar.append("Pilot karakter sayısı 3'ten az: %d" % pilotlar.size())

	var sivasli_bulundu := false
	for p in pilotlar:
		var ad: String = str(p.get("ad", ""))
		if "Sivaslı Rençber" in ad:
			sivasli_bulundu = true
		# Pilot sır içermez (YAZ-47)
		if not p.get("sir_yok", false) or p.get("cekirdek") != "durust":
			hatalar.append("Pilot karakter '%s' sır içeriyor!" % ad)

	if not sivasli_bulundu:
		hatalar.append("Sivaslı Rençber pilot karakterlerde bulunamadı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: pilot_test.gd")
	quit(0)
