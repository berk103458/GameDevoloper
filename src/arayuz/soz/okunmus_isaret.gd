## AYR-10: Görülmüş seçenek soluk renkle işaretlenir. Kayıt kişi hafızasıyla aynı sözlüktür.
extends RefCounted

const ALAN := "gorulen_secenekler"


static func soluk_mu(a: Ayarlar, kadro: KarakterKadrosu, kisi_id: StringName, secenek: String) -> bool:
	if a == null or not bool(a.al(&"okunmus_isaret")):
		return false
	return secenek in _liste(kadro, kisi_id)


static func isaretle(kadro: KarakterKadrosu, kisi_id: StringName, secenek: String) -> void:
	if kadro == null or kisi_id == &"" or secenek.is_empty():
		return
	var kayit := _kayit(kadro, kisi_id)
	var liste: Array = kayit.get(ALAN, [])
	if secenek not in liste:
		liste.append(secenek)
	kayit[ALAN] = liste
	kadro.durumlar[kisi_id] = kayit


static func renk(soluk: bool) -> Color:
	return Color(1, 1, 1, 0.45) if soluk else Color(1, 1, 1, 1)


static func _kayit(kadro: KarakterKadrosu, kisi_id: StringName) -> Dictionary:
	var ham: Variant = kadro.durumlar.get(kisi_id, {})
	return (ham as Dictionary).duplicate(true) if ham is Dictionary else {}


static func _liste(kadro: KarakterKadrosu, kisi_id: StringName) -> Array:
	if kadro == null:
		return []
	var ham: Variant = _kayit(kadro, kisi_id).get(ALAN, [])
	return ham if ham is Array else []
