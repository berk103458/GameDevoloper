## DYL-06: Dil engeli ve tercuman.
## Ortak dil yoksa kirik Turkce veya anlati ("Rumca bir seyler soyluyor...") gorunur; yabanci dilde tam cumle yazilmaz.
## Koyde o dili bilen biri varsa tercuman cagrilir: sabir -2 duser, o koylu o gun yarim calisir (1.0 -> 0.5, ikinci cagri 0'a indirmez).
## Koyde tercuman yoksa veya tercuman bayragi kapaliysa dugme gorunmez (0).
## Es tercuman carpitmaz, aksam sohbetinde (DYL-07) duydugunu anar.
class_name DilEngeli
extends RefCounted


const MuhafizGecmisiSinifi = preload("res://src/sistemler/muhafiz_gecmisi.gd")
const VARSAYILAN_DIL := "turkce"
const SABIR_BEDELI := 2
const YARIM_IS_GUCU := 0.5


## Muhafizin bildigi dilleri ("turkce" + ACL-06 gecmisinden gelen diller) doner.
static func muhafiz_dilleri(oturum: Oturum = null, ek_diller: Array = []) -> Array[String]:
	var sonuc: Array[String] = [VARSAYILAN_DIL]
	if oturum != null:
		for d in MuhafizGecmisiSinifi.diller(oturum):
			var norm := _norm_dil(String(d))
			if not norm.is_empty() and not (norm in sonuc):
				sonuc.append(norm)
	for d in ek_diller:
		var norm := _norm_dil(String(d))
		if not norm.is_empty() and not (norm in sonuc):
			sonuc.append(norm)
	return sonuc


## Muhafiz ile gelen arasinda ortak dil olup olmadigini denetler.
static func ortak_dil_var_mi(muhafiz_dil_listesi: Array, gelen_dil_listesi: Array) -> bool:
	if gelen_dil_listesi.is_empty():
		return true
	var m_norm: Array[String] = []
	for md in muhafiz_dil_listesi:
		m_norm.append(_norm_dil(String(md)))
	if m_norm.is_empty():
		m_norm.append(VARSAYILAN_DIL)

	for gd in gelen_dil_listesi:
		var g_norm := _norm_dil(String(gd))
		if g_norm.is_empty() or (g_norm in m_norm):
			return true
	return false


## Koyde gelenin dilini bilen uygun tercuman olup olmadigina ve tercuman bayragina gore
## tercuman dugmesi sayisini (0 veya 1) doner.
## Ek sart: tercuman bayragi yokken dugme 0'dir.
static func tercuman_dugmesi_sayisi(
	koylular: Array,
	gelen_dilleri: Array,
	tercuman_bayragi: bool = true
) -> int:
	if not tercuman_bayragi:
		return 0
	var uygunlar := uygun_tercumanlar(koylular, gelen_dilleri)
	return 1 if not uygunlar.is_empty() else 0


## Koyde gelenin dillerinden en az birini bilen koyluleri (veya esi) listeler.
static func uygun_tercumanlar(koylular: Array, gelen_dilleri: Array) -> Array:
	var aranan: Array[String] = []
	for gd in gelen_dilleri:
		var n := _norm_dil(String(gd))
		if not n.is_empty():
			aranan.append(n)
	if aranan.is_empty():
		return []

	var sonuc: Array = []
	for k in koylular:
		var k_diller: Array = []
		if k is Koylu:
			var kl: Koylu = k as Koylu
			if kl.saglik <= 0:
				continue
			k_diller = Array(kl.diller)
		elif k is Dictionary:
			var d: Dictionary = k
			if not bool(d.get("tercuman_bayragi", true)):
				continue
			if d.get("diller") is Array or d.get("diller") is PackedStringArray:
				k_diller = Array(d["diller"])
		for kd in k_diller:
			if _norm_dil(String(kd)) in aranan:
				sonuc.append(k)
				break
	return sonuc


