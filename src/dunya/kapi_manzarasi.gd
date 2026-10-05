## Kapının dışındaki dünya: kıvrılarak ufka giden yol, tepeler, servi silüetleri, yıldızlı gök, yol boyunca
## kapıya yürüyen mülteci silüetleri ve ufukta tehdit. Tehdit gece gece büyür; ekranda yazı olmadan anlatır:
##  1. perde — tepenin ardında yanan bir köy: önce ince duman, sonra ateş, sonra sırtta atlı silüetleri.
##  2. perde — Tekfur'un ordusu: kamp ateşleri çoğalır ve yaklaşır, çadırlar, en sonunda tepede asker sıraları.
## Yerleşim: kamera kapının içinde (z≈1.2), dışarıya (−z) bakar. Gelen kapının önünde (z≈−2.5) durur; arkası temiz
## kalsın diye ayrıntı yoğunluğu: ön plan yüksek, sorgu alanı düşük, orta plan orta, ufuk yalnız silüet.
## Tasarım: design/gdd/kapi-manzarasi.md
class_name KapiManzarasi
extends Node3D

## Toprak, buz ve yol tonları (soğuk ay ışığında; sıcak ışık yalnız kapının dibinde).
const TOPRAK := Color("#3a3a4a")
const KIRAGI := Color("#7d8aa6")
const YOL := Color("#5a4c44")
const SILUET := Color("#0e1220")
const SERVI := Color("#121a26")
const ATES := Color("#ff7a2a")
const ATES_IC := Color("#ffd27a")
const DUMAN := Color("#262833")

## Yol orta çizgisi (x, z): kapıdan (0, −2) ufuktaki sırta kıvrılır.
const YOL_NOKTALARI := [Vector2(0.0, 0.0), Vector2(0.0, -10.0), Vector2(-0.8, -18.0), Vector2(-3.5, -28.0),
	Vector2(-2.0, -40.0), Vector2(2.0, -54.0), Vector2(-1.0, -70.0), Vector2(-6.0, -88.0), Vector2(-5.0, -106.0),
	Vector2(-10.0, -124.0)]
## Yanan köyün sırtı ve Tekfur ordusunun geldiği yön (ufukta, yolun bittiği yerin sağı).
const KOY_YERI := Vector3(-8.0, 0.0, -136.0)

## Gece gökyüzü (Poly Haven HDRI).
const GOK := "satara_night_no_lamps"

## Gece (0'dan) ve perde: tehdidin ne kadar büyüdüğünü belirler.
var gece := 0
var perde := 1
## İkinci perdede Tekfur'un yakınlığı 0..1 (perde2_gece / perde2_hedef_gece).
var yakinlik := 0.0

var _zaman := 0.0
var _ates_isiklari: Array[OmniLight3D] = []
var _alevler: Array[MeshInstance3D] = []
var _dallar: Array[Node3D] = []
var _gok: MeshInstance3D


## Bu gece görünen ateş (alev parçası) sayısı: tehdidin büyüdüğünü test etmek için.
func ates_sayisi() -> int:
	return _alevler.size()


func _ready() -> void:
	# Gökyüzü HDRI'dan gelir (KapiSahnesi ortamı); HDRI yoksa yordamsal gök ve yıldızlar.
	if Pbr.gok(GOK) == null:
		_gok_kur()
	_arazi_kur()
	_yol_kur()
	_daglar_kur()
	_serviler_kur()
	_yol_kenari_kur()
	_multeciler_kur()
	if perde == 1:
		_yanan_koy_kur()
	else:
		_yanan_koy_kur(true)
		_tekfur_kur()


func _process(delta: float) -> void:
	_zaman += delta
	_yuruyenleri_ilerlet(delta)
	for i in _ates_isiklari.size():
		var l := _ates_isiklari[i]
		l.light_energy = float(l.get_meta("taban")) * (0.8 + 0.2 * sin(_zaman * 7.3 + i * 1.7) * sin(_zaman * 2.9 + i))
	for i in _alevler.size():
		var a := _alevler[i]
		var s := 0.85 + 0.25 * sin(_zaman * 9.0 + i * 2.3)
		a.scale = Vector3(1.0, s, 1.0) * float(a.get_meta("olcek"))


## Arazi yüksekliği (m): kapının çevresi düz, uzaklaştıkça yumuşak tepeler; yol boyunca hafif çukur.
static func yukseklik(x: float, z: float) -> float:
	var uzak := clampf((-z - 12.0) / 90.0, 0.0, 1.0)
	var tepe := sin(x * 0.07 + 1.3) * cos(z * 0.045) * 3.2 + sin(x * 0.021 - z * 0.03) * 5.0 + 4.0
	var h := tepe * uzak * uzak + maxf(0.0, -z - 90.0) * 0.18
	return h - _yola_yakinlik(x, z) * 0.6 * uzak


