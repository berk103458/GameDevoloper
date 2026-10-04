## Menü sahnesi (3D; referans: design/art/referans/menu_referans.webp). Ay ışıklı gece: yıldızlı gök,
## uzak dağlar ve tepede Tekfur'un kalesi; yoldan kapıya bakılır. Sağ kulenin önünde tek meşale, geçitten
## köyün ışığı sızar; kameranın arkasından çıkan bir yolcu kapıya yürür. Kapı kadrajın sağ yarısında,
## sol yarı menü listesine kalır.
class_name MenuSahnesi
extends Node3D

const KAPI := Vector3(3.0, 0.0, -7.0)
const KAPI_BOY := 5.2
const CIT_BOY := 3.3
const GOKYUZU := "res://src/dunya/gece_gokyuzu.gdshader"
## Aya doğru yön: kadrajın sol üstü.
const AY_YONU := Vector3(-0.36, 0.33, -0.87)
const YOLCU_HIZ := 0.75

var kamera: Camera3D
var _isiklar: Array[OmniLight3D] = []
var _zaman := 0.0
var _kamera_taban := Vector3(-1.6, 1.6, 8.5)
var _bakis := Vector3(-1.6, 2.5, -7.0)
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	_rng.seed = 1243
	_ortam_kur()
	_zemin_kur()
	var gecit := _kapi_kur()
	_yol_kur(gecit)
	_isiklar.append(Dunya3B.mesale_kur(self, gecit + Vector3(3.4, 0, 1.4), 3.4, 11.0))
	_ic_isik_kur(gecit)
	_uzak_kur()
	_cevre_kur()
	_otlar_kur()
	kamera = Camera3D.new()
	kamera.fov = 48.0
	add_child(kamera)
	_kamera_yerlestir()
	_yolcu_dongusu(gecit)


func _process(delta: float) -> void:
	_zaman += delta
	for i in _isiklar.size():
		var l := _isiklar[i]
		var t := 0.86 + 0.14 * sin(_zaman * 8.5 + i * 2.3) * sin(_zaman * 3.1 + i)
		l.light_energy = float(l.get_meta("taban")) * t
		if l.has_meta("alev"):
			var a: Node3D = l.get_meta("alev")
			a.scale = Vector3(1.0, 0.85 + 0.3 * t, 1.0)
	_kamera_yerlestir()


## Çok yavaş nefes: kamera neredeyse durağan.
func _kamera_yerlestir() -> void:
	if kamera == null:
		return
	kamera.position = _kamera_taban + Vector3(sin(_zaman * 0.11) * 0.2, sin(_zaman * 0.17) * 0.04, 0)
	kamera.look_at(_bakis)


## Gök (shader), ay ışığı, sis ve ışıma.
func _ortam_kur() -> void:
	var dunya := WorldEnvironment.new()
	var env := Environment.new()
	var gok := Sky.new()
	var mat := ShaderMaterial.new()
	mat.shader = load(GOKYUZU)
	mat.set_shader_parameter("ay_yonu", AY_YONU)
	mat.set_shader_parameter("ay_boyut", 0.028)
	gok.sky_material = mat
	# Ay diski keskin kalsın: gök küp haritası yüksek çözünürlükte.
	gok.radiance_size = Sky.RADIANCE_SIZE_2048
	gok.process_mode = Sky.PROCESS_MODE_QUALITY
	env.background_mode = Environment.BG_SKY
	env.sky = gok
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#3a5272")
	env.ambient_light_energy = 0.42
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.fog_enabled = true
	env.fog_light_color = Color("#141c2c")
	env.fog_light_energy = 0.8
	env.fog_density = 0.012
	env.fog_sky_affect = 0.0
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.glow_enabled = true
	env.glow_intensity = 0.9
	env.glow_strength = 1.0
	env.glow_bloom = 0.04
	env.glow_hdr_threshold = 0.95
	dunya.environment = env
	add_child(dunya)
	var ay := DirectionalLight3D.new()
	ay.light_color = Color("#9fb4d6")
	ay.light_energy = 0.55
	ay.shadow_enabled = true
	add_child(ay)
	ay.look_at_from_position(Vector3.ZERO, -AY_YONU, Vector3.UP)


## Kırağılı toprak: koyu lacivert üstünde açık, buz tutmuş lekeler.
func _zemin_kur() -> void:
	var m := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(400, 400)
	m.mesh = p
	var gurultu := FastNoiseLite.new()
	gurultu.frequency = 0.02
	gurultu.fractal_octaves = 4
	var renk := Gradient.new()
	renk.set_color(0, Color("#141b28"))
	renk.set_color(1, Color("#56647a"))
	renk.add_point(0.6, Color("#222c3e"))
	var doku := NoiseTexture2D.new()
	doku.noise = gurultu
	doku.color_ramp = renk
	doku.seamless = true
	doku.width = 512
	doku.height = 512
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = doku
	mat.uv1_scale = Vector3(40, 40, 1)
	mat.roughness = 0.8
	m.material_override = mat
	add_child(m)


