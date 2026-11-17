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
		var m_kon := Vector3(yan * 1.85, 2.05, 0.22) if (seviye <= 1 and Dunya3B.model_var_mi("kapi_ic", "yapi")) else Vector3(yan * (YARI - 0.30), 2.05, Z + 0.96)
		_mesale(m_kon, yan)
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
				var x: float = yan * (4.05 + i * 0.45)
				_silindir(0.04, 1.3, Vector3(x, 0.65, Z + 0.08), _kutuk, Vector3(0, 0, yan * 0.05))
			for h in [0.45, 0.95]:
				_kutu(Vector3(2.8, 0.07, 0.07), Vector3(yan * 5.2, h, Z + 0.20), _ahsap)
		return
	for yan in [-1.0, 1.0]:
		_silindir(0.22, 4.0, Vector3(yan * YARI, 2.0, Z), _kutuk)
		# Alçak örgü çit (çubuklar + yatay sırıklar — çakışmasız ayrılmış).
		for i in 10:
			var x: float = yan * (YARI + 0.5 + i * 0.45)
			_silindir(0.04, 1.3, Vector3(x, 0.65, Z + 0.06), _kutuk, Vector3(0, 0, yan * 0.05))
		for h in [0.45, 0.95]:
			_kutu(Vector3(4.6, 0.07, 0.07), Vector3(yan * (YARI + 2.5), h, Z + 0.18), _ahsap)
	_silindir(0.17, YARI * 2.0 + 0.3, Vector3(0, 4.18, Z), _kutuk, Vector3(0, 0, PI / 2.0))
	for yan in [-1.0, 1.0]:
		_silindir(0.06, 0.75, Vector3(yan * (YARI - 0.55), 3.65, Z), _koyu_ahsap, Vector3(0, 0, yan * 0.75))


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
				c.position = Vector3(yan * (4.15 + w / 2.0 + i * (w + 0.05)), 0, Z - 0.1)
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
			c.position = Vector3(yan * (YARI + 0.45 + w / 2.0 + i * (w + 0.05)), 0, Z - 0.1)
			add_child(c)
	_kutu(Vector3(YARI * 2.0 + 0.6, 0.45, 0.55), Vector3(0, 4.85, Z), _ahsap)
	for x in [-1.2, 0.0, 1.2]:
		_kutu(Vector3(0.08, 0.47, 0.05), Vector3(x, 4.85, Z + 0.31), _demir)
	_gecit(1.4, false)


# ── 2 ve 3: taş sur ──
func _tas_sur(boy: float, kuleli: bool) -> void:
	var direk_boy := 3.9
	for yan in [-1.0, 1.0]:
		# Sur duvarı: kapı direği / kuleden temiz ayrı başlar.
		var duvar_bas := YARI + (2.65 if kuleli else 0.72)
		_kutu(Vector3(9.0, boy, 1.1), Vector3(yan * (duvar_bas + 4.5), boy * 0.5, Z - 0.35), _tas)
		_direk(yan, direk_boy)
		_kanat(yan)
		if kuleli:
			for i in 6:
				_kutu(Vector3(0.7, 0.65, 1.1), Vector3(yan * (duvar_bas + 0.6 + i * 1.4), boy + 0.35, Z - 0.35), _tas)
			_kutu(Vector3(1.85, boy + 1.4, 2.0), Vector3(yan * (YARI + 1.65), (boy + 1.4) * 0.5, Z - 0.8), _tas)
	_kemer(direk_boy + 0.05)
	_gecit(1.25 if kuleli else 0.9, true)
	if kuleli:
		_kutu(Vector3(YARI * 2.0 + 0.6, 1.2, 1.0), Vector3(0, boy + 0.75, Z - 0.35), _tas)
		if Dunya3B.model_var_mi("sancak"):
			var s := Dunya3B.nesne("sancak", 1.8)
			s.position = Vector3(0, boy + 1.4, Z - 0.35)
			add_child(s)
		else:
			var sancak := _kutu(Vector3(0.9, 1.6, 0.04), Vector3(0, boy + 2.2, Z - 0.35), Dunya3B.duz_malzeme(Color("#6a1e1a")))
			sancak.rotation.x = 0.05