## Yol orta çizgisine yakınlık (1 = yolun üstünde, 0 = 6 m ve ötesi).
static func _yola_yakinlik(x: float, z: float) -> float:
	var en := 1e9
	for i in YOL_NOKTALARI.size() - 1:
		var a: Vector2 = YOL_NOKTALARI[i]
		var b: Vector2 = YOL_NOKTALARI[i + 1]
		var p := Vector2(x, z)
		var t := clampf((p - a).dot(b - a) / (b - a).length_squared(), 0.0, 1.0)
		en = minf(en, p.distance_to(a + (b - a) * t))
	return clampf(1.0 - en / 6.0, 0.0, 1.0)


## Yol üzerinde 0..1 konumundaki nokta (dünya; yüksekliği arazide).
static func yol_noktasi(t: float) -> Vector3:
	var n := YOL_NOKTALARI.size() - 1
	var f := clampf(t, 0.0, 1.0) * n
	var i := mini(int(f), n - 1)
	var a: Vector2 = YOL_NOKTALARI[i]
	var b: Vector2 = YOL_NOKTALARI[i + 1]
	# Catmull-Rom yumuşatma.
	var a0: Vector2 = YOL_NOKTALARI[maxi(i - 1, 0)]
	var b1: Vector2 = YOL_NOKTALARI[mini(i + 2, n)]
	var p := a.cubic_interpolate(b, a0, b1, f - i)
	return Vector3(p.x, yukseklik(p.x, p.y), p.y)


func _malzeme(renk: Color, kenar_isigi := false) -> StandardMaterial3D:
	var m := Dunya3B.duz_malzeme(renk)
	if kenar_isigi:
		m.vertex_color_use_as_albedo = true
	return m


func _isik_sacan(renk: Color, guc: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color.BLACK
	m.emission_enabled = true
	m.emission = renk
	m.emission_energy_multiplier = guc
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = renk
	return m


# ── Gök: koyu lacivert, ufka doğru açılan; yıldızlar ve ufukta yangının turuncu yansıması. ──
func _gok_kur() -> void:
	_gok = MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 400.0
	k.height = 800.0
	k.radial_segments = 32
	k.rings = 16
	_gok.mesh = k
	var st := SurfaceTool.new()
	st.create_from(k, 0)
	var dizi := st.commit_to_arrays()
	var konum: PackedVector3Array = dizi[Mesh.ARRAY_VERTEX]
	var renk := PackedColorArray()
	var ust := Color("#070a14")
	var ufuk := Color("#1b2a4a")
	var parilti := Color("#5a2a1e") if perde == 1 else Color("#3a2430")
	var ates_yon := Vector3(KOY_YERI.x, 0, KOY_YERI.z).normalized()
	for v in konum:
		var y := clampf(v.y / 400.0, -1.0, 1.0)
		var c := ufuk.lerp(ust, clampf(y * 2.2, 0.0, 1.0))
		var yon := Vector3(v.x, 0, v.z).normalized()
		var yakin := clampf(yon.dot(ates_yon), 0.0, 1.0)
		var guc := clampf(0.15 + gece * 0.08, 0.15, 0.7) if perde == 1 else 0.35 + yakinlik * 0.4
		c = c.lerp(parilti, pow(yakin, 6.0) * clampf(1.0 - y * 4.0, 0.0, 1.0) * guc)
		renk.append(c)
	dizi[Mesh.ARRAY_COLOR] = renk
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, dizi)
	_gok.mesh = am
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.vertex_color_use_as_albedo = true
	mat.cull_mode = BaseMaterial3D.CULL_FRONT
	mat.disable_fog = true
	_gok.material_override = mat
	add_child(_gok)
	# Yıldızlar: gökkubbenin üst yarısında küçük ışık noktaları (sabit tohum: her gece aynı gök).
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var nokta := SphereMesh.new()
	nokta.radius = 0.6
	nokta.height = 1.2
	nokta.radial_segments = 4
	nokta.rings = 2
	mm.mesh = nokta
	mm.instance_count = 500
	var r := RandomNumberGenerator.new()
	r.seed = 1243
	for i in mm.instance_count:
		var a := r.randf() * TAU
		var e := asin(lerpf(0.12, 0.98, pow(r.randf(), 0.7)))
		var p := Vector3(cos(e) * cos(a), sin(e), cos(e) * sin(a)) * 380.0
		mm.set_instance_transform(i, Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * r.randf_range(0.4, 1.3)), p))
	var yildiz := MultiMeshInstance3D.new()
	yildiz.multimesh = mm
	var ym := _isik_sacan(Color("#c8d4ff"), 1.0)
	ym.disable_fog = true
	yildiz.material_override = ym
	add_child(yildiz)


