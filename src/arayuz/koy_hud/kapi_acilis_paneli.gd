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
	var merkez := CenterContainer.new()
	merkez.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	renk.add_child(merkez)
	var cerceve := PanelContainer.new()
	cerceve.custom_minimum_size = Vector2(1140, 0)
	merkez.add_child(cerceve)
	var kenar := MarginContainer.new()
	kenar.add_theme_constant_override("margin_left", 36)
	kenar.add_theme_constant_override("margin_top", 28)
	kenar.add_theme_constant_override("margin_right", 36)
	kenar.add_theme_constant_override("margin_bottom", 28)
	cerceve.add_child(kenar)
	var kutu := VBoxContainer.new()
	kutu.custom_minimum_size = Vector2(1040, 0)
	kutu.add_theme_constant_override("separation", 18)
	kenar.add_child(kutu)
	var yer := Label.new()
	yer.text = String(AK.AYAR.yer_tutucu)
	yer.visible = OyuncuSurumu.debug_acik()
	kutu.add_child(yer)
	var baslik := Label.new()
	baslik.text = String(AK.AYAR.ulak)
	baslik.add_theme_font_size_override("font_size", Kabuk.BASLIK)
	kutu.add_child(baslik)
	var olay := load("res://data/olaylar/kapi_acilisi.tres") as OlayVerisi
	var asama := Label.new()
	asama.text = "1. Akşam · Sancak Ulağı Ayrılıyor"
	var alt_px := Tema.KUCUK_PX
	asama.add_theme_font_size_override("font_size", alt_px)
	asama.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	kutu.add_child(asama)
	var metin := Label.new()
	metin.text = TranslationServer.translate(olay.metin_anahtari)
	metin.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	kutu.add_child(metin)
	var gecis := Label.new()
	gecis.text = "Ulak gözden yitince kapı ilk kez açılır. Bu geceki tercihlerin 2. günün düzenini ve 2. gecenin yükünü belirleyecek."
	gecis.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	gecis.add_theme_font_size_override("font_size", alt_px)
	gecis.add_theme_color_override("font_color", Kabuk.SOLUK)
	kutu.add_child(gecis)
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
