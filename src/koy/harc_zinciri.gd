## EKO-05: ham taş → kireç → harç; taş ev ve taş sur inşaatı.
class_name HarcZinciri
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/harc_zinciri.json"))
## Yeni yapı türlerini dış denge verisinden ekler; eski katalog korunur.
static func ekle(turler: Dictionary) -> void:
	for tur in ["kirec_kuyusu", "tas_ev"]: turler[tur] = AYAR[tur].duplicate(true)
## Yalnız son taksitte gereken malzemeleri verir; seviye 1 ahşap çittir.
static func sur_malzeme(y: KoyYonetimi) -> Dictionary:
	if y.sur_taksit_odenen + 1 < y.a.sur_taksit: return {}
	return AYAR.sur_malzeme.get(str(y.sur_seviye + 1), {}).duplicate()
## CSV koruması boyunca yeni stok, yapı ve tarif adlarının okunur karşılığı.
static func ad(anahtar: String) -> String:
	return {"koy.kaynak.kirec": "Kireç", "koy.kaynak.harc": "Harç", "koy.yapi.kirec_kuyusu": "Kireç Kuyusu", "koy.yapi.kirec_kuyusu_aciklama": "Ham taş ve yakacaktan kireç; kireç ve taştan inşaat harcı üretir.", "koy.yapi.tas_ev": "Taş Ev", "koy.yapi.tas_ev_aciklama": "Altı yataklı taş ev; taş ve harçla örülür.", "koy.recete.kirec": "Kireç · 2 taş + 1 odun", "koy.recete.harc": "Harç · 2 kireç + 2 taş"}.get(anahtar, TahilZinciri.ad(anahtar))
## Sur malzeme bedelini oyuncuya son taksit öncesinde de açıklar.
static func sur_aciklama(y: KoyYonetimi) -> String:
	var m: Dictionary = AYAR.sur_malzeme.get(str(y.sur_seviye + 1), {})
	if m.is_empty(): return ""
	return "Son taksit: %d taş + %d harç" % [int(m.tas), int(m.harc)]
