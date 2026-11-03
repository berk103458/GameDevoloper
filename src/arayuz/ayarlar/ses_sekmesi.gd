## AYR-20: Üç ses kaydırıcısı. Yeni bus yoktur.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label
var kaydiricilar: Array[HSlider] = []

const ANAHTARLAR: Array[StringName] = [&"ses_ana", &"ses_muzik", &"ses_efekt"]


func _ready() -> void:
	for anahtar in ANAHTARLAR:
		var ad := Label.new()
		ad.text = tr("arayuz.ayarlar." + String(anahtar))
		add_child(ad)
		var kaydir := HSlider.new()
		kaydir.min_value = 0
		kaydir.max_value = 10
		kaydir.step = 1
		kaydir.set_value_no_signal(int(ayarlar.al(anahtar)))
		kaydir.focus_mode = Control.FOCUS_ALL
		kaydir.value_changed.connect(_degisti.bind(anahtar))
		kaydir.focus_entered.connect(func() -> void:
			if aciklama != null:
				aciklama.text = tr("arayuz.ayarlar.%s_aciklama" % anahtar)
		)
		add_child(kaydir)
		kaydiricilar.append(kaydir)
	preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(self, ayarlar, &"arka_planda_sustur", aciklama)


func _degisti(deger: float, anahtar: StringName) -> void:
	ayarlar.ayarla(anahtar, int(deger))


func _unhandled_input(olay: InputEvent) -> void:
	if not (olay is InputEventKey) or not (olay as InputEventKey).pressed:
		return
	var odak := get_viewport().gui_get_focus_owner()
	if not (odak is HSlider) or not kaydiricilar.has(odak):
		return
	var kaydir := odak as HSlider
	if (olay as InputEventKey).keycode == KEY_LEFT:
		kaydir.value -= 1
	elif (olay as InputEventKey).keycode == KEY_RIGHT:
		kaydir.value += 1
