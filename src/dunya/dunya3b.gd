## 3D dünya yardımcıları: gece ortamı, meşale ışığı, model yükleme (Meshy çıktıları `assets/model/`).
## Dokusuz nesneler sanat kitabı paletinden düz renk alır; dokulu modeller kendi dokusunu kullanır.
class_name Dunya3B
extends RefCounted

const MODEL_KOK := "res://assets/model/"
const MESALE_ALEV_DIS := Color("#E0782A")
const MESALE_ALEV_IC := Color("#FFD27A")
## Dokusuz nesnelerin palet rengi.
const NESNE_RENK := {
	"mesale": Renkler.AHSAP, "kazik_cit": Renkler.AHSAP, "araba": Renkler.AHSAP, "agac": Renkler.DERIN_MAVI,
	"kuyu": Renkler.SOGUK_MAVI, "kaya": Renkler.SOGUK_MAVI, "cuval_yigini": Renkler.AHSAP,
}
## Portre kökü → karakter modeli.
const PORTRE_MODEL := {
	"soldier_01": "asker", "craftsman_01": "esnaf", "farmer_01": "ciftci", "farmer_02": "ciftci_kadin",
}
const SINIF_MODEL := {&"asker": "asker", &"esnaf": "esnaf", &"ciftci": "ciftci"}

static var _onbellek: Dictionary = {}
const EL_ESYALARI := "res://data/el_esyalari.json"
static var _el_esyalari: Dictionary = {}


## Gece ortamı: koyu gök, soğuk mavi ortam ışığı, sis, ay ışığı.
static func ortam_kur(kok: Node3D, sis: float = 0.02) -> void:
	var dunya := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Renkler.GECE
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Renkler.SOGUK_MAVI
	env.ambient_light_energy = 0.32
	env.fog_enabled = true
	env.fog_light_color = Renkler.GECE.lerp(Renkler.DERIN_MAVI, 0.5)
	env.fog_light_energy = 0.6
	env.fog_density = sis
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	dunya.environment = env
	kok.add_child(dunya)
	var ay := DirectionalLight3D.new()
	ay.light_color = Renkler.SOGUK_MAVI
	ay.light_energy = 0.35
	ay.rotation_degrees = Vector3(-35, -30, 0)
	ay.shadow_enabled = true
	kok.add_child(ay)


## Zemin: düz renk büyük düzlem.
static func zemin_kur(kok: Node3D, boyut: float = 120.0) -> void:
	var m := MeshInstance3D.new()
	var p := PlaneMesh.new()
	p.size = Vector2(boyut, boyut)
	m.mesh = p
	m.material_override = duz_malzeme(Renkler.DERIN_MAVI.lerp(Renkler.SOGUK_MAVI, 0.35))
	kok.add_child(m)


