extends RefCounted

const YOL := "res://data/ayarlar/denge.json"

static var _tablo: Variant = JSON.parse_string(FileAccess.get_file_as_string(YOL))

static func oku() -> Variant:
	return _tablo

static func ilk_hafta_erzak(tablo: Dictionary, zorluk: String = "olagan", gecelik_erzak: int = 0) -> int:
	var hafta: Dictionary = tablo["ilk_hafta_erzak"]
	var pay := int(hafta["pay"])
	if zorluk == "siki":
		pay = maxi(gecelik_erzak, floori(float(pay) / zorluk_carpani(tablo, zorluk)))
	return int(hafta["acilis_kisi"]) * int(hafta["gece"]) + pay

static func zorluk_carpani(tablo: Dictionary, zorluk: String) -> float:
	return float(tablo["zorluk"][zorluk])

static func acilis_erzagini_yaz(kaynaklar: Kaynaklar, zorluk: String = "olagan", gecelik_erzak: int = 0) -> void:
	var fark := ilk_hafta_erzak(oku(), zorluk, gecelik_erzak) - kaynaklar.miktar("gida")
	if fark > 0:
		kaynaklar.ekle("gida", fark)
	elif fark < 0:
		kaynaklar.azalt("gida", -fark)
