extends SceneTree

var hata := 0

func _initialize() -> void:
	var k := KarakterVerisi.new()
	k.baslangic_tansiyonu = 55
	k.karar_matrisi["kabul"] = {"stat_etkisi": {"Refah": 100, "Moral": -100, "Saglik": 2, "Akce": 999},
		"muhafiz_akce": 40, "varyantlar": [{"stat_etkisi": {"Erzak": -8}}]}
	var s := ChrSorgusu.new(k)
	_kontrol(s.tansiyon == 10, "Başlatma runtime tansiyonu sınırlar")
	s.tansiyon = -33
	_kontrol(s.tansiyon == 0, "Doğrudan yazma alt sınırı korur")
	s.tansiyon = 77
	_kontrol(s.tansiyon == 10, "Doğrudan yazma üst sınırı korur")
	var etki := k.karar_verisi(&"kabul")
	_kontrol(etki["stat_etkisi"] == {"Refah": 4, "Moral": -4, "Saglik": 2}, "Beş stat anlık etkileri -4…4 sınırında")
	_kontrol(etki["varyantlar"][0]["stat_etkisi"]["Erzak"] == -4 and etki["muhafiz_akce"] == 40, "Koşullu stat sınırı kasa miktarını değiştirmez")
	_kontrol(k.karar_matrisi["kabul"]["stat_etkisi"]["Refah"] == 100 and k.karar_matrisi["kabul"]["varyantlar"][0]["stat_etkisi"]["Erzak"] == -8, "Kaynak stat değerleri korunur")
	print("CHR SINIRLARI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
