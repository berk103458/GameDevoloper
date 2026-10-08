## Köy yönetimi ekranı (Faz 2 — akşam; design/gdd/koy-yonetimi.md 6, 7, 8, 10, 14, 17):
## üst kaynak şeridi, kuşbakışı köy, alt inşaat ve eylem paneli, yapı bilgi penceresi, nüfus tablosu, pazar,
## isyan ve haraç bantları. "Geceye Geç" gece hesaplaşmasını yapar, rapor kartını ve varsa olayı gösterir.
class_name KoyEkrani
extends Control

## Gece bitti, sabah kapıya dönülür.
signal devam_istendi(rapor: Dictionary)
## Oyun bir sonla bitti (`halk_kirildi`, `isyan`, `tekfur`, `zafer`).
signal oturum_bitti(son: StringName)

const KATEGORILER: Array[String] = ["barinma", "uretim", "hizmet", "savunma"]

var oturum: Oturum
var ayarlar: Ayarlar

var sahne3b: KoyYonetimSahnesi
var hud: Hud
## Açık mini oyun (olay seçeneği `oyun` isterse); yoksa null.
var mini_oyun: MiniOyun
## `insa`, `yol`, `yik` ya da boş.
var kip := ""
var _insa_turu := ""
var _yon := 0
var _imlec := Vector2i(-1, -1)
var _secili_bina := -1
var _vp: SubViewport
var _atama_alani: KoyAtamaAlani
var _kap: SubViewportContainer
var _alt: PanelContainer
var _kategori_satiri: HBoxContainer
var _yapi_satiri: HBoxContainer
var _bilgi: PanelContainer
var _bilgi_icerik: VBoxContainer
var _bant: PanelContainer
var _ipucu: Label
var _ust_kart: PanelContainer
var _gece_dugmesi: Button
var _hiz_dugmeleri: Dictionary = {}
var _son_hiz := 1
var _onceki_fizik_adimi := 8
var _kategori := "barinma"
var _y: KoyYonetimi
var _dinamik_ortam: Node
var _gece_kilidi := preload("res://src/sistemler/gece_gecis_kilidi.gd").new()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_onceki_fizik_adimi = Engine.max_physics_steps_per_frame
	Engine.max_physics_steps_per_frame = 8
	_y = oturum.yonetim
	_dinamik_ortam = preload("res://src/sistemler/koy_ortam_sesi.gd").new()
	add_child(_dinamik_ortam)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_kap = SubViewportContainer.new()
	_kap.stretch = true
	_kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_kap.mouse_filter = Control.MOUSE_FILTER_STOP
	_kap.gui_input.connect(_dunya_girdisi)
	add_child(_kap)
	_vp = SubViewport.new()
	_vp.msaa_3d = Viewport.MSAA_4X
	_vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_SMAA
	_kap.add_child(_vp)
	sahne3b = KoyYonetimSahnesi.new()
	sahne3b.process_mode = Node.PROCESS_MODE_PAUSABLE
	sahne3b.yonetim = _y
	_vp.add_child(sahne3b)
	hud = Hud.new()
	add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hud.bagla(oturum)
	_alt_panel_kur()
	_bilgi_kur()
	_atama_alani = KoyAtamaAlani.new()
	_atama_alani.ekran = self
	add_child(_atama_alani)
	_bant = PanelContainer.new()
	_bant.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	_bant.position.y = 110
	add_child(_bant)
	_ipucu = Label.new()
	_ipucu.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_ipucu.offset_left = 24
	_ipucu.offset_right = -24
	_ipucu.offset_top = -ayarlar.boyut(260) - 70
	_ipucu.offset_bottom = -ayarlar.boyut(260) - 12
	_ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_ipucu.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	_ipucu.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(_ipucu)
	_yenile()

## Ana ekran ses adaptörü; ışığın ilk gunduz fazıyla aynı başlar.
func ortam_baslat() -> void:
	if _dinamik_ortam != null:
		_dinamik_ortam.faz(&"gunduz")


# ── Alt panel (17.2) ──────────────────────────────────────────────────────────────────────────────

