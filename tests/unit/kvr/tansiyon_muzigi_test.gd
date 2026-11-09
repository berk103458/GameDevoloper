extends SceneTree

var _hata := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var muzik := preload("res://src/sistemler/tansiyon_muzigi.gd").new()
	root.add_child(muzik)
	for deger in [0, 3, 4, 7, 8, 10]:
		muzik.guncelle(deger)
		var beklenen := 0 if deger < 4 else 1 if deger < 8 else 2
		_dene(muzik.katman == beklenen, "tansiyon_muzigi_test.gd:12")
		for o in muzik._oynaticilar:
			_dene(o.stream != null and o.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD, "tansiyon_muzigi_test.gd:14")
	await create_timer(0.8).timeout
	_dene(muzik._oynaticilar[2].volume_db > -13.0 and muzik._oynaticilar[0].volume_db < -79.0, "tansiyon_muzigi_test.gd:16")
	var tween: Tween = muzik._gecis
	muzik.guncelle(9)
	_dene(muzik._gecis == tween, "tansiyon_muzigi_test.gd:19")
	muzik.durdur()
	for o in muzik._oynaticilar:
		_dene(not o.playing, "tansiyon_muzigi_test.gd:22")
	muzik.free()
	await process_frame
	await create_timer(0.2).timeout
	print("TANSİYON MÜZİĞİ: GEÇTİ" if _hata == 0 else "TANSİYON MÜZİĞİ: KALDI (%d hata)" % _hata)
	quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
