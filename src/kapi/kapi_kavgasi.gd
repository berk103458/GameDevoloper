## CAT-01 ve CAT-02: Kapida catisma tetikleme kurallari ve dort kavga secenegi.
## - CAT-01: Yer yoklugu veya sert ret, genc erkek / ac aile reisi / asker kacaginda kavga istegi dogurur.
##   Kavga yalniz kapida ve en az 1 asker varken acilir; asker yoksa tehdit edip gider (tanikla dedikodu).
## - CAT-02: Dort secenek vardir: askerle_karsilik, akceyle_erteleme, sozle_yatistirma, reddetme.
##   Besinci secenek ve kalp alani yasaktir. Ayni secenege iki tikta sonuc bir kez yazilir.
class_name KapiKavgasi
extends RefCounted


const VERI_YOLU := "res://data/kapi_kavgasi.json"
const OZEL_ESYALAR_YOLU := "res://data/ozel_esyalar.json"

## YAP-53: CAT ayri esya sinifi acmaz; data/ozel_esyalar.json tanimini okur.
static func ozel_esya_tanimi(esya_id: String) -> Dictionary:
	var aranan := esya_id.strip_edges()
	if aranan.is_empty() or not FileAccess.file_exists(OZEL_ESYALAR_YOLU):
		return {}
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(OZEL_ESYALAR_YOLU))
	if okunan is Dictionary and okunan.get("esyalar") is Array:
		for oge in okunan["esyalar"]:
			if oge is Dictionary and String(oge.get("id", "")) == aranan:
				return oge.duplicate(true)
	return {}
const YER_TUTUCU_CANLANDIRMA := {
	"asset_id": "CAT02-KAVGA",
	"tur": "sarsinti_ve_metin",
	"sarsinti_siddeti": 0.35,
	"metin": "anlati.kavga.arbede",
}

const GECERLI_SECENEKLER := [
	"askerle_karsilik",
	"akceyle_erteleme",
	"sozle_yatistirma",
	"reddetme",
]

var _veri: Dictionary = {}
var _zar_rng := RandomNumberGenerator.new()
var _gunluk_istekler: Dictionary = {}
var _aktif_kavga: Dictionary = {}
var _secim_uygulandi: bool = false
var _verilen_sozler: Array[Dictionary] = []
var _cenaze_cagrilari: Array[Dictionary] = []


func _init() -> void:
	_zar_rng.randomize()
	_veri_yukle()


