## İsteğe bağlı, kayda yazılmayan debug gece adaptörü.
class_name GeceDeneyi
extends RefCounted
const META := &"debug_senaryo_uretim_sonrasi"

static func uretimin_ardindan(y: KoyYonetimi) -> void:
	if not y.has_meta(META):
		return
	var deney: Variant = y.get_meta(META)
	if deney is Callable and deney.is_valid():
		deney.call(y)
