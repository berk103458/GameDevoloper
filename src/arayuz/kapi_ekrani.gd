## Kapı ekranı: gelen kişi kadraja yürür, sohbet edilir, karar iki adımda verilir
## (sanat kitabı 7.2; Girdi GDD kural 15–17; Karakter kadrosu GDD).
class_name KapiEkrani
extends Control

## Gece sonu çözümü bitti; rapor `Oturum.gece_sonu()` sözlüğüdür.
signal gece_bitti(rapor: Dictionary)
## Gece içinde bar kırıldı (rüşvet hakkı kalmadı).
signal oturum_bitti(kirilan: int)
signal duraklat_istendi

const DUNYA_GENISLIK := 1140.0
const PORTRE_BOYUT := Vector2(600, 760)
const PORTRE_X := 230.0
const KARAR_SIMGE := {"kabul": "accept", "ret": "reject", "rusvet": "bribe", "kisla": "barracks"}

var oturum: Oturum
var ayarlar: Ayarlar
var evre: StringName = &""  # sohbet, karar, sonuc, gecis

var _kuyruk: Array[Gelen] = []
var _gelen: Gelen
var _sorulan: Array[int] = []
var _secili: String = ""
var _karar_dugmeleri: Array[Button] = []
var _karar_anahtarlari: PackedStringArray = []
var _belirme_id := 0
var _beliriyor := false
var _gosterilecek: Array[Button] = []

var hud: Hud
var _dunya: Control
var _portre: TextureRect
var _serit_sol: ColorRect
var _serit_sag: ColorRect
var _ad: Label
var _sinif: Label
var _kayit: RichTextLabel
var _secenekler: VBoxContainer


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)

	_dunya = Control.new()
	_dunya.position = Vector2(0, 92)
	_dunya.size = Vector2(DUNYA_GENISLIK, 988)
	_dunya.clip_contents = true
	add_child(_dunya)
	var arka := Sanat.doku("env", "env_gate_scene_bg")
	if arka != null:
		var r := TextureRect.new()
		r.texture = arka
		r.size = _dunya.size
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		_dunya.add_child(r)
	else:
		_yer_tutucu_kapi()
	_portre = TextureRect.new()
	_portre.size = PORTRE_BOYUT
	_portre.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portre.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portre.position = Vector2(DUNYA_GENISLIK + 50, _dunya.size.y - PORTRE_BOYUT.y)
	_dunya.add_child(_portre)
	_serit_sol = ColorRect.new()
	_serit_sol.color = Renkler.GECE
	_serit_sol.size = Vector2(0, _dunya.size.y)
	_dunya.add_child(_serit_sol)
	_serit_sag = ColorRect.new()
	_serit_sag.color = Renkler.GECE
	_serit_sag.size = Vector2(0, _dunya.size.y)
	_serit_sag.position = Vector2(DUNYA_GENISLIK, 0)
	_dunya.add_child(_serit_sag)

	var panel := PanelContainer.new()
	panel.position = Vector2(DUNYA_GENISLIK, 92)
	panel.size = Vector2(1920 - DUNYA_GENISLIK, 988)
	add_child(panel)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 28)
	panel.add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 12)
	kenar.add_child(dikey)
	_ad = Label.new()
	_ad.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX))
	dikey.add_child(_ad)
	_sinif = Label.new()
	_sinif.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	dikey.add_child(_sinif)
	_kayit = RichTextLabel.new()
	_kayit.bbcode_enabled = true
	_kayit.scroll_following = true
	_kayit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_kayit.focus_mode = Control.FOCUS_NONE
	dikey.add_child(_kayit)
	_secenekler = VBoxContainer.new()
	_secenekler.add_theme_constant_override("separation", 12)
	dikey.add_child(_secenekler)
	var ipucu := Label.new()
	ipucu.text = tr("arayuz.sohbet.ipucu")
	ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ipucu.add_theme_font_size_override("font_size", ayarlar.boyut(18))
	ipucu.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	dikey.add_child(ipucu)

	hud = Hud.new()
	add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hud.bagla(oturum)


## Yeni geceyi başlatır: kuyruk kurulur, ilk gelen kapıya yürür.
func gece_baslat() -> void:
	evre = &"gecis"
	_temizle()
	_kuyruk = oturum.gece_kuyrugu()
	_kayit.clear()
	_yaz("[color=#B8C2CC][b]%s[/b][/color]" % (tr("anlati.gece.basladi") % oturum.gosterilen_gece()))
	hud.guncelle()
	await Adim.kesme(self, 0.3)
	_siradaki()


