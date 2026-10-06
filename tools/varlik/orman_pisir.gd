## Köy orman kuşağı için impostor atlası pişirir (görsel tasarım md, madde 2): Poly Haven ağaçlarını köy
## kamerasının eğimiyle (45°) saydam arka plana çizer, 4×2 hücrelik tek bir atlasa dizer. Oyunda her ağaç kameraya
## dönük, gövde dibinden dönen bir dörtgendir (src/koy/gorsel/orman.gdshader); kamera eğimi pişirme açısına yakın
## olduğu için kuşbakışında da hacimli görünür. Tek doku, tek çizim çağrısı.
##   xvfb-run godot --path . --rendering-driver vulkan -s tools/varlik/orman_pisir.gd   (başsız çizmez)
## Girdi: assets/ph/model/fir_sapling_medium, island_tree_02 (polyhaven_indir.py; pişince silinebilir, repoya girmez)
## Çıktı: assets/ph/impostor/orman_atlas.png (2048×1024 RGBA) ve orman_atlas.json (hücre başına boy ve dip noktası)
extends SceneTree

const CIKTI := "res://assets/ph/impostor/"
const HUCRE := 512
## Pişirme çözünürlüğü (sonra HUCRE'ye küçültülür: yumuşak kenar).
const CIZIM := 1024
const EGIM := 45.0
## island_tree_02'nin gövdesi ile dibindeki taş tümsek aynı yüzeydir: tümsek bu yüksekliğin altında kesilir ve
## kesik çizgisi ağacın dibi sayılır (oyunda zemine oturur).
const KES := {"island_tree_02": 0.35}
## (model, parça adı (boş = tümü), yön açısı): sıra atlas hücre sırasıdır.
const DEGISKELER := [
	["fir_sapling_medium", "fir_sapling_medium_a_LOD0", 0.0],
	["fir_sapling_medium", "fir_sapling_medium_b_LOD0", 0.0],
	["fir_sapling_medium", "fir_sapling_medium_c_LOD0", 0.0],
	["fir_sapling_medium", "fir_sapling_medium_a_LOD0", 150.0],
	["island_tree_02", "", 0.0],
	["island_tree_02", "", 90.0],
	["island_tree_02", "", 180.0],
	["island_tree_02", "", 270.0],
]


