## Üst kaynak şeridi (design/gdd/koy-yonetimi.md, 17.1 ve 17.5): akçe ve ambar stokları (günlük net değişimle),
## mevsim takvimi, nüfus / yatak, köy huzuru barı, adalet ve asayiş; erzak 2 günden azsa ya da asayiş kritikse
## ilgili gösterge yanıp söner. Renk paleti sanat kitabındaki gibi: uyarı kızıl değil, meşale rengidir.
class_name Hud
extends PanelContainer

const STOKLAR: Array[String] = ["gida", "odun", "tas", "kereste", "alet"]
const UYARI := Color("#C4843A")
## Asayiş riski bu değerin üstündeyse kritik sayılır.
const ASAYIS_KRITIK := 60

var _oturum: Oturum
var _akce: Label
var _stok_etiketleri: Dictionary = {}
var _gun: Label
var _mevsim: Label
var _nufus: Label
var _huzur_kutu: HBoxContainer
var _huzur_etiket: Label
var _adalet: Label
var _asayis: Label
## Bir önceki güncellemedeki stoklar ve gün (net değişim için).
var _onceki: Dictionary = {}
var _onceki_gun := -1
var _net: Dictionary = {}
var _zaman := 0.0


## HUD'u bir oturuma bağlar.
func bagla(oturum: Oturum) -> void:
	_oturum = oturum
	oturum.koy.degisti.connect(guncelle)
	guncelle()


func _ready() -> void:
	custom_minimum_size = Vector2(0, 92)
	var kutu := HBoxContainer.new()
	kutu.add_theme_constant_override("separation", 26)
	add_child(kutu)
	_akce = _etiket(kutu, Tema.BASLIK_PX)
	for t in STOKLAR:
		_stok_etiketleri[t] = _etiket(kutu, Tema.KUCUK_PX)
	var orta := Control.new()
	orta.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kutu.add_child(orta)
	var huzur := VBoxContainer.new()
	huzur.add_theme_constant_override("separation", 4)
	_huzur_etiket = _etiket(huzur, Tema.KUCUK_PX)
	_huzur_kutu = HBoxContainer.new()
	_huzur_kutu.add_theme_constant_override("separation", 3)
	huzur.add_child(_huzur_kutu)
	kutu.add_child(huzur)
	var gosterge := VBoxContainer.new()
	_adalet = _etiket(gosterge, Tema.KUCUK_PX)
	_asayis = _etiket(gosterge, Tema.KUCUK_PX)
	kutu.add_child(gosterge)
	var sag := VBoxContainer.new()
	_gun = _etiket(sag, Tema.BASLIK_PX)
	_gun.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_mevsim = _etiket(sag, Tema.KUCUK_PX)
	_mevsim.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_nufus = _etiket(sag, Tema.KUCUK_PX)
	_nufus.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	kutu.add_child(sag)


func _etiket(ust: Control, punto: int) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", punto)
	l.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	ust.add_child(l)
	return l


func _process(delta: float) -> void:
	_zaman += delta
	if _oturum == null:
		return
	# Uyarılar yanıp söner (zamanlayıcıyla değil, kare başı tek bir alfa: bellek tahsisi yok).
	var yanip := 0.55 + 0.45 * sin(_zaman * 6.0)
	var y := _oturum.yonetim
	(_stok_etiketleri["gida"] as Label).modulate.a = yanip if y.gida_gunu() < 2.0 and y.nufus() > 0 else 1.0
	_asayis.modulate.a = yanip if y.asayis_riski >= ASAYIS_KRITIK else 1.0
	_huzur_etiket.modulate.a = yanip if y.isyan_kalan >= 0 else 1.0


## Tüm göstergeleri oturumdan yeniden çizer.
func guncelle() -> void:
	if _oturum == null:
		return
	var y := _oturum.yonetim
	var k := y.kaynaklar
	if y.gun != _onceki_gun:
		_net.clear()
		if _onceki_gun >= 0:
			for t in STOKLAR:
				_net[t] = k.miktar(t) - int(_onceki.get(t, 0))
		_onceki_gun = y.gun
		for t in STOKLAR:
			_onceki[t] = k.miktar(t)
	_akce.text = tr("arayuz.hud.akce") % y.akce
	for t in STOKLAR:
		var l: Label = _stok_etiketleri[t]
		var net := int(_net.get(t, 0))
		l.text = "%s %d%s" % [tr("koy.kaynak." + t), k.miktar(t), ("  (%+d)" % net) if net != 0 else ""]
		l.add_theme_color_override("font_color", UYARI if (t == "gida" and y.gida_gunu() < 2.0 and y.nufus() > 0) else Renkler.KUL)
	_huzur_etiket.text = (tr("arayuz.hud.isyan") % y.isyan_kalan) if y.isyan_kalan >= 0 else tr("arayuz.hud.huzur") % y.huzur()
	for c in _huzur_kutu.get_children():
		c.queue_free()
	var dolu := y.huzur() / 10
	for s in 10:
		var durum := "empty"
		if s < dolu:
			durum = "full"
			if dolu <= 3 and s == dolu - 1:
				durum = "cracked_02"
		_huzur_kutu.add_child(_parca(durum))
	_adalet.text = tr("arayuz.hud.adalet") % y.adalet
	_asayis.text = tr("arayuz.hud.asayis") % y.asayis_riski
	_asayis.add_theme_color_override("font_color", UYARI if y.asayis_riski >= ASAYIS_KRITIK else Renkler.KUL)
	_gun.text = tr("arayuz.hud.gun") % (y.gun + 1)
	_mevsim.text = tr("arayuz.hud.mevsim") % [tr("koy.mevsim." + y.a.mevsimler[y.mevsim()]), Takvim.mevsim_gunu(y.gun, y.a.mevsim_gun), y.a.mevsim_gun]
	_nufus.text = tr("arayuz.hud.nufus") % [y.nufus(), y.yatak_kapasitesi(), k.toplam(), k.kapasite]


func _parca(durum: String) -> Control:
	var t := Sanat.doku("ui", "ui_bar_segment_%s" % durum)
	if t != null:
		var r := TextureRect.new()
		r.texture = t
		r.custom_minimum_size = Vector2(16, 26)
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		return r
	var c := ColorRect.new()
	c.custom_minimum_size = Vector2(14, 24)
	c.color = Renkler.KUL if durum != "empty" else Renkler.DERIN_MAVI
	return c
