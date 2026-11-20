## Köy çevresi ve yol kenarı: ProtonScatter, Use Instancing, 120 m görünürlük.
## Yapı hücresine ve kapı yolunun ortasına nokta koymaz. Modeller repodaki kayıtlardan gelir.
class_name KoySerpintisi
extends RefCounted

const GORUNUR := 120.0


static func kur(arazi: KoyArazisi) -> ProtonScatter:
	var kok := Node3D.new()
	kok.name = &"koy_serpintisi"
	arazi.add_child(kok)
	var ilk: ProtonScatter = null
	for tur in [["ot", 140], ["tas", 28], ["cali", 18], ["agac", 12]]:
		var s := _scatter(arazi, String(tur[0]), int(tur[1]))
		kok.add_child(s)
		if ilk == null:
			ilk = s
	return ilk


static func _scatter(arazi: KoyArazisi, tur: String, adet: int) -> ProtonScatter:
	var s := ProtonScatter.new()
	s.name = tur
	s.global_seed = 14
	s.render_mode = 0
	s.dbg_disable_thread = true
	s.enable_updates_in_game = true
	s.force_rebuild_on_load = true
	s.show_output_in_tree = false
	var yigin := ProtonScatterModifierStack.new()
	var nokta: ScatterBaseModifier = load("res://src/koy/gorsel/serpinti_noktasi.gd").new()
	nokta.noktalar = _noktalar(arazi, tur, adet)
	yigin.add(nokta)
	s.modifier_stack = yigin
	match tur:
		"ot":
			_kalip(s, tur, _ot(arazi))
		"tas":
			_kalip(s, tur, _kutu(Color(0.45, 0.43, 0.4), Vector3(0.35, 0.22, 0.28), "taş"))
		"cali":
			_kalip(s, tur, _kutu(Color(0.28, 0.36, 0.18), Vector3(0.7, 0.45, 0.7), "çalı"))
		_:
			_kalip(s, tur, _agac())
	return s


static func _kalip(s: ProtonScatter, ad: String, kok: Node3D) -> void:
	var item := ProtonScatterItem.new()
	item.name = ad
	item.source = 0
	item.proportion = 100
	item.source_ignore_position = true
	item.source_ignore_rotation = true
	item.source_ignore_scale = false
	item.visibility_range_end = GORUNUR
	item.visibility_range_end_margin = 8.0
	item.override_cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	kok.name = ad + "_kaynak"
	item.add_child(kok)
	item.path = str(item.get_path_to(kok))
	s.add_child(item)


static func _noktalar(arazi: KoyArazisi, tur: String, adet: int) -> Array[Transform3D]:
	var sonuc: Array[Transform3D] = []
	var r := RandomNumberGenerator.new()
	r.seed = 14 + adet
	var deneme := 0
	var konan := 0
	while konan < adet and deneme < adet * 12:
		deneme += 1
		var p := _aday(r, arazi, tur)
		if p == Vector3.INF:
			continue
		var olcek := r.randf_range(0.75, 1.25)
		if tur == "agac":
			olcek = r.randf_range(0.85, 1.35)
		var t := Transform3D(Basis(Vector3.UP, r.randf() * TAU).scaled(Vector3.ONE * olcek), p)
		sonuc.append(t)
		konan += 1
	return sonuc


static func _aday(r: RandomNumberGenerator, arazi: KoyArazisi, tur: String) -> Vector3:
	var x := 0.0
	var z := 0.0
	if tur == "ot" or tur == "tas":
		z = r.randf_range(arazi.kapi_z, arazi.kapi_z + 46.0)
		var orta := arazi.kapi_x + sin((z - arazi.kapi_z) * 0.05) * 4.0
		var yon := -1.0 if r.randf() < 0.5 else 1.0
		x = orta + yon * r.randf_range(3.2, 7.5)
	else:
		var aci := r.randf() * TAU
		var uzak := r.randf_range(34.0, 68.0)
		x = cos(aci) * uzak
		z = sin(aci) * uzak
	if _yasak(arazi, x, z):
		return Vector3.INF
	return Vector3(x, arazi.yukseklik_burada(x, z), z)


static func _yasak(arazi: KoyArazisi, x: float, z: float) -> bool:
	if z > arazi.kapi_z - 1.0 and absf(x - arazi.kapi_x - sin((z - arazi.kapi_z) * 0.05) * 4.0) < 2.5:
		return true
	var s := arazi.sahne
	if s == null or s.yonetim == null:
		return false
	var m := s.yonetim.a.meydan
	var orta := Vector2(m.position) + Vector2(m.size) * 0.5
	var h := Vector2i(floori(x / KoyYonetimSahnesi.HUCRE + orta.x), floori(z / KoyYonetimSahnesi.HUCRE + orta.y))
	if int(s.yonetim.izgara.dolu.get(h, -1)) >= 0:
		return true
	if s.yonetim.izgara.yollar.has(h):
		return true
	return tur_ic(h, m)


static func tur_ic(h: Vector2i, m: Rect2i) -> bool:
	return h.x >= m.position.x and h.y >= m.position.y and h.x < m.position.x + m.size.x and h.y < m.position.y + m.size.y


static func _ot(arazi: KoyArazisi) -> Node3D:
	var n := MeshInstance3D.new()
	n.mesh = KoyArazisi._tutam()
	var malzeme := ShaderMaterial.new()
	malzeme.shader = KoyArazisi.CIMEN
	if arazi._cimen_mat != null:
		malzeme.set_shader_parameter("maske_splat", arazi._cimen_mat.get_shader_parameter("maske_splat"))
		malzeme.set_shader_parameter("maske_alani", arazi._cimen_mat.get_shader_parameter("maske_alani"))
	n.material_override = malzeme
	n.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return n


static func _kutu(renk: Color, boy: Vector3, etiket: String) -> Node3D:
	var n := MeshInstance3D.new()
	var k := BoxMesh.new()
	k.size = boy
	n.mesh = k
	n.position.y = boy.y * 0.5
	n.material_override = Dunya3B.duz_malzeme(renk)
	HazirSahneModeli.etiket(n, etiket, boy.y + 0.15)
	return n


static func _agac() -> Node3D:
	if Dunya3B.model_var_mi("agac"):
		return Dunya3B.nesne("agac", 4.0)
	return _kutu(Color(0.22, 0.32, 0.16), Vector3(0.8, 3.2, 0.8), "ağaç")
