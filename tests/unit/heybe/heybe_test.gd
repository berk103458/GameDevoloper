## Heybe ve rüşvet kuralları (design/gdd/heybe-ve-rusvet.md). gdUnit4 kurulana kadar düz betik:
##   godot --headless --path . -s tests/unit/heybe/heybe_test.gd   (çıkış kodu 0 = hepsi geçti)
extends SceneTree

var _hata := 0


func _init() -> void:
	_heybe_kurallari()
	_oturum_kararlari()
	_uretim_belirlenimci()
	print("HEYBE TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])


func _ornek(yalanci: bool) -> Heybe:
	var h := Heybe.new()
	h.ekle("akce", "akce", 1, 6, false)
	h.ekle("arpa", "gida", 4, 1, false)
	if yalanci:
		h.ekle("akce", "akce", 1, 20, true)
		h.ekle("yuzuk", "mal", 9, 1, true)
	h.teklif = 3
	return h


func _heybe_kurallari() -> void:
	var h := _ornek(true)
	_esit("beyan akçe", h.beyan_akce(), 6)
	_esit("gizliler görünmez", h.gorunenler().size(), 2)
	_esit("yoklamadan yakalanmaz", h.yakalandi(), false)
	_esit("astardan çıkan", h.astar_yokla().size(), 2)
	_esit("yakalandı", h.yakalandi(), true)
	_esit("artık görünür", h.gorunenler().size(), 4)
	h.teklifi_sec()
	_esit("teklif kadar akçe", h.alinan_deger(), 3)
	_esit("teklif gasp değil", h.gasp(), 0)
	h.al(h.esyalar[1], 1)
	_esit("teklif üstü beyan gasp", h.gasp(), 4)
	h.saklananlari_sec()
	_esit("saklananlar gasp sayılmaz", h.gasp(), 4)
	_esit("dağılım", h.alinan_dagilim(), {"akce": 3 + 20 + 9, "ambar": 4})
	h.al(h.esyalar[0], 99)
	_esit("adet sınırı", int(h.esyalar[0]["alinan"]), 6)
	var d := _ornek(false)
	d.astar_yokla()
	_esit("dürüstte yakalanma yok", d.yakalandi(), false)


func _oturum_kararlari() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		_esit("katalog", k.hatalar, [])
		return
	# Rüşvet, seçim yok: teklif kadar akçe, bar etkisinden başka bedel yok.
	var o := Oturum.new(k, 7)
	var g := Gelen.new()
	g.heybe = _ornek(false)
	var akce := o.akce
	var s := o.karar_ver(g, &"rusvet")
	_esit("rüşvet teklif", o.akce, akce + 3)
	_esit("rüşvet gasp yok", s["gasp"], false)
	# El koy: saklananların hepsi, tepside yalnız arpa olsa bile; gelen kalmaz.
	o = Oturum.new(k, 7)
	g = Gelen.new()
	g.heybe = _ornek(true)
	g.heybe.astar_yokla()
	g.heybe.al(g.heybe.esyalar[1], 1)
	akce = o.akce
	var ambar := o.ambar
	var adalet := o.yonetim.adalet
	s = o.karar_ver(g, &"elkoy")
	_esit("el koy akçe", o.akce, akce + 29)
	_esit("el koy ambar", o.ambar, ambar + 4)
	_esit("el koy geri çevirir", s["kaldi"], false)
	_esit("arpa teklif üstü: gasp", s["gasp"], true)
	_esit("gasp adalet bedeli", o.yonetim.adalet, adalet - k.ayarlar.gasp_halk_cezasi * Oturum.KOPRU_ADALET)
	# Dürüst birinin astarını yoklamak: köyün morali düşer.
	o = Oturum.new(k, 7)
	var tanik := o.yonetim.kabul({"ad": "tanık"})
	g = Gelen.new()
	g.heybe = _ornek(false)
	g.heybe.astar_yokla()
	var moral := tanik.moral
	s = o.karar_ver(g, &"kabul")
	_esit("dürüst arandı", s["durust_arandi"], true)
	_esit("dürüst arama bedeli", tanik.moral, moral - k.ayarlar.durust_arama_cezasi * Oturum.KOPRU_MORAL)


func _uretim_belirlenimci() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		return
	var a := Oturum.new(k, 99)
	var b := Oturum.new(k, 99)
	var yalan := 0
	for i in 200:
		var x := a.heybe_uret(&"esnaf")
		var y := b.heybe_uret(&"esnaf")
		_esit("aynı tohum aynı heybe %d" % i, str(x.esyalar), str(y.esyalar))
		var beyan := x.beyan_akce()
		if beyan < k.ayarlar.beyan_akce_min or beyan > k.ayarlar.beyan_akce_max:
			_esit("beyan aralığı", beyan, "aralıkta")
		_esit("teklif ≥ 1", x.teklif >= 1, true)
		if x.yalan_var():
			yalan += 1
	# 200 çekilişte yalan oranı ayarın kabaca çevresinde (0.35 ± 0.15).
	var oran := yalan / 200.0
	_esit("yalan oranı makul", absf(oran - k.ayarlar.yalan_olasiligi) < 0.15, true)
