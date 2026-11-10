## SAH-17: Tablo bantları gerçek karakterin oynatıcısını seçer.
extends SceneTree

const AYAR: Dictionary = preload("res://data/ayarlar/sahne.json").data


func _initialize() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var figur := Dunya3B.karakter("lowpo_demirci")
	root.add_child(figur)
	await process_frame
	var oynatici := figur._oynatici
	var hedef := Vector3(0.0, 0.0, 4.0)
	var bantlar: Dictionary = AYAR.hiz_bantlari
	var klipler: Dictionary = AYAR.klipler
	var secimler := PackedStringArray()
	var secilen_bantlar := PackedStringArray()
	var gecti := true
	figur.yuru(hedef, float(bantlar.dur[1]) * 0.5)
	await process_frame
	secimler.append(oynatici.current_animation)
	secilen_bantlar.append(figur.hareket_bandi())
	gecti = gecti and figur.position.is_zero_approx() and (figur._yurume == null or not figur._yurume.is_running())
	figur.yuru(hedef, (float(bantlar.yuru[0]) + float(bantlar.yuru[1])) * 0.5)
	secimler.append(oynatici.current_animation)
	secilen_bantlar.append(figur.hareket_bandi())
	var kosu_hizi := (float(bantlar.kos[0]) + float(bantlar.kos[1])) * 0.5
	figur.yuru(hedef, kosu_hizi, &"kacis")
	secimler.append(oynatici.current_animation)
	secilen_bantlar.append(figur.hareket_bandi())
	await create_timer(0.12).timeout
	gecti = gecti and figur.position.z > 0.3 and oynatici.current_animation_position > 0.0
	gecti = gecti and secimler == PackedStringArray([klipler.dur, klipler.yuru, klipler.kos])
	gecti = gecti and secilen_bantlar == PackedStringArray(["dur", "yuru", "kos"])
	var kos := oynatici.get_animation(klipler.kos)
	gecti = gecti and kos != null and kos != oynatici.get_animation(klipler.yuru) and kos.get_track_count() >= 17
	figur.yurumeyi_durdur()
	figur.yuru(hedef, kosu_hizi, &"kovalama")
	gecti = gecti and figur.hareket_bandi() == "kos" and oynatici.current_animation == klipler.kos
	figur.yuru(hedef, kosu_hizi)
	gecti = gecti and figur.hareket_bandi() == "yuru" and oynatici.current_animation == klipler.yuru
	figur.yurumeyi_durdur()
	gecti = gecti and oynatici.current_animation == klipler.dur
	var kitap := oynatici.get_animation_library(&"").duplicate() as AnimationLibrary
	kitap.remove_animation(StringName(klipler.yuru))
	oynatici.remove_animation_library(&"")
	oynatici.add_animation_library(&"", kitap)
	oynatici.play("konus")
	figur.yuru(hedef, float(bantlar.yuru[0]) + 0.5)
	gecti = gecti and figur.hareket_bandi() == "yuru" and oynatici.current_animation == klipler.dur
	print("SAH-22 eksik yürüyüşte oynayan klip=%s" % oynatici.current_animation)
	print("SAH-17 bantlar=%s, canlı klipler=%s" % [secilen_bantlar, secimler])
	figur.free()
	print("CANLI HIZ BANTLARI: GEÇTİ" if gecti else "CANLI HIZ BANTLARI: KALDI")
	await root.get_node("Ses").cik(0 if gecti else 1)
