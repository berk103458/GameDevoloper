# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := FileAccess.open("res://data/karakter_ses_kartlari.json", FileAccess.READ)
	if not dosya:
		hatalar.append("karakter_ses_kartlari.json bulunamadı!")
		quit(1)
		return

	var parsed = JSON.parse_string(dosya.get_as_text())
	if not (parsed is Dictionary):
		hatalar.append("karakter_ses_kartlari.json çözümlenemedi!")
		quit(1)
		return

	var kartlar: Dictionary = parsed.get("kartlar", {})
	if kartlar.size() < 30:
		hatalar.append("Ses kartı sayısı 30'un altında: %d" % kartlar.size())

	var gorulen_agizlar: Dictionary = {}
	for k_id in kartlar.keys():
		var kart: Dictionary = kartlar[k_id]
		var agiz: String = str(kart.get("agiz", "")).strip_edges().to_lower()
		var ornek: String = str(kart.get("ornek_cumle", "")).strip_edges()

		# İki kart aynı ağzı tarif edemez (YAZ-30)
		if gorulen_agizlar.has(agiz):
			hatalar.append("YAZ-30 ihlali: '%s' ve '%s' aynı ağzı kullanıyor: '%s'" % [gorulen_agizlar[agiz], k_id, agiz])
		else:
			gorulen_agizlar[agiz] = k_id

		# Kart örnek cümle ister (YAZ-33)
		if ornek.is_empty():
			hatalar.append("YAZ-33 ihlali: '%s' kartında örnek cümle eksik!" % k_id)

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: ses_karti_test.gd")
	quit(0)
