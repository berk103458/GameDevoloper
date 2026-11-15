extends Node
## SAH-50: gerçek kapıda heybe açılınca panel tıklamayı yer, kamera yaklaşmaz, gelen kişi panelin dışında görünür.
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_sah50.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 50)
		kayit = GuvenliKayit.new("user://test_sah50.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.gun = 5
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	e._gelen = ana.oturum._adli_gelen(&"chr_001")
	e._gelen.heybe = ana.oturum.heybe_uret(e._gelen.sinif)
	await e.sahne.gelen_yaklas(e._model_adi(e._gelen))
	await _kare(5)
	var cam: Camera3D = e.sahne.kamera
	var model: Node3D = e.sahne._gelen
	var mesafe_once := cam.global_position.distance_to(model.global_position)
	var kayma_once := cam.h_offset
	e._heybe_ac()
	await get_tree().create_timer(0.6).timeout
	var panel: Control = e._heybe_paneli
	_kontrol(panel != null and panel.mouse_filter == Control.MOUSE_FILTER_STOP, "Heybe paneli açık ve tıklamayı yer (BUG-15)")
	if panel == null:
		get_tree().quit(1)
		return
	var bas := cam.unproject_position(KapiKameraVurgu.kadraj_hesapla(model.global_position))
	var ui_x := bas.x * e.size.x / float(e._vp.size.x)
	var r := panel.get_global_rect()
	_kontrol(ui_x > r.end.x and ui_x < e.size.x, "Gelen kişinin başı panelin sağında, ekranda (x=%.0f, panel sonu %.0f)" % [ui_x, r.end.x])
	_kontrol(KapiKameraVurgu.kadrajda_mi(cam, model.global_position), "Kişi kamera görüş açısında")
	var mesafe := cam.global_position.distance_to(model.global_position)
	_kontrol(is_equal_approx(mesafe, mesafe_once) and KapiKameraVurgu.heybe_acikken_model_gorunur_mu(true, mesafe), "Kamera yaklaşmaz (%.2f m)" % mesafe)
	panel.kapandi.emit()
	await get_tree().create_timer(0.6).timeout
	_kontrol(is_equal_approx(cam.h_offset, kayma_once), "Heybe kapanınca kapı kadrajı geri gelir")
	get_tree().quit(1 if hata > 0 else 0)


func _kare(n: int) -> void:
	for i in n:
		await get_tree().process_frame


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)
