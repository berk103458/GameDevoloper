## CIL-07: Köy içi topluluk eşyalarını yürüme koridorlarını tıkamadan bina avlularına ve güvenli kenarlara bağlar.
class_name BinaAvluEsyalari
extends RefCounted

const ESYA_HARITASI := {
	"demirhane": [
		{"ad": "td_a040", "boy": 0.78, "ofset": Vector3(0.34, 0.0, 0.36), "don": -25.0},
		{"ad": "td_a042", "boy": 0.45, "ofset": Vector3(-0.34, 0.0, 0.36), "don": 18.0},
		{"ad": "td_o05", "boy": 0.80, "ofset": Vector3(0.38, 0.0, -0.32), "don": 0.0},
	],
	"demir_ocagi": [
		{"ad": "td_a040", "boy": 0.75, "ofset": Vector3(0.35, 0.0, 0.35), "don": -20.0},
		{"ad": "td_a042", "boy": 0.45, "ofset": Vector3(-0.35, 0.0, 0.35), "don": 15.0},
	],
	"firin": [
		{"ad": "td_a177", "boy": 1.35, "ofset": Vector3(-0.32, 0.0, 0.32), "don": 15.0},
		{"ad": "td_a081", "boy": 0.62, "ofset": Vector3(0.36, 0.0, 0.34), "don": 10.0},
		{"ad": "td_a209", "boy": 0.55, "ofset": Vector3(0.36, 0.0, -0.32), "don": -30.0},
		{"ad": "td_a227", "boy": 0.55, "ofset": Vector3(-0.36, 0.0, -0.32), "don": 0.0},
		{"ad": "td_o84", "boy": 0.35, "ofset": Vector3(0.0, 0.0, 0.40), "don": 0.0},
		{"ad": "td_o19", "boy": 0.35, "ofset": Vector3(-0.26, 2.05, 0.38), "don": 0.0, "isik": true},
	],
	"sifahane": [
		{"ad": "td_a228", "boy": 0.72, "ofset": Vector3(-0.35, 0.0, 0.35), "don": 20.0},
		{"ad": "td_o07", "boy": 0.45, "ofset": Vector3(0.36, 0.0, 0.36), "don": 0.0},
		{"ad": "td_o48", "boy": 0.45, "ofset": Vector3(0.38, 0.0, -0.34), "don": 40.0},
		{"ad": "td_o32", "boy": 0.22, "ofset": Vector3(-0.36, 0.0, -0.35), "don": 0.0, "isik": true},
	],
	"ambar": [
		{"ad": "cuval_yigini", "boy": 0.72, "ofset": Vector3(-0.35, 0.0, 0.36), "don": 12.0},
		{"ad": "td_a081", "boy": 0.62, "ofset": Vector3(0.35, 0.0, 0.36), "don": -15.0},
		{"ad": "td_a202", "boy": 1.25, "ofset": Vector3(-0.36, 0.0, -0.34), "don": 35.0},
		{"ad": "araba", "boy": 1.15, "ofset": Vector3(0.34, 0.0, -0.34), "don": 90.0},
	],
	"degirmen": [
		{"ad": "td_a205", "boy": 0.90, "ofset": Vector3(-0.36, 0.0, 0.36), "don": 25.0},
		{"ad": "td_a081", "boy": 0.62, "ofset": Vector3(0.36, 0.0, 0.36), "don": -10.0},
		{"ad": "td_a202", "boy": 1.25, "ofset": Vector3(0.36, 0.0, -0.36), "don": 0.0},
	],
	"tarla": [
		{"ad": "td_a220", "boy": 0.90, "ofset": Vector3(-0.38, 0.0, 0.38), "don": 20.0},
		{"ad": "td_a202", "boy": 1.20, "ofset": Vector3(0.38, 0.0, -0.38), "don": -15.0},
	],
	"bostan": [
		{"ad": "td_a186", "boy": 0.65, "ofset": Vector3(-0.36, 0.0, 0.36), "don": 10.0},
		{"ad": "td_o14", "boy": 0.35, "ofset": Vector3(0.36, 0.0, 0.36), "don": 0.0},
	],
	"odunluk": [
		{"ad": "td_o00", "boy": 0.75, "ofset": Vector3(-0.34, 0.0, 0.35), "don": 20.0},
		{"ad": "td_o23", "boy": 1.20, "ofset": Vector3(0.34, 0.0, 0.35), "don": 0.0},
	],
	"hizarhane": [
		{"ad": "td_o23", "boy": 1.25, "ofset": Vector3(-0.34, 0.0, 0.35), "don": 90.0},
		{"ad": "td_o00", "boy": 0.75, "ofset": Vector3(0.34, 0.0, -0.34), "don": -30.0},
	],
	"tas_ocagi": [
		{"ad": "td_o18", "boy": 0.85, "ofset": Vector3(-0.35, 0.0, 0.35), "don": 15.0},
	],
	"atolye": [
		{"ad": "dokuma_tezgahi", "boy": 1.45, "ofset": Vector3(-0.34, 0.0, 0.34), "don": 0.0},
		{"ad": "td_o79", "boy": 1.25, "ofset": Vector3(0.35, 0.0, 0.34), "don": -25.0},
		{"ad": "td_a241", "boy": 0.50, "ofset": Vector3(0.36, 0.0, -0.35), "don": 15.0},
	],
	"muhafiz_kislasi": [
		{"ad": "mizrak_sehpasi", "boy": 1.30, "ofset": Vector3(-0.36, 0.0, 0.38), "don": 15.0},
		{"ad": "td_o05", "boy": 0.85, "ofset": Vector3(0.36, 0.0, 0.38), "don": 0.0, "isik": true},
		{"ad": "td_o20", "boy": 0.48, "ofset": Vector3(0.0, 0.0, 0.40), "don": 0.0},
		{"ad": "td_o19", "boy": 0.35, "ofset": Vector3(0.26, 2.05, 0.38), "don": 0.0, "isik": true},
		{"ad": "td_o18", "boy": 0.72, "ofset": Vector3(-0.38, 0.0, -0.34), "don": 0.0},
	],
	"tas_ev": [
		{"ad": "td_o20", "boy": 0.48, "ofset": Vector3(-0.36, 0.0, 0.38), "don": 0.0},
		{"ad": "td_o07", "boy": 0.42, "ofset": Vector3(0.36, 0.0, 0.38), "don": 12.0},
		{"ad": "td_o48", "boy": 0.40, "ofset": Vector3(0.38, 0.0, -0.36), "don": -35.0},
		{"ad": "td_o19", "boy": 0.35, "ofset": Vector3(0.0, 2.05, 0.38), "don": 0.0, "isik": true},
	],
	"kulube": [
		{"ad": "td_o48", "boy": 0.42, "ofset": Vector3(-0.36, 0.0, 0.38), "don": 20.0},
		{"ad": "td_o14", "boy": 0.34, "ofset": Vector3(0.36, 0.0, 0.38), "don": 0.0},
		{"ad": "td_o20", "boy": 0.46, "ofset": Vector3(0.0, 0.0, 0.42), "don": -25.0},
	],
	"ahir": [
		{"ad": "td_o30", "boy": 0.45, "ofset": Vector3(0.0, 0.0, 0.28), "don": 0.0},
		{"ad": "td_a202", "boy": 1.15, "ofset": Vector3(-0.30, 0.0, -0.30), "don": 20.0},
		{"ad": "td_o00", "boy": 0.72, "ofset": Vector3(-0.30, 0.0, 0.30), "don": 20.0},
		{"ad": "td_a186", "boy": 0.62, "ofset": Vector3(0.30, 0.0, 0.30), "don": -25.0},
	],
	"agil": [
		{"ad": "td_o30", "boy": 0.45, "ofset": Vector3(0.28, 0.0, 0.28), "don": 0.0},
		{"ad": "td_a202", "boy": 1.10, "ofset": Vector3(-0.30, 0.0, 0.30), "don": 0.0},
		{"ad": "td_a186", "boy": 0.62, "ofset": Vector3(0.30, 0.0, -0.30), "don": 30.0},
		{"ad": "td_o48", "boy": 0.40, "ofset": Vector3(-0.30, 0.0, -0.30), "don": 40.0},
	],
	"han": [
		{"ad": "td_a073", "boy": 2.10, "ofset": Vector3(-0.36, 0.0, 0.36), "don": 12.0},
		{"ad": "td_a077", "boy": 2.00, "ofset": Vector3(0.36, 0.0, 0.36), "don": -12.0},
		{"ad": "td_o65", "boy": 1.95, "ofset": Vector3(-0.36, 0.0, -0.34), "don": 25.0},
		{"ad": "td_o19", "boy": 0.35, "ofset": Vector3(0.0, 2.05, 0.38), "don": 0.0, "isik": true},
		{"ad": "td_o20", "boy": 0.48, "ofset": Vector3(0.0, 0.0, 0.42), "don": 0.0},
		{"ad": "td_a081", "boy": 0.60, "ofset": Vector3(-0.38, 0.0, -0.36), "don": 35.0},
		{"ad": "td_o48", "boy": 0.42, "ofset": Vector3(0.40, 0.0, -0.36), "don": -20.0},
	],
}

