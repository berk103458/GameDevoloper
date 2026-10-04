## Köy sahnesi (3D): gece sonunda köy. Nüfusla evler, çadırlar ve meşaleler çoğalır; pazar ve kervansaray
## seviyeyle büyür; bu gece içeri alınanlar kapıdan yürüyerek yerine gider. İkinci perdede sur ve Tekfur'un adamları.
class_name KoySahnesi
extends Node3D

const KAPI := Vector3(0, 0, 15)
const AZAMI_FIGUR := 32

var oturum: Oturum
var kamera: Camera3D
var _isiklar: Array[OmniLight3D] = []
var _zaman := 0.0
var _aci := 0.0


func _ready() -> void:
	Dunya3B.ortam_kur(self, 0.012)
	Dunya3B.zemin_kur(self, 200.0)
	_kur()
	kamera = Camera3D.new()
	kamera.fov = 50.0
	add_child(kamera)
	_kamera_yerlestir()


## Sahneyi oturumdan yeniden kurar (yapı kurulunca çağrılır).
func yenile() -> void:
	for c in get_children():
		if c != kamera and not (c is WorldEnvironment) and not (c is DirectionalLight3D):
			c.queue_free()
	_isiklar.clear()
	Dunya3B.zemin_kur(self, 200.0)
	_kur(false)


func _process(delta: float) -> void:
	_zaman += delta
	for i in _isiklar.size():
		var l := _isiklar[i]
		l.light_energy = float(l.get_meta("taban")) * (0.85 + 0.15 * sin(_zaman * 8.0 + i * 1.7) * sin(_zaman * 2.9 + i))
	_aci += delta * 0.025
	_kamera_yerlestir()


func _kamera_yerlestir() -> void:
	if kamera == null:
		return
	var r := 21.0
	kamera.position = Vector3(sin(_aci) * r * 0.5, 9.0, cos(_aci) * r)
	kamera.look_at(Vector3(0, 0.5, -1.5))


func _kur(animasyon: bool = true) -> void:
	var kapi := Dunya3B.nesne("kapi", 4.2, "yapi")
	kapi.position = KAPI
	add_child(kapi)
	_isiklar.append(Dunya3B.mesale_kur(self, KAPI + Vector3(-2.6, 0, -0.8), 2.0, 8.0))
	_yapilari_kur()
	var nufus := oturum.koy.toplam()
	var ev_sayisi := clampi(1 + nufus / 3, 1, 14)
	for i in ev_sayisi:
		var p := _ev_konumu(i)
		var ev := Dunya3B.nesne("ev" if i % 3 != 2 else "cadir", 2.6 if i % 3 != 2 else 2.2, "yapi")
		ev.position = p
		ev.rotation_degrees.y = rad_to_deg(atan2(-p.x, -p.z)) + 180.0
		add_child(ev)
	var mesale := clampi(1 + nufus / 3, 1, 12)
	for i in mesale:
		var p := _ev_konumu(i) * 0.82
		_isiklar.append(Dunya3B.mesale_kur(self, p, 2.2, 7.5))
	var sus := [["kuyu", Vector3(1.5, 0, 1.0), 1.6], ["cuval_yigini", Vector3(4.0, 0, -6.0), 0.9], ["araba", Vector3(-3.5, 0, 6.5), 1.6],
		["agac", Vector3(-15, 0, -14), 6.0], ["agac", Vector3(16, 0, -10), 5.5], ["kaya", Vector3(12, 0, 9), 1.1]]
	for s in sus:
		var n := Dunya3B.nesne(s[0], s[2])
		n.position = s[1]
		add_child(n)
	_halki_kur(animasyon)
	if oturum.perde == 2:
		_sur_kur()
		_tekfur_kur()


func _yapilari_kur() -> void:
	var kerv: int = oturum.yapilar[&"kervansaray"]
	if kerv > 0:
		var k := Dunya3B.nesne("kervansaray", 3.2 + kerv * 0.6, "yapi")
		k.position = Vector3(-8.5, 0, -6.5)
		k.rotation_degrees.y = 25
		add_child(k)
		_isiklar.append(Dunya3B.mesale_kur(self, Vector3(-5.5, 0, -3.8), 2.4, 8.0))
	var pazar: int = oturum.yapilar[&"pazar"]
	for i in pazar * 2:
		var t := Dunya3B.nesne("pazar_tezgahi", 2.4, "yapi")
		t.position = Vector3(6.5 + (i % 2) * 3.0, 0, -5.5 + (i / 2) * 3.2)
		t.rotation_degrees.y = -70
		add_child(t)
	if pazar > 0:
		_isiklar.append(Dunya3B.mesale_kur(self, Vector3(5.0, 0, -2.5), 2.2, 7.5))