func _veri_yukle() -> void:
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI_YOLU))
	if okunan is Dictionary:
		_veri = okunan
	else:
		_veri = {
			"kavga_tipleri": [], # Veri yoksa yeni kavga tipi uydurulmaz.
			"kavga_nedenleri": ["yer_yoklugu", "sert_ret"],
			"izinli_mekan": "kapi",
			"yasak_mekanlar": ["koy_meydani", "sifahane", "divan"],
			"asgari_asker": 1,
			"secenekler": GECERLI_SECENEKLER,
			"erteleme_akce_bedeli": 2,
			"erteleme_donus_gun_araligi": [2, 4],
			"azami_acik_soz": 5,
			"karsilik_sonuc_tablosu": {
				"kritik_basari": "kacti",
				"basari": "yaralanma",
				"basarisiz": "kin",
				"kritik_basarisiz": "olum",
			},
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


## Secenek veya veri sozlugunu dogrular.
## Besinci secenek veya `kalp` / `romans` anahtari varsa hata listesinde 1 hata doner.
static func veri_dogrula(girdi: Dictionary) -> Array[String]:
	var hatalar: Array[String] = []
	for k in girdi.keys():
		var ks := String(k).strip_edges().to_lower()
		if ks == "kalp" or ks == "romans":
			hatalar.append("yasak_anahtar:" + ks)
	if girdi.has("secenek"):
		var s := _norm(String(girdi["secenek"]))
		if s == "kalp" or s == "romans":
			if not ("yasak_anahtar:" + s in hatalar):
				hatalar.append("yasak_anahtar:" + s)
		elif not (s in GECERLI_SECENEKLER):
			hatalar.append("besinci_veya_gecersiz_secenek:" + s)
	if girdi.get("secenekler") is Array:
		for oge in girdi["secenekler"]:
			var s := _norm(String(oge))
			if s == "kalp" or s == "romans":
				hatalar.append("yasak_anahtar:" + s)
			elif not (s in GECERLI_SECENEKLER):
				hatalar.append("besinci_veya_gecersiz_secenek:" + s)
	return hatalar


## Geri cevrilme aninda kavga istegini degerlendirir (CAT-01).
func ret_degerlendir(baglam: Dictionary, dedikodu: Dedikodu = null) -> Dictionary:
	var kisi_id := String(baglam.get("kisi_id", "adsiz")).strip_edges()
	var gun := int(baglam.get("gun", 0))
	var mekan := _norm(String(baglam.get("mekan", "kapi")))
	var heyet_aktif := bool(baglam.get("heyet_aktif", false))
	var neden := _norm(String(baglam.get("neden", "siradan_ret")))
	var tip := _norm(String(baglam.get("tip", "")))
	var asker_sayisi := int(baglam.get("asker_sayisi", 0))
	var tanik: Variant = baglam.get("tanik", "")

	if heyet_aktif or mekan != "kapi":
		return _sonuc(0, false, "mekan_veya_heyet_engeli", false)

	if not (neden in kavga_nedenleri()) or not (tip in kavga_tipleri()):
		return _sonuc(0, false, "siradan_ret", false)

	var gun_anahtari := "%d:%s" % [gun, kisi_id]
	if _gunluk_istekler.has(gun_anahtari):
		return _sonuc(0, false, "ayni_gun_ikinci_istek_yok", false)
	_gunluk_istekler[gun_anahtari] = true

	var asgari_asker := int(_veri.get("asgari_asker", 1))
	if asker_sayisi < asgari_asker:
		var dedikodu_yazildi := _tehdit_dedikodusu_yaz(dedikodu, kisi_id, gun, tanik)
		_aktif_kavga.clear()
		_secim_uygulandi = false
		return _sonuc(0, false, "tehdit_edip_gitti", dedikodu_yazildi)

	var sahne_basladi := bool(baglam.get("sahne_baslat", true))
	_secim_uygulandi = false
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
		"canlandirma": YER_TUTUCU_CANLANDIRMA.duplicate(true),
	}
	return _sonuc(1, sahne_basladi, String(_aktif_kavga["durum"]), false)


## Asker kapidan ayrildiginda acilmamis istegi veya baslamis sahneyi gunceller (CAT-01).
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
		_secim_uygulandi = false
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
	_secim_uygulandi = false
	return rapor


## CAT-02: Dort kavga seceneginin gorunurluk ve kilit durumlarini hesaplar.
## - Asker olurse / yoksa `askerle_karsilik` kapanir (gorunur=false), diger ucu durur.
## - Akce yetmezse veya acik soz sayisi 5 ise `akceyle_erteleme` kilitli gorunur ve nedeni yazar.
func secenek_durumlari(baglam: Dictionary) -> Dictionary:
	var asker_hayatta := bool(baglam.get("asker_hayatta", true)) and int(baglam.get("asker_sayisi", 1)) >= 1
	var muhafiz_akce := int(baglam.get("muhafiz_akce", 0))
	var bedel := int(baglam.get("erteleme_bedeli", _veri.get("erteleme_akce_bedeli", 2)))
	var acik_soz := int(baglam.get("acik_soz_sayisi", _verilen_sozler.size()))
	var azami_soz := int(_veri.get("azami_acik_soz", 5))

	var erteleme_kilitli := false
	var erteleme_neden := ""
	if acik_soz >= azami_soz:
		erteleme_kilitli = true
		erteleme_neden = "acik_soz_siniri_dolu"
	elif muhafiz_akce < bedel:
		erteleme_kilitli = true
		erteleme_neden = "akce_yetersiz"

	return {
		"askerle_karsilik": {
			"id": "askerle_karsilik",
			"gorunur": asker_hayatta,
			"acik": asker_hayatta,
			"kilitli": not asker_hayatta,
			"kilit_nedeni": "" if asker_hayatta else "asker_yok",
		},
		"akceyle_erteleme": {
			"id": "akceyle_erteleme",
			"gorunur": true,
			"acik": not erteleme_kilitli,
			"kilitli": erteleme_kilitli,
			"kilit_nedeni": erteleme_neden,
			"bedel": bedel,
		},
		"sozle_yatistirma": {
			"id": "sozle_yatistirma",
			"gorunur": true,
			"acik": true,
			"kilitli": false,
			"kilit_nedeni": "",
		},
		"reddetme": {
			"id": "reddetme",
			"gorunur": true,
			"acik": true,
			"kilitli": false,
			"kilit_nedeni": "",
		},
	}


