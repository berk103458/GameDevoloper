## Köy arazisi: 160×160 m, 128×128 bölünmüş düzlem; çim/toprak/çamur maske ile karışır.
## Maske köy yerleşiminden boyanır: yollar ve yapı önleri toprak, kuyu ve tarla çevresi çamur.
## Bitki örtüsü (orman halkası, çim) MultiMesh ile kurulur ve rüzgârda sallanır.
class_name Arazi
extends RefCounted

const BOY := 160.0
const BOLUM := 127
const MASKE_PX := 256
const ESYA := "res://assets/kenney/esya/"
## Orman halkası (m).
const ORMAN_IC := 35.0
const ORMAN_DIS := 75.0

static var _dokular: Dictionary = {}


## Zemini kurar ve maske görüntüsünü döner (bitki yerleşimi için).
static func zemin_kur(kok: Node3D, y: KoyYerlesimi) -> Image:
	var maske := _maske_boya(y)
	var m := MeshInstance3D.new()
	m.name = "Arazi"
	var p := PlaneMesh.new()
	p.size = Vector2(BOY, BOY)
	p.subdivide_width = BOLUM
	p.subdivide_depth = BOLUM
	m.mesh = p
	var mat := ShaderMaterial.new()
	mat.shader = load("res://src/koy/gorsel/arazi_zemini.gdshader")
	mat.set_shader_parameter("maske", ImageTexture.create_from_image(maske))
	mat.set_shader_parameter("cim_doku", _doku("cim", [Color(0.13, 0.17, 0.08), Color(0.2, 0.25, 0.11), Color(0.27, 0.29, 0.14)], 0.05))
	mat.set_shader_parameter("toprak_doku", _doku("toprak", [Color(0.19, 0.14, 0.09), Color(0.29, 0.22, 0.14), Color(0.36, 0.29, 0.2)], 0.09))
	mat.set_shader_parameter("camur_doku", _doku("camur", [Color(0.08, 0.06, 0.04), Color(0.14, 0.1, 0.07), Color(0.18, 0.14, 0.1)], 0.07))
	mat.set_shader_parameter("yukseklik", _doku("yukseklik", [Color.BLACK, Color.WHITE], 0.02))
	mat.set_shader_parameter("arazi_boyu", BOY)
	m.material_override = mat
	kok.add_child(m)
	return maske


