## AYR-01, AYR-04, AYR-50: Altı sekme. Kontroller ve Dil yalnız yuvadır.
## Değer anında uygulanır; dosya kapanınca yazılır.
class_name AyarSekmeleri
extends Control

const SEKMELER := [
	[&"oyun", "arayuz.ayarlar.sekme.oyun", "res://src/arayuz/ayarlar/oyun_sekmesi.gd"],
	[&"goruntu", "arayuz.ayarlar.sekme.goruntu", "res://src/arayuz/ayarlar/goruntu_sekmesi.gd"],
	[&"okuma", "arayuz.ayarlar.sekme.okuma", "res://src/arayuz/ayarlar/okuma_sekmesi.gd"],
	[&"ses", "arayuz.ayarlar.sekme.ses", "res://src/arayuz/ayarlar/ses_sekmesi.gd"],
	[&"kontroller", "arayuz.ayarlar.sekme.kontroller", "res://src/arayuz/ayarlar/kontroller_yuvasi.gd"],
	[&"dil", "arayuz.ayarlar.sekme.dil", "res://src/arayuz/ayarlar/dil_yuvasi.gd"],
]

var ayarlar: Ayarlar
var ekran: Control
var _baslik: Label
var _icerik: Control
var _aciklama: Label
var _sifir_dugme: Button
var _kapat_dugme: Button
var _aktif_indeks := 0
var _onay_sekmesi := &""
var _sekme_dugmeleri: Array[Button] = []


static func kur(hedef: Control) -> AyarSekmeleri:
	var s := AyarSekmeleri.new()
	s.name = "AyarSekmeleri"
	s.ayarlar = hedef.get("ayarlar")
	s.ekran = hedef
	hedef.add_child(s)
	return s


static func sekme_sayisi() -> int:
	return SEKMELER.size()


static func betikler() -> PackedStringArray:
	var yollar := PackedStringArray()
	for satir in SEKMELER:
		yollar.append(String(satir[2]))
	return yollar


static func bos_yuvalar() -> PackedStringArray:
	return PackedStringArray([&"kontroller", &"dil"])


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for cocuk in ekran.get_children():
		if cocuk == self or cocuk.name == "TemaZemini":
			continue
		if cocuk is CanvasItem:
			(cocuk as CanvasItem).visible = false
	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 80)
	kenar.add_theme_constant_override("margin_top", 48)
	kenar.add_theme_constant_override("margin_right", 80)
	kenar.add_theme_constant_override("margin_bottom", 48)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 12)
	kenar.add_child(dikey)
	_baslik = Label.new()
	_baslik.text = tr("arayuz.ayarlar.baslik")
	var koy_baslik := Tema.koy_baslik_fontu()
	if koy_baslik != null:
		_baslik.add_theme_font_override("font", koy_baslik)
	var baslik_px := ayarlar.boyut(Tema.BASLIK_PX) if ayarlar != null else Tema.BASLIK_PX
	_baslik.add_theme_font_size_override("font_size", baslik_px)
	_baslik.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	dikey.add_child(_baslik)
	var sekmeler := HBoxContainer.new()
	sekmeler.add_theme_constant_override("separation", 10)
	dikey.add_child(sekmeler)
	var cerceve := PanelContainer.new()
	cerceve.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cerceve.clip_contents = true
	dikey.add_child(cerceve)
	var ic_kenar := MarginContainer.new()
	ic_kenar.add_theme_constant_override("margin_left", 28)
	ic_kenar.add_theme_constant_override("margin_top", 18)
	ic_kenar.add_theme_constant_override("margin_right", 28)
	ic_kenar.add_theme_constant_override("margin_bottom", 18)
	cerceve.add_child(ic_kenar)
	_icerik = VBoxContainer.new()
	_icerik.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_icerik.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_icerik.add_theme_constant_override("separation", 8)
	ic_kenar.add_child(_icerik)
	var aciklama_cerceve := PanelContainer.new()
	aciklama_cerceve.custom_minimum_size = Vector2(0, 54)
	dikey.add_child(aciklama_cerceve)
	var aciklama_kenar := MarginContainer.new()
	aciklama_kenar.add_theme_constant_override("margin_left", 18)
	aciklama_kenar.add_theme_constant_override("margin_top", 10)
	aciklama_kenar.add_theme_constant_override("margin_right", 18)
	aciklama_kenar.add_theme_constant_override("margin_bottom", 10)
	aciklama_cerceve.add_child(aciklama_kenar)
	_aciklama = Label.new()
	_aciklama.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_aciklama.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_aciklama.add_theme_color_override("font_color", Kabuk.SOLUK)
	aciklama_kenar.add_child(_aciklama)
	var alt := HBoxContainer.new()
	alt.add_theme_constant_override("separation", 16)
	dikey.add_child(alt)
	_sifir_dugme = Button.new()
	_sifir_dugme.text = tr("arayuz.ayarlar.sekme_sifirla")
	_sifir_dugme.custom_minimum_size = Vector2(220, 48)
	_sifir_dugme.pressed.connect(_sifirla)
	alt.add_child(_sifir_dugme)
	_kapat_dugme = Button.new()
	_kapat_dugme.text = tr("arayuz.ayarlar.geri")
	_kapat_dugme.custom_minimum_size = Vector2(220, 48)
	_kapat_dugme.pressed.connect(_kapat)
	alt.add_child(_kapat_dugme)
	_sekme_dugmeleri.clear()
	for i in SEKMELER.size():
		var dugme := Button.new()
		dugme.text = tr(String(SEKMELER[i][1]))
		dugme.toggle_mode = true
		dugme.custom_minimum_size = Vector2(168, 48)
		dugme.pressed.connect(_ac.bind(i))
		sekmeler.add_child(dugme)
		_sekme_dugmeleri.append(dugme)
	if ayarlar != null and not ayarlar.degisti.is_connected(_ayar_degisti):
		ayarlar.degisti.connect(_ayar_degisti)
	_ac(0)