## Tercuman cagirir:
## - Sabirdan 2 duser.
## - Tercuman koylunun is gucu 1.0 ise cagridan sonra 0.5 olur; zaten 0.5 ise ikinci cagri 0'a indirmez.
static func tercuman_cagir(tercuman_kaydi: Dictionary, mevcut_sabir: int = 5) -> Dictionary:
	var onceki_is_gucu := float(tercuman_kaydi.get("is_gucu", 1.0))
	var yeni_is_gucu := onceki_is_gucu
	if onceki_is_gucu > YARIM_IS_GUCU:
		yeni_is_gucu = YARIM_IS_GUCU
	elif is_equal_approx(onceki_is_gucu, YARIM_IS_GUCU):
		yeni_is_gucu = YARIM_IS_GUCU
	tercuman_kaydi["is_gucu"] = yeni_is_gucu
	tercuman_kaydi["tercuman_olarak_cagrildi"] = true

	var yeni_sabir := maxi(0, mevcut_sabir - SABIR_BEDELI)
	return {
		"olur": true,
		"sabir_deltasi": -SABIR_BEDELI,
		"kalan_sabir": yeni_sabir,
		"onceki_is_gucu": onceki_is_gucu,
		"is_gucu": yeni_is_gucu,
	}


## Ortak dil ve tercuman durumuna gore konusma satirini secer.
## - Ortak dil varken `kirik` varyant secilmez (kirik_satir_sayisi = 0).
## - Ortak dil yokken ve tercuman cagrilmamisken yalniz `kirik` varyant gelir.
## - Tercuman cagrilinca tam satir (veya es degilse ve grup eslesiyorsa `tercuman` varyanti) gelir.
## - Es tercuman carpitma varyanti uretmez, ancak aksam sohbeti (DYL-07) icin ani kaydeder.
static func satir_coz(
	satir: Dictionary,
	ortak_dil: bool,
	tercuman: Dictionary = {},
	muhafiz_tecrube: int = 0,
	sezgi_esigi: int = 5
) -> Dictionary:
	var tam_metin := String(satir.get("tam", satir.get("metin", "")))
	var kirik_metin := String(satir.get("kirik", ""))
	var tercuman_metin := String(satir.get("tercuman", ""))
	var sezgi_metin := String(satir.get("sezgi", ""))

	if ortak_dil:
		return {
			"secilen_tur": "tam",
			"metin": tam_metin,
			"kirik_mi": false,
			"kirik_satir_sayisi": 0,
			"carpitildi": false,
			"sezgi": "",
			"es_aksam_anisi": "",
		}

	var tercuman_aktif := bool(tercuman.get("aktif", false))
	if not tercuman_aktif:
		return {
			"secilen_tur": "kirik",
			"metin": kirik_metin,
			"kirik_mi": true,
			"kirik_satir_sayisi": 1,
			"carpitildi": false,
			"sezgi": "",
			"es_aksam_anisi": "",
		}

	var es_mi := bool(tercuman.get("es_mi", false))
	if es_mi:
		return {
			"secilen_tur": "tam",
			"metin": tam_metin,
			"kirik_mi": false,
			"kirik_satir_sayisi": 0,
			"carpitildi": false,
			"sezgi": "",
			"es_aksam_anisi": String(satir.get("id", tam_metin)),
		}

	var tercuman_grup := _norm_dil(String(tercuman.get("grup", "")))
	var gelen_grup := _norm_dil(String(satir.get("grup", tercuman.get("gelen_grup", ""))))
	var carpitma_olur := (not tercuman_metin.is_empty()) and (not tercuman_grup.is_empty()) and (tercuman_grup == gelen_grup or bool(tercuman.get("carpitir", false)))

	if carpitma_olur:
		var sezgi_acik := (muhafiz_tecrube >= sezgi_esigi)
		return {
			"secilen_tur": "tercuman",
			"metin": tercuman_metin,
			"kirik_mi": false,
			"kirik_satir_sayisi": 0,
			"carpitildi": true,
			"sezgi": sezgi_metin if sezgi_acik else "",
			"es_aksam_anisi": "",
		}

	return {
		"secilen_tur": "tam",
		"metin": tam_metin,
		"kirik_mi": false,
		"kirik_satir_sayisi": 0,
		"carpitildi": false,
		"sezgi": "",
		"es_aksam_anisi": "",
	}


## Ortak dil yokken ve tercuman cagrilmamisken yalniz isaretle anlasilabilen konulari (2-3 konu) filtreler.
static func gorunur_konular(konular: Array, ortak_dil: bool, tercuman_aktif: bool) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	for ham in konular:
		if not (ham is Dictionary):
			continue
		var k: Dictionary = ham
		if ortak_dil or tercuman_aktif or bool(k.get("isaretle_anlasilir", false)):
			sonuc.append(k.duplicate(true))
	return sonuc


