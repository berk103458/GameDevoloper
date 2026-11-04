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
## "3d_koy" arka planı için: oyuncunun kurduğu köy (perde geçişi ve sonlar, sanat kitabı 2.6, 2.8).
var oturum: Oturum


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.name = "kabuk_zemin"
	zemin.color = Kabuk.zemin()
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)
	var arka := Sanat.doku("env", arka_plan) if arka_plan != "" and not arka_plan.begins_with("3d_") else null
	if arka_plan == "3d_koy" and oturum != null:
		var kap_k := SubViewportContainer.new()
		kap_k.stretch = true
		kap_k.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(kap_k)
		var vp_k := SubViewport.new()
		vp_k.size = Vector2i(1920, 1080)
		kap_k.add_child(vp_k)
		var koy := KoyYonetimSahnesi.new()
		koy.yonetim = oturum.yonetim
		vp_k.add_child(koy)
	elif arka_plan == "3d_kapi":
		# 3D kapı gecesi arka plan (kırılma sonu).
		var kap := SubViewportContainer.new()
		kap.stretch = true
		kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(kap)
		var vp := SubViewport.new()
		vp.size = Vector2i(1920, 1080)
		kap.add_child(vp)
		# Menüdeki kapı gecesi; yarı saydam karartma yok (7.9), sol taraf sahnede zaten karanlık.
		vp.add_child(MenuSahnesi.new())
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
	var dugmeler: Array = []
	for cocuk in dikey.get_children():
		if cocuk is Button:
			dugmeler.append(cocuk)
	OdakHalkasi.bagla(dugmeler)
	if ilk != null:
		ilk.grab_focus.call_deferred()
