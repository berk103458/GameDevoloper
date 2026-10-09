## HAR-13: yalnız HAR-06'nın ürettiği kuyruğun sunumu; gece/ziyaret/RNG üretmez.
extends RefCounted

## Tüm kuyruk sayılır; CHR kimliği, niyet, heybe ve sorgu verisi okunmaz.
static func kuyruktan(liste: Array[Gelen]) -> Dictionary:
	var d := {"toplam":liste.size(), "yolcu":0, "tuccar":0, "ticaret_yolcusu":0, "heyetler":[]}
	for g in liste:
		var b := DiplomatikHeyet.bilet(g)
		if not b.is_empty():
			# Yalnız HAR-12'nin herkese açık heyet adı; bilet/makbuz dışarı çıkmaz.
			d.heyetler.append(String(DiplomatikHeyet.AYAR.heyetler[b.tur].ad))
		elif TuccarKapiGecisi.ilgilenir(g):
			d.tuccar += 1
		else:
			d.yolcu += 1
			if g.sinif == StringName(GuvenlikKafileDengesi.AYAR.ticaret_sinifi): d.ticaret_yolcusu += 1
	return d

static func metin(d: Dictionary) -> String:
	if d.is_empty(): return ""
	if int(d.toplam) == 0: return "Kafile özeti: beklenen kapı ziyareti yok."
	var satirlar := PackedStringArray([
		"Kafile özeti: %d kapı ziyareti" % int(d.toplam),
		"Yolcu: %d · Gezgin tüccar: %d · Heyet: %d" % [int(d.yolcu), int(d.tuccar), d.heyetler.size()]
	])
	if int(d.get("ticaret_yolcusu",0)) > 0: satirlar.append("Yolcuların içinde ticaret yolcusu (esnaf): %d" % int(d.ticaret_yolcusu))
	for ad in d.heyetler: satirlar.append("Öncelikli heyet: " + String(ad))
	return "\n".join(satirlar)
