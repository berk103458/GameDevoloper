## Kapıya gelen bir kişi (adlı karakter ya da figür örneği) — bir ziyaretin verisi.
class_name Gelen
extends RefCounted

var adli: bool = false
## Adlı karakterin kimliği; figürde boş.
var id: StringName = &""
var ad_anahtari: String = ""
var sinif: StringName = &"ciftci"
## Portre kökü (`char_<portre>_neutral_card.png`).
var portre: String = ""
var giris_anahtari: String = ""
## [soru_anahtari, cevap_anahtari] çiftleri.
var sorular: Array[PackedStringArray] = []
var secenekler: PackedStringArray = []
## Karar -> bar etkisi.
var etkiler: Dictionary = {}
