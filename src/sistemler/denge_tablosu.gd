extends RefCounted

const YOL := "res://data/ayarlar/denge.json"

static var _tablo: Variant = JSON.parse_string(FileAccess.get_file_as_string(YOL))

static func oku() -> Variant:
	return _tablo

static func ilk_hafta_erzak(tablo: Dictionary) -> int:
	var hafta: Dictionary = tablo["ilk_hafta_erzak"]
	return int(hafta["acilis_kisi"]) * int(hafta["gece"]) + int(hafta["pay"])

static func zorluk_carpani(tablo: Dictionary, zorluk: String) -> float:
	return float(tablo["zorluk"][zorluk])

static func acilis_erzagini_yaz(kaynaklar: Kaynaklar) -> void:
	var fark := ilk_hafta_erzak(oku()) - kaynaklar.miktar("gida")
	if fark > 0:
		kaynaklar.ekle("gida", fark)
	elif fark < 0:
		kaynaklar.azalt("gida", -fark)
