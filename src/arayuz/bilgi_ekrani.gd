## Tam ekran bilgi kadrajı: perde geçişi ve son ekranı (sanat kitabı 2.6, 2.8, 7.9).
## Palet ısınmaz; tek durağan kadraj, metin koddan.
class_name BilgiEkrani
extends Control

signal secildi(indeks: int)

var ayarlar: Ayarlar
var baslik: String = ""
var metin: String = ""
## Büyük sayı (skor); -1 ise gösterilmez.
var sayi: int = -1
var sayi_etiketi: String = ""
var dugmeler: PackedStringArray = []
## Pasif (basılamaz) düğme indeksleri.
var pasifler: Array[int] = []
var arka_plan: String = "env_menu_bg"


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var arka := Sanat.doku("env", arka_plan) if arka_plan != "" and arka_plan != "3d_kapi" else null
	if arka_plan == "3d_kapi":
		# 3D kapı sahnesi arka plan: menüde kapı, meşale ve yolda bekleyenler.
		var kap := SubViewportContainer.new()
		kap.stretch = true
		kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(kap)
		var vp := SubViewport.new()
		vp.size = Vector2i(1920, 1080)
		kap.add_child(vp)
		var sahne := KapiSahnesi.new()
		vp.add_child(sahne)
		var golge := ColorRect.new()
		golge.color = Color(Renkler.GECE, 0.55)
		golge.position = Vector2.ZERO
		golge.size = Vector2(980, 1080)
		golge.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(golge)
	elif arka != null:
		var r := TextureRect.new()
		r.texture = arka
		r.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		r.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		r.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		add_child(r)
	var kenar := MarginContainer.new()
	kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kenar.add_theme_constant_override("margin_left", 140)
	kenar.add_theme_constant_override("margin_top", 220)
	kenar.add_theme_constant_override("margin_right", 900)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 22)
	kenar.add_child(dikey)
	var b := Label.new()
	b.text = baslik
	b.add_theme_font_size_override("font_size", ayarlar.boyut(48))
	dikey.add_child(b)
	if metin != "":
		var m := Label.new()
		m.text = metin
		m.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		dikey.add_child(m)
	if sayi >= 0:
		var e := Label.new()
		e.text = sayi_etiketi
		dikey.add_child(e)
		var s := Label.new()
		s.text = str(sayi)
		s.add_theme_font_size_override("font_size", 72)  # skor rakamı ölçeklenmez (Ayarlar kural 12)
		dikey.add_child(s)
	var bosluk := Control.new()
	bosluk.custom_minimum_size = Vector2(0, 30)
	dikey.add_child(bosluk)
	var ilk: Button = null
	for i in dugmeler.size():
		var d := Button.new()
		d.text = dugmeler[i]
		d.alignment = HORIZONTAL_ALIGNMENT_LEFT
		d.custom_minimum_size = Vector2(440, 68)
		d.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		d.pressed.connect(func() -> void: secildi.emit(i))
		d.disabled = i in pasifler
		dikey.add_child(d)
		if ilk == null and not d.disabled:
			ilk = d
	if ilk != null:
		ilk.grab_focus.call_deferred()
