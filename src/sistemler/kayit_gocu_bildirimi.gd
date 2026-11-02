## KAY-06: başarılı göçün tek seferlik teknik rapor makbuzu.
extends RefCounted
const META := &"kayit_gocu_bildirimi"
const ANAHTAR := "kayit.goc.bildirimi"

static func yukle(o: Oturum, v: Variant) -> void:
	if not v is Dictionary or not v.get("bekliyor") is bool: return
	var ilk: Variant = v.get("kaynak")
	var son: Variant = v.get("hedef")
	for n in [ilk, son]:
		if not (n is int or n is float) or not is_finite(float(n)) or floor(float(n)) != float(n): return
	if float(ilk) < 2 or float(ilk) >= float(son) or float(son) > preload("res://src/sistemler/kayit_gocu.gd").GUNCEL_SURUM: return
	o.set_meta(META, {"kaynak":int(ilk), "hedef":int(son), "bekliyor":bool(v.bekliyor)})

static func durum(o: Oturum) -> Dictionary:
	return o.get_meta(META, {}).duplicate(true)

static func gece(o: Oturum, rapor: Dictionary) -> void:
	var d := durum(o)
	if not d.get("bekliyor", false) or not rapor.get("olaylar") is Array: return
	rapor.olaylar.append({"anahtar":ANAHTAR, "deger":[int(d.kaynak), int(d.hedef)]})
	d.bekliyor = false
	o.set_meta(META, d)
