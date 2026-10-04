## Köy görünümü: gece sonunda, meşaleler yandıktan sonra (sanat kitabı 2.3, 6.5).
## Bu gece girenler sağdan yürüyerek köye girer; meşale sayısı nüfusla artar.
class_name KoyEkrani
extends Control

signal devam_istendi
## Olay seçimi bir barı kırdı.
signal oturum_bitti(kirilan: int)

const ZEMIN_Y := 560.0
const KOY_YUKSEKLIK := 1000.0
const AZAMI_FIGUR := 48
const AZAMI_MESALE := 12

var oturum: Oturum
var ayarlar: Ayarlar
## `Oturum.gece_sonu()` raporu.
var rapor: Dictionary = {}

## 3D köy sahnesi.
var sahne3b: KoySahnesi
var _dugme: Button
var _serit: PanelContainer
var _durum: Label
var _yapi_kutusu: VBoxContainer
var _tarla_kutusu: VBoxContainer
var _kart: PanelContainer
var _ilk_cizim := true


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var kap := SubViewportContainer.new()
	kap.stretch = true
	kap.position = Vector2.ZERO
	kap.size = Vector2(1920, KOY_YUKSEKLIK - 300)
	add_child(kap)
	var vp := SubViewport.new()
	vp.size = Vector2i(kap.size)
	vp.msaa_3d = Viewport.MSAA_4X
	kap.add_child(vp)
	sahne3b = KoySahnesi.new()
	sahne3b.oturum = oturum
	vp.add_child(sahne3b)
	_bilgi_ciz()
	if oturum.perde == 2:
		Ses.cal(&"sfx_saldiri", -6.0)


func _bilgi_ciz() -> void:
	_serit = PanelContainer.new()
	_serit.position = Vector2(0, KOY_YUKSEKLIK - 300)
	_serit.size = Vector2(1920, 380)
	add_child(_serit)
	var kenar := MarginContainer.new()
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 26)
	_serit.add_child(kenar)
	var yatay := HBoxContainer.new()
	yatay.add_theme_constant_override("separation", 40)
	kenar.add_child(yatay)
	var sol := VBoxContainer.new()
	sol.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	yatay.add_child(sol)
	var baslik := Label.new()
	baslik.text = "%s — %s" % [tr("arayuz.koy.baslik"), tr("anlati.gece.bitti")]
	baslik.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX))
	sol.add_child(baslik)
	_durum = Label.new()
	sol.add_child(_durum)
	for o in rapor.get("olaylar", []):
		if String(o["anahtar"]).begins_with("anlati.hasat."):
			Ses.cal(&"sfx_hasat", -4.0)
		var l := Label.new()
		var d: Array = o.get("deger", [])
		l.text = tr(o["anahtar"]) % d if not d.is_empty() else tr(o["anahtar"])
		l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
		l.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
		sol.add_child(l)
	if rapor.get("rusvet_harcandi", -1) >= 0:
		var r := Label.new()
		r.text = tr("anlati.rusvet.harcandi") % tr(oturum.ayarlar.bar_anahtarlari[rapor["rusvet_harcandi"]])
		sol.add_child(r)
	# Orta: yapılar
	_yapi_kutusu = VBoxContainer.new()
	_yapi_kutusu.add_theme_constant_override("separation", 8)
	_yapi_kutusu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_yapi_kutusu.size_flags_stretch_ratio = 1.3
	yatay.add_child(_yapi_kutusu)
	_tarla_kutusu = VBoxContainer.new()
	_tarla_kutusu.add_theme_constant_override("separation", 6)
	_tarla_kutusu.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	yatay.add_child(_tarla_kutusu)
	_dugme = Button.new()
	_dugme.text = tr("arayuz.koy.sonraki")
	_dugme.custom_minimum_size = Vector2(300, 72)
	_dugme.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_dugme.pressed.connect(func() -> void: devam_istendi.emit())
	yatay.add_child(_dugme)
	_yenile()
	var olay: OlayVerisi = rapor.get("olay")
	if olay != null:
		_olay_goster(olay)
	else:
		_dugme.grab_focus.call_deferred()


