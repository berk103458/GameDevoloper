## EKO-04: seçilebilir buğday → un → ekmek (mevcut gida stoğu).
## Eski tarla/bostan erzak ve değirmen ogutme tarif kimlikleri korunur.
class_name TahilZinciri
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/tahil_zinciri.json"))
## Fırını dış denge verisinden mevcut katalog uzantısına ekler.
static func ekle(turler: Dictionary) -> void:
	turler["firin"] = AYAR.firin.duplicate(true)
## Ham katalog korunarak yeni tahıl tariflerini mevcut kimliklerin yanına ekler.
static func tarifler(tur: String, temel: Dictionary) -> Dictionary:
	if tur not in ["tarla", "bostan", "degirmen"]: return temel
	var r: Dictionary = temel.duplicate(true)
	r.merge(AYAR.tarifler[tur], true)
	return r
## CSV kilidi boyunca yeni oyuncu etiketlerini okunur Türkçe olarak döndürür.
static func ad(anahtar: String) -> String:
	return {"koy.kaynak.bugday": "Buğday", "koy.kaynak.un": "Un", "koy.recete.bugday": "Buğday hasadı", "koy.recete.un": "Un · 2 buğday", "koy.recete.ekmek": "Ekmek · 2 un + 1 odun", "koy.yapi.firin": "Köy Fırını", "koy.yapi.firin_aciklama": "İki un ve bir yakacak odunu ekmeğe işler; ekmek mevcut erzak stoğuna eklenir. Unsuz çalışmaz."}.get(anahtar, OdunZinciri.ad(anahtar))
