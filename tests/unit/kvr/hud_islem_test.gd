extends SceneTree

var hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var hud := Hud.new()
	root.add_child(hud)
	_kontrol(not hud.is_processing(), "Oturumsuz HUD boşta çalışmaz")
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 17)
	hud.bagla(o)
	_kontrol(not hud.is_processing(), "Uyarısız kapı HUD'u uyur")
	o.yonetim.asayis_riski = 80
	hud.guncelle()
	_kontrol(hud.is_processing(), "Uyarı başlayınca uyandırılır")
	hud._process(0.2)
	_kontrol(hud._asayis.modulate.a < 1.0, "Görünür uyarı yanıp sönmeye devam eder")
	hud.hide()
	_kontrol(not hud.is_processing(), "Gizlenen HUD uyur")
	hud.show()
	_kontrol(hud.is_processing(), "Görünür uyarı yeniden canlanır")
	o.yonetim.asayis_riski = 0
	hud.guncelle()
	_kontrol(not hud.is_processing() and is_equal_approx(hud._asayis.modulate.a, 1.0), "Uyarı bitince renk düzelir ve HUD uyur")
	# El eşyası delta değerini Node'dan okuyabilir; boş işlem callback'i gerekmez.
	var esya := ElEsyasi.new()
	root.add_child(esya)
	await process_frame
	await process_frame
	_kontrol(not esya.is_processing() and esya.get_process_delta_time() > 0.0, "El eşyası işlenmeden kare süresini okur")
	esya.free()
	hud.free()
	print("HUD İŞLEM KAPISI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
