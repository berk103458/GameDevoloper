## HAE-01: tek MegaKit ailesi; hazır yapı kabuğu, ekonomik/gezinti verisi değişmez.
class_name HazirKoyYapilari
extends RefCounted

const KOK := "res://assets/cevre/megakit/"
const KAPALI := ["kulube", "tas_ev", "ambar", "sifahane", "firin", "demirhane", "atolye", "kisla"]

static func kur(n: Node3D, tur: String, en: float, derin: float) -> bool:
	if tur not in KAPALI:
		return false
	var kabuk := Node3D.new()
	kabuk.name = "megakit_yapi"
	var w := minf(en * 0.82, 3.0 if tur in ["kulube", "tas_ev"] else 6.0)
	var d := minf(derin * 0.82, 3.0 if tur in ["kulube", "tas_ev"] else 6.0)
	var h := 2.1
	var duvar := "Wall_UnevenBrick_Straight" if tur == "tas_ev" else "Wall_Plaster_Straight"
	var tamam := _parca(kabuk, "Floor_WoodDark", Vector3(w, 0.04, d), Vector3.ZERO)
	tamam = _parca(kabuk, duvar, Vector3(w, h, 0.18), Vector3(0, 0.04, -d / 2 + 0.09)) and tamam
	for x in [-1, 1]:
		tamam = _parca(kabuk, duvar, Vector3(d - 0.36, h, 0.18), Vector3(x * (w / 2 - 0.09), 0.04, 0), PI / 2) and tamam
		var yan := (w - 0.95) / 2
		tamam = _parca(kabuk, duvar, Vector3(yan, h, 0.18), Vector3(x * (0.475 + yan / 2), 0.04, d / 2 - 0.09)) and tamam
	tamam = _parca(kabuk, "Door_1_Flat", Vector3(0.95, 1.9, 0.1), Vector3(0, 0.04, d / 2 - 0.1)) and tamam
	tamam = _parca(kabuk, duvar, Vector3(0.95, 0.2, 0.18), Vector3(0, 1.94, d / 2 - 0.09)) and tamam
	tamam = _parca(kabuk, "Window_Thin_Round1", Vector3(0.6, 0.9, 0.12), Vector3(-w / 3, 0.9, d / 2)) and tamam
	tamam = _parca(kabuk, "Roof_RoundTiles_4x6", Vector3(w, 0.86, d), Vector3(0, 2.14, 0)) and tamam
	if tur in ["demirhane", "firin"]:
		tamam = _parca(kabuk, "Wall_UnevenBrick_Straight", Vector3(0.35, 0.55, 0.35), Vector3(0.5, 2.65, -0.3)) and tamam
	if not tamam:
		kabuk.free()
		return false
	n.add_child(kabuk)
	return true

static func _parca(n: Node3D, ad: String, boy: Vector3, yer: Vector3, don: float = 0.0) -> bool:
	var model := HazirSahneModeli.al(KOK + ad + ".gltf", boy)
	if model == null:
		return false
	model.name = ad
	model.position = yer
	model.rotation.y = don
	n.add_child(model)
	return true

static func sacak(boy: Vector3) -> Node3D:
	return HazirSahneModeli.al(KOK + "Overhang_Plaster_Short.gltf", boy)
