## SAH-18: İlk karışım karesi gerçek LOWPO kemik pozundan ölçülür.
extends SceneTree

const AYAR: Dictionary = preload("res://data/ayarlar/sahne.json").data
const KARE := 1.0 / 120.0


func _initialize() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var figur := Dunya3B.karakter("lowpo_demirci")
	root.add_child(figur)
	var oynatici := figur._oynatici
	oynatici.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	var iskelet := figur.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var dur := oynatici.get_animation(StringName(AYAR.klipler.dur))
	var yuru := oynatici.get_animation(StringName(AYAR.klipler.yuru))
	oynatici.stop()
	oynatici.play(StringName(AYAR.klipler.dur), 0.0)
	oynatici.advance(0.0)
	figur.yuru(Vector3(0, 0, 4), 1.0)
	oynatici.advance(KARE)
	var ilk_dur := _poz_farki(iskelet, dur, KARE * oynatici.speed_scale)
	var ilk_yuru := _poz_farki(iskelet, yuru, oynatici.current_animation_position)
	var gecis_kareleri := ceili(float(AYAR.yuruyus_gecisi_suresi) / KARE)
	var orta_kare := floori(gecis_kareleri * 0.5)
	for i in range(orta_kare - 1):
		oynatici.advance(KARE)
	var orta_yuru := _poz_farki(iskelet, yuru, oynatici.current_animation_position)
	for i in range(gecis_kareleri - orta_kare + 2):
		oynatici.advance(KARE)
	var son_yuru := _poz_farki(iskelet, yuru, oynatici.current_animation_position)
	var gecti := ilk_dur >= 0.0 and ilk_yuru > ilk_dur and orta_yuru > 0.01 and son_yuru >= 0.0 and son_yuru < 0.003
	print("SAH-18 ilk dur=%.6f rad, ilk yürü=%.6f rad, orta yürü=%.6f rad, son yürü=%.6f rad" % [ilk_dur, ilk_yuru, orta_yuru, son_yuru])
	figur.free()
	print("DURUŞ YÜRÜYÜŞ KARIŞIMI: GEÇTİ" if gecti else "DURUŞ YÜRÜYÜŞ KARIŞIMI: KALDI")
	await root.get_node("Ses").cik(0 if gecti else 1)


func _poz_farki(iskelet: Skeleton3D, klip: Animation, zaman: float) -> float:
	var toplam := 0.0
	var sayi := 0
	for i in range(klip.get_track_count()):
		if klip.track_get_type(i) != Animation.TYPE_ROTATION_3D:
			continue
		var yol := klip.track_get_path(i)
		var kemik := iskelet.find_bone(yol.get_subname(0))
		if kemik < 0:
			continue
		var hedef := klip.rotation_track_interpolate(i, zaman)
		toplam += iskelet.get_bone_pose_rotation(kemik).angle_to(hedef)
		sayi += 1
	return toplam / sayi if sayi > 0 else -1.0
