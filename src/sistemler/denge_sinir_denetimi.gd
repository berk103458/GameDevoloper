extends RefCounted

static func hata(tablo: Variant, sinirlar: Variant) -> String:
	if not tablo is Dictionary or not sinirlar is Dictionary:
		return "JSON"
	for yol: String in sinirlar:
		var deger: Variant = tablo
		for parca in yol.trim_suffix("[]").split("."):
			deger = deger.get(parca) if deger is Dictionary else null
		var sinir: Variant = sinirlar[yol]
		if not sinir is Dictionary or not _sayi(sinir.get("alt")) or not _sayi(sinir.get("ust")):
			return yol
		if sinir.alt > sinir.ust or deger == null:
			return yol
		var degerler: Array = deger if deger is Array else [deger]
		if degerler.is_empty():
			return yol
		for sayi in degerler:
			if not _sayi(sayi) or sayi < sinir.alt or sayi > sinir.ust:
				return yol
	return ""

static func _sayi(deger: Variant) -> bool:
	return (deger is float or deger is int) and is_finite(float(deger))

static func acilis_hatasi() -> String:
	return hata(
		preload("res://src/sistemler/denge_tablosu.gd").oku(),
		JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge_sinirlari.json"))
	)
