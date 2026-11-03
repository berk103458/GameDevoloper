## AYR-24: Köy ekranı açılınca varsayılan hız ayardan gelir.
extends RefCounted


static func acilis(a: Ayarlar) -> int:
	if a == null or not a.degerler.has(&"koy_hizi_varsayilan"):
		return 1
	return clampi(int(a.al(&"koy_hizi_varsayilan")), 1, 3)
