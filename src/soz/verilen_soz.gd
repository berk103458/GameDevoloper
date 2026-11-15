## KAY-09 / KAY-18: verilen söz gün, tür ve tutuldu bilgisini taşır. Açık söz en çok 5'tir.
class_name VerilenSoz
extends RefCounted

const AZAMI_ACIK := 5

var _satirlar: Array[Dictionary] = []


func satirlar() -> Array[Dictionary]:
	return _satirlar.duplicate(true)


func ekle(id: String, kisi: String, gun: int, tur: String, tutuldu: bool) -> bool:
	var kim := id.strip_edges()
	if kim.is_empty() or _kimlik_var(kim):
		return false
	if not tutuldu and acik_sayisi() >= AZAMI_ACIK:
		push_warning("KAY09_ALTINCI")
		return false
	_satirlar.append({
		"id": kim,
		"kisi": kisi,
		"gun": gun,
		"tur": tur,
		"tutuldu": tutuldu,
		"sure": maxi(gun, 0),
	})
	return true


func acik_sayisi() -> int:
	var adet := 0
	for satir in _satirlar:
		if not bool(satir.get("tutuldu", false)) and String(satir.get("sonuc", "")).is_empty():
			adet += 1
	return adet


func kaydet() -> Array:
	return _satirlar.duplicate(true)


## Sözlük gelirse liste boşalır ve oyun açılır. Altıncı satır yüklemede düşmez.
func yukle(veri: Variant) -> bool:
	_satirlar.clear()
	if veri is Dictionary:
		push_warning("KAY18_SOZ_LISTESI")
		return true
	if not veri is Array:
		return false
	for satir in veri:
		if satir is Dictionary:
			_satirlar.append((satir as Dictionary).duplicate(true))
	if acik_sayisi() > AZAMI_ACIK:
		push_warning("KAY09_YUKLEME_DUSURMEDI")
	return true


func _kimlik_var(kim: String) -> bool:
	for satir in _satirlar:
		if String(satir.get("id", "")) == kim:
			return true
	return false