## Orman halkası, dağınık ağaçlar, kayalar ve çim.
static func bitki_kur(kok: Node3D, maske: Image, tohum: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = tohum
	var agac_noktalari: Array[Transform3D] = []
	var uzun_noktalari: Array[Transform3D] = []
	var deneme := 0
	while agac_noktalari.size() + uzun_noktalari.size() < 240 and deneme < 2000:
		deneme += 1
		var a := rng.randf() * TAU
		var r := lerpf(ORMAN_IC, ORMAN_DIS, sqrt(rng.randf()))
		var p := Vector3(sin(a) * r, 0, cos(a) * r)
		if p.z < -18.0 and absf(p.x) < 12.0 + (-p.z - 18.0) * 0.15:
			continue  # kapıdan çıkan yol açık kalır
		var t := Transform3D(Basis(Vector3.UP, rng.randf() * TAU), p + Vector3(0, _tepe(p), 0))
		if rng.randf() < 0.45:
			uzun_noktalari.append(t)
		else:
			agac_noktalari.append(t)
	# Köyün içinde birkaç tek ağaç.
	for i in 9:
		var a := rng.randf() * TAU
		var p := Vector3(sin(a), 0, cos(a)) * rng.randf_range(22.0, 32.0)
		if _maske_degeri(maske, p).r < 0.2:
			agac_noktalari.append(Transform3D(Basis(Vector3.UP, rng.randf() * TAU), p))
	_coklu(kok, "tree", agac_noktalari, rng, 6.5, 9.5, 0.12)
	_coklu(kok, "tree-tall", uzun_noktalari, rng, 8.0, 12.0, 0.1)
	var kayalar: Array[Transform3D] = []
	for i in 26:
		var a := rng.randf() * TAU
		var p := Vector3(sin(a), 0, cos(a)) * rng.randf_range(24.0, 45.0)
		kayalar.append(Transform3D(Basis(Vector3.UP, rng.randf() * TAU), p + Vector3(0, _tepe(p), 0)))
	_coklu(kok, "rock-a", kayalar, rng, 0.6, 1.6, 0.0)
	var cimler: Array[Transform3D] = []
	deneme = 0
	while cimler.size() < 3200 and deneme < 12000:
		deneme += 1
		var a := rng.randf() * TAU
		var r := lerpf(5.0, 40.0, sqrt(rng.randf()))
		var p := Vector3(sin(a) * r, 0, cos(a) * r)
		var mv := _maske_degeri(maske, p)
		if mv.r > 0.25 or mv.g > 0.3:
			continue
		cimler.append(Transform3D(Basis(Vector3.UP, rng.randf() * TAU), p + Vector3(0, _tepe(p), 0)))
	_coklu(kok, "grass", cimler, rng, 0.18, 0.36, 0.05, false, Color(0.42, 0.5, 0.34))


## Arazi shader'ındaki yükselmenin kaba eşi (ağaçlar zeminin içine gömülmesin diye).
static func _tepe(p: Vector3) -> float:
	var r := Vector2(p.x, p.z).length()
	var t := smoothstep(30.0, 55.0, r)
	return t * t * 1.5


static func _coklu(kok: Node3D, ad: String, noktalar: Array[Transform3D], rng: RandomNumberGenerator,
		boy_min: float, boy_max: float, ruzgar: float, golge: bool = true, carpan: Color = Color(0.62, 0.7, 0.58)) -> void:
	if noktalar.is_empty():
		return
	var kaynak := _ilk_mesh(ESYA + ad + ".glb")
	if kaynak.is_empty():
		return
	var mesh: Mesh = kaynak["mesh"]
	var kutu := mesh.get_aabb()
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	mm.instance_count = noktalar.size()
	for i in noktalar.size():
		var hedef := rng.randf_range(boy_min, boy_max)
		var olcek := hedef / maxf(kutu.size.y, 0.01)
		var t := noktalar[i]
		t.basis = t.basis.scaled(Vector3.ONE * olcek)
		mm.set_instance_transform(i, t)
	var mi := MultiMeshInstance3D.new()
	mi.name = "Bitki_" + ad
	mi.multimesh = mm
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if golge else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var mat := ShaderMaterial.new()
	mat.shader = load("res://src/koy/gorsel/ruzgar.gdshader")
	mat.set_shader_parameter("albedo_doku", kaynak["doku"])
	mat.set_shader_parameter("siddet", ruzgar * kutu.size.y)
	mat.set_shader_parameter("taban", kutu.position.y + kutu.size.y * 0.25)
	mat.set_shader_parameter("boy", kutu.size.y * 0.75)
	mat.set_shader_parameter("renk_carpani", carpan)  # Kenney renkleri akşam/gece için soluklaşır
	mi.material_override = mat
	kok.add_child(mi)


## GLB'deki ilk mesh ve albedo dokusu (MultiMesh için).
static func _ilk_mesh(yol: String) -> Dictionary:
	if _dokular.has(yol):
		return _dokular[yol]
	var sonuc := {}
	if ResourceLoader.exists(yol):
		var n: Node = (load(yol) as PackedScene).instantiate()
		var ml := n.find_children("*", "MeshInstance3D", true, false)
		if not ml.is_empty():
			var m := (ml[0] as MeshInstance3D).mesh
			var doku: Texture2D = null
			var mat := m.surface_get_material(0)
			if mat is BaseMaterial3D:
				doku = (mat as BaseMaterial3D).albedo_texture
			sonuc = {"mesh": m, "doku": doku}
		n.free()
	_dokular[yol] = sonuc
	return sonuc


static func _maske_degeri(maske: Image, p: Vector3) -> Color:
	var x := clampi(int((p.x / BOY + 0.5) * MASKE_PX), 0, MASKE_PX - 1)
	var z := clampi(int((p.z / BOY + 0.5) * MASKE_PX), 0, MASKE_PX - 1)
	return maske.get_pixel(x, z)


## Maske: R = toprak (yol, meydan, yapı önü, tarla), G = çamur (kuyu, tarla sıraları, hayvan yeri).
static func _maske_boya(y: KoyYerlesimi) -> Image:
	var img := Image.create(MASKE_PX, MASKE_PX, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 1))
	for yol in y.yollar:
		_cizgi(img, yol[0], yol[1], yol[2] * 0.5, 0)
	_daire(img, KoyYerlesimi.MEYDAN, 6.5, 0)
	_daire(img, KoyYerlesimi.KAPI + Vector3(0, 0, 1), 3.5, 0)
	for e in y.evler:
		_daire(img, e["konum"], 2.8, 0)
	for t in y.tezgahlar:
		_daire(img, t["konum"], 2.4, 0)
	if y.kervansaray_seviye > 0:
		_daire(img, KoyYerlesimi.KERVANSARAY, 4.5 + y.kervansaray_seviye * 0.5, 0)
	_daire(img, KoyYerlesimi.KUYU, 2.2, 1)
	_daire(img, KoyYerlesimi.AMBAR, 2.6, 0)
	_daire(img, KoyYerlesimi.ODUNLUK, 4.0, 0)
	_daire(img, KoyYerlesimi.TAS_OCAGI, 4.5, 0)
	_daire(img, KoyYerlesimi.ATOLYE, 2.4, 0)
	# Tarla: sürülmüş sıralar (toprak), arada ıslak oluklar (çamur).
	for s in 7:
		var z := KoyYerlesimi.TARLA.z - 4.5 + s * 1.5
		var a := Vector3(KoyYerlesimi.TARLA.x - 6.0, 0, z)
		var b := Vector3(KoyYerlesimi.TARLA.x + 6.0, 0, z)
		_cizgi(img, a, b, 0.55, 0)
		if s % 2 == 1:
			_cizgi(img, a, b, 0.25, 1)
	return img


