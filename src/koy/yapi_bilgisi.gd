## YAP-02: bilgi yalnız mevcut kişinin optional alanında taşınır.
extends RefCounted

## Kabulden önce adayın bilgisi köyde yoktur. Meslek eşlemesi UZM tek kaynağıdır.
static func kabul_bilgisi(k: Koylu, veri: Dictionary) -> PackedStringArray:
	var bilgi := YapiKilidi.bilgi_oku(veri.get("yapi_bilgisi"))
	if CirakEgitimi.usta(k):
		bilgi.append_array(YapiKilidi.bilgi_oku(MeslekUyumu.UYGUN.get(k.zanaat_turu, [])))
	return YapiKilidi.bilgi_oku(bilgi)

static func ekle(k: Koylu, bilgi: PackedStringArray) -> void:
	var hepsi := k.yapi_bilgisi.duplicate()
	hepsi.append_array(bilgi)
	k.yapi_bilgisi = YapiKilidi.bilgi_oku(hepsi)

## Geçmiş kimliği ACL-06'da; ikinci geçmiş veya köy geneli bilgi bayrağı yok.
static func gecmis(o: RefCounted) -> void:
	var bilgi := preload("res://src/sistemler/muhafiz_gecmisi.gd").yapi_bilgisi(o)
	for k in o.yonetim.koylular:
		if k.bayrak_var("acl01_muhafiz") and k.saglik > 0:
			ekle(k, bilgi)
			return

## UZM-11 tam ustalık gerekir; UZM-04 yarı ustalık bunu erkenden açmaz.
static func ciraklar(y: KoyYonetimi) -> void:
	for k in y.koylular:
		if k.saglik <= 0 or not KoyluGelisimYoneticisi.usta(k) or k.egitim.is_empty(): continue
		var usta := y.koylu(int(k.egitim.get("usta", -1)))
		if usta == null or usta.saglik <= 0 or not CirakEgitimi.usta(usta): continue
		if k.is_yeri != int(k.egitim.get("bina", -1)) or usta.is_yeri != k.is_yeri: continue
		ekle(k, usta.yapi_bilgisi)
