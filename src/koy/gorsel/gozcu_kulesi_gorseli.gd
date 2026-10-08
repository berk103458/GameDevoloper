## HAR-06: tek düz kutu kule/ikon yer tutucusu; asset üretimi yoktur.
class_name GozcuKulesiGorseli
extends RefCounted
## Hazır yapının aynı node'una dış verili tek BoxMesh ekler.
static func kur(kok: Node3D) -> void:
	var boy: Array=GozcuKulesi.AYAR.kutu_boyut
	var mesh:=BoxMesh.new()
	mesh.size=Vector3(float(boy[0]),float(boy[1]),float(boy[2]))
	var n:=MeshInstance3D.new()
	n.name="GozcuKulesiYerTutucu"
	n.mesh=mesh
	n.position.y=mesh.size.y/2.0
	var m:=StandardMaterial3D.new()
	m.albedo_color=Color(String(GozcuKulesi.AYAR.renk))
	n.material_override=m
	kok.add_child(n)
## Aynı yapı kartı için ColorRect ikon; yeni doku/model yolu açılmaz.
static func ikon(boy: int) -> ColorRect:
	var n:=ColorRect.new()
	n.color=Color(String(GozcuKulesi.AYAR.renk))
	n.custom_minimum_size=Vector2(boy,boy)
	n.mouse_filter=Control.MOUSE_FILTER_IGNORE
	return n
