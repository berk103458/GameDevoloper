## CHR sorgusu softlock regresyonu (7/24 tester oynanışı, 11 Ekim 2026, oyun 103/106/107):
## başarısız ikna denemesi kalıcı kapanınca ve kalan cevap ipucu kilitliyse oyuncu kapıda sıkışıyordu.
## Beklenen: hiçbir cevap açık değilken "Kararını ver" çıkışı görünür ve karar ekranını ister.
extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var gelen := Gelen.new()
	gelen.id = &"chr_001"
	gelen.adli = true
	var sorgu: RefCounted = gelen.chr_sorgusu()
	var dugum: Dictionary = sorgu.karakter.diyalog_dugumu(sorgu.dugum_id)
	var secenekler: Array = dugum.get("secenekler", [])
	_kontrol(not secenekler.is_empty(), "Başlangıç düğümünde cevap seçenekleri var")

	# 1) En az bir cevap açıkken çıkış düğmesi gereksiz: eski davranış korunur.
	var panel := preload("res://src/arayuz/chr_diyalog_paneli.gd").new()
	panel.sorgu = sorgu
	root.add_child(panel)
	_kontrol(panel.get_node_or_null("KilitliKarar") == null, "Açık cevap varken kilit çıkışı yok")
	panel.free()

	# 2) Bütün cevaplar denenmiş (kalıcı kapalı) ve ipucu yok: çıkış görünmeli.
	for i in secenekler.size():
		sorgu._denemeler["%s:%d" % [sorgu.dugum_id, i]] = true
	var kilitli := preload("res://src/arayuz/chr_diyalog_paneli.gd").new()
	kilitli.sorgu = sorgu
	root.add_child(kilitli)
	for i in secenekler.size():
		_kontrol((kilitli.get_node("Secenek%d" % i) as Button).disabled, "Denenmiş cevap %d kapalı" % i)
	var cikis := kilitli.get_node_or_null("KilitliKarar") as Button
	_kontrol(cikis != null and not cikis.disabled, "Hiç açık cevap yokken 'Kararını ver' çıkışı var")
	var istendi := [false]
	kilitli.karar_istendi.connect(func() -> void: istendi[0] = true)
	if cikis != null:
		cikis.pressed.emit()
	_kontrol(istendi[0], "Çıkış düğmesi karar ekranını istiyor")
	kilitli.free()
	sorgu = null
	gelen = null

	await process_frame
	await process_frame
	await create_timer(0.8).timeout
	print("CHR KILIT CIKISI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
