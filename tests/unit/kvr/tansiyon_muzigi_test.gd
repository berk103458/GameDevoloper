extends SceneTree

func _initialize() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var muzik := preload("res://src/sistemler/tansiyon_muzigi.gd").new()
	root.add_child(muzik)
	for deger in [0, 3, 4, 7, 8, 10]:
		muzik.guncelle(deger)
		var beklenen := 0 if deger < 4 else 1 if deger < 8 else 2
		assert(muzik.katman == beklenen)
		for o in muzik._oynaticilar:
			assert(o.stream != null and o.stream.loop_mode == AudioStreamWAV.LOOP_FORWARD)
	await create_timer(0.8).timeout
	assert(muzik._oynaticilar[2].volume_db > -13.0 and muzik._oynaticilar[0].volume_db < -79.0)
	var tween: Tween = muzik._gecis
	muzik.guncelle(9)
	assert(muzik._gecis == tween)
	muzik.durdur()
	for o in muzik._oynaticilar:
		assert(not o.playing)
	muzik.free()
	await process_frame
	await create_timer(0.2).timeout
	print("TANSİYON MÜZİĞİ: GEÇTİ")
	quit(0)
