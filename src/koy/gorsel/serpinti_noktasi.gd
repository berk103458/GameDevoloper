## ProtonScatter yığınına hazır dönüşümleri yazar. Şekil düğümü istemez.
extends ScatterBaseModifier


var noktalar: Array[Transform3D] = []


func _init() -> void:
	display_name = "Köy serpinti noktaları"
	category = "Create"
	warning_ignore_no_transforms = true
	warning_ignore_no_shape = true
	can_override_seed = false


func _process_transforms(transforms, _domain, _random_seed) -> void:
	transforms.append(noktalar)
