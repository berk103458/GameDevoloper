## Ayarlar ekranı (Ayarlar GDD): anında uygular, kapanınca yazar.
class_name AyarlarEkrani
extends Control

signal kapandi

const SATIRLAR := [
	[&"ses_ana", "arayuz.ayarlar.ses_ana"],
	[&"ses_muzik", "arayuz.ayarlar.ses_muzik"],
	[&"ses_efekt", "arayuz.ayarlar.ses_efekt"],
	[&"ses_ortam", "arayuz.ayarlar.ses_ortam"],
	[&"ekran_modu", "arayuz.ayarlar.ekran_modu"],
	[&"metin_olcegi", "arayuz.ayarlar.metin_olcegi"],
	[&"belirme_hizi", "arayuz.ayarlar.belirme_hizi"],
	[&"kamera_eksen_ters", "arayuz.ayarlar.kamera_eksen_ters"],
]

var ayarlar: Ayarlar
var _degerler: Dictionary = {}


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if ayarlar != null:
		AyarlarEk.bagla(ayarlar)
	var zemin := Panel.new()
	zemin.name = "TemaZemini"
	zemin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 160)
	kenar.add_theme_constant_override("margin_top", 120)
	kenar.add_theme_constant_override("margin_right", 160)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 16)
	kenar.add_child(dikey)
	var b := Label.new()
	b.text = tr("arayuz.ayarlar.baslik")
	b.set_meta(&"metin_anahtari", "arayuz.ayarlar.baslik")
	b.add_theme_font_size_override("font_size", ayarlar.boyut(48))
	dikey.add_child(b)
	var ilk: Button = null
	for satir in SATIRLAR:
		var a: StringName = satir[0]
		var yatay := HBoxContainer.new()
		yatay.add_theme_constant_override("separation", 12)
		var l := Label.new()
		l.text = tr(satir[1])
		l.set_meta(&"metin_anahtari", satir[1])
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
	var kontroller := Button.new()
	kontroller.name = "KontrollerSekmesiDugmesi"
	kontroller.text = tr("arayuz.girdi.sekme")
	kontroller.pressed.connect(_kontroller_goster)
	alt.add_child(kontroller)
	var v := Button.new()
	v.text = tr("arayuz.ayarlar.varsayilan")
	v.pressed.connect(func() -> void:
		ayarlar.varsayilana_don()
		_yenile()
		var sekme := get_node_or_null("KontrollerSekmesi") as KontrollerSekmesi
		if sekme != null:
			sekme.yenile()
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
	var sekme := KontrollerSekmesi.new()
	sekme.name = "KontrollerSekmesi"
	sekme.ayarlar = ayarlar
	sekme.visible = false
	add_child(sekme)
	DilSekmesi.ekle(self, ayarlar)
	_yenile()
	preload("res://src/arayuz/ayarlar/ayar_sekmeleri.gd").kur(self)
	_odak_kur()
	ilk.grab_focus.call_deferred()


func _kontroller_goster() -> void:
	var sekme := get_node_or_null("KontrollerSekmesi") as KontrollerSekmesi
	if sekme == null:
		return
	sekme.visible = true
	sekme.yenile()


func _odak_kur() -> void:
	var dugmeler: Array = []
	_dugme_topla(self, dugmeler)
	OdakHalkasi.bagla(dugmeler)


func _dugme_topla(n: Node, hedef: Array) -> void:
	if n is Button and n != self and (n as CanvasItem).visible:
		hedef.append(n)
	for cocuk in n.get_children():
		if cocuk.name == "KontrollerSekmesi":
			continue
		_dugme_topla(cocuk, hedef)


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
