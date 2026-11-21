## EKO-11: kamu kasasından ayrı, salt okunur kişisel kese göstergesi.
class_name KeseGostergesi
extends VBoxContainer
var _miktar: Label
func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	add_theme_constant_override("separation", 2)
	var baslik_boyut := Kabuk.KUCUK - 3
	var miktar_boyut := Kabuk.KUCUK - 1
	var ad := Label.new()
	ad.text = "Kişisel kese"
	ad.add_theme_font_size_override("font_size", baslik_boyut)
	ad.add_theme_color_override("font_color", KaynakGostergesi.BRONZ)
	add_child(ad)
	_miktar = Label.new()
	_miktar.add_theme_font_size_override("font_size", miktar_boyut)
	add_child(_miktar)
## Kişisel para ve eşya toplamını gösterir; kamu ekonomisine yazmaz.
func guncelle(o: Oturum) -> void:
	_miktar.text = "%d akçe" % o.muhafiz_akce
	var adet := 0
	for esya in o.muhafiz_esyalari:
		adet += maxi(0, int(esya.get("adet", 0)))
	tooltip_text = "Kişisel kese: %d akçe. Rüşvet ve kişisel gelirler.\nKişisel eşyalar: %d adet. Köy kasası ve ambarından ayrıdır." % [o.muhafiz_akce, adet]
