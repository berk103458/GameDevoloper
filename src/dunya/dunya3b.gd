## 3D dünya yardımcıları: gece ortamı, meşale ışığı, model yükleme (Meshy çıktıları `assets/model/`).
## Dokusuz nesneler sanat kitabı paletinden düz renk alır; dokulu modeller kendi dokusunu kullanır.
class_name Dunya3B
extends RefCounted

const MODEL_KOK := "res://assets/model/"
## Küçük yer tutucunun yerine geçen inceltilmiş topluluk modeli. Karşılığı olmayan kod buraya yazılmaz.
const TOPLULUK_YER := {
	"kuyu": "res://assets/meshy/dogrudan/o21_tas_kuyu_cikrikli.glb",
	"kazik_cit": "res://assets/meshy/dogrudan/o37_ahsap_palisat_kazik_sur.glb",
	"nobet_ocagi": "res://assets/meshy/dogrudan/a060_tas_halkali_ocak.glb",
	"mizrak_sehpasi": "res://assets/meshy/dogrudan/a016_mizrak_sehpasi.glb",
	"cuval_yigini": "res://assets/meshy/dogrudan/a190_tahil_cuvali.glb",
	"dokuma_tezgahi": "res://assets/meshy/dogrudan/a236_kilim_dokuma_tezgahi.glb",
	"firin_agzi": "res://assets/meshy/dogrudan/a181_tandir.glb",
	"araba": "res://assets/meshy/dogrudan/o58_saman_arabasi.glb",
	"orak": "res://assets/meshy/dogrudan/a211_orak.glb",
	"mizrak": "res://assets/meshy/dogrudan/a012_mizrak.glb",
	"el_sepet": "res://assets/meshy/dogrudan/o51_sapli_sepet.glb",
	"el_sepet_buyuk": "res://assets/meshy/dogrudan/o01_hasir_sepet.glb",
	"td_o26": "res://assets/meshy/dogrudan/o26_toprak_damli_kerpic_ev.glb",
	"td_a117": "res://assets/meshy/dogrudan/a117_duz_damli_kerpic_ev.glb",
	"td_a116": "res://assets/meshy/dogrudan/a116_iki_katli_duz_damli_kerpic_ev.glb",
	"td_a157": "res://assets/meshy/animasyon_bekliyor/a157_esek.glb",
	"td_a172": "res://assets/meshy/animasyon_bekliyor/a172_okuz.glb",
	"td_k07": "res://assets/meshy/animasyon_bekliyor/k07_ayi.glb",
	"td_b117": "res://assets/meshy/animasyon_bekliyor/b117_coban_ve_koyun_heykel.glb",
	"td_o07": "res://assets/meshy/dogrudan/o07_toprak_comlek.glb",
	"td_o48": "res://assets/meshy/dogrudan/o48_toprak_testi.glb",
	"td_a241": "res://assets/meshy/dogrudan/a241_comlek_takimi.glb",
	"td_a227": "res://assets/meshy/dogrudan/a227_bakir_kazan.glb",
	"td_o84": "res://assets/meshy/dogrudan/o84_kapakli_bakir_tencere.glb",
	"td_o17": "res://assets/meshy/dogrudan/o17_sivri_kazik_cit.glb",
	"td_o64": "res://assets/meshy/dogrudan/o64_orme_cubuk_cit_ceper.glb",
	"td_a113": "res://assets/meshy/dogrudan/a113_sazdan_catili_ahsap_gozetleme_kulesi.glb",
	"td_o72": "res://assets/meshy/dogrudan/o72_tas_ahsap_kule.glb",
	"td_o76": "res://assets/meshy/dogrudan/o76_su_degirmeni.glb",
	"td_a202": "res://assets/meshy/dogrudan/a202_tinaz_saman_yigini.glb",
	"td_a220": "res://assets/meshy/dogrudan/a220_karasaban.glb",
	"td_a186": "res://assets/meshy/dogrudan/a186_saman_kovan.glb",
	"td_a205": "res://assets/meshy/dogrudan/a205_degirmen_tasi.glb",
	"td_a209": "res://assets/meshy/dogrudan/a209_el_degirmeni.glb",
	"td_o00": "res://assets/meshy/dogrudan/o00_odun_yigini_kutuk.glb",
	"td_o23": "res://assets/meshy/dogrudan/o23_rafli_odun_istifi.glb",
	"td_o18": "res://assets/meshy/dogrudan/o18_tas_yigini.glb",
	"td_o20": "res://assets/meshy/dogrudan/o20_tas_oturak.glb",
	"td_o30": "res://assets/meshy/dogrudan/o30_ahsap_yalak.glb",
	"td_a042": "res://assets/meshy/dogrudan/a042_el_korugu.glb",
	"td_o79": "res://assets/meshy/dogrudan/o79_debbaghane_deri_gerdirme.glb",
	"td_o32": "res://assets/meshy/dogrudan/o32_toprak_kandil.glb",
	"td_o19": "res://assets/meshy/dogrudan/o19_asma_toprak_kandil.glb",
	"td_o14": "res://assets/meshy/dogrudan/o14_yumurta_sepeti.glb",
	"td_a081": "res://assets/meshy/dogrudan/a081_agzi_acik_un_cuvali.glb",
	"td_a228": "res://assets/meshy/dogrudan/a228_sacayak_ustunde_kazan.glb",
	"td_o05": "res://assets/meshy/dogrudan/o05_demir_mangal_nobet_ocagi.glb",
	"td_a177": "res://assets/meshy/dogrudan/a177_kubbeli_toprak_firin.glb",
	"td_k04": "res://assets/meshy/animasyonlu/k04_tavuk.glb",
	"td_a146": "res://assets/meshy/animasyon_bekliyor/a146_tavuk_gercekci.glb",
	"td_o49": "res://assets/meshy/dogrudan/o49_kervan_konak_yeri_ortu_yuk.glb",
}
const MESALE_ALEV_DIS := Color("#E0782A")
const MESALE_ALEV_IC := Color("#FFD27A")
## Dokusuz nesnelerin palet rengi.
const NESNE_RENK := {
	"mesale": Renkler.AHSAP, "kazik_cit": Renkler.AHSAP, "araba": Renkler.AHSAP, "agac": Renkler.DERIN_MAVI,
	"kuyu": Renkler.SOGUK_MAVI, "kaya": Renkler.SOGUK_MAVI, "cuval_yigini": Renkler.AHSAP,
	"zar": Renkler.KUL, "mesale_el": Renkler.AHSAP, "nobet_ocagi": Renkler.SOGUK_MAVI,
	"mizrak_sehpasi": Renkler.AHSAP, "mizrak": Renkler.AHSAP, "kalkan": Renkler.AHSAP,
	"kilic": Renkler.KUL, "yay": Renkler.AHSAP, "fener": Renkler.SOGUK_MAVI, "sancak": Renkler.MESALE,
	"el_torba": Renkler.AHSAP, "el_heybe": Renkler.AHSAP, "el_sepet": Renkler.AHSAP,
	"el_sepet_buyuk": Renkler.AHSAP, "el_asa": Renkler.AHSAP, "el_degnek": Renkler.AHSAP,
	"el_odun": Renkler.AHSAP, "el_sandik": Renkler.AHSAP, "el_cekic": Renkler.SOGUK_MAVI,
	"el_kamci": Renkler.AHSAP, "el_kurk_bohca": Renkler.AHSAP,
	"yatak": Renkler.AHSAP, "masa": Renkler.AHSAP, "kasa": Renkler.AHSAP,
	"rahat_yatak": Renkler.AHSAP, "askilik": Renkler.AHSAP, "kutuphane": Renkler.AHSAP,
	"tarla": Renkler.AHSAP, "bostan": Renkler.AHSAP, "dizili_taslar": Renkler.SOGUK_MAVI,
	"ors": Renkler.KUL, "firin_agzi": Renkler.SOGUK_MAVI, "dokuma_tezgahi": Renkler.AHSAP,
	"divan_masasi": Renkler.AHSAP, "divan_oturak": Renkler.AHSAP, "zindan_kapisi": Renkler.KUL,
	"sacak": Renkler.AHSAP, "agac_02": Renkler.DERIN_MAVI, "kaya_02": Renkler.SOGUK_MAVI,
	"balta": Renkler.AHSAP, "orak": Renkler.KUL, "kova": Renkler.AHSAP, "kurek": Renkler.AHSAP,
	"firin_kuregi": Renkler.AHSAP, "su_kabi": Renkler.AHSAP, "kirmen": Renkler.AHSAP, "bakim_bezi": Renkler.KUL,
	"kervan_yuku": Renkler.AHSAP, "hasta_cadiri": Renkler.AHSAP, "sonen_ates": Renkler.KUL,
	"mezar": Renkler.SOGUK_MAVI, "toplu_mezar": Renkler.AHSAP, "yemin_nesneleri": Renkler.AHSAP,
	"ahi_kusagi": Renkler.MESALE, "davul_zurna": Renkler.AHSAP, "ilac_kutusu": Renkler.AHSAP,
	"kirik_kin": Renkler.KUL, "tezgah_ortusu": Renkler.AHSAP, "blok_ham": Renkler.SOGUK_MAVI,
	"blok_iz": Renkler.SOGUK_MAVI, "blok_bicim": Renkler.KUL, "blok_agiz": Renkler.KUL,
	"teslim_parcasi": Renkler.AHSAP, "hediye_bohcasi": Renkler.AHSAP, "iksir_sisesi": Renkler.DERIN_MAVI,
	"kisisel_iz": Renkler.MESALE, "muhur": Renkler.MESALE,
}
## Portre kökü → karakter modeli.
const PORTRE_MODEL := {
	"soldier_01": "asker", "craftsman_01": "esnaf", "farmer_01": "ciftci", "farmer_02": "ciftci_kadin",
	"vergi_tahsildari": "tahsildar", "aydogdu_oba": "turkmen_bey_adami",
	"celep_hamdullah": "celep", "beyin_denetcisi": "denetci",
	"nalbur": "nalbur", "silah_tuccari": "silah_tuccari", "kumasci_aktar": "kumasci",
	"zanaat_ustasi": "usta", "tohum_ustasi": "usta", "bitki_ustasi": "usta", "su_ustasi": "usta",
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
	var hazir_alev := HazirAtesEfektleri.olustur("alev", 0.65, 12)
	if hazir_alev != null:
		alev.add_child(hazir_alev)
	else:
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
	var topluluk := yol.begins_with("res://assets/meshy/")
	if topluluk:
		kap.set_meta(&"topluluk_dosya", yol)
	if not topluluk and (NESNE_RENK.has(ad) or renk is Color or malzeme != null):
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
	if adli_id == &"chr_006":
		return String(adli_id)
	if adli_id != &"" and _yol(String(adli_id) + "_yuru", "karakter") != "":
		return String(adli_id)
	if adli_id != &"" and PORTRE_MODEL.has(String(adli_id)):
		return PORTRE_MODEL[String(adli_id)]
	if PORTRE_MODEL.has(portre):
		return PORTRE_MODEL[portre]
	if not portre.is_empty() and model_var_mi(portre + "_yuru", "karakter"):
		return portre
	return SINIF_MODEL.get(sinif, "ciftci")


static func _yol(ad: String, tur: String) -> String:
	var topluluk: String = TOPLULUK_YER.get(ad, "")
	if topluluk != "" and ResourceLoader.exists(topluluk):
		return topluluk
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
static func karakter(ad: String, esya_kaynagi: String = "") -> KarakterModel:
	# Görsel model değişebilir. Verilen kapı kaynağı aynı eşya ve el satırını seçer.
	var esya_adi := ad if esya_kaynagi.is_empty() else esya_kaynagi
	var hazir := HazirKarakterler.olustur(ad)
	if hazir != null:
		hazir.name = ad
		hazir.set_meta("model_adi", ad)
		hazir.add_child(preload("res://src/ses/hazir_adim_sesi.gd").new())
		SiraOlayiKisisi.model_kur(hazir, ad)
		_el_esyalari_tak(hazir, esya_adi)
		return hazir
	var k := KarakterModel.new()
	k.name = ad
	k.set_meta("model_adi", ad)
	k.add_child(preload("res://src/ses/hazir_adim_sesi.gd").new())
	var yol := _yol(ad + "_yuru", "karakter")
	if yol != "":
		k.kur((_sahne(yol)).instantiate(), ad)
		SiraOlayiKisisi.model_kur(k, ad)
		_el_esyalari_tak(k, esya_adi)
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
