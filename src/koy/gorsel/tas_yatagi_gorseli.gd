## BUG21-TASYATAGI: tek değişim noktası; Meshy tas_yatagi.glb (yoksa gri BoxMesh yer tutucu).
class_name TasYatagiGorseli
extends RefCounted

static func kur(sahne: Node3D, ust: Node3D) -> void:
	var t: TasYatagi = sahne.yonetim.tas_yatagi
	if t == null or t.kalan <= 0: return
	var obek := Node3D.new()
	obek.name = "TasYatagi"
	obek.set_meta("tas_yatagi", true)
	obek.position = sahne.alan_merkezi(t.hucre, Vector2i.ONE)
	if Dunya3B.model_var_mi("tas_yatagi", "yapi"):
		obek.add_child(Dunya3B.nesne("tas_yatagi", 0.65, "yapi"))
		ust.add_child(obek)
		return
	var m := StandardMaterial3D.new()
	m.albedo_color = Color("777777")
	for i in 3:
		var n := MeshInstance3D.new()
		var kutu := BoxMesh.new()
		kutu.size = Vector3(0.55, 0.35, 0.55)
		n.mesh = kutu
		n.material_override = m
		n.position = Vector3((i - 1) * 0.45, 0.18 + (0.2 if i == 1 else 0.0), 0.15 if i == 1 else -0.15)
		obek.add_child(n)
	ust.add_child(obek)

## Mevcut rota ağıyla yatağın yanına gider; yeni navigasyon sistemi yok.
static func planla(hareket: Node, k: Koylu, bas: Vector2i, son: Vector2i, d: Dictionary) -> Vector2i:
	var y: KoyYonetimi = hareket.sahne.yonetim
	if k.is_yeri != TasYatagi.IS_YERI or y.tas_yatagi == null or y.tas_yatagi.kalan <= 0 or hareket.faz_adi != &"gunduz" or d.dinlen or not TasYatagi.uygun(y, k): return son
	d.bak = hareket.sahne.alan_merkezi(y.tas_yatagi.hucre, Vector2i.ONE)
	d.is = true
	return hareket.rotaci.bina_duragi(bas, Rect2i(y.tas_yatagi.hucre, Vector2i.ONE), k.id)
