## KAY-03: SYS-14'ün tek-adım yürütücüsü; dosya okumaz/yazmaz, sürüm tanımlamaz.
extends RefCounted

## Adım listesi yalnız güvenilir kodun Callable'larından gelir; kayıt dosyasından kod yüklenmez.
static func uygula(kayit: Dictionary, hedef_surumu: int, adimlar: Dictionary) -> Dictionary:
	var surum := _surum(kayit.get("surum"))
	if surum < 0 or hedef_surumu < surum: return {}
	var veri := kayit.duplicate(true)
	while surum < hedef_surumu:
		var adim: Variant = adimlar.get(surum)
		if not adim is Callable or not adim.is_valid(): return {}
		# Hatalı adım ne başlangıç sözlüğüne ne önceki sağlam adıma yazabilir.
		var sonuc: Variant = adim.call(veri.duplicate(true))
		if not sonuc is Dictionary or _surum(sonuc.get("surum")) != surum + 1: return {}
		veri = sonuc.duplicate(true)
		surum += 1
	return veri

static func _surum(v: Variant) -> int:
	if (v is int or v is float) and is_finite(float(v)) and float(v) >= 0 and float(v) == floor(float(v)) and float(v) <= 1000000000:
		return int(v)
	return -1
