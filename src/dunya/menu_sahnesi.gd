## Menü sahnesi (3D): oyuna girmeden önceki gece (sanat kitabı 2.9). Yoldan, dışarıdan kapıya bakılır:
## tek meşale, kapının ardından sızan köy ışığı, kapıya bakan tek bir bekleyen. Kapı kadrajın sağ
## yarısında; sol yarı karanlık arazi ve çit kalır, menü listesi oraya yazılır (yarı saydam karartma yok, 7.9).
class_name MenuSahnesi
extends Node3D

const KAPI := Vector3(3.0, 0.0, -7.0)
const KAPI_BOY := 5.2
const CIT_BOY := 3.3

var kamera: Camera3D
var _isiklar: Array[OmniLight3D] = []
var _zaman := 0.0
var _kamera_taban := Vector3(-1.6, 1.6, 8.5)
var _bakis := Vector3(-1.6, 2.3, -7.0)


func _ready() -> void:
	Dunya3B.ortam_kur(self, 0.04)
	Dunya3B.zemin_kur(self)
	var gecit := _kapi_kur()
	_yol_kur(gecit)
	# Tek meşale: sağ kulenin önünde (sol taraf menüye kalır).
	_isiklar.append(Dunya3B.mesale_kur(self, gecit + Vector3(3.4, 0, 1.4), 3.2, 10.0))
	_ic_isik_kur(gecit)
	_bekleyen_kur(gecit)
	_cevre_kur()
	kamera = Camera3D.new()
	kamera.fov = 48.0
	add_child(kamera)
	_kamera_yerlestir()


func _process(delta: float) -> void:
	_zaman += delta
	for i in _isiklar.size():
		var l := _isiklar[i]
		l.light_energy = float(l.get_meta("taban")) * (0.86 + 0.14 * sin(_zaman * 8.5 + i * 2.3) * sin(_zaman * 3.1 + i))
	_kamera_yerlestir()


## Çok yavaş nefes: enerji en düşük (2.9); kamera neredeyse durağan.
func _kamera_yerlestir() -> void:
	if kamera == null:
		return
	kamera.position = _kamera_taban + Vector3(sin(_zaman * 0.11) * 0.2, sin(_zaman * 0.17) * 0.04, 0)
	kamera.look_at(_bakis)


## Kapı ve iki yanındaki kazık çit. Geçidin (kapı boşluğunun) dünya konumunu döner.
func _kapi_kur() -> Vector3:
	var kapi := Dunya3B.nesne("kapi", KAPI_BOY, "yapi")
	kapi.position = KAPI
	add_child(kapi)
	var genislik := Dunya3B.boyut(kapi).x
	var ornek := Dunya3B.nesne("kazik_cit", CIT_BOY)
	var w := Dunya3B.boyut(ornek).x
	ornek.free()
	# Sol çit karanlığa doğru hafifçe kameraya kıvrılır; sağ çit kısa.
	for i in 6:
		var c := Dunya3B.nesne("kazik_cit", CIT_BOY)
		c.position = Vector3(KAPI.x - genislik / 2.0 - w * (i + 0.5) * 0.96, 0, KAPI.z + i * 0.9)
		c.rotation_degrees.y = -6.0 * (i + 1)
		add_child(c)
	for i in 3:
		var c := Dunya3B.nesne("kazik_cit", CIT_BOY)
		c.position = Vector3(KAPI.x + genislik / 2.0 + w * (i + 0.5) * 0.96, 0, KAPI.z)
		add_child(c)
	# İsteğe bağlı Meshy modeli: kapının sağında gözetleme kulesi (yoksa sahne onsuz da tamam).
	if Dunya3B.model_var_mi("gozetleme_kulesi", "yapi"):
		var k := Dunya3B.nesne("gozetleme_kulesi", 7.5, "yapi")
		k.position = Vector3(KAPI.x + genislik / 2.0 + 1.8, 0, KAPI.z + 1.5)
		k.rotation_degrees.y = -15
		add_child(k)
	# Kapı modeli simetrik: geçit ortada.
	return KAPI


## Yol: kameranın ayağından geçide.
func _yol_kur(gecit: Vector3) -> void:
	var bas := Vector3(_kamera_taban.x, 0, _kamera_taban.z + 6.0)
	var fark := bas - gecit
	var m := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(3.6, fark.length() + 2.0)
	m.mesh = p
	m.position = (bas + gecit) / 2.0 + Vector3(0, 0.01, 0)
	m.rotation.y = atan2(fark.x, fark.z)
	m.material_override = Dunya3B.duz_malzeme(Renkler.AHSAP.lerp(Renkler.SOGUK_MAVI, 0.45))
	add_child(m)


## Kapının ardındaki köy: duvarın arkasında kalır, yalnız geçitten görünür ve ışığı sızar.
func _ic_isik_kur(gecit: Vector3) -> void:
	var l := OmniLight3D.new()
	l.light_color = Renkler.MESALE
	l.light_energy = 1.8
	l.omni_range = 8.0
	l.position = gecit + Vector3(0.4, 2.0, -4.0)
	l.set_meta("taban", 1.8)
	add_child(l)
	_isiklar.append(l)
	var yerler := [Vector3(-1.0, 0, -7.0), Vector3(2.0, 0, -10.0), Vector3(-2.5, 0, -12.5)]
	for i in yerler.size():
		var ev := Dunya3B.nesne("cadir" if i == 1 else "ev", 2.6, "yapi")
		ev.position = gecit + yerler[i]
		ev.rotation_degrees.y = 160 + i * 25
		add_child(ev)


## Tek bekleyen: yolda, kapıya bakıyor, sırtı bize dönük. Yüzü görünmez — kim olduğu bilinmez.
func _bekleyen_kur(gecit: Vector3) -> void:
	var b := Dunya3B.karakter("ciftci_kadin")
	b.position = gecit.lerp(Vector3(_kamera_taban.x, 0, _kamera_taban.z), 0.42) + Vector3(0.5, 0, 0)
	add_child(b)
	b.bak(gecit)


func _cevre_kur() -> void:
	# Sol ön plan: çıplak ağaç ve kaya — menü listesinin arkası koyu ve sakin kalır.
	var yerler := [["agac", Vector3(-10.5, 0, 0.5), 8.0, 40.0], ["kaya", Vector3(-6.5, 0, 3.5), 1.0, 0.0],
		["agac", Vector3(13.0, 0, -15.0), 6.5, 0.0], ["kaya", Vector3(7.5, 0, -2.5), 0.9, 70.0],
		["araba", Vector3(10.5, 0, -3.5), 1.6, -35.0]]
	for y in yerler:
		var n := Dunya3B.nesne(y[0], y[2])
		n.position = y[1]
		n.rotation_degrees.y = y[3]
		add_child(n)
	for i in 6:
		var t := MeshInstance3D.new()
		var bm := BoxMesh.new()
		bm.size = Vector3(34, 7 + (i % 3) * 3, 4)
		t.mesh = bm
		t.position = Vector3(-70 + i * 28, 0, -55 - (i % 2) * 8)
		t.rotation_degrees.z = 7.0 * (1 if i % 2 == 0 else -1)
		t.material_override = Dunya3B.duz_malzeme(Renkler.DERIN_MAVI)
		add_child(t)
