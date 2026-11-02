## KAP-17: mevcut karar listesi ve anlatı satırı; ikinci panel yok.
extends RefCounted
const A = preload("res://src/kapi/aile_kafilesi.gd")
static func secenekler(g: Gelen, liste: PackedStringArray) -> PackedStringArray:
	var sonuc := liste.duplicate()
	if A.bolunur(g) and not sonuc.has("cocuklari_al"): sonuc.append("cocuklari_al")
	return sonuc
static func sonuc(e: KapiEkrani, g: Gelen, r: Dictionary) -> bool:
	if not r.get("aile", false): return false
	e._yaz("Kafile: %d kişi içeri alındı, %d kişi kapı dışında kaldı." % [int(r.kabul_edilen), int(r.disarida_kalan)])
	return true
