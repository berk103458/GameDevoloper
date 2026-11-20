## Instanced Renderer 1.3: aynı durağan ağı tek çizime toplar.
## Görünürlük ucu topluluk dekoruyla aynı 120 m'dir. Ölçek çağıranın transformunda kalır.
class_name OrnekYigini
extends RefCounted

const GORUNUR_METRE := 120.0
const PARCA := 32.0

static var donusen := 0


static func sifirla() -> void:
	donusen = 0


## Hareket eden sürü parçası. `is_static` kapalıdır; ebeveyn her kare taşınabilir.
static func hareketli(orgu: Mesh, malzeme: Material, konum: Vector3, olcek: Vector3 = Vector3.ONE) -> InstancedMesh3D:
	var n := _kur(orgu, malzeme, false)
	n.position = konum
	n.scale = olcek
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return n


## Durağan MeshInstance3D düğümlerini InstancedMesh3D yapar. İskeletli ağlara dokunmaz.
static func duragan_kil(kok: Node) -> int:
	var adaylar: Array[MeshInstance3D] = []
	if kok is MeshInstance3D:
		adaylar.append(kok)
	for n in kok.find_children("*", "MeshInstance3D", true, false):
		adaylar.append(n)
	var sayi := 0
	for mi in adaylar:
		if not is_instance_valid(mi) or mi.skin != null or _iskeletli(mi):
			continue
		var y := _kur(mi.mesh, mi.material_override, true)
		y.name = mi.name
		y.transform = mi.transform
		y.cast_shadow = mi.cast_shadow
		var ebeveyn := mi.get_parent()
		if ebeveyn == null:
			continue
		var sira := mi.get_index()
		var cocuklar := mi.get_children()
		ebeveyn.remove_child(mi)
		ebeveyn.add_child(y)
		ebeveyn.move_child(y, mini(sira, ebeveyn.get_child_count() - 1))
		for c in cocuklar:
			mi.remove_child(c)
			y.add_child(c)
		mi.free()
		sayi += 1
	donusen += sayi
	return sayi


static func ucgen(orgu: Mesh) -> int:
	if orgu == null:
		return 0
	var yuz := orgu.get_faces()
	return yuz.size() / 3


## Tahmini çizim: InstancedMesh3D aynı ağ kimliğinde bir çağrı, kalan her MeshInstance3D ayrı çağrı.
static func olc(kok: Node) -> Dictionary:
	var tekil := {}
	var ornek := 0
	var duz := 0
	var yigin := 0
	var ucgen_ornek := 0
	var ucgen_duz := 0
	var ucgen_yigin := 0
	var hepsi: Array[Node] = [kok]
	hepsi.append_array(kok.find_children("*", "Node", true, false))
	for n in hepsi:
		if n is InstancedMesh3D or n.get_class() == "InstancedMesh3D":
			var im := n as InstancedMesh3D
			var anahtar := str(im.mesh.get_instance_id()) if im.mesh != null else "0"
			tekil[anahtar] = true
			ornek += 1
			ucgen_ornek += ucgen(im.mesh)
		elif n is MultiMeshInstance3D:
			var mm := (n as MultiMeshInstance3D).multimesh
			yigin += 1
			if mm != null:
				ucgen_yigin += ucgen(mm.mesh) * mm.visible_instance_count
		elif n is MeshInstance3D:
			duz += 1
			ucgen_duz += ucgen((n as MeshInstance3D).mesh)
	return {
		"ornek": ornek,
		"duz": duz,
		"yigin": yigin,
		"cagri": tekil.size() + duz + yigin,
		"ucgen": ucgen_ornek + ucgen_duz + ucgen_yigin,
	}


static func _kur(orgu: Mesh, malzeme: Material, duragan: bool) -> InstancedMesh3D:
	var n := InstancedMesh3D.new()
	n.mesh = orgu
	if malzeme != null:
		n.material = malzeme
	n.is_static = duragan
	n.chunk_size = PARCA
	n.visibility_range_end = GORUNUR_METRE
	return n


static func _iskeletli(n: Node) -> bool:
	var p := n.get_parent()
	while p != null:
		if p is Skeleton3D or p is AnimationPlayer:
			return true
		p = p.get_parent()
	return false
