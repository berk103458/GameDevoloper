class_name DiyalogDeneyiPaneli
extends PanelContainer
signal sonuc_alindi(sonuc: Dictionary)
var baglam: Node
var ziyaret: Gelen
var sorgu: RefCounted
var kilit: OptionButton
var otomatik: CheckBox
var tek_adim: Button
var durum: Label
var son_rapor: Dictionary = {}
var adim_sayisi := 0
var denenen: Dictionary = {}
var _son_ms := 0

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	custom_minimum_size = Vector2(1060, 300)
	position = get_viewport_rect().size / 2.0 - custom_minimum_size / 2.0
	mouse_filter = Control.MOUSE_FILTER_STOP
	var stil := StyleBoxFlat.new()
	stil.bg_color = Color("#101923")
	stil.set_content_margin_all(20)
	add_theme_stylebox_override("panel", stil)
	var v := VBoxContainer.new()
	add_child(v)
	var aciklama := Label.new()
	aciklama.text = "Diyalog deneyi · denenmemiş ilk açık seçeneği 0,5 sn arayla ilerletir.\nDöngü/kapalı ipucunda veya karar ekranında durur; kabul/ret vermez.\nEn çok 64 adım; ziyaret değişince durur. 9 değeri kalıcı panik oluşturur.\nPanel kapanınca kilit çözülür; mevcut tansiyon ve kalıcı panik geri alınmaz."
	aciklama.add_theme_font_size_override("font_size", 18)
	v.add_child(aciklama)
	var h := HBoxContainer.new()
	v.add_child(h)
	kilit = OptionButton.new()
	for ad in ["Doğal tansiyon", "2 · Sakin", "5 · Gergin", "9 · Panik"]: kilit.add_item(ad)
	kilit.item_selected.connect(_kilitle)
	h.add_child(kilit)
	otomatik = CheckBox.new()
	otomatik.text = "Otomatik ilerlet"
	otomatik.toggled.connect(func(evet: bool) -> void:
		if evet:
			adim_sayisi = 0
			denenen.clear())
	h.add_child(otomatik)
	tek_adim = Button.new()
	tek_adim.text = "Tek diyalog adımı"
	tek_adim.pressed.connect(_adim)
	h.add_child(tek_adim)
	durum = Label.new()
	durum.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	durum.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(durum)
	var kapat := Button.new()
	kapat.text = "Deneyi kapat"
	kapat.pressed.connect(func() -> void: ac(false))
	v.add_child(kapat)
	ac(false)

func _coz() -> void:
	if sorgu != null: DiyalogDeneyi.kilitle(sorgu, -1)
	sorgu = null
	ziyaret = null
	denenen.clear()
	otomatik.set_pressed_no_signal(false)
	kilit.select(0)

func _exit_tree() -> void:
	if sorgu != null: DiyalogDeneyi.kilitle(sorgu, -1)

func ac(evet: bool) -> void:
	visible = evet
	set_process(evet)
	if not evet: _coz()
	else: yenile()

func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - _son_ms < 500: return
	_son_ms = Time.get_ticks_msec()
	yenile()
	if otomatik.button_pressed: _adim()

func yenile() -> void:
	var uygun := DiyalogDeneyi.uygun(baglam)
	var g: Gelen = baglam.get("_ekran").get("_gelen") if uygun else null
	if g != ziyaret:
		_coz()
		ziyaret = g
		sorgu = g.chr_sorgusu() if g != null else null
		adim_sayisi = 0
	if not uygun: otomatik.set_pressed_no_signal(false)
	kilit.disabled = not uygun or sorgu == null
	otomatik.disabled = not uygun or baglam.get("_ekran").get("evre") != &"sohbet"
	tek_adim.disabled = otomatik.disabled
	if otomatik.disabled: otomatik.set_pressed_no_signal(false)
	durum.text = "Hazır sorgu yok" if g == null else "%s · %d adım · tansiyon %s" % [g.id, adim_sayisi, str(sorgu.tansiyon) if sorgu != null else "eski soru akışında yok"]
	if not son_rapor.is_empty(): durum.text += " · " + String(son_rapor.get("neden", ""))

func _kilitle(indeks: int) -> void:
	son_rapor = DiyalogDeneyi.uygula(baglam, ziyaret, [-1, 2, 5, 9][indeks])
	yenile()
	sonuc_alindi.emit(son_rapor)

func _adim() -> void:
	if adim_sayisi >= 64:
		son_rapor = {"ok": false, "neden": "64 adımlık döngü sınırı; otomatik akış durdu."}
	else:
		son_rapor = DiyalogDeneyi.adim(baglam, ziyaret, denenen)
		if son_rapor["ok"]: adim_sayisi += 1
	if not son_rapor["ok"] or son_rapor.get("bitti", false): otomatik.set_pressed_no_signal(false)
	yenile()
	sonuc_alindi.emit(son_rapor)
