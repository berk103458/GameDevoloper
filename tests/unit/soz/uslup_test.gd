# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var ornek_metinler := [
		"Selamünaleyküm muhafız bey.",
		"Karaköy rençberiyim, tohum getirdim.",
		"Örsün tavında demir döveriz."
	]

	var yasakli_kaliplar := [
		"Kan akmadı, akçe aktı",
		"köyünüzün geleceği",
		"alarm",
		"tempo"
	]

	for m in ornek_metinler:
		for y in yasakli_kaliplar:
			if y.to_lower() in m.to_lower():
				hatalar.append("Metinde yasaklı üslup kalıbı bulundu: '%s' in '%s'" % [y, m])

	# Dönem dersi cümlesi denetimi
	var ders_cumlesi := "13. yüzyılda Anadolu Selçukluları devrinde..."
	if "yüzyıl" in ders_cumlesi.to_lower():
		# Doğru tespit, oyunda bu cümleler reddedilir
		pass

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: uslup_test.gd")
	quit(0)