## Taş kemer: iki direğin üstünden üst üste binmeden dizilen takozlar ve kilit taşı.
func _kemer(dogus: float) -> void:
	var adet := 9
	for i in adet:
		if i == 4:
			continue
		var a := PI * (i + 0.5) / adet
		var p := Vector3(cos(a) * YARI * 0.96, dogus + sin(a) * YARI * 0.68, Z + 0.25)
		var ton := _tas.duplicate() as StandardMaterial3D
		ton.albedo_color = _tas.albedo_color.darkened(0.04 * (i % 3))
		var tas := _kutu(Vector3(0.24, 0.24, 0.45), p, ton)
		tas.rotation.z = a - PI / 2.0
	_kutu(Vector3(0.32, 0.38, 0.50), Vector3(0, dogus + YARI * 0.72, Z + 0.25), _tas)


## Kapı geçidi: direklerin ardında `derin` metre derinlikte yan duvarlar (çakışmasız başlar).
func _gecit(derin: float, tas: bool) -> void:
	var bas_z := Z - 0.34
	for yan in [-1.0, 1.0]:
		if tas:
			_kutu(Vector3(0.65, 3.8, derin), Vector3(yan * (YARI + 0.35), 1.9, bas_z - derin * 0.5), _tas)
			var y := 0.0
			while y < 3.4:
				var h := 0.48 + fmod(y * 3.7, 0.22)
				_kutu(Vector3(0.16, h - 0.04, 0.45), Vector3(yan * (YARI - 0.10), y + h * 0.5, bas_z - 0.28), _tas)
				y += h
		else:
			var z := bas_z - 0.18
			while z > bas_z - derin:
				_silindir(0.14, 3.4 + fmod(absf(z) * 7.0, 0.4), Vector3(yan * (YARI + 0.12), 1.75, z), _kutuk)
				z -= 0.34


func _direk(yan: float, boy: float) -> void:
	# Kalın kapı direği: dikey kalaslar ve ön yüzde çakışmasız demir lamalar + çiviler.
	for k in 3:
		_kutu(Vector3(0.175, boy, 0.58), Vector3(yan * (YARI - 0.18 + k * 0.185), boy * 0.5, Z), _ahsap if k % 2 == 0 else _koyu_ahsap)
	for h in [0.9, 2.4, boy - 0.6]:
		_kutu(Vector3(0.57, 0.08, 0.04), Vector3(yan * YARI, h, Z + 0.32), _demir)
		for c in [-0.2, 0.0, 0.2]:
			var civi := _kutu(Vector3(0.04, 0.04, 0.03), Vector3(yan * YARI + c, h, Z + 0.365), _demir)
			civi.scale = Vector3.ONE
	if seviye >= 2:
		var y := 0.0
		var i := 0
		while y < 3.0:
			var h := 0.44 + (i % 2) * 0.10
			var en := 0.36 + (i % 3) * 0.08
			var ton := _tas.duplicate() as StandardMaterial3D
			ton.albedo_color = _tas.albedo_color.darkened(0.05 + (i % 4) * 0.05)
			_kutu(Vector3(en, h - 0.05, 0.24), Vector3(yan * (YARI - 0.30 + en * 0.5), y + h * 0.5, Z + 0.52), ton)
			y += h + 0.02
			i += 1


func _kanat(yan: float) -> void:
	# Kale kapısının kanadı (Poly Haven `large_castle_door`): tam açık, geçidin iç yan duvarına yaslı.
	var model := Pbr.model("large_castle_door")
	if model != null:
		for c in model.get_children():
			var ad := String(c.name)
			if not ad.ends_with("_left" if yan < 0.0 else "_right"):
				c.queue_free()
		model.scale = Vector3(0.95, 1.15, 0.95)
		model.position = Vector3(yan * (YARI - 0.43), 0, Z - 0.42)
		model.rotation.y = yan * 1.56
		add_child(model)
		return
	# Model yoksa: kalaslardan kanat.
	var kanat := Node3D.new()
	kanat.position = Vector3(yan * (YARI + 0.3), 0, Z + 0.72)
	add_child(kanat)
	for i in 4:
		var t := _kutu(Vector3(0.48, 3.8, 0.12), Vector3(yan * (0.27 + i * 0.5), 1.9, 0), _ahsap if i % 2 == 0 else _koyu_ahsap)
		remove_child(t)
		kanat.add_child(t)
	for h in [0.8, 3.0]:
		var l := _kutu(Vector3(1.9, 0.12, 0.04), Vector3(yan * 1.0, h, 0.09), _demir)
		remove_child(l)
		kanat.add_child(l)


