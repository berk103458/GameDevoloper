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
## Her sorunun üst sorusunun `sorular` içindeki indeksi; -1 = kök. Üst sorulunca takip açılır.
var soru_ust: PackedInt32Array = PackedInt32Array()
## Açılış sözü: kapıya varınca kendini ve hikâyesini anlatır (anahtar ya da düz metin).
var acilis: String = ""
var secenekler: PackedStringArray = []
## Karar -> bar etkisi.
var etkiler: Dictionary = {}
## Gemini diyalogunda kararın ziyaretçiye ait cevabı.
var yanitlar: Dictionary = {}
## Bu kadar soru sorulunca karar düğmesi açılır. Boşsa hepsi açık.
var esikler: PackedInt32Array = PackedInt32Array()
## Heybesi: söylediği ve astarda sakladığı (Oturum.heybe_uret).
var heybe: Heybe
## Bu gelene sorulabilecek en çok soru; 0 = genel ayar.
var azami_soru: int = 0
## Kötü niyetli mi: retteki tepki öfke, değilse yıkılma (panik).
var tehlikeli: bool = false


## Sorulabilecek soru sınırı: gelenin kendi sınırı, yoksa genel ayar.
func soru_siniri(genel: int) -> int:
	return azami_soru if azami_soru > 0 else genel
