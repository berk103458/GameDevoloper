## Mevcut gece raporunun cenaze karar satırları; ikinci olay kuyruğu yok.
class_name CenazeRaporu
extends RefCounted

static func ekle(e: KoyEkrani, v: VBoxContainer, tamam: Button, rapor: Dictionary, sonuc: Dictionary = {}) -> void:
	var y := e.oturum.yonetim
	if CenazeYasi.durum(y).is_empty(): return
	var l := e._etiket(v, CenazeYasi.metin(y), Tema.KUCUK_PX)
	l.name = "cenaze_ozeti"
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 900
	if not CenazeYasi.bekliyor(y): return
	tamam.disabled = true
	var gece_no := int(CenazeYasi.durum(y).olum_gecesi)
	var ucret := CenazeYasi.bedel(y)
	var bilgi := e._etiket(v, "Toplu mezar: ücretsiz, tam yas; salgında kuyu kirliliği.\nTören: %d erzak + %d kamu akçesi, yeni yas yarıya iner; en fazla 6 kişide bir gece üretim −%%10. Salgında yaşayan katılımcılar arasında temas riski." % [ucret, ucret], Tema.KUCUK_PX)
	bilgi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	bilgi.custom_minimum_size.x = 900
	var satir := HBoxContainer.new()
	v.add_child(satir)
	var dugmeler: Array[Button] = []
	for secim in ["toplu_mezar", "toren"]:
		var b := e._dugme("Toplu mezar" if secim == "toplu_mezar" else "Cenaze töreni", satir)
		b.name = "cenaze_" + secim
		b.tooltip_text = CenazeYasi.neden(y, gece_no, secim)
		b.disabled = not b.tooltip_text.is_empty()
		dugmeler.append(b)
		b.pressed.connect(func() -> void:
			if not CenazeYasi.sec(y, gece_no, secim):
				b.tooltip_text = CenazeYasi.neden(y, gece_no, secim)
				b.disabled = not b.tooltip_text.is_empty()
				return
			for dugme in dugmeler: dugme.disabled = true
			l.text = CenazeYasi.metin(y) + " · Kamu akçesi %d · Erzak %d" % [y.akce, y.kaynaklar.miktar("gida")]
			var cenaze: Dictionary = rapor.get("cenaze", {})
			cenaze.merge({"gece": gece_no, "sayi": CenazeYasi.durum(y).sayi, "salgin": CenazeYasi.durum(y).salgin, "secim": secim, "erzak": ucret if secim == "toren" else 0, "akce": ucret if secim == "toren" else 0, "ceza": CenazeYasi.durum(y).ceza}, true)
			rapor["cenaze"] = cenaze
			rapor["akce"] = y.akce
			rapor["huzur"] = y.huzur()
			for olay in rapor.get("olaylar", []):
				if olay.get("cenaze_yasi", false):
					olay.deger[0] = CenazeYasi.durum(y).ceza
					var yas := v.get_node_or_null("gece_yas") as Label
					if yas != null: yas.text = IflasYoneticisi.olay_metin(olay)
			var kamu := v.get_node_or_null("gece_akce") as Label
			var huzur := v.get_node_or_null("gece_huzur") as Label
			if kamu != null: kamu.text = e.tr("koy.rapor.akce") % [int(rapor.akce_once), y.akce]
			if huzur != null: huzur.text = e.tr("koy.rapor.huzur") % y.huzur()
			if secim == "toren" and sonuc.has("bilanco"):
				var bilanco: Dictionary = sonuc.bilanco
				bilanco.kamu.sonra = y.akce
				bilanco.kamu.net -= ucret
				bilanco.kamu.diger_net -= ucret
				bilanco.stok.gida.sonra = y.kaynaklar.miktar("gida")
				bilanco.stok.gida.net -= ucret
				bilanco.stok.gida.diger_net -= ucret
				bilanco["cenaze"] = {"erzak": ucret, "akce": ucret}
			e.oturum._koy_esitle()
			e._yenile()
			tamam.disabled = false
			tamam.grab_focus()
		)
	v.move_child(tamam, v.get_child_count() - 1)
	dugmeler[0].grab_focus.call_deferred()

## Rapor açıkken alınan kayıt geri yüklendiğinde karar kaybolmaz; normal köy kartı.
static func yukleme_karti(e: KoyEkrani) -> void:
	if not CenazeYasi.bekliyor(e.oturum.yonetim): return
	e._gece_dugmesi.disabled = true
	var v := e._kart_ac("Bekleyen cenaze kararı")
	var tamam := e._dugme("Köye dön", v)
	ekle(e, v, tamam, {})
	tamam.pressed.connect(func() -> void:
		if CenazeYasi.bekliyor(e.oturum.yonetim): return
		e._kart_kapat()
		e._gece_dugmesi.disabled = false
	)