## Dış mekan çevresi (meydan ateşinin kenarı ve köy kapı dışı — başıboş canlı içermez).
const KOY_CEVRE := [
	{"ad": "td_o05", "boy": 0.85, "yer": Vector3(-3.2, 0.0, -2.4), "don": 0.0, "isik": true},
	{"ad": "td_o20", "boy": 0.48, "yer": Vector3(-2.6, 0.0, 2.4), "don": 35.0},
	{"ad": "td_o32", "boy": 0.22, "yer": Vector3(-2.6, 0.46, 2.4), "don": 0.0, "isik": true},
	{"ad": "td_o30", "boy": 0.46, "yer": Vector3(2.8, 0.0, 2.5), "don": -20.0},
	{"ad": "td_o49", "boy": 1.40, "yer": Vector3(4.6, 0.0, 28.5), "don": -30.0},
]


## Hazır yapı düğümünün kendi parsel alanı içinde (yürüme hücrelerine taşmadan) avlu eşyalarını kurar.
static func bina_ekle(n: Node3D, tur: String, en: float, derin: float) -> void:
	var esyalar: Array = ESYA_HARITASI.get(tur, [])
	if esyalar.is_empty():
		return
	var avlu := Node3D.new()
	avlu.name = "avlu_esyalari"
	avlu.set_meta(&"avlu_esyalari", true)
	n.add_child(avlu)
	var sinir_x := en * 0.46
	var sinir_z := derin * 0.46
	for item in esyalar:
		var ad := String(item["ad"])
		if not Dunya3B.model_var_mi(ad):
			continue
		var ofset: Vector3 = item["ofset"]
		var hedef_y := float(item["boy"])
		var max_x := minf(en * 0.28, 1.35)
		var max_z := minf(derin * 0.28, 1.35)
		var esya := Dunya3B.sigdir(ad, hedef_y, "", max_x, max_z)
		esya.name = "avlu_" + ad
		var kutu := Dunya3B.boyut(esya)
		var px := clampf(ofset.x * en, -maxf(0.05, sinir_x - kutu.x * 0.5), maxf(0.05, sinir_x - kutu.x * 0.5))
		var pz := clampf(ofset.z * derin, -maxf(0.05, sinir_z - kutu.z * 0.5), maxf(0.05, sinir_z - kutu.z * 0.5))
		esya.position = Vector3(px, ofset.y, pz)
		esya.rotation.y = deg_to_rad(float(item.get("don", 0.0)))
		esya.set_meta(&"avlu_esya", true)
		avlu.add_child(esya)
		if bool(item.get("isik", false)):
			_sicak_isik_ekle(avlu, esya.position + Vector3(0.0, 0.15, 0.0), tur)


