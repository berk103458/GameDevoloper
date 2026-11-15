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
var _esik_yuzeyleri: Array[MeshInstance3D] = []

var _ahsap: StandardMaterial3D
var _koyu_ahsap: StandardMaterial3D
var _demir: StandardMaterial3D
var _tas: StandardMaterial3D
var _kutuk: StandardMaterial3D


func _ready() -> void:
	# Taranmış dokular (Poly Haven, CC0): kapı ahşabı ve sur taşı 4K, kütük kabuğu 2K.
	_ahsap = Pbr.malzeme("medieval_wood", 1.3, Color(0.78, 0.7, 0.62))
	_koyu_ahsap = Pbr.malzeme("medieval_wood", 1.3, Color(0.48, 0.42, 0.38))
	_kutuk = Pbr.malzeme("bark_willow", 1.1, Color(0.7, 0.66, 0.62))
	_demir = StandardMaterial3D.new()
	_demir.albedo_color = Color("#2a2a2c")
	_demir.metallic = 0.5
	_demir.roughness = 0.75
	_tas = Pbr.malzeme("castle_wall_varriation", 2.4, Color(0.82, 0.8, 0.78))
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
		_mesale(Vector3(yan * (YARI - 0.3), 2.05, Z + (0.85 if seviye <= 1 and Dunya3B.model_var_mi("kapi_ic", "yapi") else 0.4)), yan)
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
func _kapi_ic_kur(yukseklik: float) -> void:
	var k := Dunya3B.nesne("kapi_ic", yukseklik, "yapi")
	k.position = Vector3(0, 0, Z - 0.15)
	add_child(k)


func _kutuk_kapi() -> void:
	if Dunya3B.model_var_mi("kapi_ic", "yapi"):
		_kapi_ic_kur(4.9)
		for yan in [-1.0, 1.0]:
			for i in 6:
				var x: float = yan * (4.0 + i * 0.45)
				_silindir(0.04, 1.3, Vector3(x, 0.65, Z + 0.1), _kutuk, Vector3(0, 0, yan * 0.05))
			for h in [0.45, 0.95]:
				_kutu(Vector3(2.8, 0.07, 0.07), Vector3(yan * 5.2, h, Z + 0.1), _ahsap)
		return
	for yan in [-1.0, 1.0]:
		_silindir(0.22, 4.0, Vector3(yan * YARI, 2.0, Z), _kutuk)
		# Alçak örgü çit (çubuklar + yatay sırıklar).
		for i in 10:
			var x: float = yan * (YARI + 0.5 + i * 0.45)
			_silindir(0.04, 1.3, Vector3(x, 0.65, Z + 0.1), _kutuk, Vector3(0, 0, yan * 0.05))
		for h in [0.45, 0.95]:
			_kutu(Vector3(4.6, 0.07, 0.07), Vector3(yan * (YARI + 2.5), h, Z + 0.1), _ahsap)
	_silindir(0.17, YARI * 2.0 + 0.9, Vector3(0, 3.35, Z), _kutuk, Vector3(0, 0, PI / 2.0))
	# Kirişe bağlı ip ve çaprazlama sırık: kaba ama tutuyor.
	for yan in [-1.0, 1.0]:
		_silindir(0.06, 1.3, Vector3(yan * (YARI - 0.45), 2.95, Z), _koyu_ahsap, Vector3(0, 0, yan * 0.8))


# ── 1: ahşap kapı + kazık çit ──
func _ahsap_kapi() -> void:
	if Dunya3B.model_var_mi("kapi_ic", "yapi"):
		_kapi_ic_kur(5.4)
		for yan in [-1.0, 1.0]:
			var ornek := Dunya3B.nesne("kazik_cit", 3.6)
			var w := clampf(Dunya3B.boyut(ornek).x, 1.0, 6.0)
			ornek.free()
			for i in 4:
				var c := Dunya3B.nesne("kazik_cit", 3.6)
				c.position = Vector3(yan * (4.1 + w / 2.0 + i * w * 0.95), 0, Z - 0.1)
				add_child(c)
		return
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
		# Sur duvarı: taş dokulu kalın gövde (dokuda taşlar zaten var; blok blok örmek gerekmez).
		_kutu(Vector3(10.0, boy, 1.1), Vector3(yan * (YARI + 0.45 + 5.0), boy * 0.5, Z - 0.2), _tas)
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
			# Geçit duvarı: tek taş gövde; ağzında hafif içeri çekilmiş bir sıra blok (kalınlık okunsun).
			_kutu(Vector3(0.7, 3.8, derin), Vector3(yan * (YARI + 0.35), 1.9, Z - derin * 0.5), _tas)
			var y := 0.0
			while y < 3.4:
				var h := 0.5 + fmod(y * 3.7, 0.25)
				_kutu(Vector3(0.18, h - 0.03, 0.55), Vector3(yan * (YARI + 0.02), y + h * 0.5, Z - 0.3), _tas)
				y += h
		else:
			var z := Z - 0.1
			while z > Z - derin:
				_silindir(0.16, 3.4 + fmod(z * 7.0, 0.5), Vector3(yan * (YARI + 0.05), 1.75, z - 0.16), _kutuk)
				z -= 0.32