# ── Arazi: ızgara mesh, tepeler ve kırağı lekeleri (köşe rengi). ──
func _arazi_kur() -> void:
	# Izgara: kapıya yakın sık (0.8 m), uzakta seyrek; köşe rengi .r kırağı maskesi (arazi.gdshader).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var xs := _izgara(-90.0, 90.0, 0.8, 3.0, 0.0)
	var zs := _izgara(-200.0, 6.0, 0.8, 3.0, 0.0)
	var gurultu := FastNoiseLite.new()
	gurultu.seed = 7
	gurultu.frequency = 0.06
	for j in zs.size() - 1:
		for i in xs.size() - 1:
			var kose := []
			for d in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 0), Vector2i(1, 1), Vector2i(0, 1)]:
				var x: float = xs[i + d.x]
				var z: float = zs[j + d.y]
				kose.append(Vector3(x, yukseklik(x, z), z))
			for k in 6:
				var v: Vector3 = kose[k]
				var kiragi := clampf(gurultu.get_noise_2d(v.x, v.z) * 1.3 + 0.35 - _yola_yakinlik(v.x, v.z) * 0.6, 0.0, 1.0)
				st.set_color(Color(kiragi, 0, 0))
				st.set_uv(Vector2(v.x, v.z))
				st.add_vertex(v)
	st.generate_normals()
	st.generate_tangents()
	var m := MeshInstance3D.new()
	m.mesh = st.commit()
	var sh := ShaderMaterial.new()
	sh.shader = load("res://src/dunya/arazi.gdshader")
	for harita in [["renk", "diff"], ["normal", "nor_gl"], ["kaba", "rough"]]:
		sh.set_shader_parameter("camur_" + harita[0], Pbr.doku("brown_mud_rocks_01", harita[1]))
		sh.set_shader_parameter("kar_" + harita[0], Pbr.doku("snow_02", harita[1]))
	m.material_override = sh
	add_child(m)


## Kapıdan (0) uzaklaştıkça büyüyen aralıklarla ızgara çizgileri: yakında `ince`, uzakta `kalin` m.
static func _izgara(bas: float, son: float, ince: float, kalin: float, merkez: float) -> PackedFloat32Array:
	var a := PackedFloat32Array()
	var v := bas
	while v < son:
		a.append(v)
		var uzak := clampf(absf(v - merkez) / 60.0, 0.0, 1.0)
		v += lerpf(ince, kalin, uzak)
	a.append(son)
	return a


# ── Yol: kapıda geniş (sorgu alanı), ufka doğru daralan kıvrık şerit; kenarlarda tekerlek izi. ──
func _yol_kur() -> void:
	# Beş şerit enine: ortası tam, kenarlara doğru saydamlaşır (arazinin kırağısına yumuşak geçer).
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var parca := 260
	var enine := [-0.62, -0.42, -0.25, 0.25, 0.42, 0.62]
	var saydam := [0.0, 0.85, 1.0, 1.0, 0.85, 0.0]
	var onceki: Array = []
	var yol_boyu := 0.0
	var onceki_p := yol_noktasi(0.0)
	for s_ in parca + 1:
		var t := float(s_) / parca
		var p := yol_noktasi(t)
		yol_boyu += p.distance_to(onceki_p)
		onceki_p = p
		var ileri := yol_noktasi(minf(t + 0.003, 1.0)) - yol_noktasi(maxf(t - 0.003, 0.0))
		ileri.y = 0.0
		var yan := Vector3(-ileri.z, 0, ileri.x).normalized()
		var en := lerpf(5.2, 1.4, pow(t, 0.55))
		var sira: Array = []
		for k in enine.size():
			var v := p + yan * en * float(enine[k])
			v.y = yukseklik(v.x, v.z) + 0.025 + t * 0.06
			sira.append([v, Vector2(float(enine[k]) * en / 3.0, yol_boyu / 3.0), saydam[k]])
		if s_ > 0:
			for k in enine.size() - 1:
				for q in [[onceki, k], [onceki, k + 1], [sira, k + 1], [onceki, k], [sira, k + 1], [sira, k]]:
					var n: Array = q[0][q[1]]
					st.set_color(Color(1, 1, 1, n[2]))
					st.set_uv(n[1])
					st.add_vertex(n[0])
		onceki = sira
	st.generate_normals()
	st.generate_tangents()
	var m := MeshInstance3D.new()
	m.mesh = st.commit()
	var mat := Pbr.malzeme("muddy_tracks", 1.0, Color(0.72, 0.66, 0.6), false).duplicate() as StandardMaterial3D
	mat.uv1_scale = Vector3.ONE
	mat.vertex_color_use_as_albedo = true
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
	m.material_override = mat
	m.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(m)


