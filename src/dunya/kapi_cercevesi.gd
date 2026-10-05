## Kapının kendisi: bekçinin durduğu yerden görüntünün iki kenarını çerçeveler. Köyün sur seviyesiyle büyür:
##   0 — kaba kütük direkler, sırık kiriş, alçak örgü çit (köy yeni kurulmuş)
##   1 — kalın ahşap kapı, demir kuşaklar, iki yanda sivri kazık çit
##   2 — taş sur: yontma taş duvar, ahşap kapı çerçevesi ve demir lamalar
##   3 — yüksek taş sur, mazgallı duvar başı, kapı kulesi ve sancak
## Her seviyede iki yanda demir kollu meşale: kapının içi sıcak turuncu, dışarısı soğuk mavi kalır.
## Tasarım: design/gdd/kapi-manzarasi.md
class_name KapiCercevesi
extends Node3D

## Kapı açıklığının yarı genişliği ve kapı çizgisinin z'si (gelen z≈−2.5'te durur).
const YARI := 1.75
const Z := -1.2

var seviye := 0
## Meşale ışıkları (KapiSahnesi titretir).
var isiklar: Array[OmniLight3D] = []

var _ahsap: StandardMaterial3D
var _koyu_ahsap: StandardMaterial3D
var _demir: StandardMaterial3D
var _tas: StandardMaterial3D


func _ready() -> void:
	_ahsap = Dunya3B.duz_malzeme(Color("#4a3426"))
	_koyu_ahsap = Dunya3B.duz_malzeme(Color("#2e2119"))
	_demir = Dunya3B.duz_malzeme(Color("#2a2c30"))
	_demir.metallic = 0.6
	_demir.roughness = 0.5
	_tas = Dunya3B.duz_malzeme(Color("#4c4740"))
	match seviye:
		0:
			_kutuk_kapi()
		1:
			_ahsap_kapi()
		2:
			_tas_sur(4.2, false)
		_:
			_tas_sur(5.6, true)
	for yan in [-1.0, 1.0]:
		_mesale(Vector3(yan * (YARI - 0.3), 2.05, Z + 0.4), yan)
	_esik()
	_on_plan()


func _kutu(boyut: Vector3, konum: Vector3, mat: Material, donus := Vector3.ZERO) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var b := BoxMesh.new()
	b.size = boyut
	m.mesh = b
	m.position = konum
	m.rotation = donus
	m.material_override = mat
	add_child(m)
	return m


func _silindir(r: float, boy: float, konum: Vector3, mat: Material, donus := Vector3.ZERO) -> MeshInstance3D:
	var m := MeshInstance3D.new()
	var c := CylinderMesh.new()
	c.top_radius = r
	c.bottom_radius = r * 1.05
	c.height = boy
	c.radial_segments = 10
	m.mesh = c
	m.position = konum
	m.rotation = donus
	m.material_override = mat
	add_child(m)
	return m


# ── 0: kütük kapı ──
func _kutuk_kapi() -> void:
	for yan in [-1.0, 1.0]:
		_silindir(0.22, 4.0, Vector3(yan * YARI, 2.0, Z), _ahsap)
		# Alçak örgü çit (çubuklar + yatay sırıklar).
		for i in 10:
			var x: float = yan * (YARI + 0.5 + i * 0.45)
			_silindir(0.04, 1.3, Vector3(x, 0.65, Z + 0.1), _koyu_ahsap, Vector3(0, 0, yan * 0.05))
		for h in [0.45, 0.95]:
			_kutu(Vector3(4.6, 0.07, 0.07), Vector3(yan * (YARI + 2.5), h, Z + 0.1), _ahsap)
	_silindir(0.17, YARI * 2.0 + 0.9, Vector3(0, 3.35, Z), _ahsap, Vector3(0, 0, PI / 2.0))
	# Kirişe bağlı ip ve çaprazlama sırık: kaba ama tutuyor.
	for yan in [-1.0, 1.0]:
		_silindir(0.06, 1.3, Vector3(yan * (YARI - 0.45), 2.95, Z), _koyu_ahsap, Vector3(0, 0, yan * 0.8))


