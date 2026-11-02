## CAT-01: Geri cevrilen kavga cikarabilir.
## Yer yoklugu veya sert ret, tip listesindeki genc erkek, ac aile reisi ya da asker kacaginda
## kavga istegi dogurur. Kavga yalniz kapida ve en az bir asker varken acilir.
## Asker yoksa kisi tehdit edip gider; tanik varsa bu gidis dedikoduya (DIY-13) yazilir.
## Koy meydani, sifahane ve divanda kavga sahnesi yoktur. Heyet sirasinda kavga acilmaz.
class_name KapiKavgasi
extends RefCounted


const VERI_YOLU := "res://data/kapi_kavgasi.json"

var _veri: Dictionary = {}
var _gunluk_istekler: Dictionary = {}
var _aktif_kavga: Dictionary = {}


func _init() -> void:
	_veri_yukle()


func _veri_yukle() -> void:
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI_YOLU))
	if okunan is Dictionary:
		_veri = okunan
	else:
		_veri = {
			"kavga_tipleri": ["genc_erkek", "ac_aile_reisi", "asker_kacagi"],
			"kavga_nedenleri": ["yer_yoklugu", "sert_ret"],
			"izinli_mekan": "kapi",
			"yasak_mekanlar": ["koy_meydani", "sifahane", "divan"],
			"asgari_asker": 1,
		}


## Veri dosyasindaki gecerli kavga tiplerini doner.
func kavga_tipleri() -> Array[String]:
	var r: Array[String] = []
	var ham: Variant = _veri.get("kavga_tipleri", [])
	if ham is Array:
		for t in ham:
			r.append(_norm(String(t)))
	return r


## Veri dosyasindaki gecerli kavga nedenlerini doner.
func kavga_nedenleri() -> Array[String]:
	var r: Array[String] = []
	var ham: Variant = _veri.get("kavga_nedenleri", [])
	if ham is Array:
		for n in ham:
			r.append(_norm(String(n)))
	return r


## Geri cevrilme aninda kavga istegini degerlendirir.
## Döner: {kavga_bayragi: int (0 veya 1), sahne_acildi: bool, durum: String, dedikodu_yazildi: bool}
func ret_degerlendir(baglam: Dictionary, dedikodu: Dedikodu = null) -> Dictionary:
	var kisi_id := String(baglam.get("kisi_id", "adsiz")).strip_edges()
	var gun := int(baglam.get("gun", 0))
	var mekan := _norm(String(baglam.get("mekan", "kapi")))
	var heyet_aktif := bool(baglam.get("heyet_aktif", false))
	var neden := _norm(String(baglam.get("neden", "siradan_ret")))
	var tip := _norm(String(baglam.get("tip", "")))
	var asker_sayisi := int(baglam.get("asker_sayisi", 0))
	var tanik: Variant = baglam.get("tanik", "")

	# Kural 4 ve Uç durum: Koy meydani, sifahane, divan veya heyet sirasinda kavga acilmaz.
	if heyet_aktif or mekan != "kapi":
		return _sonuc(0, false, "mekan_veya_heyet_engeli", false)

	# Kural 1 ve 5: Tip listesinde veya neden listesinde degilse siradan rettir.
	if not (neden in kavga_nedenleri()) or not (tip in kavga_tipleri()):
		return _sonuc(0, false, "siradan_ret", false)

	# Uç durum: Ayni kisi ayni gun ikinci kavga istegi uretmez.
	var gun_anahtari := "%d:%s" % [gun, kisi_id]
	if _gunluk_istekler.has(gun_anahtari):
		return _sonuc(0, false, "ayni_gun_ikinci_istek_yok", false)
	_gunluk_istekler[gun_anahtari] = true

	# Kural 2 ve 3: Asker yoksa kisi tehdit edip gider; tanik varsa dedikoduya yazilir.
	var asgari_asker := int(_veri.get("asgari_asker", 1))
	if asker_sayisi < asgari_asker:
		var dedikodu_yazildi := _tehdit_dedikodusu_yaz(dedikodu, kisi_id, gun, tanik)
		_aktif_kavga.clear()
		return _sonuc(0, false, "tehdit_edip_gitti", dedikodu_yazildi)

	# Asker >= 1 ve tip/neden uygun: kapida kavga sahnesi acilir.
	var sahne_basladi := bool(baglam.get("sahne_baslat", true))
	_aktif_kavga = {
		"kisi_id": kisi_id,
		"gun": gun,
		"tip": tip,
		"neden": neden,
		"asker_sayisi": asker_sayisi,
		"tanik": tanik,
		"sahne_basladi": sahne_basladi,
		"secenekler_acik": sahne_basladi,
		"durum": "kavga_acik" if sahne_basladi else "istek_bekliyor",
	}
	return _sonuc(1, sahne_basladi, String(_aktif_kavga["durum"]), false)


## Uç durum: Asker kapidan ayrilirsa:
## - Acilmamis istek "tehdit_edip_gitti"ye doner (tanik varsa dedikoduya yazilir).
## - Sahne baslamissa secenekler kapanir ve sonuc "kacti" sayilir.
func asker_ayrildi(dedikodu: Dedikodu = null) -> Dictionary:
	if _aktif_kavga.is_empty():
		return _sonuc(0, false, "aktif_kavga_yok", false)

	var sahne_baslamis := bool(_aktif_kavga.get("sahne_basladi", false))
	var kisi_id := String(_aktif_kavga.get("kisi_id", "adsiz"))
	var gun := int(_aktif_kavga.get("gun", 0))
	var tanik: Variant = _aktif_kavga.get("tanik", "")

	if not sahne_baslamis:
		var dedikodu_yazildi := _tehdit_dedikodusu_yaz(dedikodu, kisi_id, gun, tanik)
		_aktif_kavga.clear()
		return {
			"kavga_bayragi": 0,
			"sahne_acildi": false,
			"secenekler_acik": false,
			"durum": "tehdit_edip_gitti",
			"sonuc": "tehdit_edip_gitti",
			"dedikodu_yazildi": dedikodu_yazildi,
		}

	_aktif_kavga["secenekler_acik"] = false
	_aktif_kavga["durum"] = "kacti"
	var rapor := {
		"kavga_bayragi": 0,
		"sahne_acildi": false,
		"secenekler_acik": false,
		"durum": "kacti",
		"sonuc": "kacti",
		"dedikodu_yazildi": false,
	}
	_aktif_kavga.clear()
	return rapor


func aktif_kavga() -> Dictionary:
	return _aktif_kavga.duplicate(true)


static func _tehdit_dedikodusu_yaz(dedikodu: Dedikodu, kisi_id: String, gun: int, tanik: Variant) -> bool:
	if dedikodu == null:
		return false
	var olay_id := "kapi_tehdit_%d_%s" % [gun, kisi_id]
	var r: Dictionary = dedikodu.olay_kaydet(olay_id, "haksiz_ret", gun, tanik, 1)
	return bool(r.get("olur", false))


static func _sonuc(bayrak: int, sahne: bool, durum: String, dedikodu_yazildi: bool) -> Dictionary:
	return {
		"kavga_bayragi": bayrak,
		"sahne_acildi": sahne,
		"secenekler_acik": sahne,
		"durum": durum,
		"dedikodu_yazildi": dedikodu_yazildi,
	}


static func _norm(metin: String) -> String:
	var s := metin.strip_edges().to_lower()
	s = s.replace("ü", "u").replace("ş", "s").replace("ı", "i").replace("ç", "c").replace("ğ", "g").replace("ö", "o").replace(" ", "_")
	return s
