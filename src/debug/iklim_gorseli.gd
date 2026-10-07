class_name IklimGorseli
extends RefCounted
const KAR := preload("res://src/debug/deney_kar.gdshader")

static func uygula(s: Node) -> void:
	var y: KoyYonetimi = s.get("yonetim")
	var hava := IklimDeneyi.hava(y)
	var kar := 0.85 if hava == "kar_firtinasi" else 0.0
	var a: Node = s.get("arazi")
	if hava == "kuraklik": a.call("kuruluk_ayarla", 1.0)
	for alan in ["_zemin_mat", "_cimen_mat"]:
		var mat: ShaderMaterial = a.get(alan)
		mat.set_shader_parameter("kar_ortusu", kar)
	var atmosfer: Node = s.get("atmosfer")
	atmosfer.get("cevre").fog_density = 0.014 if kar > 0.0 else 0.0016
	var yagis := s.get_node_or_null("DebugKarYagisi") as MultiMeshInstance3D
	if yagis == null and kar > 0.0:
		yagis = MultiMeshInstance3D.new()
		yagis.name = "DebugKarYagisi"
		yagis.set_meta(&"grafik_efekti", true)
		yagis.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var mm := MultiMesh.new()
		mm.transform_format = MultiMesh.TRANSFORM_3D
		mm.use_custom_data = true
		var mesh := SphereMesh.new()
		mesh.radius = 0.065
		mesh.height = 0.13
		mesh.radial_segments = 8
		mesh.rings = 4
		var mat := ShaderMaterial.new()
		mat.shader = KAR
		mesh.material = mat
		mm.mesh = mesh
		mm.instance_count = 600
		for i in mm.instance_count:
			var x := -50.0 + float(i % 30) * 3.45
			var z := -40.0 + float(i / 30) * 4.0
			mm.set_instance_transform(i, Transform3D(Basis(), Vector3(x, 0, z)))
			mm.set_instance_custom_data(i, Color(float((i * 137) % 601) / 601.0, 0, 0, 1))
		yagis.multimesh = mm
		# Shader'daki düşüş hacmi CPU mesh sınırından geniştir.
		yagis.custom_aabb = AABB(Vector3(-55, -2, -45), Vector3(110, 25, 90))
		s.add_child(yagis)
	if yagis != null: yagis.visible = kar > 0.0
