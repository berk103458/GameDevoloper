extends RefCounted

static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/uyku_dinlenme.json"))

static func gece(y: KoyYonetimi, uyanik: Array[int]) -> void:
	var doluluk := {}
	for kisi in y.koylular:
		if kisi.saglik <= 0:
			continue
		var ev := y.bina(kisi.ev)
		var yatakli := ev != null and ev.hazir() and int(doluluk.get(ev.id, 0)) < ev.yatak(y.katalog)
		if yatakli:
			doluluk[ev.id] = int(doluluk.get(ev.id, 0)) + 1
		if kisi.id in uyanik or kisi.yorgunluk.is_empty() or int(kisi.yorgunluk.get("son_gece", -1)) >= y.gun:
			continue
		var kalan := int(kisi.yorgunluk.get("miktar", AYAR.gece_yorgunlugu))
		kalan = maxi(0, kalan - int(AYAR.yatakli_dusus if yatakli else AYAR.acikta_dusus))
		if kalan == 0:
			kisi.yorgunluk.clear()
		else:
			kisi.yorgunluk["miktar"] = kalan
