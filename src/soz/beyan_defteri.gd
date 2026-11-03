# gdlint: disable=max-line-length
class_name BeyanDefteri
extends RefCounted

## DIY-06: Beyan defteri — karakterin söyledikleri kayda geçer.

var beyanlar: Array[Dictionary] = []

func temizle() -> void:
	beyanlar.clear()

func beyan_ekle(beyan_id: String, metin: String, dogru: bool = true, kanit_id: String = "") -> void:
	# Mükerrer beyan kontrolü
	for b in beyanlar:
		if str(b.get("id")) == beyan_id:
			return
	beyanlar.append({
		"id": beyan_id,
		"metin": metin,
		"dogru": dogru,
		"kanit_id": kanit_id,
		"zaman": Time.get_unix_time_from_system()
	})

func beyan_al(beyan_id: String) -> Dictionary:
	for b in beyanlar:
		if str(b.get("id")) == beyan_id:
			return b
	return {}

func tum_beyanlar() -> Array[Dictionary]:
	return beyanlar.duplicate(true)
