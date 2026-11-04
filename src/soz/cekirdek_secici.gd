## KAY-16: kayıtta varyant yoksa o oyunda varyant seçilmez ve tohum yenilenmez.
class_name CekirdekSecici
extends RefCounted

var tohum: int = 0
var varyant: String = ""


func kur(yeni_tohum: int) -> void:
	tohum = yeni_tohum
	varyant = ""


func yukle(veri: Variant) -> void:
	if not veri is Dictionary:
		varyant = ""
		return
	var gelen := String(veri.get("varyant", "")).strip_edges()
	if gelen.is_empty():
		varyant = ""
		return
	varyant = gelen
	if veri.has("tohum") and (veri["tohum"] is int or veri["tohum"] is float):
		tohum = int(veri["tohum"])


func sec() -> String:
	return varyant


func kaydet() -> Dictionary:
	if varyant.is_empty():
		return {}
	return {"tohum": tohum, "varyant": varyant}
