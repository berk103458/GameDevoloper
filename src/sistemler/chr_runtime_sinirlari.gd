## Kaynak veriler değişmez; yalnız kararın runtime kopyası sınırlandırılır.
extends RefCounted

static func karar(veri: Dictionary) -> Dictionary:
	var sonuc := veri.duplicate(true)
	sonuc["muhafiz_akce"] = maxi(0, sonuc.get("muhafiz_akce", 0)) if sonuc.get("muhafiz_akce", 0) is int else 0
	var esyalar := []
	var kaynak_esyalar: Variant = sonuc.get("esyalar", [])
	if kaynak_esyalar is Array:
		for esya in kaynak_esyalar:
			if esya is String or esya is StringName:
				esyalar.append(esya)
	sonuc["esyalar"] = esyalar
	if sonuc.get("stat_etkisi") is Dictionary:
		sonuc["stat_etkisi"] = statlar(sonuc["stat_etkisi"])
	else:
		sonuc["stat_etkisi"] = {}
	var varyantlar: Variant = sonuc.get("varyantlar", [])
	if not varyantlar is Array:
		varyantlar = []
	sonuc["varyantlar"] = varyantlar
	for varyant in varyantlar:
		if varyant is Dictionary and varyant.get("stat_etkisi") is Dictionary:
			varyant["stat_etkisi"] = statlar(varyant["stat_etkisi"])
	return sonuc

static func statlar(etkiler: Dictionary) -> Dictionary:
	var sonuc := {}
	for stat in ChrSozlesmesi.STATLAR:
		if etkiler.get(stat) is int:
			sonuc[stat] = clampi(etkiler[stat], -4, 4)
	return sonuc
