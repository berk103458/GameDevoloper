## AYR-09: Satır belirmesi ve zar animasyonu `Ayarlar.belirme_ms` tek kaynağını okur.
extends RefCounted


static func satir_ms(a: Ayarlar, taban: float) -> float:
	if a == null:
		return taban
	return a.belirme_ms(taban)


static func zar_ms(a: Ayarlar, taban: float) -> float:
	return preload("res://src/arayuz/kapi/zar_sonucu.gd").animasyon_ms(a, taban)
