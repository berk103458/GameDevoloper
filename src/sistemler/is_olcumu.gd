## ISG-67: son otuz ardışık geceyi kişi-gün ağırlığıyla tek rapora toplar.
## Yalnız DEN fotoğrafları ve denge tablosu okunur; oyun/kayıt/RNG çağrısı yoktur.
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json")).is_olcumu

static func _tam(v: Variant) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= 0 and float(v) <= 1000000000

static func rapor(olcumler: Array[Dictionary]) -> Dictionary:
	var geceler := {}
	for olcum in olcumler:
		var ham: Variant = olcum.get("is_olcumu")
		if not ham is Dictionary or not _tam(ham.get("gun")) or not _tam(ham.get("bosta")) or not _tam(ham.get("isgucu")):
			return {"hazir": false, "neden": "bozuk_olcum"}
		if float(ham.bosta) > float(ham.isgucu):
			return {"hazir": false, "neden": "bozuk_olcum"}
		var gece := int(ham.gun)
		var sayim := {"bosta": int(ham.bosta), "isgucu": int(ham.isgucu)}
		if geceler.has(gece) and geceler[gece] != sayim:
			return {"hazir": false, "neden": "cakisan_gece"}
		geceler[gece] = sayim
	var gunler := geceler.keys()
	gunler.sort()
	var sure := int(AYAR.gun)
	if gunler.size() < sure:
		return {"hazir": false, "neden": "eksik_gece"}
	var son := int(gunler.back())
	var ilk := son - sure + 1
	var bosta := 0
	var isgucu := 0
	for gun in range(ilk, son + 1):
		if not geceler.has(gun):
			return {"hazir": false, "neden": "kesik_gece"}
		bosta += int(geceler[gun].bosta)
		isgucu += int(geceler[gun].isgucu)
	var oran := float(bosta) / float(isgucu) if isgucu > 0 else 0.0
	return {"hazir": true, "gun": sure, "ilk_gun": ilk, "son_gun": son,
		"bosta_kisi_gun": bosta, "isgucu_kisi_gun": isgucu, "bosta_orani": oran,
		"olculebilir": isgucu > 0, "alt": float(AYAR.alt), "ust": float(AYAR.ust),
		"bantta": isgucu > 0 and oran >= float(AYAR.alt) and oran <= float(AYAR.ust)}