func _exit_tree() -> void:
	if ayarlar != null and ayarlar.degisti.is_connected(_ayar_degisti):
		ayarlar.degisti.disconnect(_ayar_degisti)


func _ayar_degisti(anahtar: StringName) -> void:
	if anahtar == &"dil":
		_yenile_metinler()


func _yenile_metinler() -> void:
	if _baslik != null:
		_baslik.text = tr("arayuz.ayarlar.baslik")
	if _sifir_dugme != null:
		_sifir_dugme.text = tr("arayuz.ayarlar.sekme_sifirla")
	if _kapat_dugme != null:
		_kapat_dugme.text = tr("arayuz.ayarlar.geri")
	_sekme_vurgula(_aktif_indeks)
	_varsayilan_aciklama(_aktif_indeks)


func _sekme_vurgula(indeks: int) -> void:
	for i in _sekme_dugmeleri.size():
		var dugme := _sekme_dugmeleri[i]
		var etkin := (i == indeks)
		dugme.set_pressed_no_signal(etkin)
		var ad_metni := tr(String(SEKMELER[i][1]))
		dugme.text = ("▸ " + ad_metni) if etkin else ad_metni
		var renk := Kabuk.BAR_DOLU if etkin else Kabuk.yazi()
		for anahtar in ["font_color", "font_pressed_color", "font_hover_color", "font_focus_color"]:
			dugme.add_theme_color_override(anahtar, renk)


func _varsayilan_aciklama(indeks: int) -> void:
	if _aciklama == null:
		return
	var kimlik := StringName(SEKMELER[indeks][0])
	match kimlik:
		&"oyun":
			_aciklama.text = tr("arayuz.ayarlar.zorluk_aciklama")
		&"goruntu":
			_aciklama.text = tr("arayuz.ayarlar.ekran_modu_aciklama")
		&"okuma":
			_aciklama.text = tr("arayuz.ayarlar.metin_olcegi_aciklama")
		&"ses":
			_aciklama.text = tr("arayuz.ayarlar.ses_ana_aciklama")
		&"kontroller":
			_aciklama.text = tr("arayuz.girdi.sekme")
		&"dil":
			_aciklama.text = tr("arayuz.dil.baslik")
		_:
			_aciklama.text = ""


func _ac(indeks: int) -> void:
	_aktif_indeks = indeks
	_onay_sekmesi = &""
	_sekme_vurgula(indeks)
	for c in _icerik.get_children():
		_icerik.remove_child(c)
		c.queue_free()
	var betik: GDScript = load(String(SEKMELER[indeks][2]))
	var sayfa: Control = betik.new()
	sayfa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sayfa.set("ayarlar", ayarlar)
	sayfa.set("aciklama", _aciklama)
	if ekran != null and ekran.has_meta(&"ipucu_kaydi"):
		sayfa.set("ipucu_kaydi", ekran.get_meta(&"ipucu_kaydi"))
	_icerik.add_child(sayfa)
	preload("res://src/arayuz/ayarlar/grv_sekme_koprusu.gd").bagla(sayfa, StringName(SEKMELER[indeks][0]), ayarlar)
	_icerik.set_meta(&"sekme", SEKMELER[indeks][0])
	_varsayilan_aciklama(indeks)


func _sifirla() -> void:
	var sekme: StringName = _icerik.get_meta(&"sekme", &"")
	if _onay_sekmesi != sekme:
		_onay_sekmesi = sekme
		_aciklama.text = tr("arayuz.ayarlar.sekme_sifirla_onay")
		return
	if sekme == &"kontroller":
		GirdiEylemleri.varsayilana_don()
	elif sekme == &"dil":
		DilAyari.sec(ayarlar, "tr")
	else:
		AyarlarEk.sekme_sifirla(ayarlar, sekme, true)
	_onay_sekmesi = &""
	var indeks := 0
	for i in SEKMELER.size():
		if SEKMELER[i][0] == sekme:
			indeks = i
	_ac(indeks)


func _kapat() -> void:
	if ekran != null and ekran.has_method("_kapat"):
		ekran.call("_kapat")
