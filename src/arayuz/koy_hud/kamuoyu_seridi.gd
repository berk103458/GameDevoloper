## SOY-30: köy HUD'unda kamuoyu konusu için tek satır; tıklanınca defter Söylenti sayfasında açılır.
## Köy ekranı sınıfına bağlanmaz; ekran ördek tiplemeyle bulunur.
class_name KamuoyuSeridi
extends RefCounted

const AD := "kamuoyu_seridi"


static func guncelle(h: Node, oturum: Variant) -> void:
	var ust: Node = h._huzur_bar.get_parent()
	var b := ust.get_node_or_null(AD) as Button
	var satir := SoylentiKoprusu.kamuoyu_satiri(oturum) if oturum is Object else ""
	if satir.is_empty():
		if b != null:
			b.queue_free()
			ust.remove_child(b)
		return
	if b == null:
		b = Button.new()
		b.name = AD
		b.flat = true
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
		ust.add_child(b)
		b.pressed.connect(func() -> void: ac(h))
	b.text = satir
	b.tooltip_text = satir


static func ac(h: Node) -> HafizaDefteriEkrani:
	var defter := HafizaDefteriBaglantisi.ac(AmbarKapisiPaneli._ekran(h))
	if defter != null:
		var i := defter._sayfalar.find("soylenti")
		if i >= 0: defter.sayfa_sec(i)
	return defter
