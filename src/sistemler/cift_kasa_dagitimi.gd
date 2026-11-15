## Rüşvet kişisel gelir; müsadere ve geçiş harcı kamu geliridir.
extends RefCounted

static func esyalari_yukle(kayit: Array) -> Array[Dictionary]:
	var esyalar: Array[Dictionary] = []
	for veri in kayit:
		if not veri is Dictionary:
			continue
		var esya: Dictionary = veri.duplicate(true)
		esya["adet"] = maxi(0, int(esya.get("adet", 1)))
		if esya.has("deger"):
			esya["deger"] = maxi(0, int(esya["deger"]))
		KaraborsaAdaptoru.kayit(esya)
		esyalar.append(esya)
	return preload("res://src/koy/usta_defterleri.gd").duzenle(esyalar)

static func kisisel_rusvet(gelen: Gelen, varsayilan: int) -> Dictionary:
	var sonuc := {"akce": 0, "esyalar": []}
	var sorgu := gelen.chr_sorgusu()
	if sorgu != null:
		var karar: Dictionary = sorgu.karakter.karar_verisi(&"rusvet")
		sonuc["akce"] = int(karar.get("muhafiz_akce", 0))
		for esya in karar.get("esyalar", []):
			sonuc["esyalar"].append({"kaynak": String(esya), "adet": 1, "edinim": "rusvet"})
		return sonuc
	if gelen.heybe == null:
		sonuc["akce"] = varsayilan
		return sonuc
	for esya in gelen.heybe.esyalar:
		var adet := int(esya.get("alinan", 0))
		if adet < 1:
			continue
		if esya["tur"] == "akce":
			sonuc["akce"] += adet * int(esya["deger"])
		else:
			sonuc["esyalar"].append({"id": esya["id"], "tur": esya["tur"], "adet": adet, "deger": esya["deger"], "edinim": "rusvet"})
	return sonuc