# ── 1: ahşap kapı + kazık çit ──
func _ahsap_kapi() -> void:
	for yan in [-1.0, 1.0]:
		_direk(yan, 4.6)
		_kanat(yan)
		var ornek := Dunya3B.nesne("kazik_cit", 3.6)
		var w := clampf(Dunya3B.boyut(ornek).x, 1.0, 6.0)
		ornek.free()
		for i in 5:
			var c := Dunya3B.nesne("kazik_cit", 3.6)
			c.position = Vector3(yan * (YARI + 0.35 + w / 2.0 + i * w * 0.95), 0, Z - 0.1)
			add_child(c)
	_kutu(Vector3(YARI * 2.0 + 1.2, 0.45, 0.55), Vector3(0, 3.45, Z), _ahsap)
	for x in [-1.2, 0.0, 1.2]:
		_kutu(Vector3(0.08, 0.47, 0.58), Vector3(x, 3.45, Z), _demir)
	_gecit(1.4, false)


# ── 2 ve 3: taş sur ──
func _tas_sur(boy: float, kuleli: bool) -> void:
	for yan in [-1.0, 1.0]:
		# Yontma taş duvar: sıra sıra, her sıra kaydırılmış bloklar (renk tonu hafifçe değişir).
		var sira := 0
		var y := 0.0
		while y < boy:
			var h := 0.42 + (sira % 3) * 0.06
			var x := YARI + 0.45 + (0.35 if sira % 2 == 1 else 0.0)
			while x < YARI + 12.0:
				var en := 0.8 + fmod(x * 1.7 + sira, 0.6)
				var ton := _tas.duplicate() as StandardMaterial3D
				ton.albedo_color = _tas.albedo_color.darkened(fmod(x * 0.37 + sira * 0.21, 0.22))
				_kutu(Vector3(en - 0.04, h - 0.04, 1.1), Vector3(yan * (x + en * 0.5), y + h * 0.5, Z - 0.2), ton)
				x += en
			y += h
			sira += 1
		_direk(yan, boy - 0.3)
		_kanat(yan)
		if kuleli:
			# Mazgallar ve kapının iki yanında çıkıntılı kule gövdesi.
			for i in 7:
				_kutu(Vector3(0.7, 0.7, 1.2), Vector3(yan * (YARI + 1.0 + i * 1.4), boy + 0.35, Z - 0.2), _tas)
			_kutu(Vector3(2.0, boy + 1.4, 2.2), Vector3(yan * (YARI + 1.6), (boy + 1.4) * 0.5, Z - 1.2), _tas)
	# Kapı üstü: taş kemer (kilit taşı ortada); 3'te kemerin üstünde kule duvarı ve sancak.
	_kemer(2.6 if not kuleli else 2.7)
	_kutu(Vector3(YARI * 2.0 + 1.4, boy - 3.6, 1.2), Vector3(0, 3.6 + (boy - 3.6) * 0.5 + 0.35, Z - 0.2), _tas)
	_gecit(1.3 if kuleli else 0.9, true)
	if kuleli:
		_kutu(Vector3(YARI * 2.0 + 1.4, 1.6, 1.2), Vector3(0, boy + 0.95, Z - 0.2), _tas)
		var sancak := _kutu(Vector3(0.9, 1.6, 0.04), Vector3(0, boy - 0.2, Z + 0.45), Dunya3B.duz_malzeme(Color("#6a1e1a")))
		sancak.rotation.x = 0.05


