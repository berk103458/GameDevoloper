## Karakter kadrosu: adlı karakterlerin oturum durumu ve dönüş kuralları
## (design/gdd/karakter-kadrosu.md, F1–F3).
class_name KarakterKadrosu
extends RefCounted

var _katalog: Katalog
var _rng_donus: RandomNumberGenerator
var _rng_ad: RandomNumberGenerator
## id -> {durum, ziyaret, son_gece, son_karar, donus, istendi}
var durumlar: Dictionary = {}
var _bu_gece_adlar: Dictionary = {}


func _init(katalog: Katalog, rng_donus: RandomNumberGenerator, rng_ad: RandomNumberGenerator) -> void:
	_katalog = katalog
	_rng_donus = rng_donus
	_rng_ad = rng_ad
	for k in katalog.karakterler():
		durumlar[k.id] = {"durum": &"gelmedi", "ziyaret": 0, "son_gece": -1, "son_karar": &"", "donus": -1, "istendi": false}


## Bu gece kapıya gelebilecek adlı karakterler.
func uygunlar(gece: int) -> Array[StringName]:
	var sonuc: Array[StringName] = []
	for k in _katalog.karakterler():
		var d: Dictionary = durumlar[k.id]
		if d["istendi"]:
			continue
		if d["durum"] == &"gelmedi" and gece >= k.en_erken_gece:
			sonuc.append(k.id)
		elif d["durum"] == &"donebilir" and gece >= int(d["donus"]):
			sonuc.append(k.id)
	return sonuc


## Varış kuyruğu bir karakteri bu geceye ister. Uygun değilse false.
func iste(id: StringName, gece: int) -> bool:
	if not id in uygunlar(gece):
		push_error("Uygun olmayan karakter istendi: %s" % id)
		return false
	durumlar[id]["istendi"] = true
	return true


## Sohbet açıldığında: ziyaret sayılır.
func ziyaret_basladi(id: StringName, gece: int) -> void:
	durumlar[id]["ziyaret"] = int(durumlar[id]["ziyaret"]) + 1
	durumlar[id]["son_gece"] = gece


## Karar sonucu: kaldı ya da gitti. Dönüş kuralı yalnız "gitti"de çalışır.
func sonuc(id: StringName, kaldi: bool, karar: StringName, gece: int) -> void:
	var d: Dictionary = durumlar[id]
	d["son_karar"] = karar
	if kaldi:
		d["durum"] = &"koyde"
		return
	var k := _katalog.karakter(id)
	var ziyaret: int = d["ziyaret"]
	match k.donus_kurali:
		&"hic_donmez":
			d["durum"] = &"kalici_ayrildi"
		&"oranla_doner":
			if ziyaret >= k.k_azami:
				d["durum"] = &"kalici_ayrildi"
			else:
				var p := clampf(k.p0 * pow(k.d, ziyaret - 1), 0.0, 1.0)
				if _rng_donus.randf() < p:
					d["durum"] = &"donebilir"
					d["donus"] = gece + _rng_donus.randi_range(k.g_min, k.g_max)
				else:
					d["durum"] = &"kalici_ayrildi"
		&"birden_cok_gelir":
			if ziyaret < k.n_ziyaret:
				d["durum"] = &"donebilir"
				d["donus"] = gece + _rng_donus.randi_range(k.g_min, k.g_max)
			else:
				d["durum"] = &"kalici_ayrildi"


## Gece sonunda "bu gece istendi" işaretleri temizlenir.
func gece_bitti() -> void:
	_bu_gece_adlar = {}
	for id in durumlar:
		durumlar[id]["istendi"] = false


## Bir sınıf şablonundan figür örneği: {ad_anahtari, cesit}.
func figur_ornegi(sablon: SinifSablonu) -> Dictionary:
	var havuz := sablon.ad_havuzu
	var kullanilan: Array = _bu_gece_adlar.get(sablon.id, [])
	if kullanilan.size() >= havuz.size():
		kullanilan = []
	var adaylar: Array[int] = []
	for i in havuz.size():
		if not i in kullanilan:
			adaylar.append(i)
	var secilen := adaylar[_rng_ad.randi_range(0, adaylar.size() - 1)]
	kullanilan.append(secilen)
	_bu_gece_adlar[sablon.id] = kullanilan
	return {"ad_anahtari": havuz[secilen], "cesit": _rng_ad.randi_range(0, sablon.giris_anahtarlari.size() - 1)}


func kaydet() -> Dictionary:
	var veri := {}
	for id in durumlar:
		var d: Dictionary = durumlar[id]
		veri[String(id)] = {"durum": String(d["durum"]), "ziyaret": d["ziyaret"], "son_gece": d["son_gece"],
			"son_karar": String(d["son_karar"]), "donus": d["donus"]}
	return veri


func yukle(veri: Dictionary) -> bool:
	for id in veri:
		if not durumlar.has(StringName(id)):
			push_error("Kayıtta bilinmeyen karakter: %s" % id)
			return false
	for id in veri:
		var v: Dictionary = veri[id]
		durumlar[StringName(id)] = {"durum": StringName(v["durum"]), "ziyaret": int(v["ziyaret"]),
			"son_gece": int(v["son_gece"]), "son_karar": StringName(v["son_karar"]), "donus": int(v["donus"]), "istendi": false}
	return true