func _siradaki() -> void:
	if _kuyruk.is_empty():
		_ad.text = ""
		_sinif.text = ""
		evre = &"gecis"
		var rapor := oturum.gece_sonu()
		hud.guncelle()
		if rapor["son"] == &"kirildi":
			oturum_bitti.emit(rapor["kirilan"])
		else:
			gece_bitti.emit(rapor)
		return
	_gelen = _kuyruk.pop_front()
	_sorulan = []
	_ad.text = tr(_gelen.ad_anahtari)
	_sinif.text = tr("arayuz.sinif.gibi") % tr("arayuz.sinif." + String(_gelen.sinif))
	_portre.texture = Sanat.portre(_gelen.portre)
	_portre.position = Vector2(DUNYA_GENISLIK + 50, _dunya.size.y - PORTRE_BOYUT.y)
	_yaz("\n[i]%s[/i]" % tr(_gelen.giris_anahtari))
	oturum.ziyaret_basladi(_gelen)
	_adim_sesi(6)
	await Adim.yuru(_portre, Vector2(PORTRE_X, _portre.position.y), 6, 10.0)
	if oturum.perde == 2 or _gelen.sorular.is_empty():
		_karar_goster()
	else:
		_sohbet_goster()


func _sohbet_goster() -> void:
	evre = &"sohbet"
	_temizle()
	var dugmeler: Array[Button] = []
	for i in _gelen.sorular.size():
		if i in _sorulan:
			continue
		var b := _dugme("— " + tr(_gelen.sorular[i][0]))
		b.pressed.connect(_soru_sor.bind(i))
		dugmeler.append(b)
	var k := _dugme(tr("arayuz.sohbet.karar_ver"))
	k.pressed.connect(_karar_goster)
	dugmeler.append(k)
	_sirayla_goster(dugmeler)


func _soru_sor(i: int) -> void:
	if evre != &"sohbet":
		return
	_sorulan.append(i)
	_yaz("[color=#4A6B8A]%s:[/color] %s\n[b]%s:[/b] %s" % [tr("arayuz.sohbet.sen"), tr(_gelen.sorular[i][0]),
		tr(_gelen.ad_anahtari), tr(_gelen.sorular[i][1])])
	if _sorulan.size() >= oturum.ayarlar.azami_soru or _sorulan.size() >= _gelen.sorular.size():
		_karar_goster()
	else:
		_sohbet_goster()


func _karar_goster() -> void:
	evre = &"karar"
	_secili = ""
	_temizle()
	_daralt(true)
	_karar_dugmeleri = []
	_karar_anahtarlari = _gelen.secenekler
	for n in _karar_anahtarlari.size():
		var anahtar := _karar_anahtarlari[n]
		var b := _dugme("%d · %s" % [n + 1, tr("arayuz.karar." + anahtar)])
		b.icon = Sanat.doku("ui", "icon_decision_%s_48" % KARAR_SIMGE[anahtar])
		b.custom_minimum_size.y = 72
		b.pressed.connect(_karar_bas.bind(anahtar))
		_karar_dugmeleri.append(b)
	_sirayla_goster(_karar_dugmeleri)


## İki adımlı onay: ilk basış seçer, aynı karara ikinci basış verir.
func _karar_bas(anahtar: String) -> void:
	if evre != &"karar":
		return
	if _secili == anahtar:
		_karar_ver(anahtar)
		return
	_secili = anahtar
	for i in _karar_dugmeleri.size():
		var b := _karar_dugmeleri[i]
		var ad := tr("arayuz.karar." + _karar_anahtarlari[i])
		b.toggle_mode = true
		b.set_pressed_no_signal(_karar_anahtarlari[i] == _secili)
		b.text = (tr("arayuz.karar.onayla") % ad) if _karar_anahtarlari[i] == _secili else "%d · %s" % [i + 1, ad]
		if _karar_anahtarlari[i] == _secili:
			b.grab_focus()


func _karar_birak() -> void:
	if evre != &"karar" or _secili == "":
		return
	_secili = ""
	for i in _karar_dugmeleri.size():
		_karar_dugmeleri[i].set_pressed_no_signal(false)
		_karar_dugmeleri[i].text = "%d · %s" % [i + 1, tr("arayuz.karar." + _karar_anahtarlari[i])]