## Tercumansiz karar verildiginde beyan defterine "anlaşılamadı" kaydi uretir.
static func tercumansiz_beyan_kaydi(konu_id: String) -> Dictionary:
	return {
		"konu": konu_id,
		"durum": "anlaşılamadı",
		"metin": "anlaşılamadı",
	}


## Cok dilli karakter verisinde eksik `kirik` varyantini dogrular.
static func dogrula_satirlar(diller: Array, satirlar: Array) -> Array[String]:
	var hatalar: Array[String] = []
	if ortak_dil_var_mi([VARSAYILAN_DIL], diller):
		return hatalar
	for i in range(satirlar.size()):
		var s: Variant = satirlar[i]
		if not (s is Dictionary):
			hatalar.append("satir_%d_sozluk_degil" % i)
			continue
		var d: Dictionary = s
		var kirik := String(d.get("kirik", "")).strip_edges()
		if kirik.is_empty():
			hatalar.append("eksik_kirik_varyant:%s" % String(d.get("id", str(i))))
	return hatalar


static func _norm_dil(dil: String) -> String:
	var s := dil.strip_edges().to_lower()
	s = s.replace("ü", "u").replace("ş", "s").replace("ı", "i").replace("ç", "c").replace("ğ", "g").replace("ö", "o")
	return s


## Gelen karakterin dillerini doner; bossa varsayilan Turkce kabul edilir.
static func gelen_dilleri(gelen: Gelen) -> Array[String]:
	var sonuc: Array[String] = []
	if gelen != null:
		for d in gelen.diller:
			var n := _norm_dil(String(d))
			if not n.is_empty() and not (n in sonuc):
				sonuc.append(n)
	if sonuc.is_empty():
		sonuc.append(VARSAYILAN_DIL)
	return sonuc


## Oturumda muhafiz ile gelen arasinda ortak dil olup olmadigini kontrol eder.
static func oturum_ortak_dil_var_mi(oturum: Oturum, gelen: Gelen) -> bool:
	return ortak_dil_var_mi(muhafiz_dilleri(oturum), gelen_dilleri(gelen))


## Gercek Oturum + KoyYonetimi uzerinden tercuman dugmesinin gorunurlugunu (0 veya 1) doner.
static func oturum_dugme_sayisi(oturum: Oturum, gelen: Gelen, tercuman_bayragi: bool = true) -> int:
	if oturum == null or oturum.yonetim == null or gelen == null:
		return 0
	if oturum_ortak_dil_var_mi(oturum, gelen):
		return 0
	return tercuman_dugmesi_sayisi(oturum.yonetim.koylular, gelen_dilleri(gelen), tercuman_bayragi)


## Oturumdaki ilk uygun (veya secili) tercuman koyluyu cagirir; sabir -2 ve is_gucu 0.5 uygulanir.
static func oturumda_tercuman_cagir(
	oturum: Oturum,
	gelen: Gelen,
	mevcut_sabir: int = 5,
	aday_koylu: Koylu = null
) -> Dictionary:
	if oturum == null or oturum.yonetim == null or gelen == null:
		return {"olur": false, "aktif": false, "kalan_sabir": mevcut_sabir}
	var uygunlar := uygun_tercumanlar(oturum.yonetim.koylular, gelen_dilleri(gelen))
	var secilen: Koylu = aday_koylu if (aday_koylu != null and (aday_koylu in uygunlar)) else (uygunlar[0] as Koylu if not uygunlar.is_empty() else null)
	if secilen == null:
		return {"olur": false, "aktif": false, "kalan_sabir": mevcut_sabir}
	var onceki_is_gucu := secilen.is_gucu
	if onceki_is_gucu > YARIM_IS_GUCU:
		secilen.is_gucu = YARIM_IS_GUCU
	var es_id := int(preload("res://src/sistemler/acilis_senaryosu.gd").durum(oturum).get("es_id", -1))
	var es_mi := es_id > 0 and secilen.id == es_id
	var yeni_sabir := maxi(0, mevcut_sabir - SABIR_BEDELI)
	return {
		"olur": true,
		"aktif": true,
		"koylu_id": secilen.id,
		"koylu_ad": secilen.ad,
		"es_mi": es_mi,
		"grup": String(secilen.sinif),
		"gelen_grup": String(gelen.sinif),
		"sabir_deltasi": -SABIR_BEDELI,
		"kalan_sabir": yeni_sabir,
		"onceki_is_gucu": onceki_is_gucu,
		"is_gucu": secilen.is_gucu,
	}