static func duz_malzeme(renk: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = renk
	mat.roughness = 1.0
	return mat


## Meşale: model (varsa) + titreyen sıcak ışık. Işığı döner.
static func mesale_kur(kok: Node3D, konum: Vector3, guc: float = 2.6, menzil: float = 9.0) -> OmniLight3D:
	var m := nesne("mesale", 1.9)
	m.position = konum
	kok.add_child(m)
	# Alev: iç içe iki koni (dışı turuncu, içi sarı). Parlaklık 1'in üstünde: ışımalı sahnelerde (menü) parlar.
	var alev := Node3D.new()
	alev.position = konum + Vector3(0, 1.9, 0)
	kok.add_child(alev)
	for katman in [[0.11, 0.5, MESALE_ALEV_DIS, 2.2], [0.06, 0.3, MESALE_ALEV_IC, 2.8]]:
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
	isik.light_energy = guc
	isik.omni_range = menzil
	isik.shadow_enabled = true
	isik.position = konum + Vector3(0, 2.0, 0)
	isik.set_meta("taban", guc)
	isik.set_meta("alev", alev)
	kok.add_child(isik)
	return isik


## Statik model: tabanı y=0'a oturtulmuş, verilen yüksekliğe ölçeklenmiş. Model yoksa düz kutu.
static func nesne(ad: String, yukseklik: float = 0.0, tur: String = "", renk: Variant = null, malzeme: Material = null) -> Node3D:
	var yol := _yol(ad, tur)
	var nesne_rengi: Color = renk if renk is Color else NESNE_RENK.get(ad, Renkler.AHSAP)
	var kap := Node3D.new()
	kap.name = ad
	if yol == "":
		var m := MeshInstance3D.new()
		var b := BoxMesh.new()
		b.size = Vector3(1, maxf(yukseklik, 0.5), 1)
		m.mesh = b
		m.position.y = b.size.y / 2.0
		m.material_override = malzeme if malzeme != null else duz_malzeme(nesne_rengi)
		kap.add_child(m)
		return kap
	var n: Node3D = (_sahne(yol)).instantiate()
	kap.add_child(n)
	var kutu := _kutu(n)
	var olcek := 1.0
	if yukseklik > 0.0 and kutu.size.y > 0.001:
		olcek = yukseklik / kutu.size.y
	n.scale = Vector3.ONE * olcek
	n.position = Vector3(-(kutu.position.x + kutu.size.x / 2.0) * olcek, -kutu.position.y * olcek, -(kutu.position.z + kutu.size.z / 2.0) * olcek)
	if NESNE_RENK.has(ad) or renk is Color or malzeme != null:
		var mat: Material = malzeme if malzeme != null else duz_malzeme(nesne_rengi)
		for mi in n.find_children("*", "MeshInstance3D", true, false):
			(mi as MeshInstance3D).material_override = mat
	return kap


## İsteğe bağlı bir model diskte var mı (yoksa çağıran onu atlar; kutu yer tutucu istemez).
static func model_var_mi(ad: String, tur: String = "") -> bool:
	return _yol(ad, tur) != ""


## `nesne()` kabının dünya ölçeğindeki boyutu (x genişlik, y yükseklik, z derinlik).
## `_kutu` alt düğümlerin ölçeğini zaten içerir; ölçek yeniden çarpılmaz.
static func boyut(n: Node3D) -> Vector3:
	return _kutu(n).size


## Karakter modeli adı: adlı karakter id'si, portre kökü ya da sınıf.
static func karakter_adi(adli_id: StringName, portre: String, sinif: StringName) -> String:
	if adli_id != &"" and _yol(String(adli_id) + "_yuru", "karakter") != "":
		return String(adli_id)
	if PORTRE_MODEL.has(portre):
		return PORTRE_MODEL[portre]
	return SINIF_MODEL.get(sinif, "ciftci")


static func _yol(ad: String, tur: String) -> String:
	var adaylar := [tur] if tur != "" else ["karakter", "yapi", "nesne"]
	for t in adaylar:
		var y := "%s%s/%s.glb" % [MODEL_KOK, t, ad]
		if ResourceLoader.exists(y):
			return y
	return ""


static func _sahne(yol: String) -> PackedScene:
	if not _onbellek.has(yol):
		_onbellek[yol] = load(yol)
	return _onbellek[yol]


static func _kutu(n: Node) -> AABB:
	var kutu := AABB()
	var ilk := true
	for mi in n.find_children("*", "MeshInstance3D", true, false):
		var m := mi as MeshInstance3D
		var a := m.get_aabb()
		var t := Transform3D.IDENTITY
		var p: Node = m
		while p != n and p is Node3D:
			t = (p as Node3D).transform * t
			p = p.get_parent()
		a = t * a
		kutu = a if ilk else kutu.merge(a)
		ilk = false
	return kutu


## Yürüyen karakter: `<ad>_yuru.glb` (iskelet + yürüme animasyonu); yoksa kapsül.
static func karakter(ad: String) -> KarakterModel:
	var k := KarakterModel.new()
	k.name = ad
	var yol := _yol(ad + "_yuru", "karakter")
	if yol != "":
		k.kur((_sahne(yol)).instantiate(), ad)
		SiraOlayiKisisi.model_kur(k, ad)
		_el_esyalari_tak(k, ad)
	else:
		k.kur(null)
	return k


## Karakterin elinde taşıdığı eşyalar (data/el_esyalari.json): model adı → [[eşya, "sag"|"sol"]].
static func _el_esyalari_tak(k: KarakterModel, ad: String) -> void:
	if _el_esyalari.is_empty():
		var veri = JSON.parse_string(FileAccess.get_file_as_string(EL_ESYALARI))
		_el_esyalari = veri if veri is Dictionary else {"_": []}
	if not _el_esyalari.has(ad):
		return
	var sk := k.find_children("*", "Skeleton3D", true, false)
	if sk.is_empty():
		return
	for parca in _el_esyalari[ad]:
		var e := ElEsyasi.olustur(String(parca[0]))
		if e == null:
			push_warning("Tanınmayan el eşyası: %s (%s)" % [parca[0], ad])
			continue
		k.add_child(e)
		e.bagla(k, sk[0] as Skeleton3D, String(parca[1]) == "sag", k.duzeltici())


## Meshy hareket klibi: ayıklanmış `hareket/<ad>_<hareket>.res` (repoda), yoksa ham `<ad>_<hareket>.glb`; yoksa "".
static func hareket_yolu(ad: String, hareket: String) -> String:
	var res := "%shareket/%s_%s.res" % [MODEL_KOK, ad, hareket]
	if ResourceLoader.exists(res):
		return res
	return _yol(ad + "_" + hareket, "karakter")
