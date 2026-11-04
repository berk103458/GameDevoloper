## AYR-17: Zar sonucu rakam ve geçti/kaldı sözüyle yazılır.
extends RefCounted


static func metin(zar: int, gecti: bool) -> String:
	var soz := TranslationServer.translate("arayuz.ayarlar.zar.gecti") if gecti else TranslationServer.translate("arayuz.ayarlar.zar.kaldi")
	return "%d %s" % [zar, soz]


static func animasyon_ms(a: Ayarlar, taban: float) -> float:
	if a == null:
		return taban
	var ms := a.belirme_ms(taban)
	if a.al(&"belirme_hizi") == &"aninda":
		return minf(ms, 200.0)
	return ms
