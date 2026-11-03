# gdlint: disable=max-line-length
class_name SozDugumu
extends RefCounted

## DIY-02: Söz motorunun tekil düğüm veri yapısı.

var id: String = ""
var satir: Variant = ""
var konu: String = ""
var katman: int = 0
var beyan: Dictionary = {}
var ikram: String = ""
var zar: Dictionary = {}
var secenekler: Array[Dictionary] = []
var kilitler: Dictionary = {}
var son_dugum: bool = false

func _init(p_id: String = "", veri: Dictionary = {}) -> void:
	id = p_id
	satir = veri.get("satir", "")
	konu = str(veri.get("konu", ""))
	katman = int(veri.get("katman", 0))
	if veri.get("beyan") is Dictionary:
		beyan = veri.get("beyan")
	elif veri.get("beyan") is String:
		beyan = {"id": "beyan_" + id, "metin": veri.get("beyan"), "dogru": true}
	ikram = str(veri.get("ikram", ""))
	if veri.get("zar") is Dictionary:
		zar = veri.get("zar")
	if veri.get("kilitler") is Dictionary:
		kilitler = veri.get("kilitler")

	var ham_sec: Array = veri.get("secenekler", [])
	for s in ham_sec:
		if s is Dictionary:
			secenekler.append(s)

	if secenekler.is_empty():
		son_dugum = true
