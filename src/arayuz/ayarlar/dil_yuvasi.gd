## AYR-50: Dil sekmesi Bölüm 46'dadır. Burada yalnız boş yuva vardır.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label


func _ready() -> void:
	var yazi := Label.new()
	yazi.text = tr("arayuz.ayarlar.yuva.bos")
	add_child(yazi)
