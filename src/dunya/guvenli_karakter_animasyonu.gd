## Eksik klipte gerçek idle'a, idle da yoksa ilk animasyonun duruş pozuna döner.
extends RefCounted

static func var_mi(oynatici: AnimationPlayer, ad: Variant) -> bool:
	return is_instance_valid(oynatici) and (ad is String or ad is StringName) and not String(ad).is_empty() and oynatici.has_animation(ad)

static func ilk(oynatici: AnimationPlayer) -> String:
	if not is_instance_valid(oynatici):
		return ""
	var adlar := oynatici.get_animation_list()
	return String(adlar[0]) if not adlar.is_empty() else ""

static func dur(oynatici: AnimationPlayer, varsayilan: String, gecis: float) -> void:
	if not is_instance_valid(oynatici):
		return
	oynatici.speed_scale = 1.0
	for idle in ["bekle", "idle", "Idle", "m_bekle"]:
		if var_mi(oynatici, idle):
			oynatici.play(idle, gecis)
			return
	for idle in oynatici.get_animation_list():
		if String(idle).get_file().to_lower() in ["bekle", "idle", "m_bekle"]:
			oynatici.play(idle, gecis)
			return
	var poz := varsayilan if var_mi(oynatici, varsayilan) else ilk(oynatici)
	if poz.is_empty():
		oynatici.stop()
		return
	oynatici.play(poz)
	oynatici.seek(0.0, true)
	oynatici.speed_scale = 0.0