func _ev_konumu(i: int) -> Vector3:
	# Köyün ortasındaki kuyunun çevresinde iki halka; giriş yolu (güney) boş kalır.
	var halka := 0 if i < 7 else 1
	var sira := i if halka == 0 else i - 7
	var r := 9.0 + halka * 5.5
	var a := deg_to_rad(-150.0 + sira * 50.0 + halka * 25.0)
	return Vector3(sin(a) * r, 0, -cos(a) * r)


func _halk_konumu(i: int) -> Vector3:
	var ev := _ev_konumu(i % 14) * 0.7
	var kay := Vector3(((i * 37) % 7 - 3) * 0.45, 0, ((i * 53) % 5 - 2) * 0.45)
	return ev + kay


func _halki_kur(animasyon: bool) -> void:
	var yeni := oturum.koy.bu_gece_girenler
	var eski := clampi(oturum.koy.toplam() - yeni.size(), 0, AZAMI_FIGUR)
	var siniflar: Array[StringName] = []
	for s in [&"ciftci", &"esnaf", &"asker"]:
		for k in oturum.koy.sayi(s):
			siniflar.append(s)
	for i in eski:
		var s: StringName = siniflar[i % siniflar.size()] if not siniflar.is_empty() else &"ciftci"
		var f := Dunya3B.karakter(Dunya3B.SINIF_MODEL[s] if i % 4 != 3 or s != &"ciftci" else "ciftci_kadin")
		f.position = _halk_konumu(i)
		add_child(f)
		f.bak(Vector3.ZERO)
	for n in yeni.size():
		var i := eski + n
		if i >= AZAMI_FIGUR:
			break
		var g: Dictionary = yeni[n]
		var f := Dunya3B.karakter(Dunya3B.karakter_adi(g["adli_id"], g.get("portre", ""), g["sinif"]))
		add_child(f)
		if animasyon:
			f.position = KAPI + Vector3(0, 0, 2)
			_gir(f, _halk_konumu(i), n)
		else:
			f.position = _halk_konumu(i)
			f.bak(Vector3.ZERO)


func _gir(f: KarakterModel, hedef: Vector3, sira: int) -> void:
	await get_tree().create_timer(0.3 + sira * 0.9).timeout
	if not is_instance_valid(f):
		return
	await f.yuru(Vector3(0, 0, 9))
	if is_instance_valid(f):
		await f.yuru(hedef)
		if is_instance_valid(f):
			f.bak(Vector3.ZERO)


func _sur_kur() -> void:
	var sur: int = oturum.yapilar[&"sur"]
	if sur <= 0:
		return
	var boy := 2.4 + sur * 0.9
	var adet := 34
	for i in adet:
		var a := TAU * i / adet
		var p := Vector3(sin(a) * 20.0, 0, cos(a) * 20.0)
		if p.distance_to(KAPI) < 3.5:
			continue
		var c := Dunya3B.nesne("kazik_cit", boy)
		c.position = p
		c.rotation.y = a + PI / 2.0
		add_child(c)


func _tekfur_kur() -> void:
	var yakinlik := clampf(float(oturum.perde2_gece) / oturum.ayarlar.perde2_hedef_gece, 0.0, 1.0)
	var adet := mini(4 + oturum.perde2_gece, 16)
	var uzak := 60.0 - yakinlik * 25.0
	var mat := Dunya3B.duz_malzeme(Renkler.DERIN_MAVI)
	for i in adet:
		var f := Dunya3B.karakter("asker")
		f.position = Vector3(-14 + (i % 8) * 4.0, 0, -uzak - (i / 8) * 3.0)
		for mi in f.find_children("*", "MeshInstance3D", true, false):
			(mi as MeshInstance3D).material_override = mat
		add_child(f)
		f.bak(Vector3.ZERO)
	_isiklar.append(Dunya3B.mesale_kur(self, Vector3(0, 0, -uzak + 2.0), 1.6, 9.0))
