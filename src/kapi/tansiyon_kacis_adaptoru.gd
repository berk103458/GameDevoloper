## ZAR-03: Karar akışına tansiyon kaçış adaptörü.
## Tansiyon 10'u aşarsa karakter ayrılır ve karar "kaçtı" olur; ret sayacı artmaz.
## Eşik sayısı data/ayarlar/denge.json içindedir (zar_esigi.tansiyon_kacis_esigi).
class_name TansiyonKacisAdaptoru
extends RefCounted

const KARAR_KACTI := &"kacti"
const KARAR_KACTI_TR := "kaçtı"

static func kacis_esigi(kurallar: Resource = null) -> int:
	return SorguZari.kacis_esigi_oku("res://data/ayarlar/denge.json", kurallar)

static func basarisiz_artis(secenek: Dictionary = {}, kurallar: Resource = null) -> int:
	return SorguZari.basarisiz_artis(secenek, kurallar)

static func kontrol(mevcut_tansiyon: int, artis: int, basarili_zar: bool, esik: int = 10) -> Dictionary:
	return SorguZari.kacis_kontrol(mevcut_tansiyon, artis, basarili_zar, esik)

static func uygula(oturum: RefCounted, gelen: RefCounted, karar: Variant = KARAR_KACTI_TR) -> Dictionary:
	return SorguZari.karar_uygula(oturum, gelen, karar)
