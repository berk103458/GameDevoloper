extends SceneTree
## SOY-17: kafileyi ailece içeri almak olumlu söylentidir; kamuoyu olunca halk barı bir kez +1, meclise şikâyet olmaz.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"ciftci"
	return g


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3030)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	var kafile := _gelen("")
	kafile.aile_id = "test_kafile"
	kafile.aile = [{"ad": "Reis"}, {"ad": "Eş"}, {"ad": "Oğul", "yas_grubu": "cocuk"}]
	var r := o.karar_ver(kafile, &"kabul")
	dene(int(r.get("kabul_edilen", 0)) == 3, "Kafile ailece kabul edildi")
	for i in 20:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var kayit: Array = a.ag_kayitlari.values().filter(func(k: Dictionary) -> bool: return k.tur == "aile_birlikte_alma" and not k.has("asil"))
	dene(kayit.size() == 1, "Ailece kabul olumlu söylenti kaydı açar")
	var satir := false
	for i in 4:
		var rapor := o.gece_sonu()
		for x in rapor.get("olaylar", []):
			satir = satir or str(x.get("deger", "")).contains("ailece")
	dene(not kayit.is_empty() and bool(kayit[0].kamuoyu_oldu), "Olumlu söylenti kamuoyu oldu")
	dene(int(a.bar_degisimi_toplam) == int(a.veri_yapilandirma.iyi_olay_bar_etkisi) and int(a.bar_degisimi_toplam) == 1, "Halk barı bir kez +1")
	dene(satir, "Sabah raporunda olumlu satır")
	dene(SoylentiKoprusu.meclis_sikayeti(o).is_empty() and a.meclis_sikayeti_sec().is_empty(), "Olumlu konu meclise şikâyet olmaz")
	dene(int(a.histeri_tetik_sayisi) == 0, "Olumlu söylentinin kopyası histeri beslemez")
	print("SÖYLENTİ İYİ OLAY: GEÇTİ" if hata == 0 else "SÖYLENTİ İYİ OLAY: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
