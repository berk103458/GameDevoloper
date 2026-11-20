## Köy arazisi (görsel tasarım md, madde 1–3): splat maskeli zemin, köyün dışında yumuşak tepeler, kapıdan güneye
## toprak yol, rüzgârlı çimen tutamları ve impostor ağaçlardan orman kuşağı. Zemin, çimen ve ağaç yüksekliği tek bir
## formülden (`yukseklik`) gelir; köyün ızgarası düzdür (fareyle hücre seçimi y = 0 düzlemini kullanır).
## Yapı ya da yol değişince yalnız maske yeniden çizilir (`maske_guncelle`); çimen ve ağaçlar yeniden dizilmez.
class_name KoyArazisi
extends Node3D

const ZEMIN_BOYU := 240.0
const ZEMIN_BOLUM := 128
## Maske, ızgaranın her yanından bu kadar hücre taşar (kapı yolu ve ızgara kenarı çiğnenmişliği için).
const MASKE_TASMA := 12
## Maske hücre başına 1 pikselden bu kata yumuşatılarak büyütülür (organik kenar).
const MASKE_BUYUTME := 8
## Düzlük ve tepe yarıçapı (m): ızgara 48 m, kenarında 8 m düz pay.
const DUZLUK := 32.0
const TEPE := 70.0
const ORMAN_BAS := 33.0
const ORMAN_SON := 110.0
const AGAC_SAYISI := 1100
const TUTAM_SAYISI := 12000
## Çimen tutamları bu uzaklıktan sonra seyrelir (sert bir kare sınır görünmesin).
const CIMEN_SEYREL := 24.0
## Atlas hücreleri: 0–3 köknar, 4–7 yapraklı (tools/varlik/orman_pisir.gd).
const ATLAS := "res://assets/ph/impostor/orman_atlas"
const ARAZI := preload("res://src/koy/gorsel/spatial_env_arazi.gdshader")
const ORMAN := preload("res://src/koy/gorsel/spatial_env_orman.gdshader")
const CIMEN := preload("res://src/koy/gorsel/spatial_env_cimen.gdshader")

var sahne: KoyYonetimSahnesi
## Kapı yolunun x'i ve kapının z'si (dünya, m).
var kapi_x := 0.0
var kapi_z := 0.0
var _maske := ImageTexture.new()
var _maske_alani := Vector4.ZERO
var _zemin_mat: ShaderMaterial
var _cimen_mat: ShaderMaterial


## Araziyi kurar; `sahne` ızgara ↔ dünya dönüşümü ve köy yönetimi için gerekir.
func kur(s: KoyYonetimSahnesi, kapi: Vector2) -> void:
	sahne = s
	kapi_x = kapi.x
	kapi_z = kapi.y
	var kose := sahne.hucre_kosesi(Vector2i(-MASKE_TASMA, -MASKE_TASMA))
	var boy := (sahne.yonetim.a.izgara_boyut.x + MASKE_TASMA * 2) * KoyYonetimSahnesi.HUCRE
	_maske_alani = Vector4(kose.x, kose.z, boy, 0.0)
	var gurultu := NoiseTexture2D.new()
	gurultu.seamless = true
	gurultu.width = 256
	gurultu.height = 256
	gurultu.generate_mipmaps = true
	var fn := FastNoiseLite.new()
	fn.seed = 7
	fn.frequency = 0.02
	fn.fractal_octaves = 3
	gurultu.noise = fn
	maske_guncelle()
	_zemin_kur(gurultu)
	_cimen_kur()
	_orman_kur()
	KoyZemini.kur(self)
	KoySerpintisi.kur(self)