func _alt_panel_kur() -> void:
	_alt = PanelContainer.new()
	_alt.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_alt.custom_minimum_size.y = ayarlar.boyut(260)
	_alt.add_theme_stylebox_override("panel", Tema.koy_paneli())
	_alt.offset_top = -ayarlar.boyut(260)
	add_child(_alt)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 18)
	_alt.add_child(kenar)
	var yatay := HBoxContainer.new()
	yatay.add_theme_constant_override("separation", 24)
	kenar.add_child(yatay)
	var sol := VBoxContainer.new()
	sol.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sol.add_theme_constant_override("separation", 10)
	yatay.add_child(sol)
	_kategori_satiri = HBoxContainer.new()
	_kategori_satiri.add_theme_constant_override("separation", 8)
	sol.add_child(_kategori_satiri)
	for k in KATEGORILER:
		var b := _dugme(tr("koy.kategori." + k), _kategori_satiri)
		b.toggle_mode = true
		b.pressed.connect(func() -> void:
			_kategori = k
			_yapi_satirini_ciz()
		)
	var araclar := ["yol", "yik"]
	for a in araclar:
		var b := _dugme(tr("koy.arac." + a), _kategori_satiri)
		b.pressed.connect(func() -> void: _kip_sec(a))
	_yapi_satiri = HBoxContainer.new()
	_yapi_satiri.add_theme_constant_override("separation", 8)
	var kaydir := ScrollContainer.new()
	kaydir.custom_minimum_size.y = ayarlar.boyut(160)
	kaydir.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaydir.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	kaydir.follow_focus = true
	sol.add_child(kaydir)
	kaydir.add_child(_yapi_satiri)
	var sag := VBoxContainer.new()
	sag.add_theme_constant_override("separation", 8)
	yatay.add_child(sag)
	var pazar := _dugme(tr("koy.eylem.pazar"), sag)
	pazar.pressed.connect(_pazar_ac)
	var nufus := _dugme(tr("koy.eylem.nufus"), sag)
	nufus.pressed.connect(_nufus_ac)
	DivanBaglantisi.kur(self, sag)
	MuhafizOdasiBaglantisi.kur(self, sag)
	HaritaBaglantisi.kur(self, sag)
	var hizlar := HBoxContainer.new()
	hizlar.add_theme_constant_override("separation", 4)
	sag.add_child(hizlar)
	for kat in [0, 1, 2, 3]:
		var b := _dugme("Ⅱ" if kat == 0 else "%dx" % kat, hizlar)
		b.add_theme_font_size_override("font_size", ayarlar.boyut(18))
		b.add_theme_stylebox_override("normal", Tema.koy_paneli())
		b.toggle_mode = true
		b.set_pressed_no_signal(kat == 1)
		b.tooltip_text = tr("koy.hiz.durdur") if kat == 0 else tr("koy.eylem.hiz") % kat
		b.pressed.connect(func() -> void: _hiz_sec(kat))
		_hiz_dugmeleri[kat] = b
	_gece_dugmesi = _dugme(tr("koy.eylem.gece"), yatay)
	_gece_dugmesi.custom_minimum_size = Vector2(260, 150)
	_gece_dugmesi.pressed.connect(_geceye_gec)


func _yapi_satirini_ciz() -> void:
	for c in _yapi_satiri.get_children():
		_yapi_satiri.remove_child(c)
		c.queue_free()
	for c in _kategori_satiri.get_children():
		if c is Button and c.toggle_mode:
			c.set_pressed_no_signal(c.text == tr("koy.kategori." + _kategori))
	if _kategori == "savunma":
		_savunma_satiri()
		return
	for tur in _y.katalog.kategoridekiler(_kategori):
		var b := YapiKarti.new()
		_yapi_satiri.add_child(b)
		b.kur(tur, _y, ayarlar)
		b.pressed.connect(func() -> void: _kip_sec("insa", tur))


## Savunma: sur taksiti (5.5) ve muhafızlar (12.3).
func _savunma_satiri() -> void:
	for tur in _y.katalog.kategoridekiler("savunma"):
		var kart := YapiKarti.new()
		_yapi_satiri.add_child(kart)
		kart.kur(tur, _y, ayarlar)
		kart.pressed.connect(func() -> void: _kip_sec("insa", tur))
	var t := _y.sur_taksiti()
	var b := _dugme(tr("koy.sur.taksit") % [_y.sur_seviye + 1, _y.sur_taksit_odenen, _y.a.sur_taksit, t] if t > 0 else tr("koy.sur.azami"), _yapi_satiri)
	b.custom_minimum_size = Vector2(340, 82)
	b.disabled = t < 0 or not _y.kilitli_harcanabilir(t) or not _y.kaynaklar.yeterli(HarcZinciri.sur_malzeme(_y))
	b.tooltip_text = tr("koy.sur.rezerv") % _y.a.rezerv
	var malzeme_metni := HarcZinciri.sur_aciklama(_y)
	if not malzeme_metni.is_empty():
		b.text += "\n" + malzeme_metni
		b.tooltip_text += "\n" + malzeme_metni
	b.pressed.connect(func() -> void:
		if _y.sur_taksit_ode():
			Ses.cal(&"sfx_insaat")
			_yenile()
	)
	var m := Label.new()
	m.text = tr("koy.muhafiz.durum") % [_y.muhafiz_sayisi(), _y.a.muhafiz_azami, _y.a.muhafiz_maas * 7]
	m.tooltip_text = MuhafizMaasi.metin(_y)
	m.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	_yapi_satiri.add_child(m)


