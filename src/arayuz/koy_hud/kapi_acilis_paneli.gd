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
	var olay := load("res://data/olaylar/kapi_acilisi.tres") as OlayVerisi
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
	var parsomen := UlakParsomenAnimasyonu.olustur()
	if parsomen != null:
		_gorsel_kur(kat, olay, parsomen, gecir)
	else:
		_duz_yazi_kur(kat, olay, gecir)
	koy.add_child(kat)
	ana.kayit.yaz(koy.oturum.kaydet())
	saat.timeout.connect(gecir)
	saat.start(AK.ulak_suresi())
	return true

static func _aileye_git(ana: Ana) -> void:
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(ana.oturum, "kapi")
	ana.kayit.yaz(ana.oturum.kaydet())
	ana._kapiya_git()

static func _devam_dugmesi(olay: OlayVerisi, gecir: Callable) -> Button:
	var devam := Button.new()
	devam.name = "UlakDevam"
	devam.text = TranslationServer.translate(String(olay.secenek_anahtarlari[0])) if not olay.secenek_anahtarlari.is_empty() else "Devam et"
	devam.custom_minimum_size = Vector2(360, 56)
	devam.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	devam.pressed.connect(gecir)
	return devam

static func _duz_yazi_kur(kat: Control, olay: OlayVerisi, gecir: Callable) -> void:
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
	var devam := _devam_dugmesi(olay, gecir)
	kutu.add_child(devam)
	devam.grab_focus.call_deferred()

static func _gorsel_kur(kat: Control, olay: OlayVerisi, parsomen: UlakParsomenAnimasyonu, gecir: Callable) -> void:
	var renk := Panel.new()
	renk.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := StyleBoxFlat.new()
	zemin.bg_color = Color(0.04, 0.03, 0.02, 0.94)
	renk.add_theme_stylebox_override("panel", zemin)
	kat.add_child(renk)
	var sahne := Control.new()
	sahne.name = "UlakSahnesi"
	sahne.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	sahne.mouse_filter = Control.MOUSE_FILTER_IGNORE
	renk.add_child(sahne)
	var ulak_doku := UlakParsomenAnimasyonu.ulak_dokusu()
	var ulak: TextureRect = null
	if ulak_doku != null:
		ulak = TextureRect.new()
		ulak.name = "UlakAsker"
		ulak.texture = ulak_doku
		ulak.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		ulak.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		ulak.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ulak.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ulak.anchor_left = 0.0
		ulak.anchor_right = 0.46
		ulak.anchor_top = 0.02
		ulak.anchor_bottom = 0.80
		ulak.offset_left = ulak.offset_right = ulak.offset_top = ulak.offset_bottom = 0.0
		ulak.modulate.a = 0.0
		sahne.add_child(ulak)
	parsomen.name = "UlakParsomen"
	parsomen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if ulak != null:
		parsomen.anchor_left = 0.36
		parsomen.anchor_right = 0.98
		parsomen.anchor_top = 0.06
		parsomen.anchor_bottom = 0.78
	else:
		parsomen.anchor_left = 0.12
		parsomen.anchor_right = 0.88
		parsomen.anchor_top = 0.06
		parsomen.anchor_bottom = 0.78
	parsomen.offset_left = parsomen.offset_right = parsomen.offset_top = parsomen.offset_bottom = 0.0
	parsomen.modulate.a = 0.0
	sahne.add_child(parsomen)
	var metin := Label.new()
	metin.name = "UlakBeratMetni"
	metin.text = TranslationServer.translate(olay.metin_anahtari)
	metin.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	metin.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	metin.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	metin.add_theme_font_size_override("font_size", 22)
	metin.add_theme_color_override("font_color", Color(0.22, 0.14, 0.07, 1))
	metin.add_theme_color_override("font_shadow_color", Color(0.90, 0.82, 0.62, 0.35))
	metin.add_theme_constant_override("shadow_offset_x", 1)
	metin.add_theme_constant_override("shadow_offset_y", 1)
	metin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	metin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	# Açık parşömenin iç yüzeyi (kare_09); metin görsele gömülmez.
	metin.anchor_left = 0.18
	metin.anchor_right = 0.90
	metin.anchor_top = 0.32
	metin.anchor_bottom = 0.66
	metin.offset_left = metin.offset_right = metin.offset_top = metin.offset_bottom = 0.0
	metin.modulate.a = 0.0
	parsomen.add_child(metin)
	var alt := MarginContainer.new()
	alt.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	alt.anchor_top = 0.78
	alt.offset_left = 36
	alt.offset_right = -36
	alt.offset_top = 0
	alt.offset_bottom = -16
	alt.mouse_filter = Control.MOUSE_FILTER_IGNORE
	renk.add_child(alt)
	var kutu := VBoxContainer.new()
	kutu.add_theme_constant_override("separation", 8)
	kutu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	alt.add_child(kutu)
	var yer := Label.new()
	yer.text = String(AK.AYAR.yer_tutucu)
	yer.visible = OyuncuSurumu.debug_acik()
	kutu.add_child(yer)
	var baslik := Label.new()
	baslik.text = String(AK.AYAR.ulak)
	baslik.add_theme_font_size_override("font_size", Kabuk.BASLIK)
	kutu.add_child(baslik)
	var alt_px := Tema.KUCUK_PX
	var asama := Label.new()
	asama.text = "1. Akşam · Sancak Ulağı Ayrılıyor"
	asama.add_theme_font_size_override("font_size", alt_px)
	asama.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	kutu.add_child(asama)
	var ipucu := Label.new()
	ipucu.name = "UlakParsomenIpucu"
	ipucu.text = "Mühürlü berata dokun"
	ipucu.add_theme_font_size_override("font_size", alt_px)
	ipucu.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	kutu.add_child(ipucu)
	var gecis := Label.new()
	gecis.text = "Ulak gözden yitince kapı ilk kez açılır. Bu geceki tercihlerin 2. günün düzenini ve 2. gecenin yükünü belirleyecek."
	gecis.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	gecis.add_theme_font_size_override("font_size", alt_px)
	gecis.add_theme_color_override("font_color", Kabuk.SOLUK)
	gecis.modulate.a = 0.0
	kutu.add_child(gecis)
	var devam := _devam_dugmesi(olay, gecir)
	kutu.add_child(devam)
	devam.grab_focus.call_deferred()
	parsomen.bitti.connect(func() -> void:
		if not is_instance_valid(kat):
			return
		ipucu.visible = false
		var yaz := kat.create_tween()
		yaz.tween_property(metin, "modulate:a", 1.0, 0.65)
		yaz.parallel().tween_property(gecis, "modulate:a", 1.0, 0.65)
	)
	# Ulak kısa tween ile sahneye girer, ardından beratı uzatır (parşömen belirir).
	kat.ready.connect(func() -> void:
		if not is_instance_valid(kat):
			return
		var gir := kat.create_tween()
		gir.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		if ulak != null:
			ulak.offset_left = 160.0
			ulak.offset_right = 160.0
			gir.tween_property(ulak, "modulate:a", 1.0, 0.55)
			gir.parallel().tween_property(ulak, "offset_left", 0.0, 0.70)
			gir.parallel().tween_property(ulak, "offset_right", 0.0, 0.70)
			gir.tween_property(parsomen, "modulate:a", 1.0, 0.40)
		else:
			gir.tween_property(parsomen, "modulate:a", 1.0, 0.45)
	, CONNECT_ONE_SHOT)