func _yenile() -> void:
	_durum.text = tr("arayuz.koy.nufus") % [oturum.koy.sayi(&"asker"), oturum.koy.sayi(&"esnaf"), oturum.koy.sayi(&"ciftci")] \
		+ "   ·   " + tr("arayuz.hud.akce") % oturum.akce + "   ·   " + tr("arayuz.hud.ambar") % oturum.ambar
	_tarlalari_ciz()
	for c in _yapi_kutusu.get_children():
		c.queue_free()
	var b := Label.new()
	b.text = tr("arayuz.koy.yapilar")
	_yapi_kutusu.add_child(b)
	for yapi in [&"pazar", &"kervansaray", &"konak", &"sur"]:
		var d := oturum.yapi_durumu(yapi)
		var ad := tr("arayuz.yapi." + String(yapi))
		var seviye: int = oturum.yapilar[yapi]
		var dugme := Button.new()
		dugme.alignment = HORIZONTAL_ALIGNMENT_LEFT
		dugme.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dugme.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
		if d["bedel"] < 0:
			dugme.text = tr("arayuz.yapi.azami") % ad
			dugme.disabled = true
		else:
			var ek := "" if oturum.koy.sayi(&"esnaf") >= d["esnaf"] else "  (" + tr("arayuz.yapi.esnaf_gerek") % d["esnaf"] + ")"
			if int(d.get("nufus", 0)) > oturum.koy.toplam():
				ek = "  (" + tr("arayuz.yapi.nufus_gerek") % d["nufus"] + ")"
			dugme.text = "%s  [%d]  —  %s%s" % [tr("arayuz.yapi.kur") % [ad, d["bedel"]], seviye, tr("arayuz.yapi.%s_aciklama" % yapi), ek]
			dugme.disabled = not d["olur"]
			dugme.pressed.connect(func() -> void:
				if oturum.yapi_kur(yapi):
					Ses.cal(&"sfx_insaat")
					_yeniden_ciz()
			)
		_yapi_kutusu.add_child(dugme)
	if oturum.rusvet_hakki < oturum.ayarlar.rusvet_hakki:
		var k := Button.new()
		k.alignment = HORIZONTAL_ALIGNMENT_LEFT
		k.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		k.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
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


func _olay_goster(olay: OlayVerisi) -> void:
	Ses.cal(&"sfx_olay")
	if olay.ses != &"":
		Ses.cal(olay.ses, -3.0)
	if olay.muzik != &"":
		Ses.muzik_cal(olay.muzik)
	_dugme.disabled = true
	_kart = PanelContainer.new()
	_kart.position = Vector2(560, 120)
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
	var b := Label.new()
	b.text = tr(olay.baslik_anahtari)
	b.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.BASLIK_PX))
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
	l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	v.add_child(l)
	var tamam := Button.new()
	tamam.text = tr("arayuz.olay.devam")
	v.add_child(tamam)
	tamam.grab_focus.call_deferred()
	tamam.pressed.connect(func() -> void:
		Ses.muzik_cal(&"")
		_kart.queue_free()
		if sonuc["kirilan"] >= 0:
			oturum_bitti.emit(sonuc["kirilan"])
			return
		_dugme.disabled = false
		_yeniden_ciz()
	)


## Tarlalar: parsellerin durumu; boş parsel varsa her ürün için "ek" düğmesi (tohum ambardan).
func _tarlalari_ciz() -> void:
	for c in _tarla_kutusu.get_children():
		c.queue_free()
	var a := oturum.ayarlar
	var t := oturum.tarlalar
	var b := Label.new()
	b.text = tr("arayuz.tarla.baslik") % t.parseller.size()
	_tarla_kutusu.add_child(b)
	if t.parseller.is_empty():
		var l := Label.new()
		l.text = tr("arayuz.tarla.yok") % a.ciftci_tarla_basina
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
		l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
		_tarla_kutusu.add_child(l)
		return
	var sureler := a.bitki_sure_sozlugu()
	var parcalar: PackedStringArray = []
	for p in t.parseller:
		if p["bitki"] == "":
			parcalar.append(tr("arayuz.tarla.bos"))
		else:
			parcalar.append(tr("arayuz.tarla.durum") % [tr("bitki." + String(p["bitki"])), p["gun"], sureler[p["bitki"]]])
	var d := Label.new()
	d.text = " · ".join(parcalar)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	d.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	d.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	_tarla_kutusu.add_child(d)
	if t.bos_sayisi() == 0:
		return
	for i in a.bitki_idleri.size():
		var id := a.bitki_idleri[i]
		var e := Button.new()
		e.alignment = HORIZONTAL_ALIGNMENT_LEFT
		e.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
		e.text = tr("arayuz.tarla.ek") % [tr("bitki." + id), a.bitki_sureleri[i], a.bitki_verimleri[i], a.bitki_tohumlari[i]]
		e.disabled = oturum.ambar < a.bitki_tohumlari[i]
		e.pressed.connect(func() -> void:
			if oturum.tarla_ek(id):
				Ses.cal(&"sfx_ekim", -4.0)
				_yeniden_ciz()
		)
		_tarla_kutusu.add_child(e)