func _kip_sec(k: String, tur: String = "") -> void:
	KoyluTakibi.kip(sahne3b, k)
	kip = k
	_insa_turu = tur
	_yon = 0
	_secili_bina = -1
	sahne3b.secim_goster(null)
	_bilgi.visible = false
	_ipucu.text = tr("koy.ipucu." + k) if k != "" else ""
	_hayalet_guncelle()


# ── Dünya girdisi: yerleşim, yol, yıkım, seçim ────────────────────────────────────────────────────

func _dunya_girdisi(olay: InputEvent) -> void:
	if olay is InputEventMouseMotion:
		_imlec = sahne3b.isaret(_vp_konum(olay.position))
		_hayalet_guncelle()
	elif olay is InputEventMouseButton and olay.pressed:
		match olay.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				sahne3b.yakinlas(1.0)
			MOUSE_BUTTON_WHEEL_DOWN:
				sahne3b.yakinlas(-1.0)
			MOUSE_BUTTON_RIGHT:
				KoyluTakibi.temizle(sahne3b)
				_kip_sec("")
			MOUSE_BUTTON_LEFT:
				if kip.is_empty():
					var kisi := KoyluSecimi.sec(sahne3b, _vp_konum(olay.position))
					if kisi >= 0:
						KoyluKarti.ac(self, kisi)
						return
				_imlec = sahne3b.isaret(_vp_konum(olay.position))
				_tikla()


func _vp_konum(yerel: Vector2) -> Vector2:
	return yerel * Vector2(_vp.size) / _kap.size


func _hayalet_guncelle() -> void:
	match kip:
		"insa":
			var d := _y.yerlesim(_insa_turu, _imlec, _yon)
			var b := _y.katalog.boyut(_insa_turu)
			sahne3b.hayalet(_imlec, Vector2i(b.y, b.x) if _yon == 1 else b, d["olur"])
			_ipucu.text = tr("koy.ipucu.insa") + ("" if d["olur"] or _imlec.x < 0 else "  —  " + tr("koy.neden." + String(d["neden"])))
		"yol":
			sahne3b.hayalet(_imlec, Vector2i.ONE, _imlec.x >= 0 and _y.izgara.bos(_imlec))
		"yik":
			var b := _bina_altinda(_imlec)
			sahne3b.secim_goster(b)
			sahne3b.hayalet(_imlec, Vector2i.ZERO, false)
		_:
			sahne3b.hayalet(_imlec, Vector2i.ZERO, false)


func _bina_altinda(h: Vector2i) -> KoyBinasi:
	if not _y.izgara.dolu.has(h):
		return null
	return _y.bina(int(_y.izgara.dolu[h]))


func _tikla() -> void:
	if _imlec.x < 0:
		return
	match kip:
		"insa":
			var d := _y.bina_kur(_insa_turu, _imlec, _yon)
			if d["olur"]:
				Ses.cal(&"sfx_insaat")
				_yenile()
				if not _y.kaynaklar.yeterli(_malzeme(_y.katalog.maliyet(_insa_turu))):
					_kip_sec("")
			else:
				Ses.cal(&"sfx_bar_catlak", -8.0)
		"yol":
			if _y.yol_kur(_imlec):
				Ses.cal(&"sfx_adim", -10.0)
				_yenile()
		"yik":
			var b := _bina_altinda(_imlec)
			if b != null and _y.bina_yik(b.id):
				Ses.cal(&"sfx_insaat", -4.0)
				_yenile()
		_:
			var b := _bina_altinda(_imlec)
			_secili_bina = b.id if b != null else -1
			sahne3b.secim_goster(b)
			_bilgi_goster()


