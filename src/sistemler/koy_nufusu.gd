## Köy nüfusu: sınıf başına sayı ve köydeki adlı karakterler.
class_name KoyNufusu
extends RefCounted

signal degisti

var sayilar: Dictionary = {&"asker": 0, &"esnaf": 0, &"ciftci": 0}
## Köye giren adlı karakterlerin kimlikleri, giriş sırasıyla.
var adlilar: Array[StringName] = []
## Bu gece köye girenler (köy görünümünde yürüyerek girer): {sinif, portre}.
var bu_gece_girenler: Array[Dictionary] = []
## Köydeki her kişinin saf verisi (karakter kartı ve kayıt için; konum/animasyon tutulmaz):
## {sinif: StringName, adli_id: StringName, ad_anahtari: String, portre: String, karar: StringName, gece: int}
var kisiler: Array[Dictionary] = []


## Köye bir kişi ekler. `karar` kapıdaki karardır (kabul/rusvet/kisla); `gece` giriş gecesi (-1: bilinmiyor).
func ekle(sinif: StringName, adli_id: StringName = &"", portre: String = "", ad_anahtari: String = "",
		karar: StringName = &"kabul", gece: int = -1) -> void:
	sayilar[sinif] = int(sayilar[sinif]) + 1
	if adli_id != &"":
		adlilar.append(adli_id)
	bu_gece_girenler.append({"sinif": sinif, "adli_id": adli_id, "portre": portre})
	kisiler.append({"sinif": sinif, "adli_id": adli_id, "ad_anahtari": ad_anahtari, "portre": portre, "karar": karar, "gece": gece})
	degisti.emit()


## Sayılarla kişi kayıtlarını eşitler (eski kayıtlar ya da kayıtsız ekleme/çıkarma sonrası).
func kisileri_esitle() -> void:
	for s in sayilar:
		var var_olan := 0
		for k in kisiler:
			if k["sinif"] == s:
				var_olan += 1
		while var_olan < int(sayilar[s]):
			kisiler.append({"sinif": s, "adli_id": &"", "ad_anahtari": "", "portre": "", "karar": &"kabul", "gece": -1})
			var_olan += 1
		while var_olan > int(sayilar[s]):
			_kisi_sil(s, &"")
			var_olan -= 1


func _kisi_sil(sinif: StringName, adli_id: StringName) -> void:
	# Adlıysa kimliğiyle; değilse o sınıftaki en son giren adsız kişi.
	for i in range(kisiler.size() - 1, -1, -1):
		var k: Dictionary = kisiler[i]
		if adli_id != &"" and k["adli_id"] == adli_id:
			kisiler.remove_at(i)
			return
	for i in range(kisiler.size() - 1, -1, -1):
		var k: Dictionary = kisiler[i]
		if k["sinif"] == sinif and k["adli_id"] == &"":
			kisiler.remove_at(i)
			return
	for i in range(kisiler.size() - 1, -1, -1):
		if kisiler[i]["sinif"] == sinif:
			kisiler.remove_at(i)
			return


## Kayıt için kişi listesi (yalnız metin ve sayı).
func kisiler_kaydi() -> Array:
	return kisiler.map(func(k: Dictionary) -> Dictionary:
		return {"sinif": String(k["sinif"]), "adli_id": String(k["adli_id"]), "ad": k["ad_anahtari"],
			"portre": k["portre"], "karar": String(k["karar"]), "gece": int(k["gece"])})


## Kayıttan kişi listesini kurar.
func kisileri_yukle(liste: Array) -> void:
	kisiler.clear()
	for v in liste:
		if v is Dictionary and StringName(v.get("sinif", "")) in sayilar:
			kisiler.append({"sinif": StringName(v["sinif"]), "adli_id": StringName(v.get("adli_id", "")),
				"ad_anahtari": String(v.get("ad", "")), "portre": String(v.get("portre", "")),
				"karar": StringName(v.get("karar", "kabul")), "gece": int(v.get("gece", -1))})
	kisileri_esitle()


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
	_kisi_sil(sinif, adli_id)
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