func _init() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(CIKTI))
	var vp := SubViewport.new()
	vp.size = Vector2i(CIZIM, CIZIM)
	vp.transparent_bg = true
	vp.msaa_3d = Viewport.MSAA_4X
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	vp.own_world_3d = true
	root.add_child(vp)
	# Yumuşak, yönsüz ışık: oyundaki güneş ve gök rengi dörtgeni yeniden aydınlatır, pişmiş gölge az olmalı.
	var isik := DirectionalLight3D.new()
	isik.rotation_degrees = Vector3(-55, 20, 0)
	isik.light_energy = 0.9
	vp.add_child(isik)
	var ortam := WorldEnvironment.new()
	ortam.environment = Environment.new()
	ortam.environment.background_mode = Environment.BG_CLEAR_COLOR
	ortam.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	ortam.environment.ambient_light_color = Color(0.85, 0.88, 0.9)
	ortam.environment.ambient_light_energy = 0.75
	ortam.environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	vp.add_child(ortam)
	var kam := Camera3D.new()
	kam.projection = Camera3D.PROJECTION_ORTHOGONAL
	kam.near = 0.5
	kam.far = 200.0
	vp.add_child(kam)
	var atlas := Image.create_empty(HUCRE * 4, HUCRE * 2, false, Image.FORMAT_RGBA8)
	var bilgi: Array = []
	var modeller := {}
	for i in DEGISKELER.size():
		var d: Array = DEGISKELER[i]
		if not modeller.has(d[0]):
			var m := Pbr.model(d[0])
			if m == null:
				push_error("model yok: %s (önce polyhaven_indir.py)" % d[0])
				quit(1)
				return
			vp.add_child(m)
			modeller[d[0]] = m
			if KES.has(d[0]):
				_dibi_kes(m, KES[d[0]])
		for ad in modeller:
			(modeller[ad] as Node3D).visible = ad == d[0]
		var model: Node3D = modeller[d[0]]
		for c in model.get_children():
			(c as Node3D).visible = d[1] == "" or c.name == d[1]
		model.rotation_degrees.y = d[2]
		await process_frame
		var kutu := _kutu(model)
		# Ağacın dibi: görünür parçanın orta altı (köknarlar sahnede 5 m arayla dizili), kesilen modelde kesik çizgisi.
		var dip := Vector3(kutu.get_center().x, maxf(kutu.position.y, KES.get(d[0], -INF)), kutu.get_center().z)
		# Kamera: dibe EGIM açısıyla bakar; dibin görüntüdeki yeri hücreye kaydedilir.
		var e := deg_to_rad(EGIM)
		var yon := Vector3(0, sin(e), cos(e))
		kam.look_at_from_position(dip + yon * 60.0, dip)
		var ters := kam.global_transform.affine_inverse()
		var xm := 0.0
		var ya := INF
		var yu := -INF
		var dip_k := ters * dip
		for k in 8:
			var p := ters * kutu.get_endpoint(k) - dip_k
			xm = maxf(xm, absf(p.x))
			ya = minf(ya, p.y)
			yu = maxf(yu, p.y)
		var boy := maxf(2.0 * xm, yu - ya) * 1.04
		var cy := (ya + yu) * 0.5
		kam.size = boy
		var kay := kam.global_transform.basis.y * cy
		kam.look_at_from_position(dip + yon * 60.0 + kay, dip + kay)
		for k in 6:
			await process_frame
		await RenderingServer.frame_post_draw
		var img := vp.get_texture().get_image()
		img.convert(Image.FORMAT_RGBA8)
		img.resize(HUCRE, HUCRE, Image.INTERPOLATE_LANCZOS)
		# Saydam piksellere komşu rengi yay: mipmap'te kara hale olmasın.
		img.fix_alpha_edges()
		atlas.blit_rect(img, Rect2i(0, 0, HUCRE, HUCRE), Vector2i((i % 4) * HUCRE, (i / 4) * HUCRE))
		# dip_v: gövde dibinin hücre içindeki dikey yeri (üstten 0..1); boy: hücrenin dünya ölçüsü (m).
		var dip_v := 0.5 + cy / boy
		bilgi.append({"model": d[0], "parca": d[1], "aci": d[2], "boy": boy, "dip_v": dip_v,
			"yukseklik": kutu.end.y - dip.y})
		print("pişti %d: %s %s %.0f° boy=%.2f dip_v=%.3f" % [i, d[0], d[1], d[2], boy, dip_v])
	atlas.save_png(CIKTI + "orman_atlas.png")
	var f := FileAccess.open(CIKTI + "orman_atlas.json", FileAccess.WRITE)
	f.store_string(JSON.stringify({"egim": EGIM, "sutun": 4, "satir": 2, "hucreler": bilgi}, "\t"))
	f.close()
	quit()


## Gövde yüzeyine (0. yüzey) `kes` yüksekliğinin altını atan bir malzeme verir; dokuları özgün malzemeden alır.
func _dibi_kes(m: Node3D, kes: float) -> void:
	var sh := Shader.new()
	sh.code = """shader_type spatial;
uniform sampler2D renk : source_color;
uniform sampler2D normal_h : hint_normal;
uniform float kes;
varying float dunya_y;
void vertex() { dunya_y = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y; }
void fragment() {
	if (dunya_y < kes) { discard; }
	ALBEDO = texture(renk, UV).rgb;
	NORMAL_MAP = texture(normal_h, UV).rgb;
	ROUGHNESS = 0.9;
}"""
	for mi in m.find_children("*", "MeshInstance3D", true, false):
		var mesh := (mi as MeshInstance3D).mesh
		var ozgun := mesh.surface_get_material(0) as StandardMaterial3D
		var yeni := ShaderMaterial.new()
		yeni.shader = sh
		yeni.set_shader_parameter("renk", ozgun.albedo_texture if ozgun else null)
		yeni.set_shader_parameter("normal_h", ozgun.normal_texture if ozgun else null)
		yeni.set_shader_parameter("kes", kes)
		(mi as MeshInstance3D).set_surface_override_material(0, yeni)


func _kutu(n: Node3D) -> AABB:
	var a := AABB()
	var ilk := true
	for mi in n.find_children("*", "MeshInstance3D", true, false):
		var m := mi as MeshInstance3D
		if not m.is_visible_in_tree():
			continue
		var k := m.global_transform * m.get_aabb()
		a = k if ilk else a.merge(k)
		ilk = false
	return a
