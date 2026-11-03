## AYR-50: Kontroller sekmesi Bölüm 45'tedir. Burada yalnız boş yuva vardır.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label


func _ready() -> void:
	var yazi := Label.new()
	yazi.text = tr("arayuz.ayarlar.yuva.bos")
	add_child(yazi)
