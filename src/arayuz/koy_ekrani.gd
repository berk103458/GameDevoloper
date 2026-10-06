## Köy görünümü: gece kapısından sonra köyün bir günü (ikindiden geceye). Tam ekran 3B köy; üstte kaynak
## şeridi, sağda köyün hâli, solda gecenin defteri ya da seçilen köylünün kartı, altta inşa kartları ve
## zaman denetimi. Gece çökünce "Kapıya dön" öne çıkar. Olay kartı ortada açılır.
class_name KoyEkrani
extends Control

signal devam_istendi
## Olay seçimi bir barı kırdı.
signal oturum_bitti(kirilan: int)

const EKRAN := Vector2(1920, 1080)

var oturum: Oturum
var ayarlar: Ayarlar
## `Oturum.gece_sonu()` raporu.
var rapor: Dictionary = {}

## 3D köy sahnesi.
var sahne3b: KoySahnesi
var _dugme: Button
var _yapi_kutusu: HBoxContainer
var _kart: PanelContainer
var _kaynak: KaynakGostergesi
var _durum_paneli: KoyDurumPaneli
var _defter: PanelContainer
var _karakter_karti: KarakterKartPaneli
var _zaman: ZamanKontrol
var _gece_bildirimi: Label
var _surukle := false
var _gece_bildirildi := false


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var kap := SubViewportContainer.new()
	kap.stretch = true
	kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kap.gui_input.connect(_sahne_girdisi)
	add_child(kap)
	var vp := SubViewport.new()
	vp.size = Vector2i(EKRAN)
	vp.msaa_3d = Viewport.MSAA_4X
	vp.positional_shadow_atlas_size = 2048
	kap.add_child(vp)
	sahne3b = KoySahnesi.new()
	sahne3b.oturum = oturum
	vp.add_child(sahne3b)
	_hud_kur()
	if oturum.perde == 2:
		Ses.cal(&"sfx_saldiri", -6.0)


func _exit_tree() -> void:
	Engine.time_scale = 1.0


func _process(_delta: float) -> void:
	if _kaynak != null:
		_kaynak.guncelle(sahne3b.saat)
	if not _gece_bildirildi and sahne3b.gece_mi():
		_gece_bildirildi = true
		_gece_bildirimi.visible = true
		var t := create_tween()
		t.tween_property(_gece_bildirimi, "modulate:a", 1.0, 1.2).from(0.0)
		if _kart == null or not is_instance_valid(_kart):
			_dugme.grab_focus()


func _hud_kur() -> void:
	_kaynak = KaynakGostergesi.new()
	_kaynak.oturum = oturum
	_kaynak.position = Vector2(0, 0)
	_kaynak.size = Vector2(EKRAN.x, 64)
	add_child(_kaynak)
	_durum_paneli = KoyDurumPaneli.new()
	_durum_paneli.oturum = oturum
	_durum_paneli.position = Vector2(EKRAN.x - 400, 84)
	add_child(_durum_paneli)
	_defter_kur()
	# Alt: inşa kartları (sol) — zaman denetimi ve kapıya dönüş (sağ).
	var alt := PanelContainer.new()
	alt.position = Vector2(20, EKRAN.y - 196)
	add_child(alt)
	var alt_kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		alt_kenar.add_theme_constant_override(y, 10)
	alt.add_child(alt_kenar)
	_yapi_kutusu = HBoxContainer.new()
	_yapi_kutusu.add_theme_constant_override("separation", 12)
	alt_kenar.add_child(_yapi_kutusu)
	var sag := VBoxContainer.new()
	sag.add_theme_constant_override("separation", 10)
	sag.alignment = BoxContainer.ALIGNMENT_END
	sag.position = Vector2(EKRAN.x - 520, EKRAN.y - 200)
	sag.size = Vector2(500, 180)
	add_child(sag)
	_gece_bildirimi = HudYardim.etiket(tr("arayuz.koy.gece_oldu"), &"Baslik", 26)
	_gece_bildirimi.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_gece_bildirimi.visible = false
	sag.add_child(_gece_bildirimi)
	_zaman = ZamanKontrol.new()
	_zaman.geceye_gec_istendi.connect(func() -> void: sahne3b.geceye_gec())
	sag.add_child(_zaman)
	_dugme = Button.new()
	_dugme.text = tr("arayuz.koy.sonraki")
	_dugme.custom_minimum_size = Vector2(0, 64)
	_dugme.add_theme_font_override("font", Tema.baslik_yazisi())
	_dugme.pressed.connect(func() -> void: devam_istendi.emit())
	sag.add_child(_dugme)
	_yenile()
	var olay: OlayVerisi = rapor.get("olay")
	if olay != null:
		_olay_goster(olay)
	else:
		_dugme.grab_focus.call_deferred()


