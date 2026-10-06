extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var s := ChrSorgusu.new(load("res://data/chr_runtime/CHR_001.tres"))
	var g := preload("res://src/arayuz/kapi/tansiyon_gostergesi.gd").new()
	g.sorgu = s
	root.add_child(g)
	for deger in [0, 3, 4, 7, 8, 10]:
		s.tansiyon = deger
		s.tansiyon_degisti.emit(deger)
		var bolge := 0 if deger < 4 else 1 if deger < 8 else 2
		_kontrol(g.bar.value == deger and (g.bar.get_theme_stylebox("fill") as StyleBoxFlat).bg_color == g.RENKLER[bolge], "Eşik rengi ve değer: %d" % deger)
		_kontrol(g.etiket.text.contains(["Sakin", "Gergin", "Panik"][bolge]), "Durum metni: %d" % deger)
	s.bayraklar["Flag_Kilitlendi"] = true
	s.tansiyon_degisti.emit(2)
	_kontrol(g.etiket.text.contains("kabul kapalı"), "Panik kilidi düşük tansiyonda da açıklanır")
	g.guncelle(99)
	_kontrol(g.bar.value == 10, "UI sınırı bozuk dış değeri korur")
	g.free()
	s.tansiyon_degisti.emit(3)
	await process_frame
	print("TANSİYON GÖSTERGESİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
