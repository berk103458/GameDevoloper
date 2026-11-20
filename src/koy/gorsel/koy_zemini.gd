## Terrain3D köy zemini. Yükseklik `KoyArazisi.yukseklik` ile aynıdır; ızgara düz kalır.
## Çarpışma kapalıdır: yapı, yol ve ızgara seçimi eski mantıkta durur. Eski düzlem düğümü silinmez.
class_name KoyZemini
extends RefCounted

const COZUNURLUK := 128
const DOKULAR := [
	["cimen", "sparse_grass"],
	["patika", "rocky_trail"],
	["camur", "muddy_tracks"],
]


static func kur(arazi: KoyArazisi) -> Terrain3D:
	var eski := arazi.get_node_or_null(^"zemin_terrain")
	if eski != null:
		eski.queue_free()
	var t := Terrain3D.new()
	t.name = &"zemin_terrain"
	t.region_size = COZUNURLUK
	t.vertex_spacing = KoyArazisi.ZEMIN_BOYU / float(COZUNURLUK - 1)
	t.collision_mode = 0
	var img := Image.create_empty(COZUNURLUK, COZUNURLUK, false, Image.FORMAT_RF)
	var yari := KoyArazisi.ZEMIN_BOYU * 0.5
	var adim := KoyArazisi.ZEMIN_BOYU / float(COZUNURLUK - 1)
	for z in COZUNURLUK:
		for x in COZUNURLUK:
			var dx := -yari + float(x) * adim
			var dz := -yari + float(z) * adim
			img.set_pixel(x, z, Color(arazi.yukseklik_burada(dx, dz), 0, 0))
	var malzeme := Terrain3DMaterial.new()
	t.material = malzeme
	arazi.add_child(t)
	t.collision_mode = 0
	var veri: Terrain3DData = t.data
	var resimler: Array = [img, null, null]
	veri.import_images(resimler, Vector3(-yari, 0, -yari), 0.0, 1.0)
	_dokular(t)
	if veri.get_region_count() > 0:
		_katmanlar(t, arazi, yari, adim)
	var duzlem := _duzlem(arazi)
	if duzlem != null and veri.get_region_count() > 0:
		duzlem.visible = false
		duzlem.name = &"zemin_eski"
	return t


static func _dokular(t: Terrain3D) -> void:
	if t.assets == null:
		return
	for i in DOKULAR.size():
		var id: String = DOKULAR[i][1]
		var a := Terrain3DTextureAsset.new()
		a.name = DOKULAR[i][0]
		var albedo := Pbr.doku(id, "diff")
		if albedo != null:
			a.albedo_texture = albedo
		var normal := Pbr.doku(id, "nor_gl")
		if normal != null:
			a.normal_texture = normal
		a.uv_scale = 0.12
		t.assets.set_texture_asset(i, a)


static func _katmanlar(t: Terrain3D, arazi: KoyArazisi, yari: float, adim: float) -> void:
	var veri: Terrain3DData = t.data
	if veri == null or not veri.has_method("set_control_base_id"):
		return
	for z in COZUNURLUK:
		for x in COZUNURLUK:
			var dx := -yari + float(x) * adim
			var dz := -yari + float(z) * adim
			var katman := 0
			if _yol(arazi, dx, dz):
				katman = 1
			elif _camur(dx, dz):
				katman = 2
			veri.set_control_base_id(Vector3(dx, 0, dz), katman)


static func _yol(arazi: KoyArazisi, x: float, z: float) -> bool:
	if z <= arazi.kapi_z - 1.0:
		return false
	return absf(x - arazi.kapi_x - sin((z - arazi.kapi_z) * 0.05) * 4.0) < 2.2


static func _camur(x: float, z: float) -> bool:
	return absf(x) < 6.0 and absf(z) < 6.0 and (int(x * 3.0) + int(z * 5.0)) % 5 == 0


static func _duzlem(arazi: KoyArazisi) -> MeshInstance3D:
	for n in arazi.get_children():
		if n is MeshInstance3D and n.name != &"zemin_terrain":
			return n
	return null
