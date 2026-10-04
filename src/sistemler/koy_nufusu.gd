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


## Köyden bir kişi çıkarır (sınıfta kimse yoksa bir şey olmaz).
func cikar(sinif: StringName, adli_id: StringName = &"") -> void:
	if int(sayilar[sinif]) <= 0:
		return
	sayilar[sinif] = int(sayilar[sinif]) - 1
	if adli_id != &"":
		adlilar.erase(adli_id)
	degisti.emit()


## Nüfusu olan sınıflardan rastgele `adet` kişi çıkarır.
func cikar_rastgele(adet: int, rng: RandomNumberGenerator) -> void:
	for k in adet:
		var dolu: Array[StringName] = []
		for s in sayilar:
			if int(sayilar[s]) > 0:
				dolu.append(s)
		if dolu.is_empty():
			return
		cikar(dolu[rng.randi_range(0, dolu.size() - 1)])
