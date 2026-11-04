## SYS-10 dumanının kayıt ve gece döngüsü. Sahne ve birim testi aynı fonksiyonu çağırır.
extends RefCounted


static func gocmus_oturum(katalog: Katalog) -> Oturum:
	var ham := Oturum.new(katalog, 11)
	ham.yonetim.kaynaklar.ekle("gida", 40)
	ham.yonetim.kaynaklar.ekle("su", 40)
	var veri: Dictionary = JSON.parse_string(JSON.stringify(ham.kaydet()))
	veri["surum"] = 2
	for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "mevsim", "yeni_binalar"]:
		veri.erase(alan)
	return Oturum.kayittan(katalog, veri)


static func model_dongusu(oturum: Oturum, katalog: Katalog, hedef: int) -> Dictionary:
	var hafiza_once := int(Performance.get_monitor(Performance.MEMORY_STATIC))
	var o := oturum
	var geceler := 0
	for _i in hedef:
		for g in o.gece_kuyrugu():
			var chr = g.chr_sorgusu()
			if chr != null:
				chr.obje_incele(1)
			var karar: StringName = &"ret" if g.tehlikeli else &"kabul"
			if g.secenekler.is_empty():
				continue
			if not String(karar) in g.secenekler:
				karar = StringName(g.secenekler[0])
			o.karar_ver(g, karar)
		var once := o.gun
		o.gece_sonu()
		if o.gun != once + 1:
			return {"olur": false, "gece": geceler, "hafiza_once": hafiza_once, "hafiza_son": hafiza_once}
		var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
		if geri == null or geri.gun != o.gun:
			return {"olur": false, "gece": geceler, "hafiza_once": hafiza_once, "hafiza_son": hafiza_once}
		o = geri
		geceler += 1
	var hafiza_son := int(Performance.get_monitor(Performance.MEMORY_STATIC))
	var rapor := bellek_raporu(hafiza_once, hafiza_son)
	rapor["olur"] = true
	rapor["gece"] = geceler
	rapor["gun"] = o.gun
	return rapor


static func bellek_raporu(once: int, son: int) -> Dictionary:
	var tavan := 2.0
	var ham: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/teknik.json"))
	if ham is Dictionary and ham.get("duman") is Dictionary and (ham.duman.get("bellek_carpan_tavan") is int or ham.duman.get("bellek_carpan_tavan") is float):
		tavan = float(ham.duman.bellek_carpan_tavan)
	var oran := float(son) / float(maxi(once, 1))
	var sicrama := oran >= tavan
	if sicrama:
		print("TEK-29 bellek_sicramasi oran=%.3f tavan=%.3f" % [oran, tavan])
	return {"hafiza_once": once, "hafiza_son": son, "bellek_oran": oran, "bellek_tavan": tavan, "sicrama": sicrama}
