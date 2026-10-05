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
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var n := 110
	var x0 := -90.0
	var z0 := 4.0
	var adim_x := 180.0 / n
	var adim_z := 180.0 / n
	var gurultu := FastNoiseLite.new()
	gurultu.seed = 7
	gurultu.frequency = 0.08
	for j in n:
		for i in n:
			var kose := []
			for d in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 0), Vector2i(1, 1), Vector2i(0, 1)]:
				var x: float = x0 + (i + d.x) * adim_x
				var z: float = z0 - (j + d.y) * adim_z
				kose.append(Vector3(x, yukseklik(x, z), z))
			for k in 6:
				var v: Vector3 = kose[k]
				var kiragi := clampf(gurultu.get_noise_2d(v.x, v.z) * 1.4 + 0.2, 0.0, 1.0)
				st.set_color(TOPRAK.lerp(KIRAGI, kiragi * 0.55))
				st.add_vertex(v)
	st.generate_normals()
	var m := MeshInstance3D.new()
	m.mesh = st.commit()
	m.material_override = _malzeme(Color.WHITE, true)
	add_child(m)


# ── Yol: kapıda geniş (sorgu alanı), ufka doğru daralan kıvrık şerit; kenarlarda tekerlek izi. ──
func _yol_kur() -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var parca := 160
	var onceki_sol := Vector3.ZERO
	var onceki_sag := Vector3.ZERO
	for s in parca + 1:
		var t := float(s) / parca
		var p := yol_noktasi(t)
		var ileri := yol_noktasi(minf(t + 0.004, 1.0)) - yol_noktasi(maxf(t - 0.004, 0.0))
		ileri.y = 0.0
		var yan := Vector3(-ileri.z, 0, ileri.x).normalized()
		var en := lerpf(4.6, 1.2, pow(t, 0.55))
		var sol := p + yan * en * 0.5
		var sag := p - yan * en * 0.5
		sol.y = yukseklik(sol.x, sol.z) + 0.03 + t * 0.05
		sag.y = yukseklik(sag.x, sag.z) + 0.03 + t * 0.05
		if s > 0:
			var r := YOL.darkened(0.15 * (s % 3) / 2.0)
			for v in [onceki_sol, onceki_sag, sag, onceki_sol, sag, sol]:
				st.set_color(r)
				st.add_vertex(v)
		onceki_sol = sol
		onceki_sag = sag
	st.generate_normals()
	var m := MeshInstance3D.new()
	m.mesh = st.commit()
	m.material_override = _malzeme(Color.WHITE, true)
	add_child(m)


# ── Uzak dağlar: üç kat silüet sırtı, uzaklaştıkça sise karışır. ──
func _daglar_kur() -> void:
	var katlar := [[-170.0, 22.0, Color("#141c30")], [-230.0, 38.0, Color("#10172a")], [-300.0, 60.0, Color("#0d1324")]]
	for k in katlar:
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		var z: float = k[0]
		var boy: float = k[1]
		var onceki := Vector3.ZERO
		for i in 61:
			var x := -260.0 + i * 520.0 / 60.0
			var y := boy * (0.45 + 0.3 * sin(x * 0.02 + z) + 0.25 * sin(x * 0.057 - z * 0.3))
			var p := Vector3(x, y, z + sin(x * 0.03) * 10.0)
			if i > 0:
				for v in [Vector3(onceki.x, -5, onceki.z), onceki, p, Vector3(onceki.x, -5, onceki.z), p, Vector3(p.x, -5, p.z)]:
					st.add_vertex(v)
			onceki = p
		var m := MeshInstance3D.new()
		m.mesh = st.commit()
		var mat := _malzeme(k[2])
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		m.material_override = mat
		add_child(m)


# ── Serviler ve kuru ağaçlar: tepelerde koyu silüetler (yol kenarında seyrek). ──
func _serviler_kur() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var koni := CylinderMesh.new()
	koni.top_radius = 0.05
	koni.bottom_radius = 0.6
	koni.height = 4.5
	koni.radial_segments = 6
	mm.mesh = koni
	var yerler: Array[Vector3] = []
	var r := RandomNumberGenerator.new()
	r.seed = 3
	while yerler.size() < 70:
		var x := r.randf_range(-70.0, 70.0)
		var z := r.randf_range(-140.0, -22.0)
		if _yola_yakinlik(x, z) > 0.4 or (absf(x) < 9.0 and z > -30.0):
			continue
		yerler.append(Vector3(x, yukseklik(x, z), z))
	mm.instance_count = yerler.size()
	for i in yerler.size():
		var o := r.randf_range(0.7, 1.5)
		mm.set_instance_transform(i, Transform3D(Basis.IDENTITY.scaled(Vector3(o, o * r.randf_range(0.9, 1.4), o)), yerler[i] + Vector3(0, 2.2 * o, 0)))
	var s := MultiMeshInstance3D.new()
	s.multimesh = mm
	s.material_override = _malzeme(SERVI)
	add_child(s)


