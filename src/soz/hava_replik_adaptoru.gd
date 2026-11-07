## KVR-SES-01: Kapı nöbetinde hava durumu ve ayaza bağlı dinamik replik adaptörü.
## Tipi, fırtına, yağmur, ayaz ve sis atmosferi için ön ek, karşılama ve köy ortam repliklerini sağlar.
class_name HavaReplikAdaptoru
extends RefCounted

const DESTEKLENEN_HAVALAR: Array[StringName] = [
	&"firtina",
	&"kar",
	&"yagmur",
	&"ayaz",
	&"sis",
]

const VARYASYON_SAYISI: Dictionary = {
	&"firtina": 3,
	&"kar": 3,
	&"yagmur": 2,
	&"ayaz": 2,
	&"sis": 2,
}

const KOYLU_HAVALARI: Array[String] = ["yagmur", "kar", "ayaz", "sicak", "sis"]
const KOYLU_KARAKTERLER: Array[String] = [
	"karaca_usta", "ayse_baci", "es", "saruca_hatun", "hasan_celebi",
	"yusuf", "miraen", "thessra", "sorhan", "aydogdu", "nogay", "genel"
]


## Verilen hava durumunun desteklenip desteklenmediğini bildirir.
static func hava_destekleniyor_mu(hava: StringName) -> bool:
	return hava in DESTEKLENEN_HAVALAR


## Ziyaretçinin açılış konuşması için dinamik atmosfer ön ek anahtarını döner.
## indeks parametresi varyasyon seçiminde kullanılır (pozitif tamsayı veya tohum).
static func ziyaretci_on_ek_anahtari(hava: StringName, indeks: int = 0) -> String:
	var temel_hava := _temel_hava_kodu(hava)
	if temel_hava.is_empty():
		return ""
	var toplam_varyasyon: int = VARYASYON_SAYISI.get(temel_hava, 1)
	var secilen: int = (abs(indeks) % toplam_varyasyon) + 1
	return "kapi.hava.%s.ziyaretci.%d" % [temel_hava, secilen]


## Muhafızın hava koşuluna özel karşılama varyasyonu metin anahtarını döner.
static func muhafiz_karsilama_anahtari(hava: StringName) -> String:
	var temel_hava := _temel_hava_kodu(hava)
	if temel_hava.is_empty():
		return ""
	return "kapi.hava.%s.muhafiz" % temel_hava


## Kapıya gelen ziyaretçinin hava durumuna göre açılış ön ekini doğrudan çevirip döner.
static func kapi_on_ek_al(ham_hava: String, varyant: int = 1) -> String:
	var h_str := normalize_hava(ham_hava)
	var k := ziyaretci_on_ek_anahtari(StringName(h_str), varyant - 1)
	if k.is_empty():
		return ""
	return String(TranslationServer.translate(StringName(k)))


## Muhafızın sert hava koşullarına göre özel karşılama varyasyonunu doğrudan çevirip döner.
static func muhafiz_karsilama_al(ham_hava: String) -> String:
	var h_str := normalize_hava(ham_hava)
	var k := muhafiz_karsilama_anahtari(StringName(h_str))
	if k.is_empty():
		return ""
	return String(TranslationServer.translate(StringName(k)))


## Ön ek ile asıl repliği düzgün bir aralıkla birleştirir.
static func replik_birlestir(on_ek: String, asil_replik: String) -> String:
	if on_ek.is_empty():
		return asil_replik
	if asil_replik.is_empty():
		return on_ek
	return "%s\n\n%s" % [on_ek.strip_edges(), asil_replik.strip_edges()]


## Hava adını standart koda çevirir (ör. kar_firtinasi -> kar, kuraklik -> sicak).
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


## Köylünün hava durumuna özel ortam repliği anahtarını döner (kvr.hava.<karakter>.<hava>.<1|2>).
static func koylu_replik_anahtari(karakter_id: String, ham_hava: String, indeks: int = 1) -> String:
	var h := normalize_hava(ham_hava)
	if h == "normal" or not h in KOYLU_HAVALARI:
		return ""
	var c := karakter_id.to_lower()
	if not c in KOYLU_KARAKTERLER:
		c = "genel"
	var v: int = (absi(indeks - 1) % 2) + 1
	return "kvr.hava.%s.%s.%d" % [c, h, v]


## Köylünün hava durumuna özel çevrilmiş replik metnini döner.
static func koylu_replik_al(karakter_id: String, ham_hava: String, varyant: int = 1) -> String:
	var anahtar := koylu_replik_anahtari(karakter_id, ham_hava, varyant)
	if anahtar.is_empty():
		return ""
	var sonuc := TranslationServer.translate(StringName(anahtar))
	if String(sonuc) == anahtar:
		var fallback_anahtar := koylu_replik_anahtari("genel", ham_hava, varyant)
		sonuc = TranslationServer.translate(StringName(fallback_anahtar))
	return String(sonuc)


static func _temel_hava_kodu(hava: StringName) -> String:
	match hava:
		&"kar", &"firtina":
			return "firtina"
		&"yagmur":
			return "yagmur"
		&"ayaz":
			return "ayaz"
		&"sis":
			return "sis"
		_:
			return ""