func _defter_kur() -> void:
	_defter = PanelContainer.new()
	_defter.position = Vector2(20, 84)
	_defter.custom_minimum_size = Vector2(520, 0)
	add_child(_defter)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 14)
	_defter.add_child(kenar)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	kenar.add_child(v)
	v.add_child(HudYardim.etiket(tr("arayuz.koy.rapor"), &"Baslik", 26))
	for o in rapor.get("olaylar", []):
		var l := Label.new()
		var d: Array = o.get("deger", [])
		l.text = "· " + (tr(o["anahtar"]) % d if not d.is_empty() else tr(o["anahtar"]))
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.custom_minimum_size.x = 490
		l.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX) - 2)
		v.add_child(l)
	if rapor.get("rusvet_harcandi", -1) >= 0:
		var r := Label.new()
		r.text = "· " + tr("anlati.rusvet.harcandi") % tr(oturum.ayarlar.bar_anahtarlari[rapor["rusvet_harcandi"]])
		r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		r.custom_minimum_size.x = 490
		r.add_theme_color_override("font_color", Renkler.BRONZ_ACIK)
		v.add_child(r)
	var ipucu := HudYardim.etiket(tr("arayuz.koy.ipucu"), &"", 17)
	ipucu.add_theme_color_override("font_color", Renkler.PARSOMEN.darkened(0.35))
	ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ipucu.custom_minimum_size.x = 490
	v.add_child(ipucu)


func _yenile() -> void:
	_kaynak.guncelle(sahne3b.saat)
	_durum_paneli.guncelle()
	for c in _yapi_kutusu.get_children():
		c.queue_free()
	for yapi in [&"pazar", &"kervansaray", &"sur"]:
		if yapi == &"sur" and oturum.perde < 2:
			continue
		var kart := BinaSecimKarti.new()
		kart.yapi = yapi
		kart.oturum = oturum
		kart.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
		kart.onizle.connect(func(y: StringName) -> void: sahne3b.onizleme_goster(y))
		kart.onizleme_bitti.connect(func() -> void: sahne3b.onizleme_gizle())
		kart.pressed.connect(func() -> void:
			if oturum.yapi_kur(yapi):
				Ses.cal(&"sfx_insaat")
				_yeniden_ciz()
		)
		_yapi_kutusu.add_child(kart)
	if oturum.rusvet_hakki < oturum.ayarlar.rusvet_hakki:
		var k := Button.new()
		k.custom_minimum_size = Vector2(220, 150)
		k.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		k.icon = load(HudYardim.IKON_KOK + "swap-bag.svg") if ResourceLoader.exists(HudYardim.IKON_KOK + "swap-bag.svg") else null
		k.expand_icon = false
		k.add_theme_constant_override("icon_max_width", 40)
		k.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		k.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		k.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX) - 2)
		k.text = tr("arayuz.koy.kese_al") % oturum.ayarlar.kese_fiyati
		k.disabled = not oturum.kese_alinabilir()
		k.pressed.connect(func() -> void:
			if oturum.kese_al():
				Ses.cal(&"sfx_kese")
				_yenile()
		)
		_yapi_kutusu.add_child(k)


## Yapı kurulunca köy yeniden çizilir (yapı görünümü ve meşaleler).
func _yeniden_ciz() -> void:
	sahne3b.yenile()
	_yenile()
	_dugme.grab_focus.call_deferred()


