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
	kat.add_child(kutu)
	var yer := Label.new()
	yer.text = String(AK.AYAR.yer_tutucu)
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
	ana.kayit.yaz(koy.oturum.kaydet())
	var saat := Timer.new()
	saat.one_shot = true
	kat.add_child(saat)
	saat.timeout.connect(func() -> void:
		AK.ulak_bitir(koy.oturum)
		_aileye_git(ana)
	)
	saat.start(AK.ulak_suresi())
	return true

static func _aileye_git(ana: Ana) -> void:
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(ana.oturum, "kapi")
	ana.kayit.yaz(ana.oturum.kaydet())
	ana._kapiya_git()
