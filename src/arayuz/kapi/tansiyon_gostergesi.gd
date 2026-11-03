## KAP-12: sorgu sinyalinden beslenen 0–10 gösterge; durum motorunu değiştirmez.
extends VBoxContainer

var sorgu: RefCounted
var etiket: Label
var bar: ProgressBar
const RENKLER := [Color("#82b689"), Color("#d1aa59"), Color("#c45b51")]

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	etiket = Label.new()
	etiket.mouse_filter = Control.MOUSE_FILTER_IGNORE
	etiket.add_theme_font_size_override("font_size", Kabuk.KUCUK)
	add_child(etiket)
	bar = ProgressBar.new()
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar.min_value = 0
	bar.max_value = 10
	bar.show_percentage = false
	bar.custom_minimum_size.y = 16
	add_child(bar)
	if sorgu != null:
		sorgu.tansiyon_degisti.connect(_sorguyu_guncelle)
		_sorguyu_guncelle(sorgu.tansiyon)
	else:
		guncelle(0)

func _sorguyu_guncelle(deger: int) -> void:
	guncelle(deger, sorgu.bayraklar.get("Flag_Kilitlendi", false))

func guncelle(deger: int, kilitli: bool = false) -> void:
	var tansiyon := clampi(deger, 0, 10)
	var bolge := 0 if tansiyon < 4 else 1 if tansiyon < 8 else 2
	etiket.text = "Tansiyon: %d / 10 — %s%s" % [tansiyon, ["Sakin", "Gergin", "Panik"][bolge], " · kabul kapalı" if kilitli else ""]
	bar.value = tansiyon
	preload("res://src/arayuz/kapi/tansiyon_bicimi.gd").uygula(self, bolge)
	var dolgu := StyleBoxFlat.new()
	dolgu.bg_color = RENKLER[bolge]
	dolgu.set_corner_radius_all(3)
	bar.add_theme_stylebox_override("fill", dolgu)
