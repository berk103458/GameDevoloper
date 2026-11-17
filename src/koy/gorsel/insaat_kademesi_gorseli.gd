## CIL-05: çok aşamalı inşaat ilerlemesi (%0/%34/%67/%100), hasar/yanık ve ahır yer tutucusu.
class_name InsaatKademesiGorseli
extends RefCounted

const TEMEL_RENK := Color("#6E655A")
const AHSAP_RENK := Color("#6B4E34")
const YANIK_RENK := Color("#2B2420")


## Yapının [0.0..1.0] inşaat ilerleme oranını katalogdaki `insa_gun` üzerinden hesaplar.
static func ilerleme_orani(b: KoyBinasi, katalog: BinaKatalogu) -> float:
	if b.hazir():
		return 1.0
	var toplam := maxi(1, int(katalog.veri(b.tur).get("insa_gun", 1)))
	var yapilan := clampf(float(toplam - b.insa_kalan) + b.insa_artik, 0.0, float(toplam))
	return clampf(yapilan / float(toplam), 0.0, 1.0)


## İlerlemeye göre şantiye kademesini kurar (0: temel/kazık, 1: iskele+yükselen gövde, 2: çatı iskelesi).
static func insa_kur(n: Node3D, b: KoyBinasi, katalog: BinaKatalogu, en: float, derin: float, govde_uret: Callable) -> void:
	var oran := ilerleme_orani(b, katalog)
	var asama := 0 if oran < 0.34 else (1 if oran < 0.67 else 2)
	n.set_meta(&"insaat_asama", asama)
	n.set_meta(&"insaat_orani", oran)
	var tas := Pbr.malzeme("castle_wall_varriation", 2.0, TEMEL_RENK)
	var ahsap := Pbr.malzeme("medieval_wood", 2.0, AHSAP_RENK)
	_kutu(n, Vector3(en * 0.86, 0.20, derin * 0.86), Vector3(0, 0.10, 0), tas, "InsaatTemel")
	if asama == 0:
		for x in [-1, 1]:
			for z in [-1, 1]:
				_kutu(n, Vector3(0.10, 0.90, 0.10), Vector3(x * en * 0.42, 0.45, z * derin * 0.42), ahsap)
		for z_yan in [-1, 1]:
			_kutu(n, Vector3(en * 0.84, 0.04, 0.04), Vector3(0, 0.65, z_yan * derin * 0.42), ahsap)
		for x_yan in [-1, 1]:
			_kutu(n, Vector3(0.04, 0.04, derin * 0.84), Vector3(x_yan * en * 0.42, 0.65, 0), ahsap)
		if Dunya3B.model_var_mi("td_o18"):
			var yig := Dunya3B.sigdir("td_o18", 0.65, "", 1.0, 1.0)
			yig.position = Vector3(-en * 0.18, 0.18, derin * 0.12)
			n.add_child(yig)
		if Dunya3B.model_var_mi("td_o00"):
			var odun := Dunya3B.sigdir("td_o00", 0.55, "", 1.2, 1.0)
			odun.position = Vector3(en * 0.18, 0.18, -derin * 0.10)
			n.add_child(odun)
		return
	var yuk_carpan := 0.48 if asama == 1 else 0.86
	var govde := Node3D.new()
	govde.name = "YukselenGovde"
	govde_uret.call(govde)
	govde.scale = Vector3(1.0, yuk_carpan, 1.0)
	n.add_child(govde)
	var iskele_boy := 2.0 if asama == 1 else 2.65
	var direkler := Node3D.new()
	direkler.name = "InsaatIskele"
	n.add_child(direkler)
	for x in [-1, 1]:
		for z in [-1, 1]:
			_kutu(direkler, Vector3(0.11, iskele_boy, 0.11), Vector3(x * en * 0.43, iskele_boy * 0.5, z * derin * 0.43), ahsap)
	var kiri_seviye := [1.1, 1.9] if asama == 1 else [2.45]
	for y in kiri_seviye:
		_kutu(direkler, Vector3(en * 0.86, 0.07, 0.09), Vector3(0, y, derin * 0.43), ahsap)
		_kutu(direkler, Vector3(en * 0.86, 0.07, 0.09), Vector3(0, y, -derin * 0.43), ahsap)
		_kutu(direkler, Vector3(0.09, 0.07, derin * 0.86), Vector3(en * 0.43, y, 0), ahsap)
		_kutu(direkler, Vector3(0.09, 0.07, derin * 0.86), Vector3(-en * 0.43, y, 0), ahsap)


## Bozuk `ahir.glb` (Z=0.061m) yerine sağlam ahşap-taş açık ahır yer tutucusu kurar.
static func ahir_yer_tutucu(n: Node3D, en: float, derin: float) -> void:
	var kok := Node3D.new()
	kok.name = "AhirYerTutucu"
	var ahsap := Pbr.malzeme("medieval_wood", 2.0, AHSAP_RENK)
	var tas := Pbr.malzeme("castle_wall_varriation", 2.0, TEMEL_RENK)
	var saman := StandardMaterial3D.new()
	saman.albedo_color = Color("#B5985A")
	saman.roughness = 0.95
	var w := minf(en * 0.84, 3.4)
	var d := minf(derin * 0.84, 3.4)
	_kutu(kok, Vector3(w, 0.12, d), Vector3(0, 0.06, 0), tas)
	_kutu(kok, Vector3(w, 1.95, 0.22), Vector3(0, 1.0, -d * 0.44), tas)
	for x in [-1, 1]:
		_kutu(kok, Vector3(0.20, 2.05, 0.20), Vector3(x * w * 0.45, 1.05, d * 0.42), ahsap)
		_kutu(kok, Vector3(0.20, 2.05, 0.20), Vector3(x * w * 0.45, 1.05, -d * 0.42), ahsap)
	var dam := _kutu(kok, Vector3(w + 0.35, 0.16, d + 0.35), Vector3(0, 2.22, 0), ahsap)
	dam.rotation_degrees.x = 12.0
	_kutu(kok, Vector3(w * 0.65, 0.18, d * 0.45), Vector3(0, 0.21, -d * 0.05), saman)
	if Dunya3B.model_var_mi("td_o30"):
		var yalak := Dunya3B.sigdir("td_o30", 0.42, "", 1.5, 0.85)
		yalak.position = Vector3(0, 0.12, d * 0.30)
		kok.add_child(yalak)
	n.add_child(kok)


## Yangın/kundak hasarı işaretli yapılara yanık görünümü uygular.
static func hasar_uygula(n: Node3D, yonetim: KoyYonetimi, b: KoyBinasi) -> void:
	var yanik_h: Variant = yonetim.get_meta(&"yanik_ev_hucre") if yonetim != null and yonetim.has_meta(&"yanik_ev_hucre") else null
	var yanik: bool = (yanik_h is Vector2i and yanik_h == b.hucre) or bool(b.get_meta(&"yanik", false))
	if not yanik:
		return
	n.set_meta(&"yanik_durum", true)
	for mi in n.find_children("*", "MeshInstance3D", true, false):
		var m := mi as MeshInstance3D
		var mat := StandardMaterial3D.new()
		mat.albedo_color = YANIK_RENK
		mat.roughness = 0.95
		m.material_override = mat


static func _kutu(ust: Node3D, boy: Vector3, yer: Vector3, mat: Material, ad: String = "") -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	if ad != "":
		mi.name = ad
	var bm := BoxMesh.new()
	bm.size = boy
	mi.mesh = bm
	mi.position = yer
	mi.material_override = mat
	ust.add_child(mi)
	return mi