# ── Uzak dağlar: gürültülü sırtlardan bir dağ silsilesi; kaya dokusu, tepelerde kar (arazi.gdshader). Sise karışır. ──
func _daglar_kur() -> void:
	var g := FastNoiseLite.new()
	g.seed = 1243
	g.noise_type = FastNoiseLite.TYPE_SIMPLEX
	g.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	g.fractal_octaves = 5
	g.frequency = 0.008
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var nx := 140
	var nz := 40
	for j in nz:
		for i in nx:
			var kose := []
			for d in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 0), Vector2i(1, 1), Vector2i(0, 1)]:
				var x: float = -320.0 + (i + d.x) * 640.0 / nx
				var z: float = -190.0 - (j + d.y) * 160.0 / nz
				var derin := clampf((-z - 190.0) / 60.0, 0.0, 1.0)
				var h := (g.get_noise_2d(x, z) * 0.5 + 0.5) * lerpf(18.0, 70.0, derin) + derin * 10.0
				kose.append(Vector3(x, h, z))
			for k in 6:
				var v: Vector3 = kose[k]
				st.set_color(Color(clampf((v.y - 22.0) / 18.0, 0.0, 1.0), 0, 0))
				st.set_uv(Vector2(v.x, v.z))
				st.add_vertex(v)
	st.generate_normals()
	st.generate_tangents()
	var m := MeshInstance3D.new()
	m.mesh = st.commit()
	var sh := ShaderMaterial.new()
	sh.shader = load("res://src/dunya/arazi.gdshader")
	for harita in [["renk", "diff"], ["normal", "nor_gl"], ["kaba", "rough"]]:
		sh.set_shader_parameter("camur_" + harita[0], Pbr.doku("aerial_rocks_02", harita[1]))
		sh.set_shader_parameter("kar_" + harita[0], Pbr.doku("snow_field_aerial", harita[1]))
	sh.set_shader_parameter("boy", 24.0)
	sh.set_shader_parameter("ton", Color(0.55, 0.55, 0.6))
	m.material_override = sh
	m.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(m)


# ── Serviler ve köknarlar: Poly Haven ağacından pişirilmiş görüntüler (impostor; tools/varlik/impostor_pisir.gd),
# kameraya dönük dörtgenlerde. Servi: dar ve uzun; köknar kümesi: geniş. Yol kenarında ve tepelerde, kümeler hâlinde. ──
func _serviler_kur() -> void:
	var dokular: Array[Texture2D] = []
	for ad in ["a", "b", "c"]:
		var yol := "res://assets/ph/impostor/servi_%s.png" % ad
		if ResourceLoader.exists(yol):
			dokular.append(load(yol))
	if dokular.is_empty():
		return
	var mats: Array[StandardMaterial3D] = []
	for d in dokular:
		var m := StandardMaterial3D.new()
		m.albedo_texture = d
		m.albedo_color = Color(0.55, 0.6, 0.6)
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
		m.alpha_scissor_threshold = 0.45
		m.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
		m.billboard_keep_scale = true
		m.cull_mode = BaseMaterial3D.CULL_DISABLED
		m.roughness = 1.0
		m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		mats.append(m)
	var r := RandomNumberGenerator.new()
	r.seed = 3
	var yerler: Array[Vector4] = []
	# Kümeler: tepelerde ve yol boyunca (yolun üstüne değil).
	var kumeler := [Vector3(-26, 0, -48), Vector3(-14, 0, -70), Vector3(14, 0, -58), Vector3(-30, 0, -95),
		Vector3(22, 0, -100), Vector3(-6, 0, -118), Vector3(10, 0, -80), Vector3(-40, 0, -130), Vector3(32, 0, -125),
		Vector3(-18, 0, -34), Vector3(9, 0, -38)]
	for k in kumeler:
		for n in r.randi_range(3, 7):
			var x: float = k.x + r.randf_range(-6.0, 6.0)
			var z: float = k.z + r.randf_range(-5.0, 5.0)
			if _yola_yakinlik(x, z) > 0.35:
				continue
			yerler.append(Vector4(x, yukseklik(x, z), z, r.randf()))
	for y in yerler:
		var q := QuadMesh.new()
		var boy := r.randf_range(7.0, 12.0)
		var servi := y.w < 0.65
		q.size = Vector2(boy * (0.28 if servi else 0.5), boy)
		q.center_offset = Vector3(0, boy * 0.5, 0)
		var m := MeshInstance3D.new()
		m.mesh = q
		m.material_override = mats[r.randi() % mats.size()]
		m.position = Vector3(y.x, y.y - 0.3, y.z)
		m.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(m)


