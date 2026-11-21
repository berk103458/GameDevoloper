## Ayarlar ses sekmesi: ana, müzik, efekt ve ortam sürgüleri.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label
var kaydiricilar: Array[HSlider] = []

const ANAHTARLAR: Array[StringName] = [&"ses_ana", &"ses_muzik", &"ses_efekt", &"ses_ortam"]


func _ready() -> void:
	add_theme_constant_override("separation", 8)
	for anahtar in ANAHTARLAR:
		var satir := HBoxContainer.new()
		satir.add_theme_constant_override("separation", 14)
		add_child(satir)
		var ad := Button.new()
		ad.text = tr("arayuz.ayarlar." + String(anahtar))
		ad.alignment = HORIZONTAL_ALIGNMENT_LEFT
		ad.focus_mode = Control.FOCUS_ALL
		ad.flat = true
		ad.custom_minimum_size = Vector2(360, 42)
		satir.add_child(ad)
		var geri := Button.new()
		geri.text = "‹"
		geri.custom_minimum_size = Vector2(76, 42)
		satir.add_child(geri)
		var orta := HBoxContainer.new()
		orta.custom_minimum_size = Vector2(260, 42)
		orta.add_theme_constant_override("separation", 14)
		satir.add_child(orta)
		var kaydir := HSlider.new()
		kaydir.min_value = 0
		kaydir.max_value = 10
		kaydir.step = 1
		kaydir.custom_minimum_size = Vector2(176, 28)
		kaydir.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		kaydir.set_value_no_signal(int(ayarlar.al(anahtar)))
		kaydir.focus_mode = Control.FOCUS_ALL
		orta.add_child(kaydir)
		var deger_etiket := Label.new()
		deger_etiket.text = "%d / 10" % int(kaydir.value)
		deger_etiket.custom_minimum_size = Vector2(70, 42)
		deger_etiket.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		deger_etiket.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		deger_etiket.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
		orta.add_child(deger_etiket)
		var ileri := Button.new()
		ileri.text = "›"
		ileri.custom_minimum_size = Vector2(76, 42)
		satir.add_child(ileri)
		var acikla := func() -> void:
			if aciklama != null:
				aciklama.text = tr("arayuz.ayarlar.%s_aciklama" % anahtar)
		for n: Control in [ad, geri, kaydir, ileri]:
			n.focus_entered.connect(acikla)
			n.mouse_entered.connect(acikla)
		kaydir.value_changed.connect(_degisti.bind(anahtar, deger_etiket))
		geri.pressed.connect(func() -> void:
			kaydir.value = maxf(kaydir.min_value, kaydir.value - 1.0)
		)
		ileri.pressed.connect(func() -> void:
			kaydir.value = minf(kaydir.max_value, kaydir.value + 1.0)
		)
		kaydiricilar.append(kaydir)
	preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(self, ayarlar, &"arka_planda_sustur", aciklama)


func _degisti(deger: float, anahtar: StringName, etiket: Label = null) -> void:
	ayarlar.ayarla(anahtar, int(deger))
	if etiket != null:
		etiket.text = "%d / 10" % int(deger)


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
