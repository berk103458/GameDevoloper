## KRI-05: tek değişim noktası, yalnız düz renk kutu mezar; ekonomi/rota/RNG yok.
class_name CenazeMezari
extends RefCounted

static func kur(s: KoyYonetimSahnesi, ust: Node3D) -> void:
	var eski := ust.get_node_or_null("cenaze_mezari")
	if eski != null:
		ust.remove_child(eski)
		eski.queue_free()
	var d := CenazeYasi.durum(s.yonetim)
	if d.is_empty(): return
	var n := Node3D.new()
	n.name = "cenaze_mezari"
	var m := s.yonetim.a.meydan
	n.position = s.alan_merkezi(m.position, m.size) + Vector3(-3.0, 0.12, 3.0)
	ust.add_child(n)
	var kutu := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(2.0, 0.24, 0.9)
	kutu.mesh = mesh
	var malzeme := StandardMaterial3D.new()
	malzeme.albedo_color = Color(0.30, 0.24, 0.19)
	kutu.material_override = malzeme
	n.add_child(kutu)
	var etiket := Label3D.new()
	etiket.text = "%s · %d kişi" % ["Cenaze töreni" if d.secim == "toren" else "Toplu mezar" if d.secim == "toplu_mezar" else "Cenaze", d.sayi]
	etiket.position.y = 0.55
	etiket.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	etiket.font_size = 24
	n.add_child(etiket)