func _unhandled_input(olay: InputEvent) -> void:
	if olay is InputEventKey and olay.pressed and not olay.echo:
		match olay.physical_keycode:
			KEY_R:
				_yon = 1 - _yon
				_hayalet_guncelle()
			KEY_B:
				_kategori = "barinma"
				_yapi_satirini_ciz()
			KEY_P:
				_nufus_ac()
			KEY_1:
				_hiz_sec(1)
			KEY_2:
				_hiz_sec(2)
			KEY_3:
				_hiz_sec(3)
			KEY_SPACE:
				_hiz_sec(_son_hiz if get_tree().paused else 0)
			KEY_ESCAPE:
				if _ust_kart != null:
					return
				_kip_sec("")


## 1/2/3 hız seçer; boşluk durdurur veya son hızda sürdürür. Arayüz duraklamada çalışır.
func _hiz_sec(kat: int) -> void:
	if _gece_kilidi.kilitli():
		kat = 1
	kat = clampi(kat, 0, 3)
	get_tree().paused = kat == 0
	Engine.time_scale = float(kat) if kat > 0 else 1.0
	if kat > 0:
		_son_hiz = kat
	for hiz in _hiz_dugmeleri:
		(_hiz_dugmeleri[hiz] as Button).set_pressed_no_signal(hiz == kat)


func _exit_tree() -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	Engine.max_physics_steps_per_frame = _onceki_fizik_adimi


# ── Yapı bilgi penceresi (10.1, 17.3) ─────────────────────────────────────────────────────────────

func _bilgi_kur() -> void:
	_bilgi = PanelContainer.new()
	_bilgi.set_anchors_and_offsets_preset(Control.PRESET_RIGHT_WIDE)
	_bilgi.offset_left = -520
	_bilgi.offset_top = 150
	_bilgi.offset_bottom = -ayarlar.boyut(260) - 20
	_bilgi.visible = false
	add_child(_bilgi)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 20)
	_bilgi.add_child(kenar)
	var kaydir := ScrollContainer.new()
	kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	kenar.add_child(kaydir)
	_bilgi_icerik = VBoxContainer.new()
	_bilgi_icerik.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_bilgi_icerik.add_theme_constant_override("separation", 8)
	kaydir.add_child(_bilgi_icerik)


func _bilgi_goster() -> void:
	for c in _bilgi_icerik.get_children():
		c.queue_free()
	var b := _y.bina(_secili_bina)
	_bilgi.visible = b != null
	if b == null:
		return
	_etiket(_bilgi_icerik, MeslekYapilari.ad(b.tur), Tema.BASLIK_PX)
	_etiket(_bilgi_icerik, "Seviye %d · Üretim ×%.2f" % [b.seviye, b.uretim_carpani()], Tema.KUCUK_PX)
	if not b.hazir():
		_etiket(_bilgi_icerik, tr("koy.bilgi.iskele") % b.insa_kalan, Tema.KUCUK_PX)
	elif KanDavasi.engel(_y, b.id):
		_etiket(_bilgi_icerik, KanDavasi.DURUS_METNI, Tema.KUCUK_PX).add_theme_color_override("font_color", Hud.UYARI)
	elif b.bekliyor != "" and b.bekliyor != "kan_davasi":
		_etiket(_bilgi_icerik, "Taşıma seferi bekleniyor" if b.bekliyor == "tasima" else tr("koy.bekliyor." + b.bekliyor), Tema.KUCUK_PX).add_theme_color_override("font_color", Hud.UYARI)
	CatiKarBilgisi.ekle(_y, b, _bilgi_icerik)
	SamanBilgisi.ekle(_y, b, _bilgi_icerik)
	KundakClueBilgisi.ekle(_y, b, _bilgi_icerik)
	var yatak := b.yatak(_y.katalog)
	if yatak > 0:
		var oturan := 0
		for k in _y.koylular:
			if k.ev == b.id:
				oturan += 1
		_etiket(_bilgi_icerik, tr("koy.bilgi.yatak") % [oturan, yatak], Tema.KUCUK_PX)
	var r := _y.katalog.receteler(b.tur)
	if b.tur == "muhafiz_kislasi": _etiket(_bilgi_icerik, MuhafizMaasi.metin(_y), Tema.KUCUK_PX)
	if b.tur == "demir_ocagi": _etiket(_bilgi_icerik, DemirZinciri.ad("koy.recete.demir"), Tema.KUCUK_PX)
	if DemirZinciri.carpan(_y, b.tur) < 1.0: _etiket(_bilgi_icerik, "Alet yok · üretim −%70", Tema.KUCUK_PX)
	if b.tur == "firin": _etiket(_bilgi_icerik, DemirZinciri.ad("koy.recete.ekmek"), Tema.KUCUK_PX)
	if r.size() > 1:
		var satir := HBoxContainer.new()
		_bilgi_icerik.add_child(satir)
		for ad in r:
			var d := _dugme(DemirZinciri.ad("koy.recete." + String(ad)), satir)
			d.toggle_mode = true
			d.set_pressed_no_signal(b.recete == ad)
			d.pressed.connect(func() -> void:
				_y.recete_sec(b.id, ad)
				_bilgi_goster()
			)
	var slot := _y.katalog.slot(b.tur)
	if slot > 0:
		var cal := _y.calisanlar(b.id)
		_etiket(_bilgi_icerik, tr("koy.bilgi.calisan") % [cal.size(), slot], Tema.KUCUK_PX)
		for k in cal:
			_koylu_satiri(k, b)
		if b.hazir() and cal.size() < slot:
			_etiket(_bilgi_icerik, tr("koy.bilgi.ata"), Tema.KUCUK_PX)
			for k in _y.bostakiler():
				var d := _dugme("%s  ·  %s %d" % [k.ad, tr("koy.bilgi.stat"), k.stat], _bilgi_icerik)
				d.pressed.connect(func() -> void:
					if _y.ata(k.id, b.id):
						Ses.cal(&"sfx_onay", -6.0)
						_yenile()
				)
	var yik := _dugme(tr("koy.arac.yik"), _bilgi_icerik)
	yik.pressed.connect(func() -> void:
		if _y.bina_yik(b.id):
			_secili_bina = -1
			_yenile()
	)