func _direk(yan: float, boy: float) -> void:
	# Kalın kapı direği: dikey kalaslar (aralarında koyu derz) ve demir lamalar.
	for k in 3:
		_kutu(Vector3(0.18, boy, 0.6), Vector3(yan * (YARI - 0.18 + k * 0.185), boy * 0.5, Z), _ahsap if k % 2 == 0 else _koyu_ahsap)
	for h in [0.9, 2.4, boy - 0.6]:
		_kutu(Vector3(0.57, 0.08, 0.62), Vector3(yan * YARI, h, Z + 0.01), _demir)
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
	# Kale kapısının kanadı (Poly Haven `large_castle_door`): içe doğru tam açık, geçidin iç yüzüne yaslı.
	var model := Pbr.model("large_castle_door")
	if model != null:
		for c in model.get_children():
			var ad := String(c.name)
			if not ad.ends_with("_left" if yan < 0.0 else "_right"):
				c.queue_free()
		model.scale = Vector3(1.7, 1.2, 1.3)
		model.position = Vector3(yan * (YARI + 0.1), 0, Z + 0.25)
		model.rotation.y = yan * -1.5
		add_child(model)
		return
	# Model yoksa: kalaslardan kanat.
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
	# Alev: parçacık (yumuşak, titreşen); sepetin içinde küçük kor.
	var alev := Node3D.new()
	alev.position = KapiKuyuAyari.alev_konumu(konum)
	add_child(alev)
	for k in 2:
		var dil := KapiManzarasi.alev(0.42 - k * 0.12, 3.0 - k * 0.6, yan * 5.0 + k * 2.3)
		dil.position = Vector3((k - 0.5) * 0.03, 0, 0)
		alev.add_child(dil)
	var kor := MeshInstance3D.new()
	var kk := SphereMesh.new()
	kk.radius = 0.07
	kk.height = 0.08
	kor.mesh = kk
	kor.position = konum + Vector3(0, 0.07, 0)
	var km := StandardMaterial3D.new()
	km.albedo_color = Color.BLACK
	km.emission_enabled = true
	km.emission = Color("#ff8a2a")
	km.emission_energy_multiplier = 3.0
	kor.material_override = km
	add_child(kor)
	var isik := OmniLight3D.new()
	isik.light_color = Renkler.MESALE
	var ayar: Dictionary = preload("res://data/ayarlar/sahne.json").data.kapi_isik
	isik.light_energy = float(ayar.enerji)
	isik.omni_range = float(ayar.menzil)
	isik.omni_attenuation = 1.3
	isik.shadow_enabled = true
	# Hacimsel siste hafif sıcak hale: kamera ışığa çok yakın, tam güçte sis küresi ekranı kaplar.
	isik.light_volumetric_fog_energy = 0.12
	isik.set_meta("taban", isik.light_energy)
	isik.set_meta("alev", alev)
	add_child(isik)
	KapiKuyuAyari.sokete_bagla(isik, alev)
	isiklar.append(isik)


func _esik() -> void:
	# Kapı eşiği: kalas döşeme ve yassı taşlar (sorgu alanının önü).
	for i in 6:
		var k := _kutu(Vector3(0.53, 0.07, 2.2), Vector3(-1.4 + i * 0.56, 0.035 + (i % 2) * 0.008, Z - 0.6), _koyu_ahsap)
		k.rotation.y = (i % 3 - 1) * 0.015
		_esik_yuzeyleri.append(k)
	var r := RandomNumberGenerator.new()
	r.seed = 5
	for i in 14:
		var x := r.randf_range(-1.6, 1.6)
		var z := r.randf_range(-5.5, -2.0)
		var tas := _kutu(Vector3(r.randf_range(0.4, 0.8), 0.06, r.randf_range(0.3, 0.6)), Vector3(x, 0.02, z), _tas)
		tas.rotation.y = r.randf() * PI
		_esik_yuzeyleri.append(tas)


## Mevcut eşik geometrisinin üst yüzeyini okur.
func esik_yuksekligi(konum: Vector3) -> float:
	var yukseklik := -INF
	for yuzey in _esik_yuzeyleri:
		var nokta := yuzey.to_local(konum)
		var sinir := yuzey.get_aabb()
		if nokta.x >= sinir.position.x and nokta.x <= sinir.end.x and nokta.z >= sinir.position.z and nokta.z <= sinir.end.z:
			nokta.y = sinir.end.y
			yukseklik = maxf(yukseklik, yuzey.to_global(nokta).y)
	return yukseklik


func _on_plan() -> void:
	# Kapının içinde, iki kenarda: fıçılar ve sandık (Poly Haven modelleri), testi. Sorgu alanından uzakta.
	var fici := Pbr.model("wooden_barrels_01")
	if fici != null:
		for c in fici.get_children():
			if not String(c.name).ends_with("barrel01"):
				c.queue_free()
			else:
				# Takımdaki konumu sıfırlanır: fıçı kendi yerinde (kapının sol dibinde) durur.
				(c as Node3D).position = Vector3((c as Node3D).position.x * 0.0, (c as Node3D).position.y, 0)
		fici.position = Vector3(-YARI + 0.35, 0, Z + 0.55)
		fici.rotation.y = 0.4
		add_child(fici)
	var sandik := Pbr.model("wooden_crate_01")
	if sandik != null:
		sandik.position = Vector3(YARI - 0.35, 0, Z + 0.9)
		sandik.rotation.y = -0.5
		sandik.scale = Vector3.ONE * 1.1
		add_child(sandik)
	var testi := Dunya3B.duz_malzeme(Color("#6e3f26"))
	testi.roughness = 0.85
	var govde := MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 0.2
	k.height = 0.46
	govde.mesh = k
	govde.position = Vector3(YARI - 0.95, 0.23, Z + 0.5)
	govde.material_override = testi
	add_child(govde)
	_silindir(0.06, 0.14, Vector3(YARI - 0.95, 0.5, Z + 0.5), testi)