## Arazi yüksekliği (m); köyün ızgarası ve kapı yolu düzdür. Şader (spatial_env_arazi) aynı formülü kullanır.
static func yukseklik(x: float, z: float, yol_x: float, kapi: float) -> float:
	var r := maxf(absf(x), absf(z))
	var k := smoothstep(DUZLUK, TEPE, r)
	if z > kapi:
		k *= smoothstep(3.0, 9.0, absf(x - yol_x - sin((z - kapi) * 0.05) * 4.0))
	var n := sin(x * 0.045 + 1.3) * cos(z * 0.038 - 0.7) + sin(x * 0.11 + z * 0.07) * 0.45 + cos(z * 0.13 - x * 0.05) * 0.3
	return k * (2.2 + n * 2.6)


func yukseklik_burada(x: float, z: float) -> float:
	return yukseklik(x, z, kapi_x, kapi_z)


## Mevsim görünümü: 0 taze yeşil … 1 kuru ve soluk.
func kuruluk_ayarla(k: float) -> void:
	if _zemin_mat != null:
		_zemin_mat.set_shader_parameter("kuruluk", k)
		_cimen_mat.set_shader_parameter("kuruluk", k)


## Splat maskesini ızgaradan yeniden çizer: R patika (yol, meydan), G çamur (kuyu, yol çukurları), B çiğnenmiş
## toprak (yapı ve yol çevresi), A çimen yok (yapı ve tarla altı).
func maske_guncelle() -> void:
	var y := sahne.yonetim
	var n := y.a.izgara_boyut.x + MASKE_TASMA * 2
	var img := Image.create_empty(n, n, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var yaz := func(h: Vector2i, kanal: int, deger: float) -> void:
		var p := h + Vector2i(MASKE_TASMA, MASKE_TASMA)
		if p.x < 0 or p.y < 0 or p.x >= n or p.y >= n:
			return
		var c := img.get_pixelv(p)
		c[kanal] = maxf(c[kanal], deger)
		img.set_pixelv(p, c)
	var komsular: Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1)]
	for h in y.izgara.yollar:
		yaz.call(h, 0, 1.0)
		# Yol çukurlarında çamur (hücreye bağlı sabit rastlantı: her yenilemede aynı).
		if absi(h.x * 73856093 ^ h.y * 19349663) % 100 < 12:
			yaz.call(h, 1, 0.65)
		for k in komsular:
			yaz.call(h + k, 2, 0.35)
	var m := y.a.meydan
	for i in m.size.x:
		for j in m.size.y:
			yaz.call(m.position + Vector2i(i, j), 0, 1.0)
	for i in range(-1, m.size.x + 1):
		for j in range(-1, m.size.y + 1):
			yaz.call(m.position + Vector2i(i, j), 2, 0.6)
	# Kuyu başı ıslak (KoyYonetimSahnesi kuyuyu meydanın sol üst çeyreğine koyar).
	yaz.call(m.position, 1, 0.8)
	yaz.call(m.position + Vector2i(1, 0), 1, 0.5)
	yaz.call(m.position + Vector2i(0, 1), 1, 0.5)
	for b in y.binalar:
		var boy := b.boyut(y.katalog)
		var tarla := b.tur in ["tarla", "bostan"]
		for i in range(-1, boy.x + 1):
			for j in range(-1, boy.y + 1):
				var h := b.hucre + Vector2i(i, j)
				var ic := i >= 0 and j >= 0 and i < boy.x and j < boy.y
				if ic:
					yaz.call(h, 3, 1.0)
					if not tarla:
						yaz.call(h, 2, 0.8)
				else:
					yaz.call(h, 2, 0.3 if tarla else 0.5)
	img.resize(n * MASKE_BUYUTME, n * MASKE_BUYUTME, Image.INTERPOLATE_CUBIC)
	if _maske.get_image() != null and _maske.get_size() == Vector2(img.get_size()):
		_maske.update(img)
	else:
		_maske.set_image(img)


