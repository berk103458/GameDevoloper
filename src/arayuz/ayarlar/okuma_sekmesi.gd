## AYR-07, AYR-08, AYR-13: Okuma sekmesi. Metin ölçeği 175'i de içerir.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label

const ANAHTARLAR: Array[StringName] = [
	&"metin_olcegi", &"satir_araligi", &"metin_agirligi", &"belirme_hizi", &"okunmus_isaret",
]


func _ready() -> void:
	for anahtar in ANAHTARLAR:
		preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(self, ayarlar, anahtar, aciklama)
