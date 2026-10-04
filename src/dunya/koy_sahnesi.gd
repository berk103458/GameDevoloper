## Köy sahnesi (3D): gece sonunda köy. Nüfusla evler, çadırlar ve meşaleler çoğalır; pazar ve kervansaray
## seviyeyle büyür; bu gece içeri alınanlar kapıdan yürüyerek yerine gider. İkinci perdede sur ve Tekfur'un adamları.
class_name KoySahnesi
extends Node3D

const KAPI := Vector3(0, 0, -19)
const AZAMI_FIGUR := 32
## Tarlalar köyün doğusunda, 2 sütun × 3 sıra parsel.
const TARLA_KOK := Vector3(18.0, 0, -12.0)
const TARLA_BOYUT := Vector2(5.0, 4.0)
const TARLA_ARALIK := Vector2(6.2, 5.4)
const YOL_RENK := Color("#3b3026")
const AZAMI_GEZGIN := 8

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
	# Tarlalar varsa çerçeve doğuya kayar ve yükselir: köy ve tarlalar birlikte görünür.
	var tarla := not oturum.tarlalar.parseller.is_empty()
	var r := 20.0 if tarla else 17.0
	var merkez := Vector3(5.0, 0.4, -5.0) if tarla else Vector3(0, 0.8, -4.0)
	kamera.position = Vector3(merkez.x + sin(_aci) * r * 0.5, 10.0 if tarla else 7.5, cos(_aci) * r)
	kamera.look_at(merkez)


func _kur(animasyon: bool = true) -> void:
	var kapi := Dunya3B.nesne("kapi", 4.2, "yapi")
	kapi.position = KAPI
	kapi.rotation_degrees.y = 180
	add_child(kapi)
	_isiklar.append(Dunya3B.mesale_kur(self, KAPI + Vector3(-3.0, 0, 1.2), 2.0, 8.0))
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
	_yollar_kur()
	var calisan := _tarlalar_kur()
	_halki_kur(animasyon, calisan)
	_gezginler_kur()
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
	# Köyün ortasındaki kuyunun çevresinde iki halka; kapıdan gelen yol (kuzey) boş kalır.
	var halka := 0 if i < 7 else 1
	var sira := i if halka == 0 else i - 7
	var r := 9.0 + halka * 5.5
	var a := deg_to_rad(30.0 + sira * 50.0 + halka * 25.0)
	return Vector3(sin(a) * r, 0, -cos(a) * r)


func _halk_konumu(i: int) -> Vector3:
	var ev := _ev_konumu(i % 14) * 0.7
	var kay := Vector3(((i * 37) % 7 - 3) * 0.45, 0, ((i * 53) % 5 - 2) * 0.45)
	return ev + kay


func _halki_kur(animasyon: bool, tarlada: int = 0) -> void:
	var yeni := oturum.koy.bu_gece_girenler
	var eski := clampi(oturum.koy.toplam() - yeni.size() - tarlada, 0, AZAMI_FIGUR)
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
			f.position = KAPI + Vector3(0, 0, 1.5)
			_gir(f, _halk_konumu(i), n)
		else:
			f.position = _halk_konumu(i)
			f.bak(Vector3.ZERO)


func _gir(f: KarakterModel, hedef: Vector3, sira: int) -> void:
	await get_tree().create_timer(0.3 + sira * 0.9).timeout
	if not is_instance_valid(f):
		return
	await f.yuru(Vector3(0, 0, -11))
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
		if p.distance_to(Vector3(0, 0, -20)) < 3.5:
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
		f.position = Vector3(-26 + (i % 8) * 3.0, 0, -uzak - (i / 8) * 3.0)
		for mi in f.find_children("*", "MeshInstance3D", true, false):
			(mi as MeshInstance3D).material_override = mat
		add_child(f)
		f.bak(Vector3.ZERO)
	_isiklar.append(Dunya3B.mesale_kur(self, Vector3(-16, 0, -uzak + 2.0), 1.6, 9.0))


# ─── Yollar ──────────────────────────────────────────────────────────────

