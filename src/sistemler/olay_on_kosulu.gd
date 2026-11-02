## BUG-16: yalnız güncel köyü okur; ayrı olay seçicisi/RNG veya kayıt alanı tutmaz.
extends RefCounted

const ANAHTARLAR := ["gece_min", "gece_max", "perde", "koyde", "ayrildi", "bayrak", "bayrak_yok", "nufus_min", "sinif_min", "ambar_max", "akce_min", "yapi_min", "bar_max", "bar_min", "sans", "tarla_ekili_min", "bina_var", "nufus_en_az", "cocuk_var", "yas_grubu", "yetiskin_hane_min", "mevsim", "kis_mi", "hane_var"]

static func dogrula(k: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	for anahtar in k:
		if anahtar not in ANAHTARLAR:
			hatalar.append("Tanınmayan olay koşulu: " + str(anahtar))
	if k.has("yas_grubu") and str(k.yas_grubu) not in ["cocuk", "yetiskin", "yasli"]:
		hatalar.append("Geçersiz yaş grubu: " + str(k.yas_grubu))
	if k.has("nufus_en_az") and (not (k.nufus_en_az is int or k.nufus_en_az is float) or float(k.nufus_en_az) < 0 or float(k.nufus_en_az) != floor(float(k.nufus_en_az))):
		hatalar.append("nufus_en_az negatif olmayan tam sayı olmalı")
	if k.has("yetiskin_hane_min") and (not (k.yetiskin_hane_min is int or k.yetiskin_hane_min is float) or not is_finite(float(k.yetiskin_hane_min)) or float(k.yetiskin_hane_min) < 0 or float(k.yetiskin_hane_min) != floor(float(k.yetiskin_hane_min))):
		hatalar.append("yetiskin_hane_min negatif olmayan tam sayı olmalı")
	if k.has("cocuk_var") and not k.cocuk_var is bool:
		hatalar.append("cocuk_var boolean olmalı")
	if k.has("hane_var") and not k.hane_var is bool:
		hatalar.append("hane_var boolean olmalı")
	if k.has("kis_mi") and not k.kis_mi is bool:
		hatalar.append("kis_mi boolean olmalı")
	if k.has("mevsim") and not (k.mevsim is int or k.mevsim is float or k.mevsim is Array):
		hatalar.append("mevsim tam sayı veya liste olmalı")
	if k.has("bina_var") and not (k.bina_var is String or k.bina_var is StringName or k.bina_var is Array or k.bina_var is PackedStringArray):
		hatalar.append("bina_var bina adı veya ad listesi olmalı")
	return hatalar

static func uygun(o: Oturum, k: Dictionary) -> bool:
	if not dogrula(k).is_empty(): return false
	if o.yonetim.nufus() < int(k.get("nufus_en_az", 0)): return false
	for tur in binalar(k):
		if not bina_var(o, tur): return false
	if k.has("cocuk_var") and yas_var(o, "cocuk") != bool(k.cocuk_var): return false
	if k.has("hane_var") and gercek_hane_var(o) != bool(k.hane_var): return false
	if k.has("yas_grubu") and not yas_var(o, str(k.yas_grubu)): return false
	if hane_sayisi(o, true) < int(k.get("yetiskin_hane_min", 0)): return false
	var m_gun := o.yonetim.a.mevsim_gun
	if k.has("kis_mi") and Takvim.kis_mi(o.yonetim.gun, m_gun) != bool(k.kis_mi): return false
	if k.has("mevsim"):
		var m := Takvim.mevsim(o.yonetim.gun, m_gun)
		if k.mevsim is Array and m not in k.mevsim: return false
		if (k.mevsim is int or k.mevsim is float) and m != int(k.mevsim): return false
	return true

static func gercek_hane_var(o: Oturum) -> bool:
	for k in o.yonetim.koylular:
		if k.saglik > 0 and k.yas_grubu == &"yetiskin" and k.hane_id >= 0:
			return true
	return false

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

## KAP-19: sayım kişinin evine değil, kalıcı hane kimliğine bakar.
## Legacy hane alanı olmayan her kişi kendi hanesi sayılır; ilişki uydurulmaz.
static var KATMANLAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/olaylar/nufus_katmanlari.json"))

static func hane_sayisi(o: Oturum, yalniz_yetiskin: bool = false) -> int:
	var haneler := {}
	for k in o.yonetim.koylular:
		if k.saglik <= 0 or (yalniz_yetiskin and k.yas_grubu != &"yetiskin"): continue
		var hane := "hane_%d" % k.hane_id if k.hane_id >= 0 else "kisi_%d" % k.id
		haneler[hane] = true
	return haneler.size()

static func katman(o: Oturum) -> String:
	var sayi := hane_sayisi(o)
	if sayi <= int(KATMANLAR.kucuk_hane_azami): return "kucuk"
	if sayi <= int(KATMANLAR.orta_hane_azami): return "orta"
	return "buyuk"

## Yalnız mevcut seçicinin aday filtresi; RNG, görülen kart veya açık kart değişmez.
static func havuzda(o: Oturum, id: StringName) -> bool:
	# Dosya havuzunun dışındaki dinamik/uyarlama kartları kendi koşullarını korur.
	if String(id) not in KATMANLAR.listeler.buyuk: return true
	return String(id) in KATMANLAR.listeler[katman(o)]

static var AGIRLIKLAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/olay_agirlik.json"))

## OZL-13: hafta başında harman ve pazar_gunu kartlarının ağırlığı çarpan alır; diğer gecelerde taban kalır.
static func agirlik(o: Oturum, kart: OlayVerisi) -> float:
	if kart == null: return 0.0
	var taban := float(kart.agirlik)
	if not Takvim.hafta_basi(o.yonetim.gun, o.yonetim.a.mevsim_gun): return taban
	var carpanlar: Dictionary = AGIRLIKLAR.get("hafta_basi_carpan", {})
	return taban * float(carpanlar.get(String(kart.id), 1.0))