# ── Yol kenarı: kırık çitler, taş yığınları, yıkık taş direk, terk edilmiş eşya. Sorgu alanı (x −2..2, z −1..−6) boş. ──
func _yol_kenari_kur() -> void:
	var ahsap := Pbr.malzeme("bark_willow", 1.0, Color(0.55, 0.5, 0.46))
	var tas := Pbr.malzeme("castle_wall_varriation", 2.4, Color(0.7, 0.7, 0.72))
	# Kırık çit: yolun solunda ve sağında kesik kesik, yer yer devrik.
	var r := RandomNumberGenerator.new()
	r.seed = 11
	for yan in [-1.0, 1.0]:
		for i in 8:
			if r.randf() < 0.35:
				continue
			var t := 0.1 + i * 0.022
			var p := yol_noktasi(t)
			var x: float = p.x + yan * (3.4 + r.randf() * 0.8)
			var tutam := Node3D.new()
			tutam.position = Vector3(x, yukseklik(x, p.z), p.z)
			tutam.rotation.y = r.randf_range(-0.2, 0.2)
			tutam.rotation.z = r.randf_range(-0.25, 0.25)
			add_child(tutam)
			for k in 2:
				var direk := _kutu(Vector3(0.12, 1.1, 0.12), Vector3(0, 0.55, k * 1.8 - 0.9), ahsap)
				tutam.add_child(direk)
			if r.randf() < 0.7:
				var kiris := _kutu(Vector3(0.08, 0.1, 2.0), Vector3(0, 0.75, 0), ahsap)
				kiris.rotation.x = r.randf_range(-0.3, 0.3)
				tutam.add_child(kiris)
	# Taş yığınları ve yıkık direk (sol orta plan).
	for y in [[Vector3(-4.8, 0, -7.0), 0.8, "boulder_01"], [Vector3(-7.5, 0, -15.0), 0.5, "rock_moss_set_01"],
			[Vector3(4.8, 0, -19.0), 0.9, "boulder_01"], [Vector3(-9.0, 0, -26.0), 0.6, "rock_moss_set_01"],
			[Vector3(-3.4, 0, -11.0), 0.35, "boulder_01"]]:
		var k: Node3D = Pbr.model(y[2])
		if k == null:
			k = Dunya3B.nesne("kaya", y[1])
		else:
			k.scale = Vector3.ONE * float(y[1])
		k.position = y[0] + Vector3(0, yukseklik(y[0].x, y[0].z) - 0.1, 0)
		k.rotation.y = y[0].x
		add_child(k)
	# Devrik kütük ve kuru dallar (yol kenarı, orta plan).
	var kutuk := Pbr.model("dead_tree_trunk_02")
	if kutuk != null:
		kutuk.position = Vector3(-5.2, yukseklik(-5.2, -9.5), -9.5)
		kutuk.rotation.y = 0.5
		add_child(kutuk)
	for d in [[Vector3(3.6, 0, -6.0), 0.3], [Vector3(-3.6, 0, -16.0), 1.4], [Vector3(5.5, 0, -12.0), 2.2]]:
		var dal := Pbr.model("dry_branches_medium_01")
		if dal == null:
			break
		dal.position = d[0] + Vector3(0, yukseklik(d[0].x, d[0].z), 0)
		dal.rotation.y = d[1]
		add_child(dal)
	var direk := _kutu(Vector3(1.0, 2.4, 1.0), Vector3(3.0, 1.2, -15.0), tas)
	add_child(direk)
	var direk_ust := _kutu(Vector3(0.8, 0.55, 0.8), Vector3(2.9, 2.65, -15.1), tas)
	direk_ust.rotation.z = 0.25
	add_child(direk_ust)
	# Kuru ceviz: sağ arkada, güçlü silüet; dalları rüzgârda çok hafif oynar.
	var agac := Dunya3B.nesne("agac", 9.0)
	agac.position = Vector3(-12.0, yukseklik(-12.0, -27.0), -27.0)
	agac.rotation.y = 0.6
	add_child(agac)
	_dallar.append(agac)
	var agac2 := Dunya3B.nesne("agac", 4.5)
	agac2.position = Vector3(-11.0, yukseklik(-11.0, -34.0), -34.0)
	add_child(agac2)


func _kutu(boyut: Vector3, konum: Vector3, mat: Material) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.position = konum
	m.material_override = mat
	return m


# ── Yolda kapıya yürüyen insanlar: gerçek karakter modelleri yolun üstünde yavaşça kapıya yürür; kuyruğun sonuna
# varan yolun başına döner (sıra hiç bitmez gibi). Bazılarının elinde fener; uzakta yalnız fener ışığı seçilir. ──
const YURUYEN_HIZ := 0.55
## Yürüyenler kuyruğun sonunun biraz gerisinde kalabalığa karışır (sise karışarak kaybolur, birden yok olmaz).
const YURUYEN_SON := 0.21
const YURUYEN_BAS := 0.78
## Kaybolma / belirme payı (yol parametresi).
const YURUYEN_SOLMA := 0.025
var _yuruyenler: Array = []


func _multeciler_kur() -> void:
	var r := RandomNumberGenerator.new()
	r.seed = 21 + gece
	var adet := 6 + mini(gece, 6) if perde == 1 else 4
	var turler := ["ciftci", "ciftci_kadin", "esnaf", "asker", "ciftci", "ciftci_kadin"]
	for i in adet:
		var k := Dunya3B.karakter(turler[i % turler.size()])
		var t := YURUYEN_SON + 0.05 + float(i) / adet * 0.55 + r.randf() * 0.02
		add_child(k)
		k.scale = Vector3.ONE * r.randf_range(0.92, 1.05)
		var yan := r.randf_range(-0.5, 0.5)
		if r.randf() < 0.35:
			var fener := MeshInstance3D.new()
			var f := SphereMesh.new()
			f.radius = 0.06
			f.height = 0.12
			fener.mesh = f
			fener.position = Vector3(0.35, 0.95, 0.1)
			fener.material_override = _isik_sacan(ATES_IC, 4.0)
			k.add_child(fener)
			var l := OmniLight3D.new()
			l.light_color = ATES
			l.light_energy = 0.6
			l.omni_range = 4.0
			l.position = fener.position
			k.add_child(l)
		_yuruyenler.append({"k": k, "t": t, "yan": yan})
		_yuruyen_yerlestir(_yuruyenler[-1])
		k.yuru(k.position + Vector3(0, 0, 0.001), 0.01)


