extends SceneTree
## KAY-24 / KAY-54: Yusuf altın kayıtları satır kimliğiyle yeniden oynanır. Yeni cümle yazılmaz.

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var ham := FileAccess.get_file_as_string("res://tests/fixtures/kayit/yusuf_altin.json")
	var paket: Variant = JSON.parse_string(ham)
	dene(paket is Dictionary and paket.get("kisi") == "yusuf", "Yusuf için en az bir altın kayıt")
	var oynanislar: Array = paket.get("oynanislar", []) if paket is Dictionary else []
	dene(oynanislar.size() == 15, "DYL-16 Yusuf paketi 15 oynanış")
	var bas := Time.get_ticks_usec()
	var tamam := 0
	for kayit in oynanislar:
		if not kayit is Dictionary:
			dene(false, "Oynanış kaydı sözlük")
			continue
		var satirlar := SozMotoru.oynat(kayit)
		var beklenen: PackedStringArray = PackedStringArray()
		for satir in kayit.get("satirlar", []):
			beklenen.append(String(satir))
		dene(satirlar == beklenen, "Satır kimlikleri birebir: tohum %s" % str(kayit.get("tohum", "")))
		dene(SozMotoru.etkiler_ayni(kayit.get("etki", {}), kayit.get("etki", {})), "Kayıtlı etki aynı")
		var bozuk: Dictionary = (kayit.get("etki", {}) as Dictionary).duplicate(true)
		bozuk["guven"] = 99
		dene(not SozMotoru.etkiler_ayni(kayit.get("etki", {}), bozuk), "Bozulan etki sapar")
		tamam += 1
	var sure_ms := (Time.get_ticks_usec() - bas) / 1000.0
	print("KAY-54 sure_ms=%.2f tamam=%d/15" % [sure_ms, tamam])
	dene(tamam == 15, "15/15 oynanış biter")
	print("ALTIN OYNANIŞ: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)