## Çalışan satırı: ad, stat, açık bayraklar, moral, sağlık; konuş, çıkar, sürgün (10.2–10.5).
func _koylu_satiri(k: Koylu, b: KoyBinasi) -> void:
	var v := VBoxContainer.new()
	_bilgi_icerik.add_child(v)
	var bayrak: PackedStringArray = []
	for f in k.bayraklar:
		bayrak.append(tr("koy.bayrak." + f))
	_etiket(v, "%s  ·  %s %d  ·  %s %d  ·  %s %d" % [k.ad, tr("koy.bilgi.stat"), k.stat, tr("koy.bilgi.moral"), k.moral,
		tr("koy.bilgi.saglik"), k.saglik], Tema.KUCUK_PX)
	if not bayrak.is_empty():
		_etiket(v, ", ".join(bayrak), Tema.KUCUK_PX).add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	var satir := HBoxContainer.new()
	v.add_child(satir)
	var kart := _dugme("Köylü kartı", satir)
	kart.pressed.connect(func() -> void: KoyluKarti.ac(self, k.id))
	var cikar := _dugme(tr("koy.bilgi.cikar"), satir)
	cikar.pressed.connect(func() -> void:
		_y.bosalt(k.id)
		_yenile()
	)
	var surgun := _dugme(tr("koy.bilgi.surgun"), satir)
	surgun.pressed.connect(func() -> void:
		if _y.surgun(k.id):
			oturum._koy_esitle()
			_yenile()
	)


# ── Nüfus tablosu (17.4) ──────────────────────────────────────────────────────────────────────────

var _siralama := "moral"


func _nufus_ac() -> void:
	var v := _kart_ac(tr("koy.nufus.baslik") % [_y.nufus(), _y.yatak_kapasitesi()])
	var basliklar := HBoxContainer.new()
	v.add_child(basliklar)
	for s in ["ad", "is", "moral", "saglik", "stat"]:
		var d := _dugme(tr("koy.nufus." + s), basliklar)
		d.custom_minimum_size.x = 150
		d.pressed.connect(func() -> void:
			_siralama = s
			_kart_kapat()
			_nufus_ac()
		)
	var liste := _y.koylular.duplicate()
	liste.sort_custom(func(a: Koylu, b: Koylu) -> bool:
		match _siralama:
			"ad":
				return a.ad < b.ad
			"is":
				return a.is_yeri < b.is_yeri
			"saglik":
				return a.saglik < b.saglik
			"stat":
				return a.stat > b.stat
		return a.moral < b.moral
	)
	var kaydir := ScrollContainer.new()
	kaydir.custom_minimum_size = Vector2(1100, 520)
	v.add_child(kaydir)
	var ic := VBoxContainer.new()
	kaydir.add_child(ic)
	for k: Koylu in liste:
		var bayrak: PackedStringArray = []
		for f in k.bayraklar:
			bayrak.append(tr("koy.bayrak." + f))
		var kisi_karti := _dugme(k.ad + " · Köylü kartı", ic)
		kisi_karti.pressed.connect(func() -> void: KoyluKarti.ac(self, k.id))
		_etiket(ic, "%-22s %-18s %s %3d   %s %3d   %s %d   %s" % [k.ad, _is_adi(k), tr("koy.bilgi.moral"), k.moral,
			tr("koy.bilgi.saglik"), k.saglik, tr("koy.bilgi.stat"), k.stat, ", ".join(bayrak)], Tema.KUCUK_PX)
	var kapat := _dugme(tr("arayuz.olay.devam"), v)
	kapat.pressed.connect(_kart_kapat)
	kapat.grab_focus.call_deferred()


