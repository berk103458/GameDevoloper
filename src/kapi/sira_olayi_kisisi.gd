## BUG-19: metin ve canlandırma aynı gerçek kuyruk modelini kullanır; RNG/kayıt üretmez.
class_name SiraOlayiKisisi
extends RefCounted
static var BILGI: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/model_kisi_bilgileri.json"))

## Yalnız gerçekten yüklenen modelde çağrılır; kapsülün cinsiyeti bilinmez.
static func model_kur(k: KarakterModel, ad: String) -> void:
	if not BILGI.has(ad): return
	k.set_meta("cinsiyet", BILGI[ad])
	k.set_meta("yas_grubu", YasRolleri.kaynak(StringName(ad)))

static func indeks(anahtar: String, n: int) -> int:
	if n < 2: return -1
	match anahtar:
		"kavga": return 0
		"bayilma": return mini(2, n - 1)
		"atlama", "panik", "vazgecme": return n - 1
	return -1

static func sec(s: KapiSahnesi, anahtar: String) -> KarakterModel:
	var i := indeks(anahtar, s._kuyruktakiler.size())
	return s._kuyruktakiler[i] if i >= 0 else null

static func anahtar(k: KarakterModel) -> String:
	var c := String(k.get_meta("cinsiyet", "")) if is_instance_valid(k) else ""
	if c not in ["e", "k"]: return "olay.sira.kisi.biri"
	var yas := String(k.get_meta("yas_grubu", "yetiskin"))
	if yas == "cocuk": return "olay.sira.kisi.cocuk"
	if yas == "yasli": return "olay.sira.kisi.yasli_kadin" if c == "k" else "olay.sira.kisi.yasli_adam"
	return "olay.sira.kisi.kadin" if c == "k" else "olay.sira.kisi.adam"

static func metin(sablon: String, kisi: String) -> String:
	return GuvenliMetin.metin(sablon).replace("{kisi}", kisi)
