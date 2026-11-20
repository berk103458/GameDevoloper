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
		OrnekYigini.duragan_kil(n)
		kok.add_child(n)


static func _mesafe(n: Node3D) -> void:
	for mi in n.find_children("*", "GeometryInstance3D", true, false):
		var g := mi as GeometryInstance3D
		g.visibility_range_end = GORUNUR_METRE
		g.visibility_range_end_margin = 8.0
		g.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF


## h: ızgara hücresi. 0..23 köyün içidir; CIL-07 sonrası yalnız dış köy silüeti ve orman kenarı ayısı burada kalır.
static func _liste() -> Array:
	return [
		{"ad": "td_o26", "boy": 2.6, "h": Vector2i(-8, -7)},
		{"ad": "td_a117", "boy": 3.0, "h": Vector2i(0, -8)},
		{"ad": "td_a116", "boy": 3.4, "h": Vector2i(8, -7)},
		{"ad": "td_k07", "boy": 1.25, "h": Vector2i(-12, 18)},
	]
