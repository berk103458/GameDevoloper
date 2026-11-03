# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var eylemler := [
		{ "ad": "soru", "kapali": false, "sebep": "" },
		{ "ad": "bakis", "kapali": false, "sebep": "" },
		{ "ad": "yemin", "kapali": true, "sebep": "inanc" }, # tek kelime
		{ "ad": "yuzles", "kapali": true, "sebep": "delil" }, # tek kelime
		{ "ad": "ikram", "kapali": true, "sebep": "erzak" }, # tek kelime
		{ "ad": "soz", "kapali": false, "sebep": "" }
	]

	# 1. Eylem düğmesi sayısı 6'yı geçmez (Kural 2)
	if eylemler.size() > 6:
		hatalar.append("Eylem sayısı 6'yı aştı! (Toplam: %d)" % eylemler.size())

	# 2. Sebep bir kelimedir ve 'DYL-' öneki içermez (Kabul)
	for e in eylemler:
		if e.get("kapali", false):
			var sebep: String = str(e.get("sebep", ""))
			if sebep.is_empty():
				hatalar.append("Kapalı eylemde sebep kelimesi boş!")
			elif " " in sebep:
				hatalar.append("Kapalı eylem sebebi tek kelime değil: '%s'" % sebep)
			if "DYL-" in sebep or "DYL_" in sebep:
				hatalar.append("Sebep kelimesinde DYL- öneki bulundu: '%s'" % sebep)

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: eylem_kadraji_test.gd")
	quit(0)