# ── Yol kenarı: kırık çitler, taş yığınları, yıkık taş direk, terk edilmiş eşya. Sorgu alanı (x −2..2, z −1..−6) boş. ──
func _yol_kenari_kur() -> void:
	var ahsap := _malzeme(Color("#3b2e26"))
	var tas := _malzeme(Color("#4f5566"))
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
	for y in [[Vector3(-4.6, 0, -6.0), 0.9], [Vector3(-5.5, 0, -12.5), 1.2], [Vector3(4.6, 0, -18.0), 1.0], [Vector3(-7.0, 0, -24.0), 1.4]]:
		var k := Dunya3B.nesne("kaya", y[1])
		k.position = y[0] + Vector3(0, yukseklik(y[0].x, y[0].z), 0)
		k.rotation.y = y[0].x
		add_child(k)
	var direk := _kutu(Vector3(1.0, 2.4, 1.0), Vector3(3.0, 1.2, -15.0), tas)
	add_child(direk)
	var direk_ust := _kutu(Vector3(0.8, 0.55, 0.8), Vector3(2.9, 2.65, -15.1), tas)
	direk_ust.rotation.z = 0.25
	add_child(direk_ust)
	# Kuru ceviz: sağ arkada, güçlü silüet; dalları rüzgârda çok hafif oynar.
	var agac := Dunya3B.nesne("agac", 8.5)
	agac.position = Vector3(3.6, yukseklik(3.6, -25.0), -25.0)
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


# ── Yolda kapıya yürüyen insanlar (silüet): kuyruğun arkasında, uzaklaştıkça küçük; bazılarının elinde fener. ──
func _multeciler_kur() -> void:
	var r := RandomNumberGenerator.new()
	r.seed = 21 + gece
	var adet := 10 + mini(gece, 8) * 2 if perde == 1 else 6
	var govde := CapsuleMesh.new()
	govde.radius = 0.22
	govde.height = 1.4
	var bas := SphereMesh.new()
	bas.radius = 0.13
	bas.height = 0.26
	var mat := _malzeme(SILUET)
	for i in adet:
		var t := 0.24 + float(i) / adet * 0.62 + r.randf() * 0.02
		var p := yol_noktasi(t)
		var kisi := Node3D.new()
		kisi.position = p + Vector3(r.randf_range(-0.4, 0.4), 0, 0)
		var g := MeshInstance3D.new()
		g.mesh = govde
		g.position.y = 0.72
		g.material_override = mat
		kisi.add_child(g)
		var b := MeshInstance3D.new()
		b.mesh = bas
		b.position.y = 1.52
		b.material_override = mat
		kisi.add_child(b)
		# Yük: sırtta bohça ya da yanında hayvan.
		if r.randf() < 0.4:
			var y := MeshInstance3D.new()
			var yk := SphereMesh.new()
			yk.radius = 0.25
			yk.height = 0.4
			y.mesh = yk
			y.position = Vector3(0, 1.05, 0.22)
			y.material_override = mat
			kisi.add_child(y)
		if r.randf() < 0.25:
			var fener := MeshInstance3D.new()
			var f := SphereMesh.new()
			f.radius = 0.07
			f.height = 0.14
			fener.mesh = f
			fener.position = Vector3(0.3, 0.9, 0)
			fener.material_override = _isik_sacan(ATES_IC, 3.0)
			kisi.add_child(fener)
		kisi.scale = Vector3.ONE * r.randf_range(0.85, 1.05)
		add_child(kisi)


