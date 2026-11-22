## Köy giriş ve mekanik rehberi: ilk günlerden 2. geceye kadar canlı yönlendirme ve mekanik özeti.
class_name KoyRehberiPaneli
extends PanelContainer

const AD := "KoyRehberiPaneli"

var _ekran: Control
var _daraltildi := false
var _ozet_acik := false
var _kullanici_dokundu := false
var _son_otomatik_daraltma_gunu := -1

var _baslik: Label
var _ozet_dugme: Button
var _daralt_dugme: Button
var _icerik_kutu: VBoxContainer
var _asama_baslik: Label
var _gorev_kutu: VBoxContainer
var _ipucu_label: Label
var _ozet_kutu: VBoxContainer


static func kur(ekran: Control) -> PanelContainer:
	if ekran == null:
		return null
	var mevcut := ekran.get_node_or_null(AD) as PanelContainer
	if mevcut != null and is_instance_valid(mevcut):
		mevcut.call("guncelle")
		return mevcut
	var panel := new()
	panel.name = AD
	panel.set("_ekran", ekran)
	ekran.add_child(panel)
	panel.call("_olustur")
	panel.call("guncelle")
	return panel


static func yenile(ekran: Control) -> void:
	if ekran == null:
		return
	var panel := ekran.get_node_or_null(AD) as PanelContainer
	if panel != null and is_instance_valid(panel):
		panel.call("guncelle")


static func kart_durumu(ekran: Control, kart_acik: bool) -> void:
	if ekran == null:
		return
	var panel := ekran.get_node_or_null(AD) as PanelContainer
	if panel == null or not is_instance_valid(panel):
		return
	panel.visible = not kart_acik
	if not kart_acik:
		panel.call("guncelle")


func _olustur() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	offset_left = 20.0
	offset_top = 176.0
	offset_right = 450.0
	offset_bottom = 240.0
	z_index = 45

	var kenar := MarginContainer.new()
	kenar.add_theme_constant_override("margin_left", 14)
	kenar.add_theme_constant_override("margin_top", 10)
	kenar.add_theme_constant_override("margin_right", 14)
	kenar.add_theme_constant_override("margin_bottom", 12)
	add_child(kenar)

	var ana := VBoxContainer.new()
	ana.add_theme_constant_override("separation", 8)
	kenar.add_child(ana)

	var ust := HBoxContainer.new()
	ust.add_theme_constant_override("separation", 6)
	ana.add_child(ust)

	var baslik_px := Tema.KUCUK_PX
	var alt_px := maxi(16, Tema.KUCUK_PX - 4)

	_baslik = Label.new()
	_baslik.text = "Köy Rehberi"
	_baslik.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_baslik.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_baslik.add_theme_font_size_override("font_size", baslik_px)
	_baslik.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	ust.add_child(_baslik)

	_ozet_dugme = Button.new()
	_ozet_dugme.text = "Mekanikler"
	_ozet_dugme.toggle_mode = true
	_ozet_dugme.custom_minimum_size = Vector2(108, 34)
	_ozet_dugme.add_theme_font_size_override("font_size", alt_px)
	_ozet_dugme.pressed.connect(_ozet_degistir)
	ust.add_child(_ozet_dugme)

	_daralt_dugme = Button.new()
	_daralt_dugme.text = "Küçült"
	_daralt_dugme.custom_minimum_size = Vector2(96, 34)
	_daralt_dugme.add_theme_font_size_override("font_size", alt_px)
	_daralt_dugme.pressed.connect(_daralt_degistir)
	ust.add_child(_daralt_dugme)

	_icerik_kutu = VBoxContainer.new()
	_icerik_kutu.add_theme_constant_override("separation", 6)
	ana.add_child(_icerik_kutu)

	_asama_baslik = Label.new()
	_asama_baslik.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_asama_baslik.add_theme_font_size_override("font_size", alt_px)
	_asama_baslik.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	_icerik_kutu.add_child(_asama_baslik)

	_gorev_kutu = VBoxContainer.new()
	_gorev_kutu.add_theme_constant_override("separation", 4)
	_icerik_kutu.add_child(_gorev_kutu)

	_ipucu_label = Label.new()
	_ipucu_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_ipucu_label.add_theme_font_size_override("font_size", alt_px)
	_ipucu_label.add_theme_color_override("font_color", Kabuk.SOLUK)
	_icerik_kutu.add_child(_ipucu_label)

	_ozet_kutu = VBoxContainer.new()
	_ozet_kutu.add_theme_constant_override("separation", 4)
	_ozet_kutu.visible = false
	_icerik_kutu.add_child(_ozet_kutu)
	_ozet_satirlarini_kur(alt_px)


