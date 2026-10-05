## Kapı sahnesi (3D): muhafızın gözünden açık kapı, meşale, yol ve kuyruk. Gelen kişi yoldan yürür,
## kapının önünde durur; kabul edilen içeri (kameranın yanından), reddedilen yola geri döner.
class_name KapiSahnesi
extends Node3D

const DURMA := Vector3(0.0, 0.0, -2.5)
const BASLANGIC := Vector3(0.5, 0.0, -9.0)
## Kapıya yürüyüş hızı (m/s): yürüyüş ~2 saniye.
const YAKLASMA_HIZI := 2.4
const ICERI := Vector3(1.9, 0.0, 2.5)
const DONUS := Vector3(-0.8, 0.0, -22.0)

var kamera: Camera3D
var _gelen: KarakterModel
## Gelenin ayağının dibine konan heybe (arama sırasında).
var _heybe: Node3D
var _isiklar: Array[OmniLight3D] = []
## Kuyrukta bekleyen figürler ve yerleri (sıra olayları bunları canlandırır).
var _kuyruktakiler: Array[KarakterModel] = []
var _kuyruk_yerleri: Array[Vector3] = []
var _zaman := 0.0


func _ready() -> void:
	Dunya3B.ortam_kur(self, 0.028)
	Dunya3B.zemin_kur(self)
	_yol_kur()
	_kapi_kur()
	_isiklar.append(Dunya3B.mesale_kur(self, Vector3(-1.75, 0, -1.6), 3.2, 10.0))
	_isiklar.append(Dunya3B.mesale_kur(self, Vector3(3.5, 0, -14.0), 1.4, 7.0))
	_kuyruk_kur()
	_cevre_kur()
	kamera = Camera3D.new()
	kamera.position = Vector3(0.0, 1.62, 1.2)
	kamera.fov = 52.0
	add_child(kamera)
	kamera.look_at(Vector3(0.0, 1.35, -6.0))


func _process(delta: float) -> void:
	_zaman += delta
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
	t.tween_property(kamera, "fov", 30.0 if evet else 52.0, 0.6)
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
		kamera.fov = 52.0 - (i if icerden else 3 - i) * 3.0
		await get_tree().create_timer(1.0 / 12.0).timeout


func _yol_kur() -> void:
	var m := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(4.5, 60.0)
	m.mesh = p
	m.position = Vector3(0, 0.01, -30.0)
	m.material_override = Dunya3B.duz_malzeme(Renkler.AHSAP.lerp(Renkler.SOGUK_MAVI, 0.45))
	add_child(m)


func _kapi_kur() -> void:
	var ahsap := Dunya3B.duz_malzeme(Renkler.AHSAP)
	for x in [-2.2, 2.2]:
		_kutu(Vector3(0.5, 4.6, 0.5), Vector3(x, 2.3, -1.4), ahsap)
	_kutu(Vector3(5.4, 0.55, 0.6), Vector3(0, 4.55, -1.4), ahsap)
	# Açık kapı kanatları (içe doğru açılmış).
	var kanat_sol := _kutu(Vector3(1.9, 3.9, 0.14), Vector3(0, 0, 0), ahsap)
	kanat_sol.position = Vector3(-2.75, 1.95, -0.4)
	kanat_sol.rotation_degrees.y = 72
	var kanat_sag := _kutu(Vector3(1.9, 3.9, 0.14), Vector3(0, 0, 0), ahsap)
	kanat_sag.position = Vector3(2.75, 1.95, -0.4)
	kanat_sag.rotation_degrees.y = -72
	# Kazık duvar kapının iki yanında: parça genişliği modelden ölçülür, kapı boşluğu açık kalır.
	var ornek := Dunya3B.nesne("kazik_cit", 3.4)
	var w := clampf(Dunya3B.boyut(ornek).x, 1.0, 6.0)
	ornek.free()
	for yon in [-1, 1]:
		for i in 6:
			var c := Dunya3B.nesne("kazik_cit", 3.4)
			c.position = Vector3(yon * (2.5 + w / 2.0 + i * w * 0.95), 0, -1.4)
			add_child(c)


func _kuyruk_kur() -> void:
	var adlar := ["ciftci", "esnaf", "ciftci_kadin", "asker", "ciftci"]
	for i in adlar.size():
		var k := Dunya3B.karakter(adlar[i])
		k.position = Vector3(-0.4 + (i % 2) * 0.9, 0, -11.0 - i * 2.0)
		add_child(k)
		k.bak(Vector3(0, 0, 10))
		_kuyruktakiler.append(k)
		_kuyruk_yerleri.append(k.position)


func _cevre_kur() -> void:
	var yerler := [["agac", Vector3(-7, 0, -12), 5.5], ["kaya", Vector3(5, 0, -8), 1.0], ["agac", Vector3(9, 0, -22), 6.0],
		["kaya", Vector3(-4.5, 0, -20), 1.2], ["araba", Vector3(-3.6, 0, -6.5), 1.6], ["cuval_yigini", Vector3(3.0, 0, -4.0), 0.9]]
	for y in yerler:
		var n := Dunya3B.nesne(y[0], y[2])
		n.position = y[1]
		n.rotation_degrees.y = y[1].x * 13.0
		add_child(n)
	# Uzak tepeler.
	for i in 5:
		var t := _kutu(Vector3(30, 6 + i * 2, 4), Vector3(-50 + i * 25, 0, -60 - i * 3), Dunya3B.duz_malzeme(Renkler.DERIN_MAVI))
		t.rotation_degrees.z = 8.0 * (1 if i % 2 == 0 else -1)


func _kutu(boyut: Vector3, konum: Vector3, mat: Material) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.position = konum
	m.material_override = mat
	add_child(m)
	return m