# ── 1. perde: tepenin ardında yanan köy. Gece 0: yalnız ince duman; sonra ateş büyür; 5. geceden sonra sırtta atlılar. ──
func _yanan_koy_kur(soner := false) -> void:
	var taban := KOY_YERI + Vector3(0, yukseklik(KOY_YERI.x, KOY_YERI.z), 0)
	var siddet := clampf(gece / 6.0, 0.0, 1.0) if not soner else 0.25
	# Ev silüetleri.
	var mat := _malzeme(SILUET)
	for i in 7:
		var ev := _kutu(Vector3(3.0, 2.2 + (i % 3) * 0.6, 3.0), taban + Vector3(-12.0 + i * 4.0, 1.0, (i % 2) * 3.0), mat)
		add_child(ev)
	# Ateşler: gece arttıkça çoğalır ve büyür.
	var ates_sayisi := 0 if gece == 0 and not soner else 1 + int(siddet * 6.0)
	var r := RandomNumberGenerator.new()
	r.seed = 1243
	for i in ates_sayisi:
		var p := taban + Vector3(r.randf_range(-12.0, 12.0), 1.4 + r.randf() * 1.2, r.randf_range(-2.0, 3.0))
		_ates_kur(p, r.randf_range(1.0, 2.0) * (0.8 + siddet), 6.0 + siddet * 10.0)
	# Ufukta yangının parıltısı: tepenin üstünde geniş, yumuşak turuncu hale.
	if ates_sayisi > 0:
		var hale := MeshInstance3D.new()
		var q := QuadMesh.new()
		q.size = Vector2(40.0 + siddet * 30.0, 14.0 + siddet * 10.0)
		hale.mesh = q
		hale.position = taban + Vector3(0, 5.0, -2.0)
		var hm := StandardMaterial3D.new()
		hm.albedo_texture = _yumusak_doku()
		hm.albedo_color = Color(ATES, 0.25 + siddet * 0.35)
		hm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		hm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		hm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		hm.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
		hm.disable_fog = true
		hale.material_override = hm
		add_child(hale)
	# Duman: hep var; gece arttıkça kalınlaşır. Rüzgârla sağa yatar.
	var duman := CPUParticles3D.new()
	duman.position = taban + Vector3(-2.0, 4.0, 0)
	duman.amount = 40 + int(siddet * 60.0)
	duman.lifetime = 14.0
	duman.preprocess = 14.0
	duman.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	duman.emission_box_extents = Vector3(8.0 * (0.3 + siddet), 1.0, 2.0)
	duman.direction = Vector3(0.35, 1.0, 0)
	duman.spread = 12.0
	duman.gravity = Vector3(0.6, 0.4, 0)
	duman.initial_velocity_min = 1.5
	duman.initial_velocity_max = 2.5
	duman.scale_amount_min = 3.0
	duman.scale_amount_max = 6.0 + siddet * 6.0
	var buyume := Curve.new()
	buyume.add_point(Vector2(0, 0.4))
	buyume.add_point(Vector2(1, 1.8))
	duman.scale_amount_curve = buyume
	var solma := Gradient.new()
	solma.set_color(0, Color(DUMAN, 0.0))
	solma.add_point(0.15, Color(DUMAN.lightened(0.15), 0.55))
	solma.set_color(solma.get_point_count() - 1, Color(DUMAN, 0.0))
	duman.color_ramp = solma
	var q := QuadMesh.new()
	q.size = Vector2(3, 3)
	duman.mesh = q
	var dm := StandardMaterial3D.new()
	dm.albedo_texture = _yumusak_doku()
	dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dm.vertex_color_use_as_albedo = true
	dm.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	dm.disable_fog = true
	duman.material_override = dm
	add_child(duman)
	# Sırtta atlı silüetleri (5. geceden sonra).
	if not soner and gece >= 5:
		for i in mini(gece - 3, 8):
			var a := _atli_kur(mat)
			var x := -22.0 + i * 3.2
			a.position = Vector3(KOY_YERI.x + x, yukseklik(KOY_YERI.x + x, KOY_YERI.z + 14.0) + 0.1, KOY_YERI.z + 14.0)
			add_child(a)


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
	# Birkaç dil: farklı boy ve eğimde koniler, içte sarı çekirdek.
	for d in 3:
		for katman in [[ATES, 1.0, 3.0], [ATES_IC, 0.5, 4.5]]:
			var a := MeshInstance3D.new()
			var k := CylinderMesh.new()
			k.top_radius = 0.0
			var b: float = boy * (1.0 - d * 0.25) * katman[1]
			k.bottom_radius = b * 0.4
			k.height = b * 1.7
			k.radial_segments = 5
			a.mesh = k
			a.position = p + Vector3((d - 1) * boy * 0.35, k.height * 0.5, (d % 2) * 0.3)
			a.rotation.z = (d - 1) * 0.18
			a.material_override = _isik_sacan(katman[0], katman[2])
			a.set_meta("olcek", 1.0)
			add_child(a)
			_alevler.append(a)
	var l := OmniLight3D.new()
	l.light_color = ATES
	l.light_energy = isik * 0.2
	l.omni_range = isik * 2.0
	l.position = p + Vector3(0, boy, 0)
	l.set_meta("taban", l.light_energy)
	add_child(l)
	_ates_isiklari.append(l)


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
