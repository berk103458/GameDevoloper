## HAR-03: mevcut Tekfur döngüsünün kamu akçesi ve buğday talebi.
class_name TekfurHaracHeyeti
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/tekfur_harac_heyeti.json"))
## İki kamu kaynağı yeterliyse mevcut bekleyen talebi bir kez kapatır.
static func ode(y: KoyYonetimi) -> bool:
	if y.son != KoyYonetimi.SON_YOK or not y.harac_bekliyor: return false
	if y.akce < y.a.harac_akce or y.kaynaklar.miktar("bugday") < y.a.harac_gida: return false
	y.akce -= y.a.harac_akce
	y.kaynaklar.azalt("bugday", y.a.harac_gida)
	y.harac_bekliyor = false
	y.set_meta("tekfur_haraci_karar", "kabul")
	return true
## Aynı gece raporu; ikinci heyet veya sayaç oluşturmaz.
static func olay(y: KoyYonetimi) -> Dictionary:
	return {"anahtar":"koy.olay.harac", "deger":[y.a.harac_akce,y.a.harac_gida], "tekfur_harac":{"akce":y.a.harac_akce,"bugday":y.a.harac_gida}}
## Mevcut bant/rapor için tek insan metni, runtime'a yazmaz.
static func metin(v: Dictionary) -> String:
	return String(AYAR.talep) % [int(v.akce),int(v.bugday)]
