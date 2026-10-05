## Kapı sahnesi (3D): muhafızın gözünden açık kapı, meşale, yol ve kuyruk. Gelen kişi yoldan yürür,
## kapının önünde durur; kabul edilen içeri (kameranın yanından), reddedilen yola geri döner.
class_name KapiSahnesi
extends Node3D

const DURMA := Vector3(0.0, 0.0, -2.5)
## Kameranın görüş açısı (dikey, derece).
const GORUS := 46.0
const BASLANGIC := Vector3(0.5, 0.0, -9.0)
## Kapıya yürüyüş hızı (m/s): yürüyüş ~2 saniye.
const YAKLASMA_HIZI := 2.4
const ICERI := Vector3(1.9, 0.0, 2.5)
const DONUS := Vector3(-0.8, 0.0, -22.0)

## Kapıyı ve manzarayı belirleyen durum (KapiEkrani sahneyi eklemeden önce oturumdan doldurur).
var gece := 0
var perde := 1
var sur := 0
## 2. perde: Tekfur'un yakınlığı 0..1.
var yakinlik := 0.0

var kamera: Camera3D
var manzara: KapiManzarasi
var cerceve: KapiCercevesi
var _okuz: Node3D
var _gelen: KarakterModel
## Gelenin ayağının dibine konan heybe (arama sırasında).
var _heybe: Node3D
var _isiklar: Array[OmniLight3D] = []
## Kuyrukta bekleyen figürler ve yerleri (sıra olayları bunları canlandırır).
var _kuyruktakiler: Array[KarakterModel] = []
var _kuyruk_yerleri: Array[Vector3] = []
var _zaman := 0.0


func _ready() -> void:
	Dunya3B.ortam_kur(self, 0.012)
	manzara = KapiManzarasi.new()
	manzara.gece = gece
	manzara.perde = perde
	manzara.yakinlik = yakinlik
	add_child(manzara)
	cerceve = KapiCercevesi.new()
	cerceve.seviye = sur
	add_child(cerceve)
	_isiklar.append_array(cerceve.isiklar)
	_kuyruk_kur()
	_kagni_kur()
	kamera = Camera3D.new()
	# Bekçinin yeri: kapının biraz gerisinde; iki direk ve meşaleler kadrajın kenarlarında (arayüzün solunda) kalır.
	kamera.position = Vector3(0.0, 1.62, 3.0)
	kamera.fov = GORUS
	add_child(kamera)
	kamera.look_at(Vector3(0.0, 1.35, -6.0))
	_ortam_ayarla()


func _process(delta: float) -> void:
	_zaman += delta
	# Öküz: arada başını sallar gibi hafifçe öne eğilip kalkar.
	if _okuz != null:
		_okuz.rotation.x = 0.03 * maxf(0.0, sin(_zaman * 0.7)) * sin(_zaman * 3.1)
	for i in _isiklar.size():
		var l := _isiklar[i]
		var taban: float = l.get_meta("taban")
		# Meşale titremesi: sert adımlar, yumuşak değil (ışık alanı canlı kalır).
		l.light_energy = taban * (0.88 + 0.12 * sin(_zaman * 9.0 + i * 2.1) * sin(_zaman * 3.3 + i))


## Gelen kişiyi yoldan kapıya yürütür.
func gelen_yaklas(model_adi: String) -> void:
	if _gelen != null:
		_gelen.queue_free()
	_gelen = Dunya3B.karakter(model_adi)
	_gelen.position = BASLANGIC
	add_child(_gelen)
	await _gelen.yuru(DURMA, YAKLASMA_HIZI)
	_gelen.bak(kamera.position)


## Gelen konuşuyor (cevap verirken): Meshy konuşma klibi varsa `sure` saniye oynar.
func gelen_konus(sure: float) -> void:
	if _gelen != null:
		_gelen.konus(sure)


## Gelenin bu Meshy hareketi var mı.
func gelen_hareket_var(ad: String) -> bool:
	return _gelen != null and _gelen.hareket_var(ad)


## Sorgu sıkıştı: gelen gerginleşir (klip varsa).
func gelen_gergin() -> void:
	if _gelen != null:
		_gelen.gergin()


