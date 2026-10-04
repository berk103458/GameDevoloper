## Köy nüfusu: sınıf başına sayı ve köydeki adlı karakterler.
class_name KoyNufusu
extends RefCounted

signal degisti

var sayilar: Dictionary = {&"asker": 0, &"esnaf": 0, &"ciftci": 0}
## Köye giren adlı karakterlerin kimlikleri, giriş sırasıyla.
var adlilar: Array[StringName] = []
## Bu gece köye girenler (köy görünümünde yürüyerek girer): {sinif, portre}.
var bu_gece_girenler: Array[Dictionary] = []


## Köye bir kişi ekler.
func ekle(sinif: StringName, adli_id: StringName = &"", portre: String = "") -> void:
	sayilar[sinif] = int(sayilar[sinif]) + 1
	if adli_id != &"":
		adlilar.append(adli_id)
	bu_gece_girenler.append({"sinif": sinif, "adli_id": adli_id, "portre": portre})
	degisti.emit()


func toplam() -> int:
	return int(sayilar[&"asker"]) + int(sayilar[&"esnaf"]) + int(sayilar[&"ciftci"])


func sayi(sinif: StringName) -> int:
	return int(sayilar[sinif])