## Taş kemer: iki direğin üstünden yarım daire dizilmiş takozlar ve kilit taşı.
func _kemer(dogus: float) -> void:
	var adet := 11
	for i in adet:
		var a := PI * (i + 0.5) / adet
		var p := Vector3(cos(a) * YARI, dogus + sin(a) * YARI * 0.55, Z + 0.3)
		var ton := _tas.duplicate() as StandardMaterial3D
		ton.albedo_color = _tas.albedo_color.darkened(0.04 * (i % 3))
		var tas := _kutu(Vector3(0.5, 0.42, 0.7), p, ton)
		tas.rotation.z = a - PI / 2.0
	_kutu(Vector3(0.42, 0.55, 0.75), Vector3(0, dogus + YARI * 0.55 + 0.05, Z + 0.32), _tas)
	# Kemerin iki yanını dolduran duvar.
	for yan in [-1.0, 1.0]:
		_kutu(Vector3(1.0, 1.4, 0.7), Vector3(yan * (YARI + 0.1), dogus + 0.6, Z + 0.3), _tas)


## Kapı geçidi: direklerin ardında `derin` metre derinlikte yan duvarlar (açıklığın kenarlarından görünür).
func _gecit(derin: float, tas: bool) -> void:
	for yan in [-1.0, 1.0]:
		if tas:
			var y := 0.0
			var sira := 0
			while y < 3.6:
				var h := 0.42 + (sira % 3) * 0.07
				var z := Z - 0.05
				while z > Z - derin:
					var uzun := 0.55 + fmod(z * 3.1 + sira, 0.4)
					var ton := _tas.duplicate() as StandardMaterial3D
					ton.albedo_color = _tas.albedo_color.darkened(0.08 + fmod(z * 0.7 + sira * 0.3, 0.2))
					_kutu(Vector3(0.6, h - 0.04, uzun - 0.04), Vector3(yan * (YARI + 0.3), y + h * 0.5, z - uzun * 0.5), ton)
					z -= uzun
				y += h
				sira += 1
		else:
			var z := Z - 0.1
			while z > Z - derin:
				_silindir(0.16, 3.4 + fmod(z * 7.0, 0.5), Vector3(yan * (YARI + 0.05), 1.75, z - 0.16), _ahsap if int(z * 10) % 2 == 0 else _koyu_ahsap)
				z -= 0.32


func _direk(yan: float, boy: float) -> void:
	# Kalın kapı direği: dikey kalaslar (aralarında koyu derz) ve demir lamalar.
	for k in 3:
		_kutu(Vector3(0.18, boy, 0.6), Vector3(yan * (YARI - 0.18 + k * 0.185), boy * 0.5, Z), _ahsap if k % 2 == 0 else _koyu_ahsap)
	for h in [0.9, 2.4, boy - 0.6]:
		_kutu(Vector3(0.6, 0.1, 0.64), Vector3(yan * YARI, h, Z + 0.01), _demir)
		for c in [-0.2, 0.0, 0.2]:
			var civi := _kutu(Vector3(0.05, 0.05, 0.05), Vector3(yan * YARI + c, h, Z + 0.34), _demir)
			civi.scale = Vector3.ONE
	if seviye >= 2:
		# Taş söve: direğin iç yanında ve önünde kaba yontma bloklar (kenarı dişli).
		var y := 0.0
		var i := 0
		while y < 3.0:
			var h := 0.45 + (i % 2) * 0.12
			var en := 0.42 + (i % 3) * 0.1
			var ton := _tas.duplicate() as StandardMaterial3D
			ton.albedo_color = _tas.albedo_color.darkened(0.05 + (i % 4) * 0.05)
			_kutu(Vector3(en, h - 0.04, 0.3), Vector3(yan * (YARI - 0.3 + en * 0.5), y + h * 0.5, Z + 0.42), ton)
			y += h
			i += 1


func _kanat(yan: float) -> void:
	# İçe doğru açılmış kanat: kameranın yanında, görüntünün kenarını kapatır.
	var kanat := Node3D.new()
	# Kanat duvarın iç yüzüne yaslanmış (tam açık): direğin ardında kalır, görüşü kapatmaz.
	kanat.position = Vector3(yan * (YARI + 0.3), 0, Z + 0.45)
	add_child(kanat)
	for i in 4:
		var t := _kutu(Vector3(0.5, 3.9, 0.12), Vector3(yan * (0.27 + i * 0.5), 1.95, 0), _ahsap if i % 2 == 0 else _koyu_ahsap)
		remove_child(t)
		kanat.add_child(t)
	for h in [0.8, 3.0]:
		var l := _kutu(Vector3(2.0, 0.12, 0.16), Vector3(yan * 1.0, h, 0.03), _demir)
		remove_child(l)
		kanat.add_child(l)


