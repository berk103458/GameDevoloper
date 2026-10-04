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

var _sahne: Control
var _dugme: Button
var _serit: PanelContainer
var _durum: Label
var _yapi_kutusu: VBoxContainer
var _kart: PanelContainer
var _ilk_cizim := true


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	_sahne = Control.new()
	_sahne.position = Vector2(0, 0)
	_sahne.size = Vector2(1920, KOY_YUKSEKLIK)
	_sahne.clip_contents = true
	add_child(_sahne)
	_sahne_ciz()
	_bilgi_ciz()
	if oturum.perde == 2:
		Ses.cal(&"sfx_saldiri", -6.0)


func _sahne_ciz() -> void:
	var arka := Sanat.doku("env", "env_village_bg")
	if arka != null:
		var r := TextureRect.new()
		r.texture = arka
		r.size = _sahne.size
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_SCALE
		_sahne.add_child(r)
	else:
		var y := ColorRect.new()
		y.color = Renkler.SOGUK_MAVI
		y.position = Vector2(0, ZEMIN_Y)
		y.size = Vector2(1920, KOY_YUKSEKLIK - ZEMIN_Y)
		_sahne.add_child(y)
	if oturum.perde == 2:
		_tekfur_ciz()
	_yapilari_ciz()
	_mesaleleri_ciz()
	_figurleri_ciz()
	_ilk_cizim = false


## Meşale sayısı = 1 + nüfus / 3 (en çok AZAMI_MESALE).
func mesale_sayisi() -> int:
	return clampi(1 + oturum.koy.toplam() / 3, 1, AZAMI_MESALE)


func _mesale_konumu(i: int) -> Vector2:
	# Sabit, düzensiz bir dizilim: köy sağa ve sola doğru yayılır.
	var sira := [960, 760, 1160, 600, 1330, 450, 1480, 860, 1060, 300, 1640, 680]
	var derin := [0, 40, 20, 70, 50, 30, 80, 110, 100, 60, 90, 130]
	return Vector2(sira[i], ZEMIN_Y + 40 + derin[i])


func _mesaleleri_ciz() -> void:
	var leke := Sanat.doku("fx", "fx_torchlight_patch_village_01")
	var mesale := Sanat.doku("fx", "fx_torch_village_01")
	for i in mesale_sayisi():
		var p := _mesale_konumu(i)
		if leke != null:
			var l := TextureRect.new()
			l.texture = leke
			l.position = p - Vector2(130, -50)
			_sahne.add_child(l)
		else:
			var l2 := ColorRect.new()
			l2.color = Renkler.MESALE
			l2.position = p + Vector2(-90, 70)
			l2.size = Vector2(180, 40)
			_sahne.add_child(l2)
		if mesale != null:
			var m := TextureRect.new()
			m.texture = mesale
			m.position = p - Vector2(20, 0)
			_sahne.add_child(m)


func _figur_konumu(i: int) -> Vector2:
	# Meşale kümelerinin çevresine sıkışan yerleşim; konum sırası sabittir.
	var mesale := _mesale_konumu(i % mesale_sayisi())
	var halka := i / mesale_sayisi()
	var yon := -1.0 if (i + halka) % 2 == 0 else 1.0
	return mesale + Vector2(yon * (40 + halka * 34), 10 + (halka % 3) * 22)


func _figurleri_ciz() -> void:
	var yeni := oturum.koy.bu_gece_girenler
	var eski_sayi := clampi(oturum.koy.toplam() - yeni.size(), 0, AZAMI_FIGUR)
	var sirali_siniflar := _sinif_dizisi()
	for i in eski_sayi:
		_figur_ekle(&"", sirali_siniflar[i % sirali_siniflar.size()] if not sirali_siniflar.is_empty() else &"ciftci", _figur_konumu(i), false)
	for n in yeni.size():
		var i := eski_sayi + n
		if i >= AZAMI_FIGUR:
			break
		var g: Dictionary = yeni[n]
		if not _ilk_cizim:
			_figur_ekle(g["adli_id"], g["sinif"], _figur_konumu(i), false)
			continue
		var f := _figur_ekle(g["adli_id"], g["sinif"], Vector2(1960, _figur_konumu(i).y), true)
		_gir(f, _figur_konumu(i), n)


func _sinif_dizisi() -> Array[StringName]:
	var dizi: Array[StringName] = []
	for s in [&"ciftci", &"esnaf", &"asker"]:
		for k in oturum.koy.sayi(s):
			dizi.append(s)
	return dizi


