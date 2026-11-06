## ACL-06: tek kimlik saklanır; yapı/dil bilgisi veriden türetilir.
extends RefCounted
const META := &"acl06_muhafiz_gecmisi"
const SIRA := ["eski_levent", "ahi_ciragi", "medrese_talebesi", "coban_oglu"]
static var VERI: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_gecmisleri.json"))
static var YAPILAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/yapi_bilgisi.json"))

static func kimlik(o: Oturum) -> String:
	return String(o.get_meta(META, ""))

static func sec(o: Oturum, id: String) -> bool:
	if not VERI.has(id) or not kimlik(o).is_empty() or o.gun != 0 or o.get_meta(&"acl06_yuklendi", false):
		return false
	o.set_meta(META, id)
	preload("res://src/koy/yapi_bilgisi.gd").gecmis(o)
	return true

static func yukle(o: Oturum, v: Variant) -> void:
	# Yükleme yalnız yeni oturuma uygulanır; eski kayda seçim uydurulmaz.
	o.set_meta(&"acl06_yuklendi", true)
	if kimlik(o).is_empty() and v is String and VERI.has(v):
		o.set_meta(META, v)
	preload("res://src/koy/yapi_bilgisi.gd").gecmis(o)

static func yapi_bilgisi(o: Oturum) -> PackedStringArray:
	var id := kimlik(o)
	var yapi: String = String(YAPILAR.get("muhafiz_gecmisleri", {}).get(id, ""))
	return PackedStringArray([yapi]) if not yapi.is_empty() else PackedStringArray()

static func diller(o: Oturum) -> PackedStringArray:
	return PackedStringArray(VERI.get(kimlik(o), {}).get("diller", []))
