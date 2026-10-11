## Mevcut taş kartında bilgi ve kazı ataması; ayrı atama penceresi açmaz.
class_name TasYatagiPaneli
extends RefCounted

static func yenile(ekran: Node) -> void:
	var kart: Node = ekran.hud._stok_etiketleri["tas"]
	var v: HBoxContainer = kart.get_child(0).get_node_or_null("TasYatagiBilgisi")
	var y: KoyYonetimi = ekran.oturum.yonetim
	if v == null:
		v = HBoxContainer.new()
		v.name = "TasYatagiBilgisi"
		kart.get_child(0).add_child(v)
		var l := Label.new()
		l.name = "Bilgi"
		l.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
		v.add_child(l)
		var kazi := Button.new()
		kazi.name = "Kazi"
		v.add_child(kazi)
		kazi.pressed.connect(func() -> void:
			for k in y.bostakiler():
				if y.ata(k.id, TasYatagi.IS_YERI): break
			ekran._yenile()
		)
		var birak := Button.new()
		birak.name = "Birak"
		birak.text = TranslationServer.translate("koy.tas_yatagi.birak")
		v.add_child(birak)
		birak.pressed.connect(func() -> void:
			for k in y.calisanlar(TasYatagi.IS_YERI): y.bosalt(k.id)
			ekran._yenile()
		)
	v.visible = y.tas_yatagi != null
	if not v.visible: return
	v.get_node("Bilgi").text = y.tas_yatagi.bilgi()
	var kazi: Button = v.get_node("Kazi")
	kazi.text = TranslationServer.translate("koy.tas_yatagi.kaz") % y.calisanlar(TasYatagi.IS_YERI).size()
	kazi.disabled = y.tas_yatagi.kalan <= 0 or y.son != ""
	var aday := false
	for k in y.bostakiler():
		if TasYatagi.uygun(y, k): aday = true
	kazi.disabled = kazi.disabled or not aday
	v.get_node("Birak").disabled = y.calisanlar(TasYatagi.IS_YERI).is_empty()
	kart.tooltip_text = y.tas_yatagi.bilgi()