func _figur_ekle(adli_id: StringName, sinif: StringName, konum: Vector2, _yeni: bool) -> Control:
	var t := Sanat.koy_figuru(adli_id, sinif)
	var c: Control
	if t != null:
		var r := TextureRect.new()
		r.texture = t
		c = r
	else:
		var k := ColorRect.new()
		k.color = Renkler.DERIN_MAVI
		k.size = Vector2(36, 96)
		c = k
	c.position = konum - Vector2(28, 110)
	_sahne.add_child(c)
	return c


func _gir(f: Control, hedef: Vector2, sira: int) -> void:
	await get_tree().create_timer(0.4 + sira * 0.5).timeout
	await Adim.yuru(f, hedef - Vector2(28, 110), 14, 6.0)


## Yapı seviyeleri: yapıların önünde seviye başına bir meşale; ikinci perdede sur (kazık çit).
func _yapilari_ciz() -> void:
	var mesale := Sanat.doku("fx", "fx_torch_village_01")
	var yerler := {&"kervansaray": [360.0, 575.0, 790.0], &"pazar": [1290.0, 1500.0, 1710.0]}
	for yapi in yerler:
		var xler: Array = yerler[yapi]
		for i in int(oturum.yapilar[yapi]):
			if mesale != null:
				var m := TextureRect.new()
				m.texture = mesale
				m.position = Vector2(xler[i] - 20, 470)
				_sahne.add_child(m)
	var sur: int = oturum.yapilar[&"sur"]
	if oturum.perde == 2 and sur > 0:
		var boy := 30.0 + sur * 22.0
		var x := 0.0
		while x < 1920.0:
			var kazik := ColorRect.new()
			kazik.color = Renkler.AHSAP
			kazik.position = Vector2(x, KOY_YUKSEKLIK - 300 - boy)
			kazik.size = Vector2(26, boy)
			_sahne.add_child(kazik)
			var uc := ColorRect.new()
			uc.color = Renkler.MUREKKEP
			uc.position = Vector2(x, KOY_YUKSEKLIK - 300 - boy)
			uc.size = Vector2(26, 4)
			_sahne.add_child(uc)
			x += 34.0


func _tekfur_ciz() -> void:
	var t := Sanat.doku("char", "crowd_tekfur_spear_01_far")
	var yakinlik := clampf(float(oturum.perde2_gece) / oturum.ayarlar.perde2_hedef_gece, 0.0, 1.0)
	# Uzak tepelerde, kervansarayın solunda; geceler geçtikçe sayıca artar ve aşağı (yakına) iner.
	var adet := mini(1 + oturum.perde2_gece / 3, 3)
	for i in adet:
		var x := -260.0 + i * 150.0 + yakinlik * 60.0
		var y := 392.0 + yakinlik * 70.0 + i * 12.0
		if t != null:
			var r := TextureRect.new()
			r.texture = t
			r.position = Vector2(x, y)
			_sahne.add_child(r)
		else:
			var k := ColorRect.new()
			k.color = Renkler.DERIN_MAVI
			k.position = Vector2(x, y)
			k.size = Vector2(200, 30)
			_sahne.add_child(k)


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
	for c in _yapi_kutusu.get_children():
		c.queue_free()
	var b := Label.new()
	b.text = tr("arayuz.koy.yapilar")
	_yapi_kutusu.add_child(b)
	for yapi in [&"pazar", &"kervansaray", &"sur"]:
		var d := oturum.yapi_durumu(yapi)
		var ad := tr("arayuz.yapi." + String(yapi))
		var seviye: int = oturum.yapilar[yapi]
		if yapi == &"sur" and oturum.perde < 2:
			continue
		var dugme := Button.new()
		dugme.alignment = HORIZONTAL_ALIGNMENT_LEFT
		dugme.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dugme.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
		if d["bedel"] < 0:
			dugme.text = tr("arayuz.yapi.azami") % ad
			dugme.disabled = true
		else:
			var ek := "" if oturum.koy.sayi(&"esnaf") >= d["esnaf"] else "  (" + tr("arayuz.yapi.esnaf_gerek") % d["esnaf"] + ")"
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
	for c in _sahne.get_children():
		c.queue_free()
	_sahne_ciz()
	_yenile()
	_dugme.grab_focus.call_deferred()


func _olay_goster(olay: OlayVerisi) -> void:
	Ses.cal(&"sfx_olay")
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
		_kart.queue_free()
		if sonuc["kirilan"] >= 0:
			oturum_bitti.emit(sonuc["kirilan"])
			return
		_dugme.disabled = false
		_yeniden_ciz()
	)
