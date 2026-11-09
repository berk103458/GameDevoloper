## Görev 22 SAH kanıtı: gerçek köy ekranı (KoyEkrani + KoyYonetimSahnesi + KameraSurukleme + KoyluTakibi)
## ve gerçek kapı sahnesi (KapiSahnesi) üzerinden SAH-41, 42, 43, 44, 45, 46, 48 ve 49.
## Yardımcı fonksiyon değil, oyunun girdi yolu (tekerlek/orta tuş olayı) ve sahne kamerası ölçülür.
extends SceneTree

const NOKTA := Vector2(900, 400)
const ADIM := Vector2(40, 20)
var hata := 0
var kontrol_sayisi := 0
var ekran: Control


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	create_timer(90.0).timeout.connect(func() -> void: quit(1))
	root.size = Vector2i(1920, 1080)
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 31)
	var kisi := o.yonetim.kabul({"ad": "Kanıt deneği", "sinif": "ciftci"})
	ekran = load("res://src/arayuz/koy_ekrani.gd").new()
	ekran.oturum = o
	ekran.ayarlar = Ayarlar.new("user://sah22_unused.cfg")
	ekran.theme = Tema.olustur(ekran.ayarlar)
	root.add_child(ekran)
	await process_frame
	await process_frame
	var s: KoyYonetimSahnesi = ekran.sahne3b
	s.halk_hareketi.set_process(false)
	s.halk_hareketi._bekleyen.clear()
	var f := s.halk_hareketi.modeller[kisi.id] as KarakterModel
	f.yurumeyi_durdur()
	f.position = Vector3.ZERO
	var ayar: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/sahne.json"))
	var alt_u := float(ayar.kamera_uzaklik.min)
	var ust_u := float(ayar.kamera_uzaklik.max)
	var kayit_once := JSON.stringify(o.kaydet())

	# SAH-41: köyde tek kamera ve tek sürükleme bileşeni; takip aynı kamerayı oynatır.
	var kameralar := s.find_children("*", "Camera3D", true, false)
	_kontrol(kameralar.size() == 1 and kameralar[0] == s.kamera, "SAH-41: köy sahnesinde tek Camera3D")
	_kontrol(s.find_children("kamera_surukleme", "", true, false).size() == 1, "SAH-41: tek kamera_surukleme bileşeni")
	KoyluTakibi.sec(s, kisi.id)
	var takip := s.get_node("koylu_takibi") as KoyluTakibi
	_kontrol(s.get_viewport().get_camera_3d() == s.kamera and takip.sahne.kamera == s.kamera, "SAH-41: takip ve sürükleme aynı kamerayı kullanır")

	# SAH-42 + SAH-45: oyunun tekerlek olayıyla en yakın uca; uzaklık sahne.json alt sınırında, zemin ve model delinmez.
	for i in 60:
		_dugme(NOKTA, true, MOUSE_BUTTON_WHEEL_UP)
	takip.guncelle()
	_kontrol(is_equal_approx(s.uzaklik, alt_u), "SAH-42: en yakın uzaklık sahne.json min (%.2f / %.2f)" % [s.uzaklik, alt_u])
	_kontrol(s.kamera.global_position.y > 0.5, "SAH-42: en yakında kamera zeminin üstünde (y=%.2f)" % s.kamera.global_position.y)
	var taban := float(ayar.kamera_taban_mesafe)
	var model_mesafe := s.kamera.global_position.distance_to(f.global_position + Vector3.UP * 0.9)
	_kontrol(takip.takip and model_mesafe >= taban, "SAH-45: takip edilen köylüye kamera mesafesi %.2f >= taban %.2f" % [model_mesafe, taban])
	for i in 60:
		_dugme(NOKTA, true, MOUSE_BUTTON_WHEEL_DOWN)
	_kontrol(is_equal_approx(s.uzaklik, ust_u), "SAH-42: en uzak uzaklık sahne.json max (%.2f / %.2f)" % [s.uzaklik, ust_u])

	# SAH-44: orta tuş takibi aynı olayda bırakır; bırakınca takip geri gelmez.
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	_kontrol(not takip.takip, "SAH-44: orta tuşa basınca takip kapanır")
	_hareket(NOKTA + ADIM, true)
	_dugme(NOKTA + ADIM, false)
	var serbest := s.hedef
	f.position += Vector3(2, 0, 1)
	takip.guncelle()
	_kontrol(not takip.takip and s.hedef == serbest, "SAH-44: bırakınca takip kendiliğinden dönmez")

	# SAH-43: ızgara köşesinde en uzak uçta yakınlaştırma hedefi (sınırı) değiştirmez.
	var alt := s.hucre_kosesi(Vector2i.ZERO)
	var ust := s.hucre_kosesi(s.yonetim.a.izgara_boyut)
	s.hedef = Vector3(ust.x, 0, ust.z)
	s._kamera_yerlestir()
	var kose := s.hedef
	for i in 10:
		_dugme(NOKTA, true, MOUSE_BUTTON_WHEEL_DOWN)
		_dugme(NOKTA, true, MOUSE_BUTTON_WHEEL_UP)
	_kontrol(s.hedef == kose, "SAH-43: yakınlaştırma köşedeki hedefi kaydırmaz")
	_hareket(NOKTA)
	_dugme(NOKTA, true)
	for i in 40:
		_hareket(NOKTA - Vector2(i + 1, i + 1) * 6, true)
	_dugme(NOKTA, false)
	_kontrol(s.hedef.x >= alt.x and s.hedef.x <= ust.x and s.hedef.z >= alt.z and s.hedef.z <= ust.z, "SAH-43: köşeden sürüklemede hedef köy sınırı içinde")

	# SAH-48: kamera hareketleri kayda yazılmaz.
	var kayit_sonra := JSON.stringify(o.kaydet())
	_kontrol(kayit_sonra == kayit_once, "SAH-48: kamera hareketinden sonra kayıt aynı")
	for anahtar in ["uzaklik", "kamera", "hedef", "yon", "egim"]:
		_kontrol(not kayit_sonra.contains("\"%s\"" % anahtar), "SAH-48: kayıtta '%s' alanı yok" % anahtar)

	# SAH-46: köy yakınlaştırması kapı kamerasının FOV'unu değiştirmez.
	var kapi := KapiSahnesi.new()
	root.add_child(kapi)
	await process_frame
	var kapi_fov := kapi.kamera.fov
	_kontrol(is_equal_approx(kapi_fov, KapiSahnesi.GORUS), "SAH-46: kapı FOV'u BUG-13 sabiti (%.1f)" % kapi_fov)
	for i in 30:
		s.yakinlas(1.0)
		s._kamera_yerlestir()
	_kontrol(is_equal_approx(kapi.kamera.fov, kapi_fov), "SAH-46: köy yakınlaştırmasından sonra kapı FOV'u aynı")
	ekran.free()

	# SAH-49: gerçek kapı akışında üç boy model DURMA noktasına yürür; baş kemiği kamera kadrajında.
	for ad in ["chr_006", "chr_001", "asker"]:
		await kapi.gelen_yaklas(ad)
		var model := kapi._gelen
		var bas := _bas_konumu(model)
		_kontrol(bas != Vector3.INF, "SAH-49: %s baş kemiği bulundu" % ad)
		if bas != Vector3.INF:
			_kontrol(kapi.kamera.is_position_in_frustum(bas), "SAH-49: %s başı kadrajda (y=%.2f)" % [ad, bas.y])
			_kontrol(KapiKameraVurgu.kadrajda_mi(kapi.kamera, model.global_position), "SAH-49: %s yüz noktası FOV yarı açısında" % ad)
		_kontrol(is_equal_approx(kapi.kamera.fov, KapiSahnesi.GORUS), "SAH-49: %s için FOV BUG-13 sabitinde" % ad)
	kapi.free()
	if hata == 0:
		print("SAH KAMERA KANIT: GEÇTİ (%d kontrol)" % kontrol_sayisi)
	else:
		print("SAH KAMERA KANIT: KALDI (%d hata / %d kontrol)" % [hata, kontrol_sayisi])
	quit(1 if hata > 0 else 0)


func _bas_konumu(model: Node3D) -> Vector3:
	for sk: Skeleton3D in model.find_children("*", "Skeleton3D", true, false):
		for i in sk.get_bone_count():
			if sk.get_bone_name(i).to_lower().contains("head"):
				return sk.global_transform * sk.get_bone_global_pose(i).origin
	return Vector3.INF


func _hareket(p: Vector2, orta: bool = false) -> void:
	var e := InputEventMouseMotion.new()
	e.position = p
	e.global_position = p
	e.button_mask = MOUSE_BUTTON_MASK_MIDDLE if orta else 0
	root.push_input(e, true)


func _dugme(p: Vector2, bas: bool, tus: MouseButton = MOUSE_BUTTON_MIDDLE) -> void:
	var e := InputEventMouseButton.new()
	e.position = p
	e.global_position = p
	e.button_index = tus
	e.pressed = bas
	e.button_mask = MOUSE_BUTTON_MASK_MIDDLE if bas and tus == MOUSE_BUTTON_MIDDLE else 0
	root.push_input(e, true)


func _kontrol(v: bool, ad: String) -> void:
	kontrol_sayisi += 1
	if not v:
		hata += 1
		push_error(ad)
