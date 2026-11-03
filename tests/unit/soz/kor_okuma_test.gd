# gdlint: disable=max-line-length
extends SceneTree

func _init() -> void:
	var hatalar: Array[String] = []

	var ornek_replikler := [
		{ "metin": "Örsün üstünde demir tavında dövülür.", "beklenen_meslek": "demirci" },
		{ "metin": "Tuz ekmek hakkı için, sabah fırından iki somun çıkardım.", "beklenen_meslek": "firinci" },
		{ "metin": "Yün eğiririm, çulha tezgâhında mekik dokurum.", "beklenen_meslek": "dokumaci" },
		{ "metin": "Kuzu güderim, dağ ardında kurt uluması dinlerim.", "beklenen_meslek": "coban" }
	]

	for rep in ornek_replikler:
		var m: String = rep.get("metin", "")
		var beklenen: String = rep.get("beklenen_meslek", "")
		var tespit_edilen := ""
		if "örs" in m or "demir" in m:
			tespit_edilen = "demirci"
		elif "fırın" in m or "somun" in m:
			tespit_edilen = "firinci"
		elif "yün" in m or "çulha" in m or "dokurum" in m:
			tespit_edilen = "dokumaci"
		elif "kuzu" in m or "kurt" in m or "güderim" in m:
			tespit_edilen = "coban"

		if tespit_edilen != beklenen:
			hatalar.append("Kör okuma repliği '%s' için beklenen '%s' iken '%s' bulundu!" % [m, beklenen, tespit_edilen])

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: kor_okuma_test.gd")
	quit(0)