static func _px(p: Vector3) -> Vector2:
	return Vector2((p.x / BOY + 0.5) * MASKE_PX, (p.z / BOY + 0.5) * MASKE_PX)


static func _boya(img: Image, x: int, z: int, kanal: int, deger: float) -> void:
	if x < 0 or z < 0 or x >= MASKE_PX or z >= MASKE_PX:
		return
	var c := img.get_pixel(x, z)
	if kanal == 0:
		c.r = maxf(c.r, deger)
	else:
		c.g = maxf(c.g, deger)
	img.set_pixel(x, z, c)


static func _daire(img: Image, merkez: Vector3, yaricap: float, kanal: int) -> void:
	var m := _px(merkez)
	var r := yaricap / BOY * MASKE_PX
	for z in range(int(m.y - r - 2), int(m.y + r + 3)):
		for x in range(int(m.x - r - 2), int(m.x + r + 3)):
			var d := Vector2(x + 0.5, z + 0.5).distance_to(m)
			_boya(img, x, z, kanal, clampf((r + 1.0 - d) / 2.0, 0.0, 1.0))


static func _cizgi(img: Image, a3: Vector3, b3: Vector3, yari_genislik: float, kanal: int) -> void:
	var a := _px(a3)
	var b := _px(b3)
	var r := yari_genislik / BOY * MASKE_PX
	var lo := Vector2(minf(a.x, b.x), minf(a.y, b.y)) - Vector2(r + 2, r + 2)
	var hi := Vector2(maxf(a.x, b.x), maxf(a.y, b.y)) + Vector2(r + 2, r + 2)
	for z in range(int(lo.y), int(hi.y) + 1):
		for x in range(int(lo.x), int(hi.x) + 1):
			var p := Vector2(x + 0.5, z + 0.5)
			var d := p.distance_to(Geometry2D.get_closest_point_to_segment(p, a, b))
			_boya(img, x, z, kanal, clampf((r + 1.0 - d) / 1.5, 0.0, 1.0))


## Dikişsiz gürültü dokusu, renk rampasıyla.
static func _doku(ad: String, renkler: Array, siklik: float) -> Texture2D:
	if _dokular.has(ad):
		return _dokular[ad]
	var g := FastNoiseLite.new()
	g.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	g.frequency = siklik
	g.fractal_octaves = 4
	g.seed = ad.hash()
	var n := NoiseTexture2D.new()
	n.width = 512
	n.height = 512
	n.seamless = true
	n.noise = g
	n.generate_mipmaps = true
	var r := Gradient.new()
	var ofs := PackedFloat32Array()
	var cs := PackedColorArray()
	for i in renkler.size():
		ofs.append(float(i) / maxf(renkler.size() - 1, 1))
		cs.append(renkler[i])
	r.offsets = ofs
	r.colors = cs
	n.color_ramp = r
	_dokular[ad] = n
	return n
