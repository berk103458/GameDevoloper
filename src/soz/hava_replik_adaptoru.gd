## KVR-SES-01: Kapı nöbetinde hava durumu ve ayaza bağlı dinamik replik adaptörü.
## Tipi, fırtına, yağmur, ayaz ve sis atmosferi için ön ek ve karşılama metinlerini sağlar.
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

## Ön ek ile asıl repliği düzgün bir aralıkla birleştirir.
static func replik_birlestir(on_ek: String, asil_replik: String) -> String:
	if on_ek.is_empty():
		return asil_replik
	if asil_replik.is_empty():
		return on_ek
	return "%s\n\n%s" % [on_ek.strip_edges(), asil_replik.strip_edges()]

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