## CAT-02: Yeni bir kavga secimi icin cift-tik kilidini sifirlar.
func yeni_kavga_ac(baglam: Dictionary = {}) -> void:
	_secim_uygulandi = false
	_aktif_kavga = {
		"kisi_id": String(baglam.get("kisi_id", "adsiz")),
		"gun": int(baglam.get("gun", 1)),
		"tanik": baglam.get("tanik", ""),
		"sahne_basladi": true,
		"secenekler_acik": true,
		"durum": "kavga_acik",
		"canlandirma": YER_TUTUCU_CANLANDIRMA.duplicate(true),
	}


## CAT-02: Dort secenekten birini uygular ve birbirinden farkli `sonuc_kimligi` uretir.
## Ayni secenege (veya kavgaya) iki tikta sonuc yalniz 1 kez yazilir.
func secenek_uygula(
	secenek: String,
	baglam: Dictionary = {},
	kadro: KarakterKadrosu = null,
	dedikodu: Dedikodu = null,
	cenaze_habercisi: Callable = Callable()
) -> Dictionary:
	var dogrulama := veri_dogrula({"secenek": secenek})
	for k in baglam.keys():
		var ks := String(k).to_lower()
		if ks == "kalp" or ks == "romans":
			dogrulama.append("yasak_anahtar:" + ks)
	if not dogrulama.is_empty():
		return {
			"olur": false,
			"hata_sayisi": dogrulama.size(),
			"hatalar": dogrulama,
			"sonuc_kimligi": "",
		}

	if _secim_uygulandi:
		return {
			"olur": false,
			"hata": "ayni_secenege_ikinci_tik_engellendi",
			"yazim_sayisi": 0,
			"sonuc_kimligi": "",
		}

	var norm_secenek := _norm(secenek)
	var durumlar := secenek_durumlari(baglam)
	var secenek_durum: Dictionary = durumlar.get(norm_secenek, {})
	if not bool(secenek_durum.get("acik", false)):
		return {
			"olur": false,
			"hata": "secenek_kilitli_veya_kapali",
			"kilit_nedeni": String(secenek_durum.get("kilit_nedeni", "")),
			"sonuc_kimligi": "",
		}

	_secim_uygulandi = true
	var kisi_id := StringName(String(baglam.get("kisi_id", _aktif_kavga.get("kisi_id", "adsiz"))))
	var gun := int(baglam.get("gun", _aktif_kavga.get("gun", 1)))
	var tanik: Variant = baglam.get("tanik", _aktif_kavga.get("tanik", ""))

	match norm_secenek:
		"askerle_karsilik":
			return _uygula_askerle_karsilik(kisi_id, gun, baglam, kadro, cenaze_habercisi)
		"akceyle_erteleme":
			return _uygula_akceyle_erteleme(kisi_id, gun, baglam, kadro)
		"sozle_yatistirma":
			return _uygula_sozle_yatistirma(kisi_id, gun, baglam, kadro)
		"reddetme":
			return _uygula_reddetme(kisi_id, gun, tanik, kadro, dedikodu)

	return {"olur": false, "sonuc_kimligi": ""}


## DYL-05 `yarin_gel` sozu tutulmadiginda grup itibarini -1 dusurur.
func erteleme_sozu_tutulmadi(grup_itibari: GrupItibari, grup: String) -> Dictionary:
	if grup_itibari == null:
		return {"olur": false}
	grup_itibari.ziyaret_baslat()
	return grup_itibari.uygula(grup, -1, true)


func verilen_sozler() -> Array[Dictionary]:
	return _verilen_sozler.duplicate(true)