## Kapı ve iki yanındaki kazık çit. Geçidin (kapı boşluğunun) dünya konumunu döner.
func _kapi_kur() -> Vector3:
	var kapi := Dunya3B.nesne("kapi", KAPI_BOY, "yapi")
	kapi.position = KAPI
	add_child(kapi)
	var genislik := Dunya3B.boyut(kapi).x
	var ornek := Dunya3B.nesne("kazik_cit", CIT_BOY)
	var w := Dunya3B.boyut(ornek).x
	ornek.free()
	for i in 6:
		var c := Dunya3B.nesne("kazik_cit", CIT_BOY)
		c.position = Vector3(KAPI.x - genislik / 2.0 - w * (i + 0.5) * 0.96, 0, KAPI.z + i * 0.9)
		c.rotation_degrees.y = -6.0 * (i + 1)
		add_child(c)
	for i in 3:
		var c := Dunya3B.nesne("kazik_cit", CIT_BOY)
		c.position = Vector3(KAPI.x + genislik / 2.0 + w * (i + 0.5) * 0.96, 0, KAPI.z)
		add_child(c)
	if Dunya3B.model_var_mi("gozetleme_kulesi", "yapi"):
		var k := Dunya3B.nesne("gozetleme_kulesi", 7.5, "yapi")
		k.position = Vector3(KAPI.x + genislik / 2.0 + 1.8, 0, KAPI.z + 1.5)
		k.rotation_degrees.y = -15
		add_child(k)
	# Kapı modeli simetrik: geçit ortada.
	return KAPI


func _yol_kur(gecit: Vector3) -> void:
	var bas := Vector3(_kamera_taban.x, 0, _kamera_taban.z + 6.0)
	var fark := bas - gecit
	var m := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(3.6, fark.length() + 2.0)
	m.mesh = p
	m.position = (bas + gecit) / 2.0 + Vector3(0, 0.01, 0)
	m.rotation.y = atan2(fark.x, fark.z)
	var mat := Dunya3B.duz_malzeme(Color("#3a4152"))
	mat.roughness = 0.6
	m.material_override = mat
	add_child(m)


## Kapının ardındaki köy: duvarın arkasında kalır, yalnız geçitten görünür ve ışığı sızar.
func _ic_isik_kur(gecit: Vector3) -> void:
	var l := OmniLight3D.new()
	l.light_color = Renkler.MESALE
	l.light_energy = 2.2
	l.omni_range = 8.0
	l.position = gecit + Vector3(0.4, 2.0, -4.0)
	l.set_meta("taban", 2.2)
	add_child(l)
	_isiklar.append(l)
	var yerler := [Vector3(-1.0, 0, -7.0), Vector3(2.0, 0, -10.0), Vector3(-2.5, 0, -12.5)]
	for i in yerler.size():
		var ev := Dunya3B.nesne("cadir" if i == 1 else "ev", 2.6, "yapi")
		ev.position = gecit + yerler[i]
		ev.rotation_degrees.y = 160 + i * 25
		add_child(ev)


## Kameranın arkasından çıkıp kapıya yürüyen yolcu; geçitten girince yeniden başlar.
func _yolcu_dongusu(gecit: Vector3) -> void:
	var ilk := true
	while is_inside_tree():
		var y := Dunya3B.karakter("ciftci_kadin")
		var bas := Vector3(_kamera_taban.x + 2.2, 0, _kamera_taban.z + 1.0)
		y.position = bas.lerp(gecit, 0.5) if ilk else bas
		ilk = false
		add_child(y)
		await y.yuru(gecit + Vector3(0.3, 0, 1.0), YOLCU_HIZ)
		if not is_instance_valid(y):
			return
		await y.yuru(gecit + Vector3(0.3, 0, -3.0), YOLCU_HIZ)
		if is_instance_valid(y):
			y.queue_free()
		await get_tree().create_timer(2.5).timeout