func _yuruyen_yerlestir(y: Dictionary) -> void:
	var k: KarakterModel = y["k"]
	var t: float = y["t"]
	var p := yol_noktasi(t)
	var ileri := yol_noktasi(maxf(t - 0.01, 0.0)) - p
	ileri.y = 0.0
	var yan := Vector3(-ileri.z, 0, ileri.x).normalized()
	k.position = p + yan * float(y["yan"])
	k.look_at(k.position + ileri, Vector3.UP, true)


## Yürüyenleri ilerletir (KapiManzarasi._process).
func _yuruyenleri_ilerlet(delta: float) -> void:
	for y in _yuruyenler:
		var t: float = y["t"]
		var adim := YURUYEN_HIZ * delta / maxf(yol_noktasi(t).distance_to(yol_noktasi(t + 0.01)) * 100.0, 0.01)
		t -= adim
		if t < YURUYEN_SON:
			t = YURUYEN_BAS + randf() * 0.04
		y["t"] = t
		_yuruyen_yerlestir(y)
		var k: KarakterModel = y["k"]
		k.gorunurluk(minf((t - YURUYEN_SON) / YURUYEN_SOLMA, (YURUYEN_BAS + 0.04 - t) / YURUYEN_SOLMA))


# ── 1. perde: tepenin ardında yanan köy. Gece 0: yalnız ince duman; sonra ateş büyür; 5. geceden sonra sırtta atlılar. ──
func _yanan_koy_kur(soner := false) -> void:
	var taban := KOY_YERI + Vector3(0, yukseklik(KOY_YERI.x, KOY_YERI.z), 0)
	var siddet := clampf(gece / 6.0, 0.0, 1.0) if not soner else 0.25
	# Köy: dokulu kerpiç evler ve çadırlar sırta oturur (her biri kendi zeminine; havada durmaz).
	var mat := _malzeme(SILUET)
	var rk := RandomNumberGenerator.new()
	rk.seed = 77
	var evler: Array[Vector3] = []
	for i in 11:
		var x := rk.randf_range(-16.0, 16.0)
		var z := rk.randf_range(-6.0, 6.0)
		var p := Vector3(taban.x + x, 0, taban.z + z)
		p.y = yukseklik(p.x, p.z) - 0.25
		var cadir := i % 4 == 3
		var ev := Dunya3B.nesne("cadir" if cadir else "ev", rk.randf_range(2.6, 3.6) * (0.8 if cadir else 1.0), "yapi")
		ev.position = p
		ev.rotation.y = rk.randf() * TAU
		ev.scale = Vector3.ONE * rk.randf_range(0.9, 1.25)
		add_child(ev)
		evler.append(p)
	# Köyün ortasında yıkık bir taş kule (silüette köy olduğu okunsun).
	var kule := _kutu(Vector3(3.0, 7.0, 3.0), Vector3(taban.x + 2.0, yukseklik(taban.x + 2.0, taban.z) + 3.2, taban.z - 1.0),
			Pbr.malzeme("castle_wall_varriation", 3.0, Color(0.6, 0.58, 0.56)))
	add_child(kule)
	# Ateşler: gece arttıkça çoğalır ve büyür.
	var ates_sayisi := 0 if gece == 0 and not soner else 1 + int(siddet * 6.0)
	var r := RandomNumberGenerator.new()
	r.seed = 1243
	for i in ates_sayisi:
		# Ateş bir evin damında: o evin zemininden yukarıda.
		var ev_p: Vector3 = evler[i % evler.size()]
		var p := ev_p + Vector3(r.randf_range(-0.8, 0.8), 2.4 + r.randf() * 0.6, r.randf_range(-0.8, 0.8))
		_ates_kur(p, r.randf_range(1.2, 2.2) * (0.8 + siddet), 6.0 + siddet * 10.0)
	# Ufukta yangının parıltısı: tepenin üstünde geniş, yumuşak turuncu hale.
	if ates_sayisi > 0:
		var hale := MeshInstance3D.new()
		var q := QuadMesh.new()
		q.size = Vector2(70.0 + siddet * 40.0, 26.0 + siddet * 14.0)
		hale.mesh = q
		hale.position = taban + Vector3(0, 5.0, -2.0)
		var hm := StandardMaterial3D.new()
		hm.albedo_texture = _yumusak_doku()
		hm.albedo_color = Color(ATES, 0.1 + siddet * 0.16)
		hm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		hm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		hm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		hm.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
		hm.disable_fog = true
		hale.material_override = hm
		add_child(hale)
	# Duman: hep var; gece arttıkça sütunlar çoğalır ve kalınlaşır. Rüzgârla sağa yatar.
	var sutun := 1 + int(siddet * 3.0)
	for k in sutun:
		var d := MeshInstance3D.new()
		var q := QuadMesh.new()
		var boy := 45.0 + siddet * 40.0 - k * 6.0
		q.size = Vector2(boy * 0.8, boy)
		q.center_offset = Vector3(0, boy * 0.5, 0)
		d.mesh = q
		var sh := ShaderMaterial.new()
		sh.shader = load("res://src/dunya/duman.gdshader")
		sh.set_shader_parameter("gurultu", _gurultu_doku())
		sh.set_shader_parameter("tohum", float(k) * 0.37)
		sh.set_shader_parameter("koyuluk", 0.45 + siddet * 0.35)
		d.material_override = sh
		var kaynak: Vector3 = evler[(k * 3) % evler.size()]
		d.position = kaynak + Vector3(0, 2.0, -1.0 - k)
		d.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		add_child(d)
	# Sırtta atlı silüetleri (5. geceden sonra).
	if not soner and gece >= 5:
		for i in mini(gece - 3, 8):
			var a := _atli_kur(mat)
			var x := -22.0 + i * 3.2
			a.position = Vector3(KOY_YERI.x + x, yukseklik(KOY_YERI.x + x, KOY_YERI.z + 14.0) + 0.1, KOY_YERI.z + 14.0)
			add_child(a)