func _ozet_satirlarini_kur(alt_px: int) -> void:
	var maddeler := [
		"• Üretim: Alttaki şeritten yapı seçip + / - ile işçi ata.",
		"• İnşa: 'İnşa Et' ile boş zemine bina kur; akçe, odun ve taş gerekir.",
		"• Stok: Her gece nüfus kadar gıda eksilir; kışın yakacak ve yatak kritiktir.",
		"• Halk: 3B sahnedeki köylüye tıklayıp 'Muhabbet Et' ile nabız tut.",
		"• Tüccar & Hayvan: Pazar -> 'Tüccar Kervanı' ile koyun, keçi, tavuk, eşek alıp ürün katkısı sağla.",
		"• Gece Kapısı: Sağ üstten hızı 1x/2x yap veya geceye geçip akşam sohbetiyle kapıya geç.",
	]
	for satir in maddeler:
		var l := Label.new()
		l.text = satir
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.add_theme_font_size_override("font_size", alt_px)
		l.add_theme_color_override("font_color", Kabuk.yazi())
		_ozet_kutu.add_child(l)


func _ozet_degistir() -> void:
	_ozet_acik = not _ozet_acik
	_kullanici_dokundu = true
	if _daraltildi and _ozet_acik:
		_daraltildi = false
	_gorunumu_uygula()


func _daralt_degistir() -> void:
	_daraltildi = not _daraltildi
	_kullanici_dokundu = true
	_gorunumu_uygula()


func _gorunumu_uygula() -> void:
	if _icerik_kutu != null:
		_icerik_kutu.visible = not _daraltildi
	if _ozet_kutu != null:
		_ozet_kutu.visible = (not _daraltildi) and _ozet_acik
	if _ozet_dugme != null:
		_ozet_dugme.visible = not _daraltildi
		_ozet_dugme.set_pressed_no_signal(_ozet_acik)
	if _daralt_dugme != null:
		_daralt_dugme.text = "Rehberi Aç (?)" if _daraltildi else "Küçült"
	if _daraltildi:
		offset_right = 330.0
	else:
		offset_right = 450.0


func guncelle() -> void:
	if _ekran == null or _gorev_kutu == null:
		return
	var o: Oturum = _ekran.get("oturum") as Oturum
	var y: KoyYonetimi = o.yonetim if o != null else (_ekran.get("_y") as KoyYonetimi)
	if y == null:
		return

	if y.gun > 2 and not _kullanici_dokundu and _son_otomatik_daraltma_gunu != y.gun:
		_son_otomatik_daraltma_gunu = y.gun
		_daraltildi = true

	for c in _gorev_kutu.get_children():
		_gorev_kutu.remove_child(c)
		c.queue_free()

	var tas_calisan := y.calisanlar(TasYatagi.IS_YERI).size()
	var nufus := y.nufus()
	var bosta := y.bostakiler().size()
	var yatak := y.yatak_kapasitesi()
	var gida_gun := y.gida_gunu()
	var ilk_aile := o != null and o.bayraklar.has(&"acl04_aile_karari")
	var alt_px := maxi(16, Tema.KUCUK_PX - 4)

	if y.gun == 0 and not ilk_aile:
		_asama_baslik.text = "1. Gün · Kuruluş ve İlk İşler"
		_satir_ekle(tas_calisan > 0, "Taş Yatağı'na işçi ata (%d çalışıyor)" % tas_calisan, alt_px)
		_satir_ekle(bosta == 0 or nufus - bosta >= 2, "Boştaki köylüleri değerlendir (%d boşta)" % bosta, alt_px)
		_satir_ekle(false, "Akşam kapısı için sağ üstten günü ilerlet", alt_px)
		_ipucu_label.text = "İpucu: Alttaki şeritten Taş Yatağı'na tıkla, '+' ile işçi ekle."
	elif y.gun <= 1:
		_asama_baslik.text = "1. Akşam – 2. Gün · İlk Kapı ve Denge"
		_satir_ekle(ilk_aile, "İlk aileyi kapıda karşıla ve karar ver", alt_px)
		_satir_ekle(yatak >= nufus, "Barınak / yatak dengesini koru (%d/%d)" % [nufus, yatak], alt_px)
		_satir_ekle(gida_gun >= 2.0, "En az 2 günlük gıda stoğu tut (%.1f gün)" % gida_gun, alt_px)
		_ipucu_label.text = "İpucu: Bir köylüye tıklayıp 'Muhabbet Et' ile köydeki havayı yoklayabilirsin."
	else:
		_asama_baslik.text = "%d. Gün · Köy ve Gece Nöbeti" % (y.gun + 1)
		_satir_ekle(bosta == 0, "Boşta işçi bırakma (%d boşta)" % bosta, alt_px)
		_satir_ekle(yatak >= nufus, "Yatak kapasitesi: %d / %d" % [nufus, yatak], alt_px)
		_satir_ekle(gida_gun >= 2.0, "Gıda güvencesi: %.1f günlük stok" % gida_gun, alt_px)
		_ipucu_label.text = "İpucu: 'Mekanikler' düğmesinden tüm temel kuralları açıp kapatabilirsin."

	_gorunumu_uygula()


func _satir_ekle(tamam: bool, metin: String, alt_px: int) -> void:
	var l := Label.new()
	var isaret := "✓" if tamam else "•"
	l.text = "%s %s" % [isaret, metin]
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", alt_px)
	l.add_theme_color_override("font_color", Kabuk.MORAL if tamam else Kabuk.yazi())
	_gorev_kutu.add_child(l)
