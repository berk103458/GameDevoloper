## SOY-21: çınar meclisindeki söylenti şikâyeti ve "dinle, hükme bağla" kararı; sonuç aynı kartta yazılır.
class_name SoylentiHukmu
extends RefCounted


static func ekle(e: Node, v: Control, sikayet: String) -> void:
	CinarMeclisPaneli._metin(e, v, sikayet, "meclis_soylenti_sikayeti")
	var b: Button = e._dugme("Şikâyeti dinle, hükme bağla", v)
	b.name = "meclis_soylenti_hukum"
	b.pressed.connect(func() -> void:
		var satir := SoylentiKoprusu.hukme_bagla(e.oturum)
		if satir.is_empty(): return
		b.disabled = true
		var l := CinarMeclisPaneli._metin(e, v, "Meclis dinledi ve konuyu hükme bağladı: %s Söz taşıyanların doğruluğu köyde bilinir oldu." % satir, "meclis_soylenti_sonucu")
		v.move_child(l, b.get_index() + 1)
		e.oturum._koy_esitle()
	)
