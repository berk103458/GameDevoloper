## KAY-08 / KAY-50 / KAY-62: ziyaret beyanları kişi kimliğinin altında, tekil ve tavanlıdır.
class_name BeyanDefteri
extends RefCounted

var _satirlar: Array[Dictionary] = []


func satirlar() -> Array[Dictionary]:
	return _satirlar.duplicate(true)


func ekle(kisi: String, id: String, gece: int) -> bool:
	var kim := id.strip_edges()
	if kim.is_empty():
		return false
	for satir in _satirlar:
		if String(satir.get("id", "")) == kim:
			return false
	var adet := 0
	for satir in _satirlar:
		if String(satir.get("kisi", "")) == kisi:
			adet += 1
	if adet >= KisiHafizasi.BEYAN_TAVANI:
		push_warning("KAY50_BEYAN_TAVANI")
		return false
	_satirlar.append({"id": kim, "kisi": kisi, "gece": gece})
	return true


## Gece kapanınca satırlar kişi kimliğinin altında kalır; ikinci yazım listeyi uzatmaz.
func gece_kapat(kisi: String) -> int:
	var adet := 0
	for satir in _satirlar:
		if String(satir.get("kisi", "")) == kisi:
			satir["kapandi"] = true
			adet += 1
	return adet


func kaydet() -> Array:
	return _satirlar.duplicate(true)


func yukle(veri: Variant) -> bool:
	_satirlar.clear()
	if not veri is Array:
		push_warning("KAY18_BEYAN")
		return true
	for satir in veri:
		if not satir is Dictionary:
			continue
		var kim := String(satir.get("id", "")).strip_edges()
		if kim.is_empty():
			push_warning("KAY62_BEYAN")
			continue
		if _kimlik_var(kim):
			continue
		_satirlar.append((satir as Dictionary).duplicate(true))
	var gruplar := {}
	var sira: Array[String] = []
	for satir in _satirlar:
		var kisi := String(satir.get("kisi", ""))
		if not gruplar.has(kisi):
			gruplar[kisi] = []
			sira.append(kisi)
		(gruplar[kisi] as Array).append(satir)
	_satirlar.clear()
	for kisi in sira:
		for satir in KisiHafizasi.beyan_tavanina_sigdir(gruplar[kisi]):
			if satir is Dictionary:
				_satirlar.append(satir)
	return true


func _kimlik_var(kim: String) -> bool:
	for satir in _satirlar:
		if String(satir.get("id", "")) == kim:
			return true
	return false