## Uzak dağ sıraları ve tepede Tekfur'un kalesi (pencerelerinde ışık).
func _uzak_kur() -> void:
	var koyu := Dunya3B.duz_malzeme(Color("#0e1422"))
	var acik := Dunya3B.duz_malzeme(Color("#18223a"))
	for sira in 2:
		for i in 14:
			var m := MeshInstance3D.new()
			var k := CylinderMesh.new()
			k.top_radius = 0.0
			var boy := _rng.randf_range(18.0, 42.0) + sira * 14.0
			k.bottom_radius = boy * _rng.randf_range(1.3, 1.9)
			k.height = boy
			k.radial_segments = 5
			m.mesh = k
			m.position = Vector3(-190 + i * 30 + _rng.randf_range(-8, 8), boy / 2.0 - 2.0, -110 - sira * 70 - _rng.randf_range(0, 20))
			m.rotation.y = _rng.randf_range(0, TAU)
			m.material_override = koyu if sira == 0 else acik
			add_child(m)
	# Kalenin tepesi.
	var tepe := MeshInstance3D.new()
	var tk := CylinderMesh.new()
	tk.top_radius = 9.0
	tk.bottom_radius = 46.0
	tk.height = 26.0
	tk.radial_segments = 7
	tepe.mesh = tk
	tepe.position = Vector3(-58, 11, -100)
	tepe.material_override = koyu
	add_child(tepe)
	var kale := Node3D.new()
	kale.position = Vector3(-58, 23, -100)
	kale.scale = Vector3.ONE * 0.6
	add_child(kale)
	var tas := Dunya3B.duz_malzeme(Color("#0b101b"))
	_kutu(kale, Vector3(10, 7, 8), Vector3(0, 3.5, 0), tas)
	_kutu(kale, Vector3(3.5, 13, 3.5), Vector3(-2, 6.5, -1), tas)
	for x in [-6.5, 6.5]:
		_kutu(kale, Vector3(3, 9, 3), Vector3(x, 4.5, 1), tas)
	_kutu(kale, Vector3(18, 3.5, 1.5), Vector3(0, 1.75, 5), tas)
	var pencere := StandardMaterial3D.new()
	pencere.albedo_color = Color.BLACK
	pencere.emission_enabled = true
	pencere.emission = Renkler.MESALE
	pencere.emission_energy_multiplier = 6.0
	for p in [Vector3(-2, 10, 0.8), Vector3(2, 4.5, 4.1), Vector3(-6.5, 6.5, 2.6), Vector3(6.5, 5.5, 2.6), Vector3(-4, 1.5, 5.8)]:
		_kutu(kale, Vector3(0.5, 0.8, 0.3), p, pencere)


func _kutu(kok: Node3D, boyut: Vector3, konum: Vector3, mat: Material) -> void:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.position = konum
	m.material_override = mat
	kok.add_child(m)


func _cevre_kur() -> void:
	# Sol üst köşeye dalları uzanan ön plan ağacı; sağda çıplak ağaç; dağınık kayalar.
	var yerler := [["agac", Vector3(-9.0, 0, 4.0), 12.0, 40.0], ["agac", Vector3(12.5, 0, -12.0), 7.0, 0.0],
		["kaya", Vector3(-6.0, 0, 3.0), 0.9, 0.0], ["kaya", Vector3(7.0, 0, -3.0), 0.8, 70.0],
		["kaya", Vector3(9.5, 0, -6.5), 0.6, 20.0], ["kaya", Vector3(1.8, 0, 2.5), 0.35, 10.0],
		["araba", Vector3(-6.5, 0, -4.0), 1.6, 30.0]]
	for y in yerler:
		var n := Dunya3B.nesne(y[0], y[2])
		n.position = y[1]
		n.rotation_degrees.y = y[3]
		if y[0] == "kaya":
			var gri := Dunya3B.duz_malzeme(Color("#3a404c"))
			for mi in n.find_children("*", "MeshInstance3D", true, false):
				(mi as MeshInstance3D).material_override = gri
		add_child(n)


## Kuru ot tutamları (yol dışında).
func _otlar_kur() -> void:
	var ot := PrismMesh.new()
	ot.size = Vector3(0.035, 0.2, 0.035)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("#566052")
	mat.roughness = 1.0
	ot.material = mat
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = ot
	var konumlar: Array[Vector3] = []
	for i in 700:
		var merkez := Vector3(_rng.randf_range(-3, 16), 0, _rng.randf_range(-6, 1.5))
		for j in 5:
			konumlar.append(merkez + Vector3(_rng.randf_range(-0.15, 0.15), 0, _rng.randf_range(-0.15, 0.15)))
	var yol_disi: Array[Vector3] = []
	for p in konumlar:
		if absf(p.x - lerpf(KAPI.x, _kamera_taban.x, (p.z - KAPI.z) / (_kamera_taban.z + 6.0 - KAPI.z))) < 2.6:
			continue
		yol_disi.append(p)
	konumlar = yol_disi
	mm.instance_count = konumlar.size()
	for i in konumlar.size():
		var b := Basis(Vector3.UP, _rng.randf_range(0, TAU)).rotated(Vector3.RIGHT, _rng.randf_range(-0.35, 0.35))
		b = b.scaled(Vector3.ONE * _rng.randf_range(0.6, 1.4))
		mm.set_instance_transform(i, Transform3D(b, konumlar[i] + Vector3(0, 0.08, 0)))
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	add_child(mi)
