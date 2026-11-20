class_name SurHasarGorseli
extends RefCounted

static func uygula(kok: Node3D, hasar: int) -> void:
	kok.set_meta("sur_hasar", hasar)
	if hasar <= 0:
		return
	kok.scale.y *= 1.0 - 0.8 * clampi(hasar, 0, 100) / 100.0
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("#584535").lerp(Color("#211f1d"), hasar / 100.0)
	mat.roughness = 1.0
	for n in kok.find_children("*", "MeshInstance3D", true, false):
		(n as MeshInstance3D).material_override = mat
	for n in kok.find_children("*", "InstancedMesh3D", true, false):
		(n as InstancedMesh3D).material = mat
	if kok is MeshInstance3D:
		(kok as MeshInstance3D).material_override = mat
	elif kok is InstancedMesh3D:
		(kok as InstancedMesh3D).material = mat
