class_name KasaDenetcisiPaneli
extends PanelContainer
signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var girdiler: Dictionary = {}
var dugmeler: Dictionary = {}
var durum: Label
var son_rapor: Dictionary = {}
var _sure := 0.0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(760, 340)
	position = get_viewport_rect().size / 2.0 - custom_minimum_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var kutu := StyleBoxFlat.new()
	kutu.bg_color = Color("#101923")
	kutu.set_content_margin_all(20)
	add_theme_stylebox_override("panel", kutu)
	var v := VBoxContainer.new()
	add_child(v)
	var baslik := Label.new()
	baslik.text = "Çift kasa ve rüşvet kesesi"
	v.add_child(baslik)
	durum = Label.new()
	durum.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(durum)
	for islem in ["koy_akce", "muhafiz_akce", "kese_ekle"]:
		var satir := HBoxContainer.new()
		v.add_child(satir)
		var l := Label.new()
		l.text = {"koy_akce": "Köy kasası", "muhafiz_akce": "Muhafız kasası", "kese_ekle": "Keseye eklenecek akçe"}[islem]
		l.custom_minimum_size.x = 250
		satir.add_child(l)
		var spin := SpinBox.new()
		spin.min_value = 1 if islem == "kese_ekle" else 0
		spin.max_value = KasaDenetleyici.SINIR
		spin.step = 1
		spin.custom_minimum_size.x = 170
		spin.tooltip_text = "0–1.000.000 akçe. İlk iki satır yeni bakiyeyi belirler; son satır keseye ekler."
		satir.add_child(spin)
		girdiler[islem] = spin
		var b := Button.new()
		b.text = "Keseye ekle" if islem == "kese_ekle" else "Bakiyeyi ayarla"
		b.pressed.connect(_uygula.bind(islem))
		satir.add_child(b)
		dugmeler[islem] = b
	var sifirla := Button.new()
	sifirla.text = "Rüşvet kesesini sıfırla (akçe + kişisel eşyalar)"
	sifirla.tooltip_text = "Yalnız kişisel keseyi temizler. Köy kasası, geçmiş rüşvet kararları ve ziyaret bayrakları korunur."
	sifirla.pressed.connect(_uygula.bind("kese_sifirla"))
	v.add_child(sifirla)
	dugmeler["kese_sifirla"] = sifirla
	var kapat := Button.new()
	kapat.text = "Denetçiyi kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	v.add_child(kapat)
	ac(false)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if evet:
		var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
		if o != null:
			girdiler["koy_akce"].value = o.koy_akce
			girdiler["muhafiz_akce"].value = o.muhafiz_akce
		girdiler["kese_ekle"].value = 10
		yenile()
		girdiler["koy_akce"].get_line_edit().grab_focus()
	else:
		var odak := get_viewport().gui_get_focus_owner()
		if odak != null and is_ancestor_of(odak): odak.release_focus()

func _process(delta: float) -> void:
	_sure += delta
	if _sure >= 0.5:
		_sure = 0.0
		yenile()

func yenile() -> void:
	var o: Oturum = baglam.get("oturum") if is_instance_valid(baglam) else null
	durum.text = "Oturum yok" if o == null else "Köy: %d akçe · Muhafız: %d akçe · Kişisel eşya: %d kayıt" % [o.koy_akce, o.muhafiz_akce, o.muhafiz_esyalari.size()]
	for b: Button in dugmeler.values(): b.disabled = not DurumAnlikGoruntusu.alinabilir(baglam)

func _uygula(islem: String) -> void:
	var miktar := 0
	if girdiler.has(islem):
		girdiler[islem].apply()
		miktar = int(girdiler[islem].value)
	son_rapor = KasaDenetleyici.uygula(baglam, islem, miktar)
	yenile()
	sonuc_alindi.emit(son_rapor)
