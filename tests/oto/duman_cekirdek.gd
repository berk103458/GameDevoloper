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
	return {"olur": true, "gece": geceler, "gun": o.gun, "hafiza_once": hafiza_once,
		"hafiza_son": int(Performance.get_monitor(Performance.MEMORY_STATIC))}
