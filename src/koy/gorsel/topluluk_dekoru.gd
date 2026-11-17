## Köy ızgarasının dışına, her modelden bir kopya. Yolu ve yapı hücrelerini kapatmaz.
class_name ToplulukDekoru
extends RefCounted

const GORUNUR_METRE := 120.0

static func kur(s: KoyYonetimSahnesi, ust: Node3D) -> void:
	var eski := ust.get_node_or_null(^"topluluk_dekoru")
	if eski != null:
		eski.name = &"topluluk_dekoru_eski"
	var kok := Node3D.new()
	kok.name = &"topluluk_dekoru"
	kok.set_meta(&"topluluk_dekoru", true)
	ust.add_child(kok)
	for p in _liste():
		var ad := String(p["ad"])
		if not Dunya3B.model_var_mi(ad):
			continue
		var n := Dunya3B.nesne(ad, float(p["boy"]))
		n.position = s.alan_merkezi(p["h"], Vector2i.ONE)
		n.rotation.y = deg_to_rad(float(p.get("don", 0.0)))
		_mesafe(n)
		kok.add_child(n)


static func _mesafe(n: Node3D) -> void:
	for mi in n.find_children("*", "GeometryInstance3D", true, false):
		var g := mi as GeometryInstance3D
		g.visibility_range_end = GORUNUR_METRE
		g.visibility_range_end_margin = 8.0
		g.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF


## h: ızgara hücresi. 0..23 köyün içidir; dekor hep bunun dışındadır.
static func _liste() -> Array:
	return [
		{"ad": "td_o26", "boy": 2.6, "h": Vector2i(-8, -7)},
		{"ad": "td_a117", "boy": 3.0, "h": Vector2i(0, -8)},
		{"ad": "td_a116", "boy": 3.4, "h": Vector2i(8, -7)},
		{"ad": "td_a113", "boy": 5.2, "h": Vector2i(-16, -6)},
		{"ad": "td_o72", "boy": 5.2, "h": Vector2i(18, -7)},
		{"ad": "td_a157", "boy": 1.25, "h": Vector2i(-7, 3)},
		{"ad": "td_a172", "boy": 1.45, "h": Vector2i(-7, 8)},
		{"ad": "td_o30", "boy": 0.55, "h": Vector2i(-11, 6)},
		{"ad": "td_a220", "boy": 1.0, "h": Vector2i(-11, 2)},
		{"ad": "td_a202", "boy": 1.5, "h": Vector2i(-7, 13)},
		{"ad": "td_a146", "boy": 0.42, "h": Vector2i(-11, 11)},
		{"ad": "td_k07", "boy": 1.45, "h": Vector2i(-12, 18)},
		{"ad": "td_o17", "boy": 1.45, "h": Vector2i(-6, 20), "don": 90.0},
		{"ad": "td_o64", "boy": 1.15, "h": Vector2i(-10, -2), "don": 90.0},
		{"ad": "td_o07", "boy": 0.5, "h": Vector2i(29, 2)},
		{"ad": "td_o48", "boy": 0.55, "h": Vector2i(32, 2)},
		{"ad": "td_a241", "boy": 0.7, "h": Vector2i(29, 5)},
		{"ad": "td_a227", "boy": 0.75, "h": Vector2i(32, 5)},
		{"ad": "td_o84", "boy": 0.5, "h": Vector2i(35, 2)},
		{"ad": "td_a177", "boy": 1.45, "h": Vector2i(30, 9)},
		{"ad": "td_a042", "boy": 0.7, "h": Vector2i(34, 8)},
		{"ad": "td_a228", "boy": 0.9, "h": Vector2i(28, 12)},
		{"ad": "td_o05", "boy": 0.75, "h": Vector2i(35, 12)},
		{"ad": "td_b117", "boy": 1.8, "h": Vector2i(29, 16)},
		{"ad": "td_o79", "boy": 1.7, "h": Vector2i(35, 16)},
		{"ad": "td_o49", "boy": 2.0, "h": Vector2i(42, 4)},
		{"ad": "td_o76", "boy": 3.2, "h": Vector2i(42, 20)},
		{"ad": "td_o20", "boy": 0.5, "h": Vector2i(20, 29)},
		{"ad": "td_o32", "boy": 0.28, "h": Vector2i(23, 29)},
		{"ad": "td_o19", "boy": 0.25, "h": Vector2i(26, 29)},
		{"ad": "td_o14", "boy": 0.4, "h": Vector2i(20, 32)},
		{"ad": "td_a081", "boy": 0.55, "h": Vector2i(23, 32)},
		{"ad": "td_a186", "boy": 0.9, "h": Vector2i(26, 32)},
		{"ad": "td_a205", "boy": 0.7, "h": Vector2i(29, 29)},
		{"ad": "td_a209", "boy": 0.95, "h": Vector2i(32, 29)},
		{"ad": "td_o00", "boy": 0.9, "h": Vector2i(29, 33)},
		{"ad": "td_o23", "boy": 1.1, "h": Vector2i(33, 33)},
		{"ad": "td_o18", "boy": 0.65, "h": Vector2i(37, 33)},
	]
