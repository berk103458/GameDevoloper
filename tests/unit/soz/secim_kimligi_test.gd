extends SceneTree

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var ham: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/soz_kapi/secim.json"))
	dene(ham is Dictionary, "Seçim fixtürü okunur")
	for durum in ham.get("durumlar", []):
		var gelen := SozMotoru.secim_kimligi({"bayraklar": durum.bayraklar, "secenekler": durum.secenekler})
		dene(gelen == String(durum.beklenen), "KLT-54 seçim kimliği " + gelen)
	print("SEÇİM KİMLİĞİ: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)
