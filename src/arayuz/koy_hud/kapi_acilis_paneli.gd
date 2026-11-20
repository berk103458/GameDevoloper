extends RefCounted
const AK = preload("res://src/sistemler/kapi_acilis_olayi.gd")

static func ac(koy: KoyEkrani) -> bool:
	if not AK.gece_engelli(koy.oturum): return false
	if koy.has_node("KapiAcilisSunumu"): return true
	var ana := koy.get_parent() as Ana
	if ana == null: return true
	AK.baslat(koy.oturum)
	if AK.aile_bekliyor(koy.oturum):
		_aileye_git(ana)
		return true
	var kat := Control.new()
	kat.name = "KapiAcilisSunumu"
	kat.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	koy.add_child(kat)
	var renk := Panel.new()
	renk.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kat.add_child(renk)
	var kutu := VBoxContainer.new()
	kutu.position = Vector2(180, 240)
	kutu.size = Vector2(1500, 580)
	kutu.add_theme_constant_override("separation", 18)
	kat.add_child(kutu)
	var yer := Label.new()
	yer.text = String(AK.AYAR.yer_tutucu)
	yer.visible = OyuncuSurumu.debug_acik()
	kutu.add_child(yer)
	var baslik := Label.new()
	baslik.text = String(AK.AYAR.ulak)
	baslik.add_theme_font_size_override("font_size", Kabuk.BASLIK)
	kutu.add_child(baslik)
	var olay := load("res://data/olaylar/kapi_acilisi.tres") as OlayVerisi
	var metin := Label.new()
	metin.text = TranslationServer.translate(olay.metin_anahtari)
	metin.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	kutu.add_child(metin)
	var saat := Timer.new()
	saat.one_shot = true
	kat.add_child(saat)
	var gecildi := [false]
	var gecir := func() -> void:
		if gecildi[0]:
			return
		gecildi[0] = true
		if is_instance_valid(saat):
			saat.stop()
		if not is_instance_valid(ana) or not is_instance_valid(koy) or ana.oturum != koy.oturum:
			return
		AK.ulak_bitir(koy.oturum)
		_aileye_git(ana)
	var devam := Button.new()
	devam.name = "UlakDevam"
	devam.text = TranslationServer.translate(String(olay.secenek_anahtarlari[0])) if not olay.secenek_anahtarlari.is_empty() else "Devam et"
	devam.custom_minimum_size = Vector2(360, 56)
	devam.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	devam.pressed.connect(gecir)
	kutu.add_child(devam)
	devam.grab_focus.call_deferred()
	ana.kayit.yaz(koy.oturum.kaydet())
	saat.timeout.connect(gecir)
	saat.start(AK.ulak_suresi())
	return true

static func _aileye_git(ana: Ana) -> void:
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(ana.oturum, "kapi")
	ana.kayit.yaz(ana.oturum.kaydet())
	ana._kapiya_git()
