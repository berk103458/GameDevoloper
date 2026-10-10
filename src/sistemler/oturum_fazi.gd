## BUG-0013: son kaydedilen ekran fazı. Legacy/bozuk alan kapıdan devam eder;
## eski kayıtta köy fazını kanıtsız tahmin etmeyiz. Kapı içi snapshot yerine geçmez.
extends RefCounted

const META := &"oturum_fazi"

static func oku(v: Variant) -> String:
	return "koy" if v is String and v == "koy" else "kapi"

static func durum(o: Oturum) -> String:
	return oku(o.get_meta(META, "kapi"))

static func ayarla(o: Oturum, faz: String) -> void:
	o.set_meta(META, oku(faz))