## Toprak yollar: kapıdan merkeze, merkezin çevresinde halka, pazara, kervansaraya ve tarlalara.
func _yollar_kur() -> void:
	var merkez := Vector3(1.5, 0, 1.0)
	_yol(KAPI + Vector3(0, 0, 1.5), merkez, 2.2)
	var r := 11.7
	var adim := 18
	for i in adim:
		var a := TAU * i / adim
		var b := TAU * (i + 1) / adim
		_yol(merkez + Vector3(sin(a) * r, 0, cos(a) * r), merkez + Vector3(sin(b) * r, 0, cos(b) * r), 1.5)
	if int(oturum.yapilar[&"pazar"]) > 0:
		_yol(merkez, Vector3(7.5, 0, -4.0), 1.4)
	if int(oturum.yapilar[&"kervansaray"]) > 0:
		_yol(merkez, Vector3(-7.0, 0, -4.5), 1.4)
	if not oturum.tarlalar.parseller.is_empty():
		_yol(merkez + Vector3(r, 0, 0), TARLA_KOK + Vector3(-3.4, 0, 6.0), 1.4)


func _yol(a: Vector3, b: Vector3, en: float) -> void:
	var fark := b - a
	var m := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(en, fark.length() + en * 0.5)
	m.mesh = p
	m.position = (a + b) / 2.0 + Vector3(0, 0.015, 0)
	m.rotation.y = atan2(fark.x, fark.z)
	m.material_override = Dunya3B.duz_malzeme(YOL_RENK)
	add_child(m)


# ─── Tarlalar ────────────────────────────────────────────────────────────

## Parseller: sürülmüş toprak, karıklar, ekin (olgunlaştıkça uzar ve sararır), çalışan çiftçiler.
## Döner: tarlada çalışan figür sayısı (köydeki duranlardan düşülür).
func _tarlalar_kur() -> int:
	var sureler := oturum.ayarlar.bitki_sure_sozlugu()
	var ciftci_kalan := oturum.koy.sayi(&"ciftci")
	var calisan := 0
	if not oturum.tarlalar.parseller.is_empty():
		_isiklar.append(Dunya3B.mesale_kur(self, TARLA_KOK + Vector3(TARLA_ARALIK.x / 2.0, 0, TARLA_ARALIK.y), 3.0, 14.0))
	var toprak := Dunya3B.duz_malzeme(Color("#4a3826"))
	var karik := Dunya3B.duz_malzeme(Color("#2e2218"))
	for i in oturum.tarlalar.parseller.size():
		var p: Dictionary = oturum.tarlalar.parseller[i]
		var merkez := TARLA_KOK + Vector3((i % 2) * TARLA_ARALIK.x, 0, (i / 2) * TARLA_ARALIK.y)
		var zemin := MeshInstance3D.new()
		var pm := PlaneMesh.new()
		pm.size = TARLA_BOYUT
		zemin.mesh = pm
		zemin.position = merkez + Vector3(0, 0.02, 0)
		zemin.material_override = toprak
		add_child(zemin)
		for k in 7:
			var c := MeshInstance3D.new()
			var b := BoxMesh.new()
			b.size = Vector3(TARLA_BOYUT.x - 0.4, 0.06, 0.12)
			c.mesh = b
			c.position = merkez + Vector3(0, 0.04, -TARLA_BOYUT.y / 2.0 + 0.35 + k * 0.55)
			c.material_override = karik
			add_child(c)
		if p["bitki"] != "":
			_ekin_kur(merkez, String(p["bitki"]), Tarlalar.olgunluk(p, sureler))
			# Ekili parselde iki çiftçi çalışır (köyde çiftçi oldukça).
			for k in 2:
				if ciftci_kalan <= 0:
					break
				var f := Dunya3B.karakter("ciftci" if (i + k) % 2 == 0 else "ciftci_kadin")
				f.position = merkez + Vector3(-1.2 + k * 2.2, 0, -0.6 + k * 0.9)
				f.rotation.y = randf() * TAU
				add_child(f)
				f.calis(&"calis")
				ciftci_kalan -= 1
				calisan += 1
	return calisan