## Alev: dalgalanan damla biçimli gölgelendirici (alev.gdshader), kameraya dönük. `boy` alevin yüksekliği (m).
## Meşaleler (KapiCercevesi) ve uzak yangınlar kullanır; birkaç dil yan yana konarak daha büyük ateş olur.
static func alev(boy: float, parlaklik: float = 2.5, tohum: float = 0.0) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var q := QuadMesh.new()
	q.size = Vector2(boy * 0.62, boy)
	q.center_offset = Vector3(0, boy * 0.42, 0)
	m.mesh = q
	var sh := ShaderMaterial.new()
	sh.shader = load("res://src/dunya/alev.gdshader")
	sh.set_shader_parameter("gurultu", _gurultu_doku())
	sh.set_shader_parameter("parlaklik", parlaklik)
	sh.set_shader_parameter("tohum", tohum)
	m.material_override = sh
	m.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return m


static var _gurultu: NoiseTexture2D


static func _gurultu_doku() -> NoiseTexture2D:
	if _gurultu == null:
		var g := FastNoiseLite.new()
		g.frequency = 0.02
		g.fractal_octaves = 3
		_gurultu = NoiseTexture2D.new()
		_gurultu.noise = g
		_gurultu.width = 256
		_gurultu.height = 256
		_gurultu.seamless = true
	return _gurultu


## Parçacık alev: yumuşak, toplamalı (additive) taneler; sarıdan kızıla söner. `boy` ≈ alevin yüksekliği (m),
## `parlaklik` ışımanın gücü (1 = sönük, 2 = meşale yakını). Meşaleler (KapiCercevesi) de bunu kullanır.
static func parcacik_alev(boy: float, parlaklik: float) -> CPUParticles3D:
	var a := CPUParticles3D.new()
	a.amount = 16
	a.lifetime = 0.7
	a.preprocess = 1.0
	a.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
	a.emission_sphere_radius = boy * 0.18
	a.direction = Vector3.UP
	a.spread = 10.0
	a.gravity = Vector3(0.05, boy * 1.2, 0)
	a.initial_velocity_min = boy * 0.6
	a.initial_velocity_max = boy * 1.2
	a.scale_amount_min = boy * 0.35
	a.scale_amount_max = boy * 0.7
	var kucul := Curve.new()
	kucul.add_point(Vector2(0, 1.0))
	kucul.add_point(Vector2(1, 0.15))
	a.scale_amount_curve = kucul
	var renk := Gradient.new()
	renk.set_color(0, Color(ATES_IC, 0.85))
	renk.add_point(0.3, Color(ATES, 0.7))
	renk.set_color(renk.get_point_count() - 1, Color(0.5, 0.08, 0.02, 0.0))
	a.color_ramp = renk
	var q := QuadMesh.new()
	q.size = Vector2(1, 1.5)
	a.mesh = q
	var m := StandardMaterial3D.new()
	m.albedo_texture = _yumusak_doku()
	# Karışım (toplamalı değil): üst üste binen taneler parlaklığı katlamaz, alev ışımaya boğulmaz.
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.vertex_color_use_as_albedo = true
	m.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	m.disable_fog = true
	m.albedo_color = Color(parlaklik, parlaklik, parlaklik)
	a.material_override = m
	return a


