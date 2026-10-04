## Heybe paneli (kapı ekranının dünya alanının üstüne açılır): heybe açılır, eşyalar dökülür;
## oyuncu eşyaları "Alınacaklar" tepsisine taşır/geri koyar, astarı yoklar. Yalan yakalanınca mühür basılır.
## Kurallar: design/gdd/heybe-ve-rusvet.md
class_name HeybePaneli
extends Control

signal kapandi
## Alınacaklar ya da astar değişti (kapı ekranı karar düğmelerini tazeler).
signal degisti

const TEPSI := Rect2(700, 150, 400, 600)
const KART_ARALIK := Vector2(188, 162)

var heybe: Heybe
var ayarlar: Ayarlar
var gelen_adi: String = ""
var beyan_metni: String = ""

var _cizim: HeybeCizimi
var _kartlar: Array[EsyaKarti] = []
var _yuvalar := {}
var _toplam: Label
var _teklif: Label
var _uyari: Label
var _astar_dugme: Button
var _kapat: Button
var _muhur: Control
var _font: Font
var _mesgul := false


func _ready() -> void:
	size = Vector2(1140, 988)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_font = Tema.font(500)
	var zemin := ColorRect.new()
	zemin.color = Color(Renkler.GECE, 0.94)
	zemin.size = size
	add_child(zemin)
	_etiket(tr("heybe.baslik") % gelen_adi, Vector2(48, 24), Tema.BASLIK_PX, Renkler.KUL)
	var b := _etiket(tr("heybe.soyledigi") % beyan_metni if heybe.soruldu else tr("heybe.sormadin"), Vector2(48, 76), 22, Renkler.SOGUK_MAVI)
	b.size.x = 1040
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_cizim = HeybeCizimi.new()
	_cizim.position = Vector2(40, 150)
	_cizim.size = Vector2(620, 600)
	add_child(_cizim)
	var tepsi_baslik := _etiket(tr("heybe.alinacaklar"), TEPSI.position + Vector2(0, -2), 26, Renkler.KUL)
	tepsi_baslik.add_theme_font_override("font", Tema.font(700))
	var ipucu := _etiket(tr("heybe.bos"), TEPSI.position + Vector2(0, 520), 17, Renkler.SOGUK_MAVI)
	ipucu.size.x = TEPSI.size.x
	ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_toplam = _etiket("", Vector2(700, 772), 24, Renkler.KUL)
	_teklif = _etiket("", Vector2(700, 806), 20, Renkler.SOGUK_MAVI)
	_uyari = _etiket("", Vector2(700, 836), 18, Renkler.MESALE)
	_uyari.size.x = 420
	_uyari.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_astar_dugme = _dugme(tr("heybe.astar"), Vector2(70, 772), Vector2(300, 64))
	_astar_dugme.pressed.connect(_astar_yokla)
	_kapat = _dugme(tr("heybe.kapat"), Vector2(700, 898), Vector2(400, 64))
	_kapat.pressed.connect(func() -> void: kapandi.emit())
	if heybe.astar_yoklandi:
		_astar_dugme.disabled = true
		_astar_dugme.text = tr("heybe.astar_yoklandi")
		_cizim.yirtik = 1.0 if heybe.yalan_var() else 0.0
	_ac()


func _draw() -> void:
	# Tepsi: koyu zemin, ince kül çerçeve, kenarda dikiş.
	var r := Rect2(TEPSI.position + Vector2(0, 40), TEPSI.size - Vector2(0, 40))
	draw_rect(r, Color("#101217"))
	draw_rect(r, Color(Renkler.KUL, 0.35), false, 2.0)
	draw_dashed_line(r.position + Vector2(10, 10), Vector2(r.end.x - 10, r.position.y + 10), Color(MenuSatiri.ALTIN, 0.35), 1.5, 8.0)


