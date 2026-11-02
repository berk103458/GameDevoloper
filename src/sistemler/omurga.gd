## OMR-02, OMR-04, OMR-06, OMR-34, OMR-53: Perde 1 donemleri ve Perde 2 dalgalari.
## Donem mevcut nufustan, dalga ise `PerdeGecisi.gece(y)` degerinden turetildigi icin kalici alan tutmaz.
## OMR-53: Esikler ve sabitler data/omurga.json dosyasindadir; kod icinde 0 ve 1 haric sayisal sabit yoktur.
class_name Omurga
extends RefCounted

const PerdeGecisi = preload("res://src/koy/perde_gecisi.gd")
const VERI_YOLU := "res://data/omurga.json"

const DONEM_KURULUS := &"kurulus"
const DONEM_YERLESME := &"yerlesme"
const DONEM_OTURMA := &"oturma"

static var _veri_onbellek: Dictionary = {}


static func veri() -> Dictionary:
	if not _veri_onbellek.is_empty():
		return _veri_onbellek
	if FileAccess.file_exists(VERI_YOLU):
		var metin := FileAccess.get_file_as_string(VERI_YOLU)
		var json := JSON.new()
		if json.parse(metin) == OK and json.data is Dictionary:
			_veri_onbellek = json.data
			return _veri_onbellek
	return {}


static func kurulus_ust_sinir() -> int:
	return int(veri().get("donem_esikleri", {}).get("kurulus_ust_sinir", 0))


static func yerlesme_ust_sinir() -> int:
	return int(veri().get("donem_esikleri", {}).get("yerlesme_ust_sinir", 0))


## OMR-02: Perde 1 uc doneme bolunur: kurulus, yerlesme, oturma.
static func donem(kaynak: Variant) -> StringName:
	var n := _nufus_coz(kaynak)
	var k_ust := kurulus_ust_sinir()
	var y_ust := yerlesme_ust_sinir()
	if n <= k_ust:
		return DONEM_KURULUS
	if n <= y_ust:
		return DONEM_YERLESME
	return DONEM_OTURMA


## OMR-04: Perde 2 uc dalgaya bolunur (1: baski gelir, 2: baski sikisir, 3: kapanis).
## `perde2_hedef_gece` degisince dalga sinirlari oranla kayar (orn. 12 -> 4+4+4, 15 -> 5+5+5).
static func dalga(kaynak: Variant, hedef_gece: int = 0) -> int:
	var cozulmus := _perde2_gece_coz(kaynak, hedef_gece)
	var g := maxi(0, int(cozulmus["gece"]))
	var h := int(cozulmus["hedef"])
	var bolum := float(veri().get("dalga_bolum", 1))
	var sinir1 := float(h) / (bolum if bolum > 0.0 else 1.0)
	var sinir2 := sinir1 + sinir1
	var indeksler: Array = veri().get("dalga_indeksleri", [1, 1 + 1, 1 + 1 + 1])
	if float(g) < sinir1:
		return int(indeksler[0])
	if float(g) < sinir2:
		return int(indeksler[1])
	return int(indeksler[1 + 1])


static func dalga_sinirlari(hedef_gece: int = 0) -> Dictionary:
	var v_hedef := int(veri().get("dalga_varsayilan_hedef", 0))
	var h := hedef_gece if hedef_gece > 0 else v_hedef
	var bolum := float(veri().get("dalga_bolum", 1))
	var sinir1 := float(h) / (bolum if bolum > 0.0 else 1.0)
	var sinir2 := sinir1 + sinir1
	return {
		"dalga_1_bitis": int(floor(sinir1)),
		"dalga_2_bitis": int(floor(sinir2)),
		"hedef_gece": h,
	}


static func hat_onceligi() -> Array:
	return veri().get("hat_onceligi", []).duplicate()


static func yuz_eslemesi() -> Dictionary:
	return veri().get("yuz_eslemesi", {}).duplicate()


static func sinif_agirliklari() -> Dictionary:
	return veri().get("sinif_agirliklari", {}).duplicate()


static func bos_gun_olasiliklari() -> Dictionary:
	return veri().get("bos_gun_olasiligi", {}).duplicate()


static func _nufus_coz(kaynak: Variant) -> int:
	if kaynak is int or kaynak is float:
		return int(kaynak)
	if kaynak is Dictionary:
		return int((kaynak as Dictionary).get("nufus", 0))
	if kaynak is Object and (kaynak as Object).has_method("nufus"):
		return int((kaynak as Object).call("nufus"))
	return 0


static func _perde2_gece_coz(kaynak: Variant, varsayilan_hedef: int) -> Dictionary:
	var g := 0
	var v_hedef := int(veri().get("dalga_varsayilan_hedef", 0))
	var h := varsayilan_hedef if varsayilan_hedef > 0 else v_hedef
	if kaynak is int or kaynak is float:
		g = int(kaynak)
	elif kaynak is Dictionary:
		var d := kaynak as Dictionary
		g = int(d.get("perde2_gece", d.get("gece", 0)))
		if d.has("perde2_hedef_gece"):
			h = int(d["perde2_hedef_gece"])
	elif kaynak is KoyYonetimi:
		g = PerdeGecisi.gece(kaynak as KoyYonetimi)
	return {"gece": g, "hedef": h}