func _mesale(konum: Vector3, yan: float) -> void:
	# Duvara demir kolla bağlı sepetli meşale.
	_kutu(Vector3(0.06, 0.06, 0.45), konum + Vector3(0, -0.35, -0.2), _demir, Vector3(-0.6, 0, 0))
	var sepet := MeshInstance3D.new()
	var c := CylinderMesh.new()
	c.top_radius = 0.09
	c.bottom_radius = 0.05
	c.height = 0.16
	c.radial_segments = 8
	sepet.mesh = c
	sepet.position = konum
	sepet.material_override = _demir
	add_child(sepet)
	var alev := Node3D.new()
	alev.position = konum + Vector3(0, 0.1, 0)
	add_child(alev)
	for katman in [[0.075, 0.3, Dunya3B.MESALE_ALEV_DIS, 2.6], [0.04, 0.18, Dunya3B.MESALE_ALEV_IC, 3.2]]:
		var mi := MeshInstance3D.new()
		var koni := CylinderMesh.new()
		koni.top_radius = 0.0
		koni.bottom_radius = katman[0]
		koni.height = katman[1]
		koni.radial_segments = 8
		mi.mesh = koni
		mi.position.y = katman[1] / 2.0
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color.BLACK
		mat.emission_enabled = true
		mat.emission = katman[2]
		mat.emission_energy_multiplier = katman[3]
		mi.material_override = mat
		alev.add_child(mi)
	var isik := OmniLight3D.new()
	isik.light_color = Renkler.MESALE
	isik.light_energy = 1.9
	isik.omni_range = 9.0
	isik.omni_attenuation = 1.3
	isik.shadow_enabled = true
	isik.position = konum + Vector3(yan * -0.3, 0.5, -0.5)
	isik.set_meta("taban", 1.9)
	isik.set_meta("alev", alev)
	add_child(isik)
	isiklar.append(isik)


func _esik() -> void:
	# Kapı eşiği: kalas döşeme ve yassı taşlar (sorgu alanının önü).
	for i in 6:
		_kutu(Vector3(0.55, 0.06, 2.2), Vector3(-1.4 + i * 0.56, 0.03, Z - 0.6), _koyu_ahsap if i % 2 == 0 else _koyu_ahsap.duplicate())
	var r := RandomNumberGenerator.new()
	r.seed = 5
	for i in 14:
		var x := r.randf_range(-1.6, 1.6)
		var z := r.randf_range(-5.5, -2.0)
		var tas := _kutu(Vector3(r.randf_range(0.4, 0.8), 0.05, r.randf_range(0.3, 0.6)), Vector3(x, 0.03, z), _tas)
		tas.rotation.y = r.randf() * PI


func _on_plan() -> void:
	# Kapının içinde, iki kenarda: fıçı, sandık, testi (ön plan yüksek ayrıntı; sorgu alanından uzakta).
	var ahsap := _ahsap
	_silindir(0.3, 0.8, Vector3(-YARI + 0.05, 0.4, Z + 0.9), ahsap)
	for h in [0.12, 0.68]:
		_silindir(0.32, 0.05, Vector3(-YARI + 0.05, h, Z + 0.9), _demir)
	_kutu(Vector3(0.6, 0.5, 0.5), Vector3(YARI + 0.2, 0.25, Z + 0.9), _koyu_ahsap, Vector3(0, 0.3, 0))
	var testi := Dunya3B.duz_malzeme(Color("#6e3f26"))
	var govde := MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 0.24
	k.height = 0.55
	govde.mesh = k
	govde.position = Vector3(YARI - 0.25, 0.27, Z + 0.6)
	govde.material_override = testi
	add_child(govde)
	_silindir(0.07, 0.16, Vector3(YARI - 0.25, 0.6, Z + 0.6), testi)
