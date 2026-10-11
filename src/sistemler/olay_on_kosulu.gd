## BUG-16: yalnız güncel köyü okur; ayrı olay seçicisi/RNG veya kayıt alanı tutmaz.
extends RefCounted

const ANAHTARLAR := ["gece_min", "gece_max", "perde", "koyde", "ayrildi", "bayrak", "bayrak_yok", "nufus_min", "sinif_min", "ambar_max", "akce_min", "yapi_min", "bar_max", "bar_min", "sans", "tarla_ekili_min", "bina_var", "nufus_en_az", "cocuk_var", "yas_grubu"]

static func dogrula(k: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	for anahtar in k:
		if anahtar not in ANAHTARLAR:
			hatalar.append("Tanınmayan olay koşulu: " + str(anahtar))
	if k.has("yas_grubu") and str(k.yas_grubu) not in ["cocuk", "yetiskin", "yasli"]:
		hatalar.append("Geçersiz yaş grubu: " + str(k.yas_grubu))
	if k.has("nufus_en_az") and (not (k.nufus_en_az is int or k.nufus_en_az is float) or float(k.nufus_en_az) < 0 or float(k.nufus_en_az) != floor(float(k.nufus_en_az))):
		hatalar.append("nufus_en_az negatif olmayan tam sayı olmalı")
	if k.has("cocuk_var") and not k.cocuk_var is bool:
		hatalar.append("cocuk_var boolean olmalı")
	if k.has("bina_var") and not (k.bina_var is String or k.bina_var is StringName or k.bina_var is Array or k.bina_var is PackedStringArray):
		hatalar.append("bina_var bina adı veya ad listesi olmalı")
	return hatalar

static func uygun(o: Oturum, k: Dictionary) -> bool:
	if not dogrula(k).is_empty(): return false
	if o.yonetim.nufus() < int(k.get("nufus_en_az", 0)): return false
	for tur in binalar(k):
		if not bina_var(o, tur): return false
	if k.has("cocuk_var") and yas_var(o, "cocuk") != bool(k.cocuk_var): return false
	if k.has("yas_grubu") and not yas_var(o, str(k.yas_grubu)): return false
	return true

static func binalar(k: Dictionary) -> PackedStringArray:
	var deger: Variant = k.get("bina_var", [])
	return PackedStringArray([str(deger)]) if deger is String or deger is StringName else PackedStringArray(deger)

static func bina_var(o: Oturum, tur: String) -> bool:
	# ROADMAP 1 eski yapı imzaları mevcut ekonomi adaptöründen okunur.
	if tur in ["pazar", "kervansaray", "konak", "sur"]:
		return o._eski_yapi_seviyesi(tur) > 0
	return o._yapi_sayisi(tur) > 0

static func yas_var(o: Oturum, yas: String) -> bool:
	for kisi in o.yonetim.koylular:
		if kisi.saglik > 0 and str(kisi.yas_grubu) == yas: return true
	return false