## Kenarları yumuşak yuvarlak leke (duman taneleri için).
static func _yumusak_doku() -> GradientTexture2D:
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(1, 1, 1, 0))
	g.add_point(0.45, Color(1, 1, 1, 0.55))
	var d := GradientTexture2D.new()
	d.gradient = g
	d.fill = GradientTexture2D.FILL_RADIAL
	d.fill_from = Vector2(0.5, 0.5)
	d.fill_to = Vector2(1.0, 0.5)
	d.width = 64
	d.height = 64
	return d


func _ates_kur(p: Vector3, boy: float, isik: float) -> void:
	for k in 3:
		var dil := alev(boy * (1.25 - k * 0.25), 2.2, float(k) * 3.7 + p.x)
		dil.position = p + Vector3((k - 1) * boy * 0.35, 0, (k % 2) * 0.3)
		add_child(dil)
	var l := OmniLight3D.new()
	l.light_color = ATES
	l.light_energy = isik * 0.2
	l.omni_range = isik * 2.0
	l.position = p + Vector3(0, boy, 0)
	l.set_meta("taban", l.light_energy)
	add_child(l)
	_ates_isiklari.append(l)
	# Test ve tehdit sayımı için: her ateş bir "alev" sayılır.
	var iz := MeshInstance3D.new()
	iz.set_meta("olcek", 1.0)
	iz.visible = false
	add_child(iz)
	_alevler.append(iz)


func _atli_kur(mat: Material) -> Node3D:
	var n := Node3D.new()
	var at := _kutu(Vector3(0.5, 0.9, 1.8), Vector3(0, 1.1, 0), mat)
	n.add_child(at)
	var boyun := _kutu(Vector3(0.35, 0.9, 0.35), Vector3(0, 1.7, -0.9), mat)
	boyun.rotation.x = 0.5
	n.add_child(boyun)
	for z in [-0.7, 0.7]:
		for x in [-0.18, 0.18]:
			n.add_child(_kutu(Vector3(0.12, 0.8, 0.12), Vector3(x, 0.4, z), mat))
	var binici := _kutu(Vector3(0.45, 0.9, 0.35), Vector3(0, 2.0, 0.1), mat)
	n.add_child(binici)
	var mizrak := _kutu(Vector3(0.04, 2.6, 0.04), Vector3(0.3, 2.6, 0.0), mat)
	mizrak.rotation.x = 0.15
	n.add_child(mizrak)
	n.rotation.y = PI / 2.0
	return n


# ── 2. perde: Tekfur'un ordusu. Kamp ateşleri yakınlıkla çoğalır ve yaklaşır; çadırlar; en sonda asker sıraları. ──
func _tekfur_kur() -> void:
	var r := RandomNumberGenerator.new()
	r.seed = 1261
	var uzak := lerpf(125.0, 60.0, yakinlik)
	var adet := 3 + int(yakinlik * 45.0)
	var mat := _malzeme(SILUET)
	for i in adet:
		var x := r.randf_range(-35.0, 45.0)
		var z := -uzak - r.randf_range(0.0, 25.0)
		if _yola_yakinlik(x, z) > 0.5:
			x += 8.0
		var p := Vector3(x, yukseklik(x, z), z)
		_kamp_atesi_kur(p, i < 10)
		if yakinlik > 0.3 and r.randf() < 0.6:
			var c := MeshInstance3D.new()
			var k := CylinderMesh.new()
			k.top_radius = 0.0
			k.bottom_radius = 1.4
			k.height = 2.2
			k.radial_segments = 4
			c.mesh = k
			c.position = p + Vector3(r.randf_range(-3, 3), 1.1, r.randf_range(-3, -1))
			c.material_override = mat
			add_child(c)
	# Asker sıraları: son gecelerde yakın sırtta.
	if yakinlik >= 0.7:
		var z := -uzak + 12.0
		for sira in 3:
			for i in 26:
				var x := -26.0 + i * 1.6 + sira * 0.8
				var asker := _kutu(Vector3(0.45, 1.5, 0.35), Vector3(x, yukseklik(x, z - sira * 2.0) + 0.75, z - sira * 2.0), mat)
				add_child(asker)
				var bas := _kutu(Vector3(0.28, 0.3, 0.28), asker.position + Vector3(0, 0.95, 0), mat)
				add_child(bas)
				var mizrak := _kutu(Vector3(0.04, 2.4, 0.04), asker.position + Vector3(0.2, 0.9, 0), mat)
				add_child(mizrak)


func _kamp_atesi_kur(p: Vector3, isikli: bool) -> void:
	var a := MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 0.35
	k.height = 0.5
	k.radial_segments = 6
	k.rings = 3
	a.mesh = k
	a.position = p + Vector3(0, 0.25, 0)
	a.material_override = _isik_sacan(ATES, 4.0)
	a.set_meta("olcek", 1.0)
	add_child(a)
	_alevler.append(a)
	if isikli:
		var l := OmniLight3D.new()
		l.light_color = ATES
		l.light_energy = 0.8
		l.omni_range = 7.0
		l.position = p + Vector3(0, 1.0, 0)
		l.set_meta("taban", l.light_energy)
		add_child(l)
		_ates_isiklari.append(l)
