## Gerçek LOWPO oynatıcısında poz, süre ve ağırlık kontrolleri.
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
	var agirliklar_gecerli := _agirliklari_dene()
	var eksik_yuru_gecerli := _eksik_klibi_dene("yuru")
	var eksik_kos_gecerli := _eksik_klibi_dene("kos")
	gecti = gecti and zorluklar_esit and agirliklar_gecerli and eksik_yuru_gecerli and eksik_kos_gecerli
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


func _agirliklari_dene() -> bool:
	var figur := Dunya3B.karakter("lowpo_demirci")
	root.add_child(figur)
	var oynatici := figur._oynatici
	var olcer := _olcer_kur(oynatici)
	var kitap := AnimationLibrary.new()
	_olcum_klibi_ekle(kitap, oynatici, StringName(AYAR.klipler.yuru), Vector3.RIGHT)
	_olcum_klibi_ekle(kitap, oynatici, StringName(AYAR.klipler.dur), Vector3.UP)
	oynatici.remove_animation_library(&"")
	oynatici.add_animation_library(&"", kitap)
	_elle_durusu_baslat(oynatici)
	figur.yuru(Vector3(0, 0, 4), 1.0)
	for i in range(ceili(float(AYAR.yuruyus_gecisi_suresi) / KARE) + 2):
		oynatici.advance(KARE)
	var saf_yuruyus := olcer.position
	figur.yurumeyi_durdur()
	var durus_kareleri := ceili(KarakterModel.GECIS / KARE)
	var ortak_kare := 0
	var en_buyuk_sapma := 0.0
	var orta := Vector3.ZERO
	for i in range(durus_kareleri + 2):
		oynatici.advance(KARE)
		var agirlik := olcer.position
		en_buyuk_sapma = maxf(en_buyuk_sapma, absf(agirlik.x + agirlik.y - 1.0))
		if agirlik.x > 0.001 and agirlik.y > 0.001:
			ortak_kare += 1
		if i == floori(durus_kareleri * 0.5):
			orta = agirlik
	var gecti := saf_yuruyus.is_equal_approx(Vector3.RIGHT) and olcer.position.is_equal_approx(Vector3.UP)
	gecti = gecti and ortak_kare > 0 and en_buyuk_sapma < 0.0001
	print("SAH-25 orta yürüyüş=%.6f, duruş=%.6f, ortak kare=%d, toplam sapması=%.6f" % [orta.x, orta.y, ortak_kare, en_buyuk_sapma])
	figur.free()
	return gecti


func _eksik_klibi_dene(eksik: String) -> bool:
	var figur := Dunya3B.karakter("lowpo_demirci")
	root.add_child(figur)
	var oynatici := figur._oynatici
	var olcer := _olcer_kur(oynatici)
	var kitap := AnimationLibrary.new()
	var bekle := StringName(AYAR.klipler.dur)
	_olcum_klibi_ekle(kitap, oynatici, bekle, Vector3.UP)
	_olcum_klibi_ekle(kitap, oynatici, &"konus", Vector3.RIGHT)
	if eksik == "kos":
		_olcum_klibi_ekle(kitap, oynatici, StringName(AYAR.klipler.yuru), Vector3.BACK)
	oynatici.remove_animation_library(&"")
	oynatici.add_animation_library(&"", kitap)
	oynatici.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	oynatici.play(&"konus", 0.0)
	oynatici.advance(0.0)
	var gecti := olcer.position.is_equal_approx(Vector3.RIGHT)
	var hiz := HareketGecisi.kosu_taban_hizi() + 0.5 if eksik == "kos" else 1.0
	var baglam := &"kacis" if eksik == "kos" else &""
	figur.yuru(Vector3(0, 0, 4), hiz, baglam)
	oynatici.advance(KARE)
	var agirlik := olcer.position
	gecti = gecti and oynatici.current_animation == bekle and agirlik.is_equal_approx(Vector3.UP)
	print("SAH-27 eksik=%s, oynayan=%s, konuşma/bekleme/yürüyüş ağırlığı=%s" % [eksik, oynatici.current_animation, agirlik])
	figur.free()
	return gecti


func _olcer_kur(oynatici: AnimationPlayer) -> Node3D:
	var olcer := Node3D.new()
	olcer.name = "AgirlikOlcer"
	oynatici.get_node(oynatici.root_node).add_child(olcer)
	return olcer


func _olcum_klibi_ekle(kitap: AnimationLibrary, oynatici: AnimationPlayer, ad: StringName, deger: Vector3) -> void:
	# Yalnız test kopyasındaki bir iz, motorun gerçek karışım ağırlığını ölçer.
	var klip := oynatici.get_animation(ad).duplicate() as Animation
	var iz := klip.add_track(Animation.TYPE_POSITION_3D)
	klip.track_set_path(iz, NodePath("AgirlikOlcer"))
	klip.position_track_insert_key(iz, 0.0, deger)
	kitap.add_animation(ad, klip)


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
