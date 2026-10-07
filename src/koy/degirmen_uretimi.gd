## Mevcut toplu gıda modelinde öğütme: 2 ham erzak → 3 temel işlenmiş erzak.
## Bu UZM-08 denge adaptörü; ayrı buğday/un zinciri EKO paketlerinde genişletilir.
class_name DegirmenUretimi
extends RefCounted
static func ekler(temel: Dictionary) -> Dictionary:
	if not temel.has("tarla"): return {}
	var v: Dictionary = temel["tarla"].duplicate(true)
	v["kurulabilir"] = true
	v["uzmanlik"] = "degirmenci"
	v["kis_durur"] = false
	v["receteler"] = {"ogutme": {"girdi": {"gida": 2}, "uretim": {"gida": 3.0}}}
	return {"degirmen": v}