func _is_adi(k: Koylu) -> String:
	if DivanHukmu.zindanda(k): return "Zindanda"
	if k.is_yeri == KoyYonetimi.MUHAFIZ:
		return tr("koy.is.muhafiz")
	var b := _y.bina(k.is_yeri)
	return MeslekYapilari.ad(b.tur) if b != null else tr("koy.is.bosta")


# ── Pazar: tezgâh ve kervan (5.1, 5.2) ────────────────────────────────────────────────────────────

func _pazar_ac() -> void:
	var v := _kart_ac(tr("koy.pazar.baslik"))
	v = PazarKartKaydirma.kur(self, v)
	GezginTuccarPazarAdaptoru.pazar(self, v)
	SuRezervPaneli.ekle(self, v)
	TicaretFiyatPaneli.ekle(self, v)
	PazarSatisPaneli.hedef(self, v)
	_etiket(v, tr("koy.pazar.tezgah") % [int(_y.a.tezgah_orani * 100), _y.a.tezgah_gunluk_azami], Tema.KUCUK_PX)
	for t in ["odun", "tas", "gida", "kereste", "kurk"]:
		var satir := HBoxContainer.new()
		v.add_child(satir)
		_etiket(satir, "%s: %d" % [tr("koy.kaynak." + t), _y.kaynaklar.miktar(t)], Tema.KUCUK_PX).custom_minimum_size.x = 260
		for adet in [5, 20]:
			var d := _dugme(tr("koy.pazar.sat") % adet, satir)
			d.name = "pazar_tezgah_%s_%d" % [t, adet]
			d.disabled = not PazarSatisi.uygun(oturum, t, adet, false, PazarSatisPaneli.kisisel(self))
			d.pressed.connect(func() -> void:
				var r := PazarSatisi.uygula(oturum, t, adet, false, PazarSatisPaneli.kisisel(self))
				if r["akce"] > 0:
					Ses.cal(&"sfx_kese")
				_kart_kapat()
				_pazar_ac()
				hud.guncelle()
			)
		if _y.kervan_gunu():
			var k := _dugme(tr("koy.pazar.kervana") % 20, satir)
			k.name = "pazar_kervan_" + t
			k.disabled = not PazarSatisi.uygun(oturum, t, 20, true, PazarSatisPaneli.kisisel(self))
			k.pressed.connect(func() -> void:
				if PazarSatisi.uygula(oturum, t, 20, true, PazarSatisPaneli.kisisel(self))["akce"] > 0:
					Ses.cal(&"sfx_kese")
				_kart_kapat()
				_pazar_ac()
				hud.guncelle()
			)
	if _y.kervan_gunu():
		_etiket(v, tr("koy.pazar.kervan_var"), Tema.KUCUK_PX).add_theme_color_override("font_color", Hud.UYARI)
		var satir := HBoxContainer.new()
		v.add_child(satir)
		for t in _y.a.kervan_satis:
			var d := _dugme(tr("koy.pazar.al") % [10, tr("koy.kaynak." + String(t)), TicaretFiyatlari.bedel(_y, String(t), 10)], satir)
			d.name = "kervan_al_" + String(t)
			d.pressed.connect(func() -> void:
				if _y.kervandan_al(String(t), 10):
					Ses.cal(&"sfx_kese")
				_kart_kapat()
				_pazar_ac()
				hud.guncelle()
			)
	else:
		_etiket(v, tr("koy.pazar.kervan_yok") % (_y.a.kervan_araligi - 1 - _y.gun % _y.a.kervan_araligi), Tema.KUCUK_PX)
	SamanBilgisi.pazar(self, v)
	GezginStokPaneli.ekle(self, v)
	KumasAktarPaneli.ekle(self, v)
	CekiHayvaniPaneli.ekle(self, v)
	VergiPaneli.ekle(self, v)
	KasaTransferPaneli.ekle(self, v)
	var kapat := PazarKartKaydirma.dugme(self, v, tr("arayuz.olay.devam"))
	kapat.pressed.connect(_kart_kapat)
	kapat.grab_focus.call_deferred()