func _karar_ver(anahtar: String) -> void:
	evre = &"sonuc"
	_temizle()
	Ses.cal(&"sfx_onay")
	var sonuc := oturum.karar_ver(_gelen, StringName(anahtar))
	if anahtar == "rusvet":
		Ses.cal(&"sfx_kese")
	Ses.cal(&"sfx_kapi_acilir" if sonuc["kaldi"] else &"sfx_kapi_kapanir", -4.0)
	_yaz(tr("anlati.sonuc." + anahtar) % tr(_gelen.ad_anahtari))
	if sonuc["rusvet_harcandi"] >= 0:
		Ses.cal(&"sfx_bar_catlak")
		_yaz("[i]%s[/i]" % (tr("anlati.rusvet.harcandi") % tr(oturum.ayarlar.bar_anahtarlari[sonuc["rusvet_harcandi"]])))
	hud.guncelle()
	_daralt(false)
	var hedef_x := -PORTRE_BOYUT.x - 40 if sonuc["kaldi"] else DUNYA_GENISLIK + 50
	_adim_sesi(8)
	await Adim.yuru(_portre, Vector2(hedef_x, _portre.position.y), 8, 10.0)
	if sonuc["kirilan"] >= 0:
		oturum_bitti.emit(sonuc["kirilan"])
		return
	_siradaki()


func _adim_sesi(adet: int) -> void:
	for i in adet / 2:
		Ses.cal(&"sfx_adim", -6.0)
		await get_tree().create_timer(Adim.KARE_SN * 4.0).timeout


func _daralt(icerden: bool) -> void:
	for i in range(1, 4):
		var g := 40.0 * (i if icerden else 3 - i)
		_serit_sol.size.x = g
		_serit_sag.position.x = DUNYA_GENISLIK - g
		_serit_sag.size.x = g
		await get_tree().create_timer(Adim.KARE_SN).timeout


func _dugme(yazi: String) -> Button:
	var b := Button.new()
	b.text = yazi
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.custom_minimum_size = Vector2(0, 64)
	b.focus_mode = Control.FOCUS_ALL
	b.focus_entered.connect(func() -> void: Ses.cal(&"sfx_secim", -8.0))
	b.mouse_entered.connect(func() -> void:
		if b.visible:
			b.grab_focus()
	)
	_secenekler.add_child(b)
	return b


func _temizle() -> void:
	_belirme_id += 1
	_beliriyor = false
	for c in _secenekler.get_children():
		c.queue_free()


## Seçenekler tek tek belirir (sanat kitabı 7.7); belirme süresi ayardan.
func _sirayla_goster(dugmeler: Array[Button]) -> void:
	var benim := _belirme_id
	_gosterilecek = dugmeler
	for b in dugmeler:
		b.visible = false
	var bekle := ayarlar.belirme_ms(oturum.ayarlar.belirme_ms) / 1000.0
	_beliriyor = true
	for i in dugmeler.size():
		if benim != _belirme_id or not is_instance_valid(dugmeler[i]):
			return
		dugmeler[i].visible = true
		if i == 0:
			dugmeler[i].grab_focus()
		if bekle > 0.0 and i < dugmeler.size() - 1:
			await get_tree().create_timer(bekle).timeout
	if benim == _belirme_id:
		_beliriyor = false


func _tumunu_goster() -> void:
	_belirme_id += 1
	_beliriyor = false
	for b in _gosterilecek:
		if is_instance_valid(b):
			b.visible = true


func _yaz(s: String) -> void:
	_kayit.append_text(s + "\n")


func _input(olay: InputEvent) -> void:
	# Belirme sürerken bir basış atlamadır: kalanlar görünür, hiçbiri seçilmez (Girdi kural 17).
	if _beliriyor and (olay.is_action_pressed("ui_accept") or (olay is InputEventMouseButton and olay.pressed)):
		_tumunu_goster()
		get_viewport().set_input_as_handled()


func _unhandled_input(olay: InputEvent) -> void:
	if evre == &"karar":
		for n in 4:
			if olay.is_action_pressed("kisayol_%d" % (n + 1)) and n < _karar_anahtarlari.size():
				_karar_bas(_karar_anahtarlari[n])
				get_viewport().set_input_as_handled()
				return
	if olay.is_action_pressed("geri"):
		get_viewport().set_input_as_handled()
		if evre == &"karar" and _secili != "":
			_karar_birak()
		else:
			duraklat_istendi.emit()
	elif olay.is_action_pressed("menu"):
		get_viewport().set_input_as_handled()
		duraklat_istendi.emit()


func _yer_tutucu_kapi() -> void:
	var zemin := ColorRect.new()
	zemin.color = Renkler.SOGUK_MAVI
	zemin.position = Vector2(0, 620)
	zemin.size = Vector2(DUNYA_GENISLIK, 368)
	_dunya.add_child(zemin)
	for x in [40.0, DUNYA_GENISLIK - 120.0]:
		var direk := ColorRect.new()
		direk.color = Renkler.AHSAP
		direk.position = Vector2(x, 0)
		direk.size = Vector2(80, 988)
		_dunya.add_child(direk)