## Ekin: küçük koniler (tahıl) ya da yuvarlak öbekler (baklagil); boy ve renk olgunluğa göre.
func _ekin_kur(merkez: Vector3, bitki: String, olgunluk: float) -> void:
	var tahil := bitki == "bugday" or bitki == "arpa"
	var renk := Color("#4f7a3a").lerp(Color("#c9a646") if tahil else Color("#7a8f3c"), olgunluk)
	var mat := Dunya3B.duz_malzeme(renk)
	var mesh: Mesh
	if tahil:
		var c := CylinderMesh.new()
		c.top_radius = 0.0
		c.bottom_radius = 0.07
		c.height = 0.15 + 0.75 * olgunluk
		c.radial_segments = 4
		mesh = c
	else:
		var k := SphereMesh.new()
		k.radius = 0.12 + 0.12 * olgunluk
		k.height = (0.12 + 0.12 * olgunluk) * 1.4
		k.radial_segments = 6
		k.rings = 3
		mesh = k
	mesh.surface_set_material(0, mat)
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = mesh
	var sira := 7
	var sutun := 12
	mm.instance_count = sira * sutun
	var yukseklik := (0.15 + 0.75 * olgunluk) / 2.0 if tahil else 0.1
	for a in sira:
		for b in sutun:
			var x := -TARLA_BOYUT.x / 2.0 + 0.35 + b * (TARLA_BOYUT.x - 0.7) / (sutun - 1)
			var z := -TARLA_BOYUT.y / 2.0 + 0.35 + a * 0.55
			var t := Transform3D(Basis(Vector3.UP, randf() * TAU), merkez + Vector3(x + randf_range(-0.08, 0.08), yukseklik, z))
			mm.set_instance_transform(a * sutun + b, t)
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	add_child(mi)


# ─── Gezen köylüler ──────────────────────────────────────────────────────

## Nüfusla artan sayıda köylü yollarda dolaşır: kuyu, evler, pazar, kervansaray, tarlalar, kapı.
func _gezginler_kur() -> void:
	var adet := clampi(oturum.koy.toplam() / 3, 0, AZAMI_GEZGIN)
	if adet == 0:
		return
	var duraklar: Array[Vector3] = [Vector3(1.5, 0, 2.2), KAPI + Vector3(0, 0, 3.0)]
	for i in clampi(1 + oturum.koy.toplam() / 3, 1, 14):
		duraklar.append(_ev_konumu(i) * 0.82)
	if int(oturum.yapilar[&"pazar"]) > 0:
		duraklar.append(Vector3(6.0, 0, -3.5))
	if int(oturum.yapilar[&"kervansaray"]) > 0:
		duraklar.append(Vector3(-6.0, 0, -4.0))
	if not oturum.tarlalar.parseller.is_empty():
		duraklar.append(TARLA_KOK + Vector3(-3.0, 0, 5.0))
	var siniflar := ["ciftci", "esnaf", "asker", "ciftci_kadin"]
	for i in adet:
		var g := Dunya3B.karakter(siniflar[i % siniflar.size()])
		g.position = duraklar[i % duraklar.size()] + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
		add_child(g)
		_gezgin_dongu(g, duraklar, i)


func _gezgin_dongu(g: KarakterModel, duraklar: Array[Vector3], tohum: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1000 + tohum
	await get_tree().create_timer(rng.randf_range(0.2, 2.0)).timeout
	while is_instance_valid(g) and g.is_inside_tree():
		var hedef := duraklar[rng.randi_range(0, duraklar.size() - 1)] + Vector3(rng.randf_range(-1.2, 1.2), 0, rng.randf_range(-1.2, 1.2))
		await g.yuru(hedef, rng.randf_range(0.9, 1.3))
		if not is_instance_valid(g) or not g.is_inside_tree():
			return
		await get_tree().create_timer(rng.randf_range(1.0, 3.5)).timeout
