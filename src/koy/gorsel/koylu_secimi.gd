## Görsel figürün çevresindeki seçim küresi; 30 figür sınırını aşanlar nüfus listesinden erişilir.
class_name KoyluSecimi
extends RefCounted
static func sec(sahne: KoyYonetimSahnesi, ekran: Vector2) -> int:
	if not is_instance_valid(sahne.halk_hareketi): return -1
	var kamera := sahne.kamera
	var bas := kamera.project_ray_origin(ekran)
	var yon := kamera.project_ray_normal(ekran).normalized()
	var en_yakin := INF
	var secili := -1
	for id in sahne.halk_hareketi.modeller:
		var model: Node3D = sahne.halk_hareketi.modeller[id]
		if not is_instance_valid(model) or model.is_queued_for_deletion(): continue
		var merkez := model.global_position + Vector3.UP * 0.9
		var t := (merkez - bas).dot(yon)
		if t <= 0 or t >= en_yakin: continue
		if (bas + yon * t).distance_squared_to(merkez) <= 0.7 * 0.7:
			en_yakin = t
			secili = id
	return secili
