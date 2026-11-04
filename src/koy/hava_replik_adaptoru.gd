# KVR-SES-01: Köy ve Kapı Dinamik Hava Replikleri Adaptörü
# Kalfa ve arayüz sistemleri için sıfır yan etkili, hafif veri ve metin sorgu köprüsü.
class_name HavaReplikAdaptoru
extends RefCounted

const HAVALAR := ["yagmur", "kar", "ayaz", "sicak", "sis"]
const KARAKTERLER := [
	"karaca_usta", "ayse_baci", "es", "saruca_hatun", "hasan_celebi",
	"yusuf", "miraen", "thessra", "sorhan", "aydogdu", "nogay", "genel"
]


## Gelen hava adını sistem adlarıyla standartlaştırır (ör. kar_firtinasi -> kar, kuraklik -> sicak)
static func normalize_hava(ham_hava: String) -> String:
	match ham_hava:
		"kar_firtinasi", "firtina", "tipi", "kar":
			return "kar"
		"yagmur", "saganak":
			return "yagmur"
		"ayaz", "don":
			return "ayaz"
		"kuraklik", "sicak", "kavurucu":
			return "sicak"
		"sis", "pus":
			return "sis"
		_:
			return "normal"


## Köylü karakterinin hava durumuna özel ortam repliğini döner
static func koylu_replik_al(karakter_id: String, ham_hava: String, varyant: int = 1) -> String:
	var h := normalize_hava(ham_hava)
	if h == "normal" or not h in HAVALAR:
		return ""
	var c := karakter_id.to_lower()
	if not c in KARAKTERLER:
		c = "genel"
	var v := 1 if varyant <= 1 else 2
	var anahtar := "kvr.hava.%s.%s.%d" % [c, h, v]
	var sonuc := TranslationServer.translate(StringName(anahtar))
	if String(sonuc) == anahtar:
		# Fallback to genel
		anahtar = "kvr.hava.genel.%s.%d" % [h, v]
		sonuc = TranslationServer.translate(StringName(anahtar))
	return String(sonuc)


## Kapıya gelen ziyaretçinin hava durumuna göre açılış ön ekini döner (kapi.hava.*)
static func kapi_on_ek_al(ham_hava: String, varyant: int = 1) -> String:
	var h := normalize_hava(ham_hava)
	if h == "normal":
		return ""
	var anahtar := ""
	match h:
		"kar":
			var v := clampi(varyant, 1, 3)
			anahtar = "kapi.hava.firtina_%d" % v
		"yagmur":
			var v := 1 if varyant <= 1 else 2
			anahtar = "kapi.hava.yagmur_%d" % v
		"ayaz":
			var v := 1 if varyant <= 1 else 2
			anahtar = "kapi.hava.ayaz_%d" % v
		"sis":
			var v := 1 if varyant <= 1 else 2
			anahtar = "kapi.hava.sis_%d" % v
		"sicak":
			var v := 1 if varyant <= 1 else 2
			anahtar = "kapi.hava.sicak_%d" % v
		_:
			return ""
	return String(TranslationServer.translate(StringName(anahtar)))


## Muhafızın sert hava koşullarına göre özel karşılama varyasyonunu döner
static func muhafiz_karsilama_al(ham_hava: String) -> String:
	var h := normalize_hava(ham_hava)
	if h == "normal":
		return ""
	var anahtar := ""
	match h:
		"kar":
			anahtar = "kapi.hava.firtina_muhafiz"
		"yagmur":
			anahtar = "kapi.hava.yagmur_muhafiz"
		"ayaz":
			anahtar = "kapi.hava.ayaz_muhafiz"
		"sis":
			anahtar = "kapi.hava.sis_muhafiz"
		"sicak":
			anahtar = "kapi.hava.sicak_muhafiz"
		_:
			return ""
	return String(TranslationServer.translate(StringName(anahtar)))
