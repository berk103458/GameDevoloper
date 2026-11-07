## AYR-23: Zorluk `denge.json` anahtarlarından biridir ve oyun kaydında durur.
## Değişim Bölüm 39 defterine tek satır olarak yazılır.
extends RefCounted

const DENGE := "res://data/ayarlar/denge.json"


static func anahtarlar() -> PackedStringArray:
	var sonuc := PackedStringArray()
	if not FileAccess.file_exists(DENGE):
		return sonuc
	var veri = JSON.parse_string(FileAccess.get_file_as_string(DENGE))
	if not (veri is Dictionary):
		return sonuc
	var tablo: Variant = (veri as Dictionary).get("zorluk", {})
	if tablo is Dictionary:
		for k in (tablo as Dictionary).keys():
			sonuc.append(String(k))
	return sonuc


static func gecerli(deger: String) -> bool:
	return deger in anahtarlar()


static func oku(deger: Variant) -> String:
	if deger is String or deger is StringName:
		var ad := String(deger)
		if gecerli(ad): return ad
	return "olagan"


static func kayda_yaz(kayit: Dictionary, deger: String) -> Dictionary:
	if gecerli(deger):
		kayit["zorluk"] = deger
	return kayit


static func degistir(a: Ayarlar, kayit: Dictionary, deger: String) -> String:
	if a == null or not gecerli(deger):
		return ""
	var eski := String(a.al(&"zorluk"))
	if not AyarlarEk.ayarla(a, &"zorluk", StringName(deger)):
		return ""
	kayda_yaz(kayit, deger)
	return "zorluk %s -> %s" % [eski, deger]
