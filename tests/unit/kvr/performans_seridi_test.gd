extends SceneTree
var hata := 0
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var p := PerformansSeridi.new()
	root.add_child(p)
	_kontrol(not p.is_processing() and not p.visible and p.olcum_sayisi == 0, "Kapalı monitör sayaç sorgulamaz")
	p.ac(true)
	_kontrol(p.is_processing() and p.olcum_sayisi == 1, "Açılınca gerçek ölçüm alınır")
	var adet := p.olcum_sayisi
	for i in 50:
		p._process(2.0)
	_kontrol(p.olcum_sayisi == adet, "Örnekleme gerçek zamanla sınırlı; oyun hızı sorguyu sıklaştırmaz")
	_kontrol(p.son_olcum["kare_ms"] >= 0 and p.son_olcum["fps"] >= 0, "Gerçek Performance değerleri okunur")
	if DisplayServer.get_name() == "headless":
		_kontrol(p.son_olcum["vram"] == null and p.son_olcum["draw"] == null and p.text.contains("ölçüm yok"), "Headless grafik ölçümü sıfır başarı gibi sunulmaz")
	var baslangic := Time.get_ticks_msec()
	while Time.get_ticks_msec() - baslangic < 600:
		await process_frame
	p._yenile()
	_kontrol(p.olcum_sayisi > adet, "Açıkken sayaç yenilenir")
	p.ac(false)
	_kontrol(not p.is_processing(), "Kapanınca işlem durur")
	p.free()
	print("PERFORMANS ŞERİDİ: GEÇTİ" if hata == 0 else "PERFORMANS ŞERİDİ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
