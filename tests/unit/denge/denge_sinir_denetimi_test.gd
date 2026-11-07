extends SceneTree

const Denetim = preload("res://src/sistemler/denge_sinir_denetimi.gd")

func _initialize() -> void:
	var hata := Denetim.acilis_hatasi()
	var tablo: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
	var sinirlar: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge_sinirlari.json"))
	tablo.zorluk.olagan = 2
	if not hata.is_empty() or Denetim.hata(tablo, sinirlar) != "zorluk.olagan":
		push_error("DEN-03b: geçerli tablo veya bozuk değer denetimi başarısız: " + hata)
		quit(1)
		return
	tablo.zorluk.olagan = 1.0
	tablo.zorluk.ustalik = 1.5
	sinirlar["zorluk.ustalik"] = {"alt": 1.0, "ust": 2.0}
	if Denetim.hata(tablo, sinirlar) != "zorluk":
		push_error("DEN-65: dördüncü zorluk sınırı olsa da reddedilmeli")
		quit(1)
		return
	print("DEN-03b ve DEN-65: GEÇTİ")
	quit()