## Köy sahnesindeki yürüme-dışı noktalara (kapı dışı kervan yeri vb.) güvenli çevre eşyalarını koyar.
static func cevre_kur(s: KoyYonetimSahnesi, ust: Node3D) -> void:
	var eski := ust.get_node_or_null(^"koy_avlu_cevre")
	if eski != null:
		eski.queue_free()
	var kok := Node3D.new()
	kok.name = "koy_avlu_cevre"
	kok.set_meta(&"avlu_esyalari", true)
	ust.add_child(kok)
	var rota := KoyRotasi.new()
	rota.kur(s.yonetim.izgara, 1.0)
	var m := s.yonetim.a.meydan
	var meydan_merkez := s.alan_merkezi(m.position, m.size)
	var i := 0
	for item in KOY_CEVRE:
		var ad := String(item["ad"])
		if not Dunya3B.model_var_mi(ad):
			continue
		var ofset: Vector3 = item["yer"]
		var konum := Vector3(ofset.x, ofset.y, ofset.z)
		if ofset.z < 20.0:
			konum = meydan_merkez + ofset
		if _yurume_engelli_mi(s, rota, konum):
			# Meydan yürüme hücresi üstündeyse dış sur/orman güvenli kenarına (çakışmadan) kaydır.
			konum = s.alan_merkezi(Vector2i(-2, 4 + i * 3), Vector2i.ONE) + Vector3(0.0, ofset.y, 0.0)
		i += 1
		var esya := Dunya3B.nesne(ad, float(item["boy"]))
		esya.name = "cevre_" + ad
		esya.position = konum
		esya.rotation.y = deg_to_rad(float(item.get("don", 0.0)))
		esya.set_meta(&"avlu_esya", true)
		kok.add_child(esya)
		if bool(item.get("isik", false)):
			_sicak_isik_ekle(kok, esya.position + Vector3(0.0, 0.35, 0.0), "cevre")
	if preload("res://src/koy/ticaret/ek_hayvan_pazari.gd").tuccar_koyde_mi(s.yonetim):
		for t_item in [
			{"ad": "td_k14", "boy": 1.72, "yer": Vector3(3.6, 0.0, 27.8), "don": -145.0},
			{"ad": "td_k05", "boy": 1.55, "yer": Vector3(5.6, 0.0, 27.6), "don": -110.0},
		]:
			var t_ad := String(t_item["ad"])
			if not Dunya3B.model_var_mi(t_ad):
				continue
			var t_konum: Vector3 = t_item["yer"]
			if _yurume_engelli_mi(s, rota, t_konum):
				t_konum = s.alan_merkezi(Vector2i(-2, 4 + i * 3), Vector2i.ONE)
			i += 1
			var tn := Dunya3B.nesne(t_ad, float(t_item["boy"]))
			tn.name = "cevre_" + t_ad
			tn.position = t_konum
			tn.rotation.y = deg_to_rad(float(t_item["don"]))
			tn.set_meta(&"avlu_esya", true)
			kok.add_child(tn)


static func _yurume_engelli_mi(s: KoyYonetimSahnesi, rota: KoyRotasi, konum: Vector3) -> bool:
	var bas := s.hucre_kosesi(Vector2i.ZERO)
	var hx := int(floor((konum.x - bas.x) / s.HUCRE))
	var hz := int(floor((konum.z - bas.z) / s.HUCRE))
	return rota.gecilir(Vector2i(hx, hz))


static func _sicak_isik_ekle(ust: Node3D, konum: Vector3, etiket: String) -> void:
	var isik := OmniLight3D.new()
	isik.name = "sicak_kandil_isigi_" + etiket
	isik.light_color = Color("#FF9A40")
	isik.light_energy = 1.4
	isik.omni_range = 5.5
	isik.omni_attenuation = 1.4
	isik.shadow_enabled = false
	isik.position = konum
	isik.set_meta(&"gece_isigi", true)
	ust.add_child(isik)
