## AYR-38, AYR-39, AYR-40: Görüntü sekmesi. Grafik profili ve 3B çözünürlük burada.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label
var _boyut: HBoxContainer

const ANAHTARLAR: Array[StringName] = [
	&"ekran_modu", &"pencere_boyutu", &"vsync", &"kare_siniri",
	&"grafik_profili", &"cozunurluk_3d", &"renk_paleti", &"yuksek_kontrast",
	&"hareket_azalt", &"odak_cercevesi",
]


func _ready() -> void:
	for anahtar in ANAHTARLAR:
		preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(self, ayarlar, anahtar, aciklama)
	_boyut = _dugme_bul(&"pencere_boyutu")
	if not ayarlar.degisti.is_connected(_pencere):
		ayarlar.degisti.connect(_pencere)
	_pencere(&"")


func secici_etkin() -> bool:
	return ayarlar != null and ayarlar.al(&"ekran_modu") == &"pencere"


func _pencere(_anahtar: StringName) -> void:
	if _boyut == null:
		return
	var acik := secici_etkin()
	for c in _boyut.get_children():
		if c is Button and String((c as Button).text) in ["‹", "›"]:
			(c as Button).disabled = not acik


func _dugme_bul(anahtar: StringName) -> HBoxContainer:
	for kutu in get_children():
		if kutu is HBoxContainer and kutu.get_meta(&"anahtar", &"") == anahtar:
			return kutu
	return null
