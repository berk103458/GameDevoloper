## SOY-09: köylü kartında "Ne duydun?" — köylü ağda duyduğu söylentiyi kendi ağzından söyler.
## En son duyduğu sürümü söyler (bozan kendi bozuk kopyasını); sistem doğru mu yanlış mı olduğunu söylemez.
## Duymayan köylüde dal yoktur; kart okuması ağı kurmaz.
## SOY-20: ikinci seçenek "Bunu konuşma" — güvenilir köylü susar, güvenilmez olan daha çok yayar; oyuncuya sonuç söylenmez.
class_name NeDuydun
extends RefCounted


static func kayit(o: Object, k: Koylu) -> Dictionary:
	if o == null or k == null or not o.has_meta(SoylentiKoprusu.META):
		return {}
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var id := str(k.id)
	var secilen := {}
	var en_iyi := -1
	var anahtarlar: Array = a.ag_kayitlari.keys()
	anahtarlar.sort()
	for olay_id in anahtarlar:
		var r: Dictionary = a.ag_kayitlari[olay_id]
		if bool(r.get("hukme_baglandi", false)) or not id in (r.get("duyanlar", []) as Array):
			continue
		var puan := int(r.get("gece", 0))
		if puan > en_iyi:
			en_iyi = puan
			secilen = r
	return secilen


static func metin(o: Object, k: Koylu) -> String:
	var r := kayit(o, k)
	if r.is_empty():
		return ""
	var soz := SoylentiKoprusu.olay_metni(SoylentiKoprusu.ag(o), r)
	return "" if soz.is_empty() else "%s: «%s»" % [k.ad, soz]


static func ekle(ekran: Control, ust: Control, k: Koylu) -> void:
	var soz := metin(ekran.oturum, k)
	if soz.is_empty():
		return
	var sor: Button = ekran._dugme("Ne duydun?", ust)
	sor.name = "ne_duydun"
	sor.pressed.connect(func() -> void:
		sor.disabled = true
		var cevap: Label = ekran._etiket(ust, soz, Tema.KUCUK_PX)
		cevap.name = "ne_duydun_cevabi"
		cevap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		ust.move_child(cevap, sor.get_index() + 1)
		var sustur: Button = ekran._dugme("Bunu konuşma", ust)
		sustur.name = "bunu_konusma"
		ust.move_child(sustur, cevap.get_index() + 1)
		sustur.pressed.connect(func() -> void:
			sustur.disabled = true
			sustur.text = susturma_cevabi(ekran.oturum, k)
		)
	)


static func susturma_cevabi(o: Object, k: Koylu) -> String:
	var r := kayit(o, k)
	if not r.is_empty():
		SoylentiKoprusu.ag(o).sustur(str(k.id), String(r.olay_id))
	return "%s başını salladı." % k.ad
