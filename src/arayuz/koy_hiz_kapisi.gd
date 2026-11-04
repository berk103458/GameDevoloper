## TEK-22 / TEK-34: sahne çıkınca hız ve duraklama sıfırlanır.
extends RefCounted


static func sifirla(agac: SceneTree, onceki_fizik: int) -> void:
	if agac == null:
		return
	agac.paused = false
	Engine.time_scale = 1.0
	Engine.max_physics_steps_per_frame = onceki_fizik
