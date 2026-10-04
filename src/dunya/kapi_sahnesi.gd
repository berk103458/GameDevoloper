## Kapı sahnesi (3D): muhafızın gözünden açık kapı, meşale, yol ve kuyruk. Gelen kişi yoldan yürür,
## kapının önünde durur; kabul edilen içeri (kameranın yanından), reddedilen yola geri döner.
class_name KapiSahnesi
extends Node3D

const DURMA := Vector3(0.0, 0.0, -3.0)
const BASLANGIC := Vector3(0.6, 0.0, -26.0)
const ICERI := Vector3(1.9, 0.0, 2.5)
const DONUS := Vector3(-0.8, 0.0, -32.0)

var kamera: Camera3D
var _gelen: KarakterModel
var _isiklar: Array[OmniLight3D] = []
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
	await _gelen.yuru(DURMA)
	_gelen.bak(kamera.position)


## Karar sonrası: kaldıysa içeri, gittiyse yola.
func gelen_git(kaldi: bool) -> void:
	if _gelen == null:
		return
	var g := _gelen
	_gelen = null
	if kaldi:
		await g.yuru(Vector3(1.6, 0, -0.5))
		await g.yuru(ICERI)
	else:
		await g.yuru(DONUS)
	g.queue_free()


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
	# Kazık duvar kapının iki yanında.
	for yon in [-1, 1]:
		for i in 7:
			var c := Dunya3B.nesne("kazik_cit", 3.6)
			c.position = Vector3(yon * (3.4 + i * 2.3), 0, -1.4)
			add_child(c)


func _kuyruk_kur() -> void:
	var adlar := ["ciftci", "esnaf", "ciftci_kadin", "asker", "ciftci"]
	for i in adlar.size():
		var k := Dunya3B.karakter(adlar[i])
		k.position = Vector3(-0.4 + (i % 2) * 0.9, 0, -16.0 - i * 2.2)
		add_child(k)
		k.bak(Vector3(0, 0, 10))


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
