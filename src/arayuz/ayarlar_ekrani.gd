## Ayarlar ekranı (Ayarlar GDD): anında uygular, kapanınca yazar.
class_name AyarlarEkrani
extends Control

signal kapandi

const SATIRLAR := [
	[&"ses_ana", "arayuz.ayarlar.ses_ana"],
	[&"ses_muzik", "arayuz.ayarlar.ses_muzik"],
	[&"ses_efekt", "arayuz.ayarlar.ses_efekt"],
	[&"ekran_modu", "arayuz.ayarlar.ekran_modu"],
	[&"metin_olcegi", "arayuz.ayarlar.metin_olcegi"],
	[&"belirme_hizi", "arayuz.ayarlar.belirme_hizi"],
	[&"kamera_eksen_ters", "arayuz.ayarlar.kamera_eksen_ters"],
]

var ayarlar: Ayarlar
var _degerler: Dictionary = {}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 160)
	kenar.add_theme_constant_override("margin_top", 120)
	kenar.add_theme_constant_override("margin_right", 760)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 16)
	kenar.add_child(dikey)
	var b := Label.new()
	b.text = tr("arayuz.ayarlar.baslik")
	b.add_theme_font_size_override("font_size", ayarlar.boyut(48))
	dikey.add_child(b)
	var ilk: Button = null
	for satir in SATIRLAR:
		var a: StringName = satir[0]
		var yatay := HBoxContainer.new()
		yatay.add_theme_constant_override("separation", 12)
		var l := Label.new()
		l.text = tr(satir[1])
		l.custom_minimum_size = Vector2(420, 0)
		yatay.add_child(l)
		var geri := Button.new()
		geri.text = "‹"
		geri.custom_minimum_size = Vector2(64, 60)
		geri.pressed.connect(_degistir.bind(a, -1))
		yatay.add_child(geri)
		var deger := Label.new()
		deger.custom_minimum_size = Vector2(300, 0)
		deger.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		yatay.add_child(deger)
		var ileri := Button.new()
		ileri.text = "›"
		ileri.custom_minimum_size = Vector2(64, 60)
		ileri.pressed.connect(_degistir.bind(a, 1))
		yatay.add_child(ileri)
		dikey.add_child(yatay)
		_degerler[a] = deger
		if ilk == null:
			ilk = ileri
	var alt := HBoxContainer.new()
	alt.add_theme_constant_override("separation", 16)
	var v := Button.new()
	v.text = tr("arayuz.ayarlar.varsayilan")
	v.pressed.connect(func() -> void:
		ayarlar.varsayilana_don()
		_yenile()
	)
	alt.add_child(v)
	var k := Button.new()
	k.text = tr("arayuz.ayarlar.geri")
	k.pressed.connect(_kapat)
	alt.add_child(k)
	dikey.add_child(alt)
	var grafik := GrafikAyarlariPaneli.new()
	grafik.ayarlar = ayarlar
	add_child(grafik)
	_yenile()
	ilk.grab_focus.call_deferred()


func _degistir(a: StringName, yon: int) -> void:
	var v: Variant = ayarlar.al(a)
	if a == &"kamera_eksen_ters":
		ayarlar.ayarla(a, not bool(v))
	elif Ayarlar.GECERLI.has(a):
		var liste: Array = Ayarlar.GECERLI[a]
		var i := (liste.find(v) + yon + liste.size()) % liste.size()
		ayarlar.ayarla(a, liste[i])
	else:
		ayarlar.ayarla(a, clampi(int(v) + yon, 0, 10))
	_yenile()


func _yenile() -> void:
	for a in _degerler:
		var v: Variant = ayarlar.al(a)
		var l: Label = _degerler[a]
		match a:
			&"kamera_eksen_ters":
				l.text = tr("arayuz.ayarlar.kamera_eksen.acik") if v else tr("arayuz.ayarlar.kamera_eksen.kapali")
			&"ekran_modu":
				l.text = tr("arayuz.ayarlar.ekran." + String(v))
			&"belirme_hizi":
				l.text = tr("arayuz.ayarlar.belirme." + String(v))
			&"metin_olcegi":
				l.text = "%%%d" % int(v)
			_:
				l.text = "▮".repeat(int(v)) + "·".repeat(10 - int(v))


func _kapat() -> void:
	ayarlar.yaz()
	kapandi.emit()


func _unhandled_input(olay: InputEvent) -> void:
	if olay.is_action_pressed("geri"):
		get_viewport().set_input_as_handled()
		_kapat()