# ── İsyan ve haraç bantları (11.4, 15.3–15.4) ─────────────────────────────────────────────────────

func _bant_ciz() -> void:
	for c in _bant.get_children():
		c.queue_free()
	_bant.visible = _y.isyan_kalan >= 0 or _y.harac_bekliyor
	if not _bant.visible:
		return
	var v := VBoxContainer.new()
	_bant.add_child(v)
	var satir := HBoxContainer.new()
	if _y.isyan_kalan >= 0:
		_etiket(v, tr("koy.isyan.bant") % _y.isyan_kalan, Tema.KUCUK_PX).add_theme_color_override("font_color", Hud.UYARI)
		v.add_child(satir)
		var as_ := _dugme(tr("koy.isyan.as") % (_y.nufus() * _y.a.as_dagit_gida), satir)
		as_.pressed.connect(func() -> void:
			if _y.as_dagit():
				_yenile()
		)
		var vergi := _dugme(tr("koy.isyan.vergi"), satir)
		vergi.disabled = _y.vergi_muaf
		vergi.pressed.connect(func() -> void:
			_y.vergi_sifirla()
			_yenile()
		)
		var surgun := _dugme(tr("koy.isyan.surgun"), satir)
		surgun.pressed.connect(func() -> void:
			if _y.elebasi_surgun():
				oturum._koy_esitle()
				_yenile()
		)
	if _y.harac_bekliyor:
		_etiket(v, tr("koy.harac.bant") % [_y.a.harac_akce, _y.a.harac_gida], Tema.KUCUK_PX).add_theme_color_override("font_color", Hud.UYARI)
		var h := HBoxContainer.new()
		v.add_child(h)
		var ode := _dugme(tr("koy.harac.ode"), h)
		ode.pressed.connect(func() -> void:
			if _y.harac_ode():
				Ses.cal(&"sfx_kese")
				_yenile()
		)
		var red := _dugme(tr("koy.harac.reddet"), h)
		red.pressed.connect(func() -> void:
			_y.harac_reddet()
			Ses.cal(&"sfx_saldiri", -6.0)
			_yenile()
		)


# ── Gece (Faz 3) ve rapor kartı (14.3–14.4) ───────────────────────────────────────────────────────

func _geceye_gec() -> void:
	if not _gece_kilidi.al():
		return
	_gece_dugmesi.disabled = true
	_kip_sec("")
	_hiz_sec(1)
	Ses.cal(&"sfx_gece_bitti")
	var once := _y.kaynaklar.stok.duplicate()
	var sonuc := oturum.gece_sonu()
	_yenile()
	# Gece hesaplaşması karanlıkta: rapor kartı ay ışığına dönen köyün üstünde açılır.
	sahne3b.faz(&"gece", 1.8)
	_dinamik_ortam.faz(&"gece")
	var r: Dictionary = sonuc["rapor"]
	var v := _kart_ac(tr("koy.rapor.baslik") % (int(r["gun"]) + 1))
	var uretim: Dictionary = r["uretim"]
	var parca: PackedStringArray = []
	for t in uretim:
		if int(uretim[t]) > 0:
			parca.append("+%d %s" % [int(uretim[t]), tr("koy.kaynak." + String(t))])
	_etiket(v, tr("koy.rapor.uretim") % (", ".join(parca) if not parca.is_empty() else "—"), Tema.KUCUK_PX)
	var tuk: Dictionary = r["tuketim"]
	_etiket(v, tr("koy.rapor.tuketim") % [int(tuk.get("gida", 0)), int(tuk.get("odun", 0))], Tema.KUCUK_PX)
	_etiket(v, tr("koy.rapor.akce") % [int(r["akce_once"]), int(r["akce"])], Tema.KUCUK_PX)
	_etiket(v, tr("koy.rapor.huzur") % int(r["huzur"]), Tema.KUCUK_PX)
	for o in r["olaylar"]:
		var l := _etiket(v, IflasYoneticisi.olay_metin(o), Tema.KUCUK_PX)
		l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = 900
	var tamam := _dugme(tr("koy.rapor.sabah"), v)
	tamam.grab_focus.call_deferred()
	tamam.pressed.connect(func() -> void:
		_kart_kapat()
		if sonuc["son"] != &"":
			oturum_bitti.emit(sonuc["son"])
			return
		var olay: OlayVerisi = sonuc["olay"]
		if olay != null:
			_olay_goster(olay, sonuc)
		else:
			devam_istendi.emit(sonuc)
	)
	if once.get("gida", 0) > 0 and _y.kaynaklar.miktar("gida") == 0:
		Ses.cal(&"sfx_bar_catlak")