func cenaze_cagrilari() -> Array[Dictionary]:
	return _cenaze_cagrilari.duplicate(true)


func aktif_kavga() -> Dictionary:
	return _aktif_kavga.duplicate(true)


func _uygula_askerle_karsilik(
	kisi_id: StringName,
	gun: int,
	baglam: Dictionary,
	kadro: KarakterKadrosu,
	cenaze_habercisi: Callable
) -> Dictionary:
	var tablo: Dictionary = _veri.get("karsilik_sonuc_tablosu", {})
	var zorluk := int(baglam.get("zorluk", 4))
	var asker_becerisi := int(baglam.get("asker_becerisi", 0))
	var atis := int(baglam["zar_atis"]) if baglam.has("zar_atis") else SorguZari.at(_zar_rng, SorguZari.TUR_D6)
	var gerekli_hedef := maxi(2, zorluk - asker_becerisi)
	var basarili: bool = SorguZari.basarili(atis, gerekli_hedef, SorguZari.TUR_D6)
	var zar_sonuc: Dictionary = {
		"tur": String(SorguZari.TUR_D6),
		"gerekli": gerekli_hedef,
		"zar": atis,
		"basarili": basarili,
	}

	var alt_sonuc := ""
	if baglam.has("zorla_alt_sonuc"):
		alt_sonuc = _norm(String(baglam["zorla_alt_sonuc"]))
	elif atis >= 6:
		alt_sonuc = String(tablo.get("kritik_basari", "kacti"))
	elif basarili:
		alt_sonuc = String(tablo.get("basari", "yaralanma"))
	elif atis <= 1:
		alt_sonuc = String(tablo.get("kritik_basarisiz", "olum"))
	else:
		alt_sonuc = String(tablo.get("basarisiz", "kin"))

	# Kin ile kacis ayri kayit kimligidir
	var kayit_kimligi := "kavga_" + alt_sonuc
	var sonuc_kimligi := "karsilik_" + alt_sonuc

	if alt_sonuc == "olum":
		var cenaze_kaydi := {"kisi_id": String(kisi_id), "gun": gun, "neden": "kapi_kavgasi"}
		_cenaze_cagrilari.append(cenaze_kaydi)
		if cenaze_habercisi.is_valid():
			cenaze_habercisi.call(cenaze_kaydi)
		if kadro != null and kadro.durumlar.has(kisi_id):
			KisiHafizasi.oldu_isaretle(kadro, kisi_id, gun)
	elif kadro != null and kadro.durumlar.has(kisi_id):
		var karar_adi := "kacti" if alt_sonuc == "kacti" else "ret"
		KisiHafizasi.kaydet_olay(kadro, kisi_id, {
			"son_karar": karar_adi,
			"karar_satiri": kayit_kimligi,
		}, gun)

	_aktif_kavga.clear()
	return {
		"olur": true,
		"secenek": "askerle_karsilik",
		"alt_sonuc": alt_sonuc,
		"kayit_kimligi": kayit_kimligi,
		"sonuc_kimligi": sonuc_kimligi,
		"zar": zar_sonuc,
		"cenaze_cagri_sayisi": _cenaze_cagrilari.size(),
		"ganimet_esya_id": String(ozel_esya_tanimi(String(baglam.get("ganimet_esya_id", ""))).get("id", "")) if basarili else "",
		"ganimet_esya": ozel_esya_tanimi(String(baglam.get("ganimet_esya_id", ""))) if basarili else {},
		"canlandirma": YER_TUTUCU_CANLANDIRMA.duplicate(true),
	}


