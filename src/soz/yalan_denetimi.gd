## KAY-10: muhafızın yalanı `dogru: false` taşır. Açığa çıkan yalan gizlenmez.
class_name YalanDenetimi
extends RefCounted

var _satirlar: Array[Dictionary] = []


func ekle(id: String, kisi: String, aciga_cikti: bool = false) -> void:
	var kim := id.strip_edges()
	if kim.is_empty():
		return
	for satir in _satirlar:
		if String(satir.get("id", "")) == kim:
			if aciga_cikti or bool(satir.get("aciga_cikti", false)):
				satir["aciga_cikti"] = true
			satir["dogru"] = false
			return
	_satirlar.append({"id": kim, "kisi": kisi, "dogru": false, "aciga_cikti": aciga_cikti})


func kaydet() -> Array:
	var sonuc: Array = []
	for satir in _satirlar:
		var kopya := satir.duplicate(true)
		kopya["dogru"] = false
		sonuc.append(kopya)
	return sonuc


func yukle(veri: Variant) -> bool:
	_satirlar.clear()
	if not veri is Array:
		return true
	for satir in veri:
		if not satir is Dictionary:
			continue
		var acik := bool(satir.get("aciga_cikti", false))
		_satirlar.append({
			"id": String(satir.get("id", "")),
			"kisi": String(satir.get("kisi", "")),
			"dogru": false,
			"aciga_cikti": acik,
		})
	return true


func aciga_cikti(id: String) -> bool:
	for satir in _satirlar:
		if String(satir.get("id", "")) == id:
			return bool(satir.get("aciga_cikti", false))
	return false