func _zemin_kur(gurultu: NoiseTexture2D) -> void:
	var p := PlaneMesh.new()
	p.size = Vector2(ZEMIN_BOYU, ZEMIN_BOYU)
	p.subdivide_width = ZEMIN_BOLUM - 1
	p.subdivide_depth = ZEMIN_BOLUM - 1
	var z := MeshInstance3D.new()
	z.name = &"zemin_eski"
	z.mesh = p
	# Köşeler şaderde yükselir: görünürlük kutusu tepeleri de kapsasın.
	z.extra_cull_margin = 12.0
	_zemin_mat = ShaderMaterial.new()
	_zemin_mat.shader = ARAZI
	for d in [["cimen", "sparse_grass"], ["patika", "rocky_trail"], ["camur", "muddy_tracks"], ["toprak", "brown_mud_leaves_01"]]:
		_zemin_mat.set_shader_parameter("doku_" + d[0], Pbr.doku(d[1], "diff"))
		_zemin_mat.set_shader_parameter("normal_" + d[0], Pbr.doku(d[1], "nor_gl"))
	_zemin_mat.set_shader_parameter("maske_splat", _maske)
	_zemin_mat.set_shader_parameter("maske_alani", _maske_alani)
	_zemin_mat.set_shader_parameter("gurultu", gurultu)
	_zemin_mat.set_shader_parameter("tepe", Vector4(DUZLUK, TEPE, kapi_x, kapi_z))
	_zemin_mat.set_shader_parameter("orman_bas", ORMAN_BAS)
	z.material_override = _zemin_mat
	add_child(z)


## Çimen tutamı: 5 sivri yaprak (yaprak başı bir üçgen), kökte UV.y = 0, uçta 1.
static func _tutam() -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var r := RandomNumberGenerator.new()
	r.seed = 5
	for i in 5:
		var a := TAU * i / 5.0 + r.randf() * 0.6
		var yan := Vector3(cos(a), 0, sin(a))
		var dik := Vector3(-yan.z, 0, yan.x)
		var boy := r.randf_range(0.3, 0.55)
		var egik := yan * r.randf_range(0.08, 0.22)
		var kok := yan * r.randf_range(0.0, 0.08)
		var gen := 0.035
		var n := (Vector3.UP * 0.8 + yan * 0.2).normalized()
		for v in [[kok - dik * gen, 0.0], [kok + dik * gen, 0.0], [kok + egik + Vector3(0, boy, 0), 1.0]]:
			st.set_normal(n)
			st.set_uv(Vector2(0.5, v[1]))
			st.add_vertex(v[0])
	return st.commit()


func _cimen_kur() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = _tutam()
	mm.instance_count = TUTAM_SAYISI
	var r := RandomNumberGenerator.new()
	r.seed = 21
	var sinir := ORMAN_BAS + 14.0
	var konan := 0
	var deneme := 0
	while konan < TUTAM_SAYISI and deneme < TUTAM_SAYISI * 4:
		deneme += 1
		var x := r.randf_range(-sinir, sinir)
		var z := r.randf_range(-sinir, sinir + 10.0)
		# Kapı yolunun üstüne düşmez (maskenin dışında da yol vardır).
		if z > kapi_z - 1.0 and absf(x - kapi_x - sin((z - kapi_z) * 0.05) * 4.0) < 2.4:
			continue
		if r.randf() > 1.0 - smoothstep(CIMEN_SEYREL, sinir, maxf(absf(x), absf(z))) * 0.9:
			continue
		var t := Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * r.randf_range(0.7, 1.4)),
			Vector3(x, yukseklik_burada(x, z), z))
		mm.set_instance_transform(konan, t)
		konan += 1
	mm.visible_instance_count = konan
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_cimen_mat = ShaderMaterial.new()
	_cimen_mat.shader = CIMEN
	_cimen_mat.set_shader_parameter("maske_splat", _maske)
	_cimen_mat.set_shader_parameter("maske_alani", _maske_alani)
	mi.material_override = _cimen_mat
	add_child(mi)


