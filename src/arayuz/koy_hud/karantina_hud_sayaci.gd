## HUD nüfus satırının yanındaki karantina sayacı. Köy ekranı sınıfına bağlanmaz:
## HUD, `KoyEkrani` derlenmeden (ör. autoload'suz `-s` testlerinde) kurulabilmelidir.
class_name KarantinaHudSayaci
extends RefCounted


static func guncelle(h: Node, y: KoyYonetimi, katman: RefCounted) -> void:
	var sayi := 0
	for k in y.koylular:
		if KarantinaYoneticisi.aktif(k): sayi += 1
	var ust: Node = h._nufus.get_parent()
	if not katman.acik("karantina_paneli.gd", "ana", sayi > 0):
		katman.gecici_kaldir(ust, "KarantinaSayisi")
		if sayi <= 0 and y.has_meta(KarantinaIsaretiAnimasyonu.META):
			y.remove_meta(KarantinaIsaretiAnimasyonu.META)
		return
	var l := ust.get_node_or_null("KarantinaSayisi") as Label
	if l == null:
		l = h._etiket(ust, Tema.KUCUK_PX)
		l.name = "KarantinaSayisi"
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		if not bool(y.get_meta(KarantinaIsaretiAnimasyonu.META, false)):
			y.set_meta(KarantinaIsaretiAnimasyonu.META, true)
			if h is Control:
				KarantinaIsaretiAnimasyonu.oynat(h as Control)
	l.text = TranslationServer.translate("koy.karantina.hud") % sayi
