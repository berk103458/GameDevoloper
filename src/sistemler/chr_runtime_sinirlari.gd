## Kaynak veriler değişmez; yalnız kararın runtime kopyası sınırlandırılır.
extends RefCounted

static func karar(veri: Dictionary) -> Dictionary:
	var sonuc := veri.duplicate(true)
	if sonuc.get("stat_etkisi") is Dictionary:
		sonuc["stat_etkisi"] = statlar(sonuc["stat_etkisi"])
	for varyant in sonuc.get("varyantlar", []):
		if varyant is Dictionary and varyant.get("stat_etkisi") is Dictionary:
			varyant["stat_etkisi"] = statlar(varyant["stat_etkisi"])
	return sonuc

static func statlar(etkiler: Dictionary) -> Dictionary:
	var sonuc := {}
	for stat in ChrSozlesmesi.STATLAR:
		if etkiler.get(stat) is int:
			sonuc[stat] = clampi(etkiler[stat], -4, 4)
	return sonuc
