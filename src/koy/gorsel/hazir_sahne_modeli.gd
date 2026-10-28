## Hazır 3D sahneleri metre zarfına oturtur; kaynak malzemeye ve simülasyona dokunmaz.
class_name HazirSahneModeli
extends RefCounted

static func al(yol: String, boy: Vector3, orantili: bool = false) -> Node3D:
	if not ResourceLoader.exists(yol):
		return null
	var kaynak := load(yol) as PackedScene
	if kaynak == null:
		return null
	var kok := Node3D.new()
	kok.set_meta("asset_yolu", yol)
	var model := kaynak.instantiate() as Node3D
	kok.add_child(model)
	var a := Dunya3B._kutu(model)
	if a.size.x <= 0.0001 or a.size.y <= 0.0001 or a.size.z <= 0.0001:
		kok.free()
		return null
	var oran := boy / a.size
	if orantili:
		oran = Vector3.ONE * minf(oran.x, minf(oran.y, oran.z))
	model.scale = oran
	model.position = -Vector3(a.get_center().x, a.position.y, a.get_center().z) * oran
	return kok