func _olay_goster(olay: OlayVerisi, sonuc: Dictionary) -> void:
	Ses.cal(&"sfx_olay")
	if olay.ses != &"":
		Ses.cal(olay.ses, -3.0)
	if olay.muzik != &"":
		Ses.muzik_cal(olay.muzik)
	var v := _kart_ac(tr(olay.baslik_anahtari))
	var m := _etiket(v, tr(olay.metin_anahtari), Tema.GOVDE_PX)
	m.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	m.custom_minimum_size.x = 900
	var ilk: Button = null
	for i in olay.secenek_anahtarlari.size():
		var d := _dugme("— " + tr(olay.secenek_anahtarlari[i]), v)
		d.alignment = HORIZONTAL_ALIGNMENT_LEFT
		d.disabled = not oturum.secenek_olur(olay, i)
		d.pressed.connect(_olay_sec.bind(olay, i, sonuc))
		if ilk == null and not d.disabled:
			ilk = d
	if ilk != null:
		ilk.grab_focus.call_deferred()


func _olay_sec(olay: OlayVerisi, i: int, gece: Dictionary) -> void:
	Ses.cal(&"sfx_onay")
	var e: Dictionary = olay.secenek_etkileri[i]
	var puan := -1
	var azami := 0
	if e.has("oyun"):
		mini_oyun = MiniOyun.olustur(StringName(e["oyun"]), ayarlar, oturum.ayarlar)
	if mini_oyun != null:
		_ust_kart.visible = false
		# Pano köyü örter; 3D çizimi durur.
		_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
		add_child(mini_oyun)
		var r: Array = await mini_oyun.bitti
		_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		puan = r[0]
		azami = r[1]
		mini_oyun.queue_free()
		mini_oyun = null
		_ust_kart.visible = true
	var sonuc := oturum.olay_uygula(olay, i, puan)
	_kart_kapat()
	var v := _kart_ac(tr(olay.baslik_anahtari))
	if puan >= 0:
		_etiket(v, tr("arayuz.oyun.puan") % [puan, azami], Tema.KUCUK_PX).add_theme_color_override("font_color", MenuSatiri.ALTIN)
	var l := _etiket(v, tr(sonuc["sonuc_anahtari"]), Tema.KUCUK_PX)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 900
	l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	var tamam := _dugme(tr("arayuz.olay.devam"), v)
	tamam.grab_focus.call_deferred()
	tamam.pressed.connect(func() -> void:
		Ses.muzik_cal(&"")
		_kart_kapat()
		devam_istendi.emit(gece)
	)


# ── Yardımcılar ───────────────────────────────────────────────────────────────────────────────────

func _yenile() -> void:
	sahne3b.yenile()
	hud.guncelle()
	_yapi_satirini_ciz()
	_bant_ciz()
	if _secili_bina >= 0:
		sahne3b.secim_goster(_y.bina(_secili_bina))
		_bilgi_goster()


func _kart_ac(baslik: String) -> VBoxContainer:
	_kart_kapat()
	_ust_kart = PanelContainer.new()
	_ust_kart.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	add_child(_ust_kart)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 30)
	_ust_kart.add_child(kenar)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	kenar.add_child(v)
	_etiket(v, baslik, Tema.BASLIK_PX)
	_ust_kart.resized.connect(func() -> void:
		if is_instance_valid(_ust_kart):
			_ust_kart.position = (size - _ust_kart.size) / 2.0
	)
	return v


func _kart_kapat() -> void:
	if _ust_kart != null and is_instance_valid(_ust_kart):
		_ust_kart.queue_free()
	_ust_kart = null


func _etiket(ust: Control, metin: String, punto: int) -> Label:
	var l := Label.new()
	l.text = metin
	l.add_theme_font_size_override("font_size", ayarlar.boyut(punto))
	ust.add_child(l)
	return l


func _dugme(metin: String, ust: Control) -> Button:
	var b := Button.new()
	b.text = metin
	b.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	b.focus_mode = Control.FOCUS_ALL
	ust.add_child(b)
	return b


func _malzeme(m: Dictionary) -> Dictionary:
	var s := m.duplicate()
	s.erase("akce")
	return s