func _uygula_akceyle_erteleme(
	kisi_id: StringName,
	gun: int,
	baglam: Dictionary,
	kadro: KarakterKadrosu
) -> Dictionary:
	var bedel := int(baglam.get("erteleme_bedeli", _veri.get("erteleme_akce_bedeli", 2)))
	var muhafiz_akce := int(baglam.get("muhafiz_akce", bedel))
	var kalan_akce := maxi(0, muhafiz_akce - bedel)
	var aralik: Array = _veri.get("erteleme_donus_gun_araligi", [2, 4])
	var donus_gun_ek := clampi(int(baglam.get("donus_gun_ek", 2)), int(aralik[0]), int(aralik[1]))
	var donus_gun := gun + donus_gun_ek

	var soz_satiri := {
		"kisi_id": String(kisi_id),
		"soz": "yarin_gel",
		"gun": gun,
		"donus_gun": donus_gun,
		"odenen_akce": bedel,
	}
	_verilen_sozler.append(soz_satiri)

	if kadro != null and kadro.durumlar.has(kisi_id):
		KisiHafizasi.kaydet_olay(kadro, kisi_id, {
			"verilen_soz": "yarin_gel",
			"odenen_akce": bedel,
		}, gun)

	_aktif_kavga.clear()
	return {
		"olur": true,
		"secenek": "akceyle_erteleme",
		"sonuc_kimligi": "erteleme_yarin_gel",
		"verilen_soz": "yarin_gel",
		"verilen_soz_satir_sayisi": 1,
		"donus_gun": donus_gun,
		"harcanan_muhafiz_akce": bedel,
		"kalan_muhafiz_akce": kalan_akce,
	}


func _uygula_sozle_yatistirma(
	kisi_id: StringName,
	gun: int,
	baglam: Dictionary,
	kadro: KarakterKadrosu
) -> Dictionary:
	var yaklasim := String(baglam.get("yaklasim", "ikna")).strip_edges().to_lower()
	if yaklasim != "ikna" and yaklasim != "gonul_alma":
		yaklasim = "ikna"
	var zorluk := int(baglam.get("zorluk", 3))
	var atis := int(baglam["zar_atis"]) if baglam.has("zar_atis") else SorguZari.at(_zar_rng, SorguZari.TUR_D6)
	var basarili: bool = SorguZari.basarili(atis, zorluk, SorguZari.TUR_D6)
	var zar_sonuc: Dictionary = {
		"tur": String(SorguZari.TUR_D6),
		"gerekli": zorluk,
		"zar": atis,
		"basarili": basarili,
	}
	var sonuc_kimligi := "yatistirma_basarili" if basarili else "yatistirma_basarisiz"

	if kadro != null and kadro.durumlar.has(kisi_id):
		KisiHafizasi.kaydet_olay(kadro, kisi_id, {
			"son_karar": "ret",
			"karar_satiri": sonuc_kimligi,
		}, gun)

	_aktif_kavga.clear()
	return {
		"olur": true,
		"secenek": "sozle_yatistirma",
		"yaklasim": yaklasim,
		"basarili": basarili,
		"sonuc_kimligi": sonuc_kimligi,
		"zar": zar_sonuc,
	}


func _uygula_reddetme(
	kisi_id: StringName,
	gun: int,
	tanik: Variant,
	kadro: KarakterKadrosu,
	dedikodu: Dedikodu
) -> Dictionary:
	var dedikodu_yazildi := false
	if dedikodu != null:
		var r: Dictionary = dedikodu.olay_kaydet("kavga_reddetme_%d_%s" % [gun, String(kisi_id)], "haksiz_ret", gun, tanik, 1)
		dedikodu_yazildi = bool(r.get("olur", false))

	if kadro != null and kadro.durumlar.has(kisi_id):
		KisiHafizasi.kaydet_olay(kadro, kisi_id, {
			"son_karar": "ret",
			"karar_satiri": "kavga_kin",
		}, gun)

	_aktif_kavga.clear()
	return {
		"olur": true,
		"secenek": "reddetme",
		"sonuc_kimligi": "reddetme_kin",
		"kayit_kimligi": "kavga_kin",
		"kavga_bitti": true,
		"dedikodu_yazildi": dedikodu_yazildi,
	}


static func _tehdit_dedikodusu_yaz(dedikodu: Dedikodu, kisi_id: String, gun: int, tanik: Variant) -> bool:
	if dedikodu == null:
		return false
	var olay_id := "kapi_tehdit_%d_%s" % [gun, kisi_id]
	var r: Dictionary = dedikodu.olay_kaydet(olay_id, "haksiz_ret", gun, tanik, 1, {"satir": "Kapıdan geri çevrilen kişi tehdit edip gitti."})
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