## 3B görünüm üzerindeki fare: köylü vurgulama/seçme, tekerlekle yakınlaşma, orta tuşla döndürme.
func _sahne_girdisi(olay: InputEvent) -> void:
	if olay is InputEventMouseButton:
		var m := olay as InputEventMouseButton
		if m.pressed and m.button_index == MOUSE_BUTTON_WHEEL_UP:
			sahne3b.kamera.yakinlas(1.0)
		elif m.pressed and m.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			sahne3b.kamera.yakinlas(-1.0)
		elif m.button_index == MOUSE_BUTTON_MIDDLE or m.button_index == MOUSE_BUTTON_RIGHT:
			_surukle = m.pressed
		elif m.pressed and m.button_index == MOUSE_BUTTON_LEFT:
			var ai := sahne3b.koylu_bul(m.position)
			if ai != null:
				karakter_goster(ai)
			else:
				_karakter_kapat()
	elif olay is InputEventMouseMotion:
		var h := olay as InputEventMouseMotion
		if _surukle:
			sahne3b.kamera.dondur(-h.relative.x * 0.006)
		else:
			sahne3b.vurgula(sahne3b.koylu_bul(h.position))


## Köylünün kartını açar (defterin yerine).
func karakter_goster(ai: KoyluAI) -> void:
	_karakter_kapat()
	Ses.cal(&"sfx_onay", -10.0)
	sahne3b.sec(ai)
	_karakter_karti = KarakterKartPaneli.new()
	_karakter_karti.oturum = oturum
	_karakter_karti.ai = ai
	_karakter_karti.position = Vector2(20, 84)
	_karakter_karti.kapandi.connect(_karakter_kapat)
	add_child(_karakter_karti)
	_defter.visible = false


func _karakter_kapat() -> void:
	if _karakter_karti != null and is_instance_valid(_karakter_karti):
		_karakter_karti.queue_free()
	_karakter_karti = null
	sahne3b.sec(null)
	_defter.visible = true


func _unhandled_input(olay: InputEvent) -> void:
	if olay.is_action_pressed(&"geri") and _karakter_karti != null:
		_karakter_kapat()
		get_viewport().set_input_as_handled()


func _olay_goster(olay: OlayVerisi) -> void:
	Ses.cal(&"sfx_olay")
	_dugme.disabled = true
	_kart = PanelContainer.new()
	_kart.position = Vector2(560, 160)
	_kart.size = Vector2(800, 0)
	add_child(_kart)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 32)
	_kart.add_child(kenar)
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 14)
	v.custom_minimum_size = Vector2(736, 0)
	kenar.add_child(v)
	var b := HudYardim.etiket(tr(olay.baslik_anahtari), &"Baslik", ayarlar.boyut(Tema.BASLIK_PX))
	v.add_child(b)
	var m := Label.new()
	m.text = tr(olay.metin_anahtari)
	m.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(m)
	var ilk: Button = null
	for i in olay.secenek_anahtarlari.size():
		var d := Button.new()
		d.text = "— " + tr(olay.secenek_anahtarlari[i])
		d.alignment = HORIZONTAL_ALIGNMENT_LEFT
		d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		d.disabled = not oturum.secenek_olur(olay, i)
		d.pressed.connect(_olay_sec.bind(olay, i))
		v.add_child(d)
		if ilk == null and not d.disabled:
			ilk = d
	if ilk != null:
		ilk.grab_focus.call_deferred()


func _olay_sec(olay: OlayVerisi, i: int) -> void:
	Ses.cal(&"sfx_onay")
	var sonuc := oturum.olay_uygula(olay, i)
	var v: VBoxContainer = _kart.get_child(0).get_child(0)
	for c in v.get_children():
		if c is Button:
			c.queue_free()
	var l := Label.new()
	l.text = tr(sonuc["sonuc_anahtari"])
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_color_override("font_color", Renkler.BRONZ_ACIK)
	v.add_child(l)
	var tamam := Button.new()
	tamam.text = tr("arayuz.olay.devam")
	v.add_child(tamam)
	tamam.grab_focus.call_deferred()
	tamam.pressed.connect(func() -> void:
		_kart.queue_free()
		if sonuc["kirilan"] >= 0:
			oturum_bitti.emit(sonuc["kirilan"])
			return
		_dugme.disabled = false
		_yeniden_ciz()
	)
