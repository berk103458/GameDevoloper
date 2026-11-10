extends SceneTree
## SOY-22: kapıda tanıklı rüşvet kamuoyu olunca gerçek gece sonundaki sancak teftişi onu bir kez sorar.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _teftis(o: Oturum) -> Dictionary:
	return SancakTeftisi.oku(o.sancak_teftisi)


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.karar_ver(_gelen("rusvetci"), &"rusvet")
	for i in 15:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	o.gece_sonu()
	dene(int(_teftis(o).son_gece) == 6 and int(_teftis(o).get("soylenti_sorusu", 0)) == 0, "Kamuoyu olmadan teftiş söylentiyi sormaz")
	var gece := 0
	while int(_teftis(o).son_gece) < 11 and gece < 8:
		o.gece_sonu()
		gece += 1
	var d := _teftis(o)
	dene(int(d.son_gece) == 11 and int(d.get("soylenti_sorusu", 0)) == 1, "Kamuoyu olan rüşvet teftişte sorulur")
	dene(SancakTeftisi.olay_metin(d).contains(TranslationServer.translate("koy.sancak.soylenti_sorusu")), "Sabah kartı soruyu söyler")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(int(_teftis(geri).get("soylenti_sorusu", 0)) == 1, "Soru kayıttan döner")
	var ikinci := {}
	SoylentiKoprusu.teftis(o, ikinci)
	dene(SoylentiKoprusu.ag(o).teftis_sorulari.is_empty() and not ikinci.has("soylenti_sorusu"), "Aynı olay ikinci teftişte sorulmaz")
	print("SÖYLENTİ TEFTİŞ: GEÇTİ" if hata == 0 else "SÖYLENTİ TEFTİŞ: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