## Karar sonrası: kaldıysa içeri, gittiyse yola. `tehlikeli`: retde öfke, değilse yıkılma.
func gelen_git(kaldi: bool, tehlikeli: bool = true) -> void:
	if is_instance_valid(_heybe):
		_heybe.queue_free()
	_heybe = null
	if _gelen == null:
		return
	var g := _gelen
	_gelen = null
	# Giden kişi yürümeye devam eder; sahne onu beklemez, kısa bir süre sonra sıradaki gelir.
	_ayril(g, kaldi, tehlikeli)
	await get_tree().create_timer(2.6).timeout


func _ayril(g: KarakterModel, kaldi: bool, tehlikeli: bool = true) -> void:
	# Önce tepki: kabulde şükran; retde kötü niyetli öfkelenir, masum diz çöker. Sonra yürür.
	await g.duygu(&"sevinc" if kaldi else (&"ofke" if tehlikeli else &"panik"))
	if not is_instance_valid(g):
		return
	if kaldi:
		await g.yuru(Vector3(1.6, 0, -0.5))
		if is_instance_valid(g):
			await g.yuru(ICERI)
	else:
		await g.yuru(DONUS)
	if is_instance_valid(g):
		g.queue_free()


## Kameranın bakış noktası ve görüş açısı (sıra olayında kuyruğa döner).
const BAKIS_KAPI := Vector3(0.0, 1.35, -6.0)
const BAKIS_KUYRUK := Vector3(-0.1, 1.1, -14.0)
var _bakis := BAKIS_KAPI


## Kamerayı kuyruğa çevirip yakınlaştırır (true) ya da kapıya döndürür (false).
func kuyruga_bak(evet: bool) -> void:
	var t := create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	t.tween_method(_bakis_ayarla, _bakis, BAKIS_KUYRUK if evet else BAKIS_KAPI, 0.6)
	t.tween_property(kamera, "fov", 28.0 if evet else GORUS, 0.6)
	await t.finished


func _bakis_ayarla(v: Vector3) -> void:
	_bakis = v
	kamera.look_at(v)


