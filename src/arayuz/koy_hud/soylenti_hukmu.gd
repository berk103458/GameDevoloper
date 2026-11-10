## SOY-21: çınar meclisindeki söylenti şikâyeti ve "dinle, hükme bağla" kararı; sonuç aynı kartta yazılır.
## SOY-18: hükümden önce muhafız söze "doğru" ya da "yalan" diyebilir; tek nitelik.
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
	for dogru_der in [true, false]:
		var n: Button = e._dugme("Muhafız olarak: \"Bu söz %s\"" % ("doğru" if dogru_der else "yalan"), v)
		n.name = "meclis_soylenti_nitele_" + ("dogru" if dogru_der else "yalan")
		n.pressed.connect(func() -> void:
			var satir := SoylentiKoprusu.nitele(e.oturum, dogru_der)
			if satir.is_empty(): return
			for c in v.get_children():
				if String(c.name).begins_with("meclis_soylenti_nitele_"): c.disabled = true
			var l := CinarMeclisPaneli._metin(e, v, satir, "meclis_soylenti_niteleme")
			v.move_child(l, n.get_index() + 1)
			e.oturum._koy_esitle()
		)
