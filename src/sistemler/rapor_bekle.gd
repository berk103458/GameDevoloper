## AYR-26: Gece raporu açıkken zamanlayıcı 0'dır; oyuncu kapatır.
extends RefCounted

const KAPALI_MS := 4000


static func zamanlayici_ms(a: Ayarlar) -> int:
	if a == null or not a.degerler.has(&"rapor_bekle") or bool(a.degerler[&"rapor_bekle"]):
		return 0
	return KAPALI_MS


static func uygula(kart: Node, a: Ayarlar) -> int:
	var ms := zamanlayici_ms(a)
	if kart != null:
		kart.set_meta(&"rapor_zamanlayici_ms", ms)
	return ms