## Sıra olayı canlandırması (ilk aşama): olay oynar. `anahtar`: atlama, kavga, bayilma, vazgecme, panik.
func sira_olayi_baslat(anahtar: String) -> void:
	var n := _kuyruktakiler.size()
	if n < 2:
		return
	await kuyruga_bak(true)
	match anahtar:
		"atlama":
			var k := _kuyruktakiler[n - 1]
			await k.yuru(Vector3(0.9, 0, -9.6), 3.4)
			k.bak(kamera.position)
		"kavga":
			var a := _kuyruktakiler[0]
			var b := _kuyruktakiler[1]
			a.bak(b.position)
			b.bak(a.position)
			for tur in 2:
				a.duygu(&"ofke")
				b.duygu(&"ofke")
				var t := create_tween().set_parallel()
				t.tween_property(a, "position", a.position + (b.position - a.position).normalized() * 0.35, 0.18)
				t.tween_property(b, "position", b.position + (a.position - b.position).normalized() * 0.2, 0.18)
				t.chain().tween_property(a, "position", _kuyruk_yerleri[0], 0.25)
				await get_tree().create_timer(0.9).timeout
		"bayilma":
			var k := _kuyruktakiler[mini(2, n - 1)]
			var t := create_tween()
			t.tween_property(k, "rotation:x", deg_to_rad(-82.0), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			await t.finished
		"vazgecme":
			var k := _kuyruktakiler[n - 1]
			await k.yuru(k.position + Vector3(0.3, 0, -4.5), 2.4)
		"panik":
			_kuyruktakiler[n - 1].duygu(&"ofke")
			for k in _kuyruktakiler:
				k.bak(k.position + Vector3(0, 0, -10))
			await get_tree().create_timer(1.2).timeout


## Sıra olayının ikinci aşaması: seçilen seçeneğe göre biter. `etki`: seçeneğin etki sözlüğü.
func sira_olayi_bitir(anahtar: String, etki: Dictionary) -> void:
	var n := _kuyruktakiler.size()
	if n < 2:
		return
	var geri: bool = etki.get("geri", false)
	match anahtar:
		"atlama":
			if geri:
				await _kuyruktakiler[n - 1].yuru(_kuyruk_yerleri[n - 1], 2.0)
				_kuyruktakiler[n - 1].bak(Vector3(0, 0, 10))
		"kavga":
			_kuyruktakiler[0].bak(Vector3(0, 0, 10))
			_kuyruktakiler[1].bak(Vector3(0, 0, 10))
		"bayilma":
			var k := _kuyruktakiler[mini(2, n - 1)]
			if etki.get("bar", [0])[0] > 0:
				var t := create_tween()
				t.tween_property(k, "rotation:x", 0.0, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
				await t.finished
				k.bak(Vector3(0, 0, 10))
			else:
				var t := create_tween()
				t.tween_property(k, "position:x", k.position.x - 2.4, 1.2)
				await t.finished
		"vazgecme":
			var k := _kuyruktakiler[n - 1]
			if geri:
				await k.yuru(_kuyruk_yerleri[n - 1], 1.6)
				k.bak(Vector3(0, 0, 10))
			else:
				_kuyruktakiler.remove_at(n - 1)
				_kuyruk_yerleri.remove_at(n - 1)
				await k.yuru(k.position + Vector3(0, 0, -16.0), 1.6)
				if is_instance_valid(k):
					k.queue_free()
		"panik":
			for k in _kuyruktakiler:
				k.bak(Vector3(0, 0, 10))
	await kuyruga_bak(false)


## Gelen heybesini önüne koyar: deri torba ve kapağı, yere konur gibi belirir.
func heybe_koy() -> void:
	if _gelen == null or is_instance_valid(_heybe):
		return
	_heybe = Node3D.new()
	# Torba: basık küre gövde, üstte devrik kapak ve askı.
	var govde := MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 0.16
	k.height = 0.26
	govde.mesh = k
	govde.scale = Vector3(1.0, 0.85, 0.7)
	govde.position.y = 0.11
	govde.material_override = Dunya3B.duz_malzeme(Color("#6b4630"))
	_heybe.add_child(govde)
	var kapak := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = Vector3(0.24, 0.02, 0.16)
	kapak.mesh = b
	kapak.position = Vector3(0, 0.2, -0.1)
	kapak.rotation_degrees.x = -60
	kapak.material_override = Dunya3B.duz_malzeme(Color("#4a2f1f"))
	_heybe.add_child(kapak)
	_heybe.position = _gelen.position + Vector3(0.42, 0, 0.12)
	_heybe.scale = Vector3.ONE * 0.2
	add_child(_heybe)
	create_tween().tween_property(_heybe, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


## Karar anında kadraj daralır (kamera görüş açısı sert adımlarla).
func daralt(icerden: bool) -> void:
	for i in range(1, 4):
		kamera.fov = GORUS - (i if icerden else 3 - i) * 3.0
		await get_tree().create_timer(1.0 / 12.0).timeout


## Sinematik gece ışığı (Forward+): HDRI gökyüzü, ay ışığı, hacimsel sis (meşale ışığı sisin içinde huzme yapar),
## ortam gölgesi (SSAO), dolaylı ışık (SSIL), AgX ton eşleme, soğuk-sıcak renk ayarı ve uzak alan bulanıklığı.
## Compatibility çiziciyle açılırsa desteklenmeyen ayarlar yok sayılır; sahne yine düzgün görünür.
func _ortam_ayarla() -> void:
	for n in get_children():
		if n is WorldEnvironment:
			var env := (n as WorldEnvironment).environment
			var hdri := Pbr.gok(KapiManzarasi.GOK)
			if hdri != null:
				var gok := PanoramaSkyMaterial.new()
				gok.panorama = hdri
				gok.energy_multiplier = 0.7
				var sky := Sky.new()
				sky.sky_material = gok
				sky.radiance_size = Sky.RADIANCE_SIZE_256
				env.background_mode = Environment.BG_SKY
				env.sky = sky
				env.sky_rotation = Vector3(0, deg_to_rad(200.0), 0)
				env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
				env.ambient_light_sky_contribution = 0.85
				env.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
			env.ambient_light_color = Color("#2c3c5c")
			env.ambient_light_energy = 0.5
			env.tonemap_mode = Environment.TONE_MAPPER_AGX
			env.tonemap_exposure = 1.5
			# Uzak sis: tepeler ve ufuk soğuk maviye karışır.
			env.fog_enabled = true
			env.fog_mode = Environment.FOG_MODE_EXPONENTIAL
			env.fog_light_color = Color("#16213a")
			env.fog_light_energy = 0.9
			env.fog_density = 0.006
			env.fog_sky_affect = 0.25
			env.fog_aerial_perspective = 0.4
			# Hacimsel sis: meşalelerin çevresinde sıcak ışık hüzmesi, yakın planda nem.
			env.volumetric_fog_enabled = true
			env.volumetric_fog_density = 0.018
			env.volumetric_fog_albedo = Color("#8796b8")
			env.volumetric_fog_length = 48.0
			env.volumetric_fog_anisotropy = 0.35
			env.volumetric_fog_ambient_inject = 0.15
			env.ssao_enabled = true
			env.ssao_radius = 1.2
			env.ssao_intensity = 2.2
			env.ssil_enabled = true
			env.ssil_intensity = 0.8
			env.glow_enabled = true
			env.glow_intensity = 0.45
			env.glow_bloom = 0.0
			env.glow_hdr_threshold = 1.3
			# Yalnız küçük yarıçaplı ışıma katmanları: alevin çevresinde dar hale, ekranı kaplayan pus yok.
			for k in range(1, 8):
				env.set("glow_levels/%d" % k, 1.0 if k <= 3 else 0.0)
			# Renk ayarı: hafif kontrast, doygunluk biraz düşük (savaş sonrası, soğuk gece).
			env.adjustment_enabled = true
			env.adjustment_contrast = 1.08
			env.adjustment_saturation = 0.88
		elif n is DirectionalLight3D:
			var ay := n as DirectionalLight3D
			ay.light_color = Color("#9fb4e6")
			ay.light_energy = 0.32
			ay.light_volumetric_fog_energy = 0.6
			ay.rotation_degrees = Vector3(-24, 155, 0)
			ay.shadow_enabled = true
			ay.directional_shadow_max_distance = 60.0
			ay.shadow_blur = 1.5
	# Kamera: uzak alan çok hafif bulanık (gözü gelene çeker), sabit pozlama.
	var nitelik := CameraAttributesPractical.new()
	nitelik.dof_blur_far_enabled = true
	nitelik.dof_blur_far_distance = 45.0
	nitelik.dof_blur_far_transition = 40.0
	nitelik.dof_blur_amount = 0.04
	kamera.attributes = nitelik


func _kuyruk_kur() -> void:
	# Bekleyen sıra: yolun üstünde, kapıdan geriye; en öndekiler belirgin, gerisi manzaradaki silüetlere karışır.
	var adlar := ["ciftci", "esnaf", "ciftci_kadin", "asker", "ciftci"]
	for i in adlar.size():
		var k := Dunya3B.karakter(adlar[i])
		var p := KapiManzarasi.yol_noktasi(0.06 + i * 0.022)
		k.position = Vector3(p.x - 0.7 + (i % 2) * 0.7, p.y, p.z - 3.0)
		add_child(k)
		k.bak(Vector3(0, 0, 10))
		_kuyruktakiler.append(k)
		_kuyruk_yerleri.append(k.position)


## Sağ orta planda öküzlü kağnı: yükü bir ailenin bütün evi (çuval, sandık, testi, yorgan).
func _kagni_kur() -> void:
	var araba := Dunya3B.nesne("araba", 1.7)
	araba.position = Vector3(1.9, 0, -12.5)
	araba.rotation.y = deg_to_rad(-100)
	add_child(araba)
	var yuk := Node3D.new()
	yuk.position = araba.position + Vector3(0, 1.0, 0)
	yuk.rotation.y = araba.rotation.y
	add_child(yuk)
	var renkler := [Color("#6b5a40"), Color("#4a3a2c"), Color("#5c4a5a"), Color("#7a6a4a")]
	for i in 5:
		var m := MeshInstance3D.new()
		if i % 2 == 0:
			var k := SphereMesh.new()
			k.radius = 0.35
			k.height = 0.55
			m.mesh = k
		else:
			var b := BoxMesh.new()
			b.size = Vector3(0.6, 0.45, 0.5)
			m.mesh = b
		m.position = Vector3(-0.7 + i * 0.35, 0.25 + (i % 2) * 0.15, (i % 3 - 1) * 0.3)
		m.material_override = Dunya3B.duz_malzeme(renkler[i % renkler.size()])
		yuk.add_child(m)
	if Dunya3B.model_var_mi("okuz"):
		_okuz = Dunya3B.nesne("okuz", 1.55)
		_okuz.position = araba.position + Vector3(-0.6, 0, 2.6)
		_okuz.rotation.y = araba.rotation.y + PI
		add_child(_okuz)


func _kutu(boyut: Vector3, konum: Vector3, mat: Material) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.position = konum
	m.material_override = mat
	add_child(m)
	return m