## Açılış: heybe yere konur gibi belirir, kapak açılır, eşyalar ağızdan sırayla dökülür.
func _ac() -> void:
	_mesgul = true
	_cizim.scale = Vector2(0.92, 0.92)
	_cizim.pivot_offset = _cizim.size / 2.0
	var t := create_tween().set_parallel()
	t.tween_property(_cizim, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(_cizim, "acik", 1.0, 0.45).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_delay(0.15)
	await t.finished
	Ses.cal(&"sfx_kese", -6.0)
	for e in heybe.gorunenler():
		_kart_ekle(e, _cizim.agiz_merkezi())
		await get_tree().create_timer(0.09).timeout
	_yerlestir(false)
	_ozet()
	_mesgul = false
	if not _kartlar.is_empty():
		_kartlar[0].grab_focus()
	else:
		_kapat.grab_focus()


func _kart_ekle(e: Dictionary, cikis: Vector2) -> EsyaKarti:
	var k := EsyaKarti.new()
	k.esya = e
	k.ad = tr("esya." + String(e["id"]))
	k.gizli_yazi = tr("heybe.gizli")
	k.adet_yazi = tr("heybe.adet")
	k.font_ = _font
	k.position = cikis - EsyaKarti.BOYUT / 2.0
	k.scale = Vector2(0.3, 0.3)
	k.pivot_offset = EsyaKarti.BOYUT / 2.0
	add_child(k)
	_kartlar.append(k)
	k.pressed.connect(_kart_bas.bind(k))
	k.adet_istendi.connect(_adet.bind(k))
	k.focus_entered.connect(func() -> void: Ses.cal(&"sfx_secim", -10.0))
	_yerlestir(true)
	return k


## Kartları yuvalarına götürür: alınanlar tepside, kalanlar heybenin önünde.
func _yerlestir(anlik: bool) -> void:
	var heybede := 0
	var tepside := 0
	for k in _kartlar:
		var e := k.esya
		var tepsiye: bool = int(e["alinan"]) > 0 and (e["tur"] != "akce" or int(e["alinan"]) == int(e["adet"]))
		var hedef: Vector2
		if tepsiye:
			hedef = TEPSI.position + Vector2(12 + (tepside % 2) * KART_ARALIK.x, 52 + (tepside / 2) * KART_ARALIK.y)
			tepside += 1
		else:
			hedef = _cizim.position + Vector2(40 + (heybede % 3) * KART_ARALIK.x, 175 + (heybede / 3) * KART_ARALIK.y)
			heybede += 1
		var t := k.create_tween().set_parallel()
		var sure := 0.22 if anlik else 0.3
		t.tween_property(k, "position", hedef, sure).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		t.tween_property(k, "scale", Vector2.ONE, sure).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		k.queue_redraw()


func _kart_bas(k: EsyaKarti) -> void:
	if _mesgul:
		return
	var e := k.esya
	heybe.al(e, 0 if int(e["alinan"]) > 0 else int(e["adet"]))
	Ses.cal(&"sfx_kese" if e["tur"] == "akce" else &"sfx_secim", -6.0)
	_degisti()


func _adet(degisim: int, k: EsyaKarti) -> void:
	if _mesgul:
		return
	heybe.al(k.esya, int(k.esya["alinan"]) + degisim)
	Ses.cal(&"sfx_kese", -12.0)
	_degisti()


func _degisti() -> void:
	_yerlestir(false)
	_ozet()
	degisti.emit()


func _ozet() -> void:
	_toplam.text = tr("heybe.toplam") % heybe.alinan_deger()
	_teklif.text = tr("heybe.teklif") % heybe.teklif
	var gasp := heybe.gasp()
	if gasp > 0:
		_uyari.text = tr("heybe.gasp_uyari") % gasp
	elif heybe.yakalandi():
		_uyari.text = tr("heybe.serbest")
	else:
		_uyari.text = ""


## Astarı yokla: heybe sarsılır, dikiş yırtılır; saklananlar fırlar ve mühür basılır.
func _astar_yokla() -> void:
	if _mesgul or heybe.astar_yoklandi:
		return
	_mesgul = true
	_astar_dugme.disabled = true
	var t := create_tween()
	for i in 6:
		t.tween_property(_cizim, "sarsinti", 7.0 if i % 2 == 0 else -7.0, 0.05)
	t.tween_property(_cizim, "sarsinti", 0.0, 0.05)
	await t.finished
	var cikan := heybe.astar_yokla()
	degisti.emit()
	if cikan.is_empty():
		_astar_dugme.text = tr("heybe.astar_yoklandi")
		_uyari.text = tr("heybe.astar_bos") % gelen_adi
		_mesgul = false
		_kapat.grab_focus()
		return
	Ses.cal(&"sfx_bar_catlak", -4.0)
	var y := create_tween()
	y.tween_property(_cizim, "yirtik", 1.0, 0.35).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await y.finished
	for e in cikan:
		var k := _kart_ekle(e, _cizim.astar_merkezi())
		k.scale = Vector2(0.2, 0.2)
		Ses.cal(&"sfx_kese", -4.0)
		await get_tree().create_timer(0.16).timeout
	_astar_dugme.text = tr("heybe.astar_yoklandi")
	await _muhur_bas()
	_ozet()
	_mesgul = false
	_kartlar[_kartlar.size() - 1].grab_focus()


## "Yalan yakalandı" mührü: büyükten küçülerek, hafif dönerek basılır.
func _muhur_bas() -> void:
	_muhur = Muhur.new()
	_muhur.yazi = tr("heybe.yakalandi")
	_muhur.font_ = Tema.font(700)
	_muhur.size = Vector2(210, 210)
	_muhur.pivot_offset = _muhur.size / 2.0
	# Sağ üstteki boş alan: kartların ve tepsinin üstüne düşmez.
	_muhur.position = Vector2(size.x - 250, -18)
	_muhur.scale = Vector2(2.2, 2.2)
	_muhur.rotation_degrees = -26.0
	_muhur.modulate.a = 0.0
	add_child(_muhur)
	var t := create_tween().set_parallel()
	t.tween_property(_muhur, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	t.tween_property(_muhur, "rotation_degrees", -12.0, 0.18)
	t.tween_property(_muhur, "modulate:a", 1.0, 0.08)
	await t.finished
	Ses.cal(&"sfx_onay", -2.0)
	var s := create_tween()
	s.tween_property(self, "position", Vector2(0, 92 + 4), 0.04)
	s.tween_property(self, "position", Vector2(0, 92), 0.06)
	await s.finished


func _unhandled_input(olay: InputEvent) -> void:
	if olay.is_action_pressed("geri"):
		get_viewport().set_input_as_handled()
		kapandi.emit()


func _etiket(metin: String, konum: Vector2, px: int, renk: Color) -> Label:
	var l := Label.new()
	l.text = metin
	l.position = konum
	l.add_theme_font_size_override("font_size", ayarlar.boyut(px))
	l.add_theme_color_override("font_color", renk)
	add_child(l)
	return l


func _dugme(metin: String, konum: Vector2, boyut: Vector2) -> Button:
	var b := Button.new()
	b.text = metin
	b.position = konum
	b.size = boyut
	b.focus_mode = Control.FOCUS_ALL
	add_child(b)
	return b
