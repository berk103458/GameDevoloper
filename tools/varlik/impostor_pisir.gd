## Uzak plan ağaçları için "impostor" pişirir: ağır bir modeli (fir_sapling_medium: 3 servi, 75 MB geometri) önden,
## saydam arka planla görüntüye çizer. Uzakta bu görüntü kameraya dönük dörtgende kullanılır (KapiManzarasi).
##   godot --path . --rendering-driver vulkan -s tools/varlik/impostor_pisir.gd   (pencereli/xvfb; başsız çizmez)
## Girdi: assets/ph/model/fir_sapling_medium (polyhaven_indir.py ile indirilir, pişirince silinebilir)
## Çıktı: assets/ph/impostor/servi_<a|b|c>.png (512×1024, RGBA)
extends SceneTree

const MODEL := "fir_sapling_medium"
const CIKTI := "res://assets/ph/impostor/"


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(CIKTI))
	var vp := SubViewport.new()
	vp.size = Vector2i(512, 1024)
	vp.transparent_bg = true
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	vp.own_world_3d = true
	root.add_child(vp)
	var isik := DirectionalLight3D.new()
	isik.rotation_degrees = Vector3(-35, 25, 0)
	isik.light_energy = 1.2
	vp.add_child(isik)
	var ortam := WorldEnvironment.new()
	ortam.environment = Environment.new()
	ortam.environment.background_mode = Environment.BG_CLEAR_COLOR
	ortam.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	ortam.environment.ambient_light_color = Color(0.7, 0.75, 0.85)
	ortam.environment.ambient_light_energy = 0.6
	vp.add_child(ortam)
	var kam := Camera3D.new()
	kam.projection = Camera3D.PROJECTION_ORTHOGONAL
	vp.add_child(kam)
	var model := Pbr.model(MODEL)
	vp.add_child(model)
	var parcalar := model.get_children()
	for p in parcalar:
		for q in parcalar:
			(q as Node3D).visible = q == p
		var kutu := _kutu(p as Node3D)
		var merkez := kutu.get_center()
		kam.size = kutu.size.y * 1.02
		kam.position = Vector3(merkez.x, merkez.y, kutu.end.z + 20.0)
		kam.near = 1.0
		kam.far = 60.0
		for k in 4:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := vp.get_texture().get_image()
		var ad := String(p.name).get_slice("_", 3)
		img.save_png(CIKTI + "servi_%s.png" % ad)
		print("pişti: servi_", ad, " ", kutu.size)
	quit()


func _kutu(n: Node3D) -> AABB:
	var a := AABB()
	var ilk := true
	for mi in n.find_children("*", "MeshInstance3D", true, false) + ([n] if n is MeshInstance3D else []):
		var m := mi as MeshInstance3D
		var k := m.global_transform * m.get_aabb()
		a = k if ilk else a.merge(k)
		ilk = false
	return a
