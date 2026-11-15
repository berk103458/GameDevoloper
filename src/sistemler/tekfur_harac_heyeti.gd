## HAR-03: mevcut Tekfur döngüsünün kamu akçesi ve buğday talebi.
class_name TekfurHaracHeyeti
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/tekfur_harac_heyeti.json"))
## DNY-03: haraç kapısı dünya olayı çarpanını uygular (ikinci heyet oluşturmaz).
static func harac_bedeli(y: KoyYonetimi) -> Dictionary:
	var c := DunyaEtkisi.y_carpani(y, "harac")
	return {"akce": ceili(float(y.a.harac_akce) * c), "bugday": ceili(float(y.a.harac_gida) * c)}
## İki kamu kaynağı yeterliyse mevcut bekleyen talebi bir kez kapatır.
static func ode(y: KoyYonetimi) -> bool:
	if y.son != KoyYonetimi.SON_YOK or not y.harac_bekliyor: return false
	var bedel := harac_bedeli(y)
	if y.akce < int(bedel.akce) or y.kaynaklar.miktar("bugday") < int(bedel.bugday): return false
	y.akce -= int(bedel.akce)
	y.kaynaklar.azalt("bugday", int(bedel.bugday))
	y.harac_bekliyor = false
	y.set_meta("tekfur_haraci_karar", "kabul")
	return true
## Aynı gece raporu; ikinci heyet veya sayaç oluşturmaz.
static func olay(y: KoyYonetimi) -> Dictionary:
	var bedel := harac_bedeli(y)
	return {"anahtar":"koy.olay.harac", "deger":[int(bedel.akce), int(bedel.bugday)], "tekfur_harac":{"akce":int(bedel.akce),"bugday":int(bedel.bugday)}}
## Mevcut bant/rapor için tek insan metni, runtime'a yazmaz.
static func metin(v: Dictionary) -> String:
	return String(AYAR.talep) % [int(v.akce),int(v.bugday)]
