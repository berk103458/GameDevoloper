extends RefCounted

static var KADEMELER: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/aclik_kademeleri.json"))

static func _kademe(kisi: Koylu) -> Dictionary:
	var gun := maxi(kisi.aclik, 1 if kisi.ac else 0)
	return KADEMELER.get(str(mini(gun, 3)), {})

static func uretim(kisi: Koylu) -> float:
	return float(_kademe(kisi).get("uretim", 1.0))

static func yurume(kisi: Koylu) -> float:
	return float(_kademe(kisi).get("yurume", 1.0)) if kisi != null else 1.0

static func hastalik_riski(kisi: Koylu) -> int:
	return int(_kademe(kisi).get("hastalik_riski", 0))
