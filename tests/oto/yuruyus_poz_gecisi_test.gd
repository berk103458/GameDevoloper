## SAH-18 ve SAH-24: Gerçek LOWPO iskeletinde poz karışımı ve zorluklar arası süre.
extends SceneTree

const AYAR: Dictionary = preload("res://data/ayarlar/sahne.json").data
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const ZORLUK = preload("res://src/sistemler/zorluk_secimi.gd")
const KARE := 1.0 / 120.0


func _initialize() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var figur := Dunya3B.karakter("lowpo_demirci")
	root.add_child(figur)
	var oynatici := figur._oynatici
	var iskelet := figur.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var dur := oynatici.get_animation(StringName(AYAR.klipler.dur))
	var yuru := oynatici.get_animation(StringName(AYAR.klipler.yuru))
	_elle_durusu_baslat(oynatici)
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
	var zorluklar_esit := await _zorluklari_dene()
	gecti = gecti and zorluklar_esit
	print("DURUŞ YÜRÜYÜŞ KARIŞIMI: GEÇTİ" if gecti else "DURUŞ YÜRÜYÜŞ KARIŞIMI: KALDI")
	await root.get_node("Ses").cik(0 if gecti else 1)


func _elle_durusu_baslat(oynatici: AnimationPlayer) -> void:
	oynatici.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	oynatici.stop()
	oynatici.play(StringName(AYAR.klipler.dur), 0.0)
	oynatici.advance(0.0)


func _zorluklari_dene() -> bool:
	var katalog := Katalog.new()
	katalog.yukle()
	var zorluklar := ZORLUK.anahtarlar()
	var kareler := PackedInt32Array()
	var gecti := zorluklar.size() == 3
	var tablo_karesi := ceili(float(AYAR.yuruyus_gecisi_suresi) / KARE)
	for zorluk in zorluklar:
		var oturum := Oturum.new(katalog, 76)
		ACILIS.kur(oturum, zorluk)
		var sahne := KoyYonetimSahnesi.new()
		sahne.yonetim = oturum.yonetim
		root.add_child(sahne)
		var figur := Dunya3B.karakter("lowpo_demirci")
		sahne._halk.add_child(figur)
		var kare := _tam_klibe_gecis(figur, tablo_karesi + 2)
		kareler.append(kare)
		gecti = gecti and sahne.yonetim.get_meta(&"zorluk", "") == zorluk and kare >= tablo_karesi
		sahne.queue_free()
		await process_frame
	print("SAH-24 zorluklar=%s, saf klibe geçiş kareleri=%s, tablo=%.3f s" % [zorluklar, kareler, float(AYAR.yuruyus_gecisi_suresi)])
	return gecti and kareler[0] == kareler[1] and kareler[1] == kareler[2]


func _tam_klibe_gecis(figur: KarakterModel, son_kare: int) -> int:
	var oynatici := figur._oynatici
	var iskelet := figur.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var klip := oynatici.get_animation(StringName(AYAR.klipler.yuru))
	_elle_durusu_baslat(oynatici)
	figur.yuru(Vector3(0, 0, 4), 1.0)
	for kare in range(1, son_kare + 1):
		oynatici.advance(KARE)
		var fark := _poz_farki(iskelet, klip, oynatici.current_animation_position)
		if fark >= 0.0 and fark < 0.003:
			return kare
	return -1


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
