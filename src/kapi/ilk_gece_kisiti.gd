## OGR-02: ACL-04 ilk aile ziyareti yalnız soru ve karar öğretir.
extends RefCounted

const ACILIS = preload("res://src/sistemler/kapi_acilis_olayi.gd")

static func etkin(o: Oturum, gelen: Gelen) -> bool:
	return gelen != null and o.gun == 0 and gelen.id == ACILIS.AILE

static func heybe_acik(o: Oturum, gelen: Gelen) -> bool:
	return gelen != null and gelen.heybe != null and not etkin(o, gelen)
