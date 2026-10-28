## Mevcut zanaat duruşunu dinler; iş/üretim başlatmaz ve sahne kalkınca susar.
extends Node

var karakter: KarakterModel
var _sure := 0.0
static var _son_vurus := 0

func _process(delta: float) -> void:
	if not is_instance_valid(karakter) or karakter.duzeltici() == null or karakter.duzeltici().surekli != &"dov":
		_sure = 0.0
		return
	_sure += delta
	if _sure < 0.9:
		return
	_sure = 0.0
	var simdi := Time.get_ticks_msec()
	if simdi - _son_vurus >= 350:
		_son_vurus = simdi
		get_tree().root.get_node("Ses").cal(&"sfx_ors", -18.0)
