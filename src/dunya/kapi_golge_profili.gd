## Kapı ışıkları: gölge atlası sınırı ve renderer mesafe sönümü; kare başına mesafe taraması yok.
extends Node

const ATLAS_SINIRI := 2048
const META := &"_kapi_golge_profili"
var isiklar: Array[OmniLight3D] = []
var _gorunum: Viewport

func _ready() -> void:
	_gorunum = get_viewport()
	var ortak: Dictionary = _gorunum.get_meta(META, {})
	if ortak.is_empty():
		ortak = {"onceki": _gorunum.positional_shadow_atlas_size,
			"uygulanan": mini(_gorunum.positional_shadow_atlas_size, ATLAS_SINIRI), "adet": 0}
		_gorunum.positional_shadow_atlas_size = ortak["uygulanan"]
	ortak["adet"] += 1
	_gorunum.set_meta(META, ortak)
	for isik in isiklar:
		if is_instance_valid(isik):
			isik.distance_fade_enabled = true
			isik.distance_fade_begin = 24.0
			isik.distance_fade_shadow = 16.0
			isik.distance_fade_length = 8.0

func _exit_tree() -> void:
	if not is_instance_valid(_gorunum):
		return
	var ortak: Dictionary = _gorunum.get_meta(META, {})
	if ortak.is_empty():
		return
	ortak["adet"] -= 1
	if ortak["adet"] == 0:
		# Başka bir kalite ayarı sahne açıkken değiştiyse kullanıcı seçimini koru.
		if _gorunum.positional_shadow_atlas_size == ortak["uygulanan"]:
			_gorunum.positional_shadow_atlas_size = ortak["onceki"]
		_gorunum.remove_meta(META)
	else:
		_gorunum.set_meta(META, ortak)