## Orman kuşağı: köy sınırından dışa doğru sıklaşan, kümeler hâlinde ağaçlar; kapı yolu açık kalır.
func _orman_kur() -> void:
	if not ResourceLoader.exists(ATLAS + ".png") or not FileAccess.file_exists(ATLAS + ".json"):
		return
	var bilgi: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(ATLAS + ".json"))
	var hucreler := PackedVector4Array()
	for h in bilgi["hucreler"]:
		hucreler.append(Vector4(float(h["boy"]), float(h["dip_v"]), 0, 0))
	var dortgen := ArrayMesh.new()
	var diz := []
	diz.resize(Mesh.ARRAY_MAX)
	diz[Mesh.ARRAY_VERTEX] = PackedVector3Array([Vector3(-0.5, 0, 0), Vector3(0.5, 0, 0), Vector3(0.5, 1, 0), Vector3(-0.5, 1, 0)])
	diz[Mesh.ARRAY_NORMAL] = PackedVector3Array([Vector3.BACK, Vector3.BACK, Vector3.BACK, Vector3.BACK])
	diz[Mesh.ARRAY_TEX_UV] = PackedVector2Array([Vector2(0, 1), Vector2(1, 1), Vector2(1, 0), Vector2(0, 0)])
	diz[Mesh.ARRAY_INDEX] = PackedInt32Array([0, 2, 1, 0, 3, 2])
	dortgen.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, diz)
	# Dörtgen şaderde kameraya döner ve ağaç boyuna büyür: görünürlük kutusu en büyük ağacı kapsasın.
	dortgen.custom_aabb = AABB(Vector3(-16, -2, -16), Vector3(32, 34, 32))
	var kume := FastNoiseLite.new()
	kume.seed = 13
	kume.frequency = 0.035
	var r := RandomNumberGenerator.new()
	r.seed = 77
	var yerler: Array[Vector4] = []
	var deneme := 0
	while yerler.size() < AGAC_SAYISI and deneme < AGAC_SAYISI * 30:
		deneme += 1
		var x := r.randf_range(-ORMAN_SON, ORMAN_SON)
		var z := r.randf_range(-ORMAN_SON, ORMAN_SON)
		var uz := maxf(absf(x), absf(z))
		if uz < ORMAN_BAS - 4.0:
			continue
		if z > kapi_z - 2.0 and absf(x - kapi_x - sin((z - kapi_z) * 0.05) * 4.0) < 5.0:
			continue
		# Kenarda seyrek tek tük ağaç, dışa doğru kümelenen sık orman.
		var olasilik := smoothstep(ORMAN_BAS - 4.0, ORMAN_BAS + 12.0, uz) * (0.25 + 0.75 * (kume.get_noise_2d(x, z) * 0.5 + 0.5))
		if r.randf() > olasilik:
			continue
		yerler.append(Vector4(x, yukseklik_burada(x, z), z, r.randf()))
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_custom_data = true
	mm.mesh = dortgen
	mm.instance_count = yerler.size()
	for i in yerler.size():
		var y := yerler[i]
		var yaprakli := y.w < 0.35
		var hucre := 4 + r.randi() % 4 if yaprakli else r.randi() % 4
		var olcek := r.randf_range(2.3, 3.1) if yaprakli else r.randf_range(1.25, 1.9)
		mm.set_instance_transform(i, Transform3D(Basis(), Vector3(y.x, y.y - 0.1, y.z)))
		mm.set_instance_custom_data(i, Color(hucre, olcek, r.randf(), 0))
	var mat := ShaderMaterial.new()
	mat.shader = ORMAN
	mat.set_shader_parameter("atlas", load(ATLAS + ".png"))
	mat.set_shader_parameter("hucreler", hucreler)
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	mi.material_override = mat
	# Alçak akşam güneşinde ağaç gölgeleri 20–30 m uzayıp köyün üstüne kara lekeler düşürüyordu: gölge yok.
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mi)