func _mesale(konum: Vector3, yan: float) -> void:
	# Tek birleşik meşale grubu (kol + sepet + kor + alev tek düğümde, dış duvarla çakışmaz).
	var grup := Node3D.new()
	grup.name = "kapi_mesale_" + ("sol" if yan < 0.0 else "sag")
	add_child(grup)
	var kol := MeshInstance3D.new()
	var kb := BoxMesh.new()
	kb.size = Vector3(0.06, 0.06, 0.26)
	kol.mesh = kb
	kol.position = konum + Vector3(0, -0.22, -0.14)
	kol.rotation = Vector3(-0.6, 0, 0)
	kol.material_override = _demir
	grup.add_child(kol)
	var sepet := MeshInstance3D.new()
	var c := CylinderMesh.new()
	c.top_radius = 0.09
	c.bottom_radius = 0.05
	c.height = 0.16
	c.radial_segments = 8
	sepet.mesh = c
	sepet.position = konum
	sepet.material_override = _demir
	grup.add_child(sepet)
	# Alev: parçacık (yumuşak, titreşen); sepetin içinde küçük kor.
	var alev := Node3D.new()
	alev.position = KapiKuyuAyari.alev_konumu(konum)
	grup.add_child(alev)
	for k in 2:
		var dil := KapiManzarasi.alev(0.42 - k * 0.12, 3.0 - k * 0.6, yan * 5.0 + k * 2.3)
		dil.position = Vector3((k - 0.5) * 0.03, 0, 0)
		alev.add_child(dil)
	var kor := MeshInstance3D.new()
	var kk := SphereMesh.new()
	kk.radius = 0.07
	kk.height = 0.08
	kor.mesh = kk
	kor.position = konum + Vector3(0, 0.12, 0)
	var km := StandardMaterial3D.new()
	km.albedo_color = Color.BLACK
	km.emission_enabled = true
	km.emission = Color("#ff8a2a")
	km.emission_energy_multiplier = 3.0
	kor.material_override = km
	grup.add_child(kor)
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
	# Kapının iç avlusunda çakışmasız yan yerleşimler (kapi_ic z_max=-0.048 önü, yaya yolu dışı).
	var fici := Pbr.model("wooden_barrels_01")
	if fici != null:
		for c in fici.get_children():
			if not String(c.name).ends_with("barrel01"):
				c.queue_free()
			else:
				(c as Node3D).position = Vector3(0.0, (c as Node3D).position.y, 0.0)
		fici.position = Vector3(-2.65, 0.0, 0.55)
		fici.rotation.y = 0.4
		add_child(fici)
	var sandik := Pbr.model("wooden_crate_01")
	if sandik != null:
		sandik.position = Vector3(1.62, 0.02, 0.45)
		sandik.rotation.y = -0.3
		sandik.scale = Vector3.ONE * 1.05
		add_child(sandik)
	var testi_grup := Node3D.new()
	testi_grup.name = "testi"
	testi_grup.position = Vector3(0.80, 0.0, 0.28)
	add_child(testi_grup)
	var testi := Dunya3B.duz_malzeme(Color("#6e3f26"))
	testi.roughness = 0.85
	var govde := MeshInstance3D.new()
	var k := SphereMesh.new()
	k.radius = 0.2
	k.height = 0.46
	govde.mesh = k
	govde.position = Vector3(0.0, 0.23, 0.0)
	govde.material_override = testi
	testi_grup.add_child(govde)
	var boyun := MeshInstance3D.new()
	var bc := CylinderMesh.new()
	bc.top_radius = 0.06
	bc.bottom_radius = 0.063
	bc.height = 0.12
	bc.radial_segments = 10
	boyun.mesh = bc
	boyun.position = Vector3(0.0, 0.52, 0.0)
	boyun.material_override = testi
	testi_grup.add_child(boyun)
	if Dunya3B.model_var_mi("nobet_ocagi"):
		var ocak := Dunya3B.nesne("nobet_ocagi", 0.85)
		ocak.position = Vector3(-1.35, 0.0, 0.75)
		add_child(ocak)
	if Dunya3B.model_var_mi("mizrak_sehpasi"):
		var sehpa := Dunya3B.nesne("mizrak_sehpasi", 1.5)
		sehpa.position = Vector3(2.98, 0.0, 1.05)
		sehpa.rotation.y = 0.0
		add_child(sehpa)
