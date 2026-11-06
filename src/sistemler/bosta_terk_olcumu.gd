## DEN-35: yalnız rapor geçmişinden yeni istek başlangıçlarını sayar.
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json")).bosta_terk_aralik
static func tam(v: Variant) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= 0 and float(v) <= 1000000000
static func rapor(olcumler: Array[Dictionary]) -> Dictionary:
	var geceler := {}
	for olcum in olcumler:
		var d: Variant = olcum.get("bosta_terk")
		if not d is Dictionary or not tam(d.get("gun")) or not d.get("kisiler") is Array:
			return {"hazir": false, "neden": "bozuk_olcum"}
		var kisiler: Array[int] = []
		for id in d.kisiler:
			if not tam(id) or int(id) == 0 or int(id) in kisiler: return {"hazir": false, "neden": "bozuk_olcum"}
			kisiler.append(int(id))
		kisiler.sort()
		var gun := int(d.gun)
		if geceler.has(gun) and geceler[gun] != kisiler: return {"hazir": false, "neden": "cakisan_gece"}
		geceler[gun] = kisiler
	var gunler := geceler.keys()
	gunler.sort()
	var sure := int(AYAR.gun)
	if gunler.size() < sure: return {"hazir": false, "neden": "eksik_gece"}
	var son := int(gunler.back())
	var ilk := son - sure + 1
	var once: Array = geceler.get(ilk - 1, [])
	var sayi := 0
	for gun in range(ilk, son + 1):
		if not geceler.has(gun): return {"hazir": false, "neden": "kesik_gece"}
		for id in geceler[gun]:
			if id not in once: sayi += 1
		once = geceler[gun]
	return {"hazir": true, "gun": sure, "ilk_gun": ilk, "son_gun": son, "terk_istegi_sayisi": sayi,
		"alt": int(AYAR.alt), "ust": int(AYAR.ust), "bantta": sayi >= int(AYAR.alt) and sayi <= int(AYAR.ust)}
