## OMR-02, OMR-04, OMR-06, OMR-34: Perde 1 donemleri ve Perde 2 dalgalari.
## Donem mevcut nufustan, dalga ise `PerdeGecisi.gece(y)` degerinden turetildigi icin kalici alan tutmaz.
class_name Omurga
extends RefCounted

const PerdeGecisi = preload("res://src/koy/perde_gecisi.gd")

const DONEM_KURULUS := &"kurulus"
const DONEM_YERLESME := &"yerlesme"
const DONEM_OTURMA := &"oturma"

const KURULUS_UST_SINIR := 7
const YERLESME_UST_SINIR := 13


## OMR-02: Perde 1 uc doneme bolunur: kurulus (nufus < 8), yerlesme (8-13), oturma (14-18+).
static func donem(kaynak: Variant) -> StringName:
	var n := _nufus_coz(kaynak)
	if n < 8:
		return DONEM_KURULUS
	if n <= 13:
		return DONEM_YERLESME
	return DONEM_OTURMA


## OMR-04: Perde 2 uc dalgaya bolunur (1: baski gelir, 2: baski sikisir, 3: kapanis).
## `perde2_hedef_gece` degisince dalga sinirlari oranla kayar (orn. 12 -> 4+4+4, 15 -> 5+5+5).
static func dalga(kaynak: Variant, hedef_gece: int = 12) -> int:
	var cozulmus := _perde2_gece_coz(kaynak, hedef_gece)
	var g := maxi(0, int(cozulmus["gece"]))
	var h := maxi(3, int(cozulmus["hedef"]))
	var sinir1 := float(h) / 3.0
	var sinir2 := (float(h) * 2.0) / 3.0
	if float(g) < sinir1:
		return 1
	if float(g) < sinir2:
		return 2
	return 3


static func dalga_sinirlari(hedef_gece: int = 12) -> Dictionary:
	var h := maxi(3, hedef_gece)
	return {
		"dalga_1_bitis": int(floor(float(h) / 3.0)),
		"dalga_2_bitis": int(floor((float(h) * 2.0) / 3.0)),
		"hedef_gece": h,
	}


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
	var h := varsayilan_hedef
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
