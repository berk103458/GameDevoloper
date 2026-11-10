extends SceneTree
## SOY-18/19: muhafız meclis önünde söze "doğru"/"yalan" der; nitelik kayıtta muhafız düğümüdür, yanlışı −1.
## Doğru sözü yalanlamak tanıklı "muhafızın yalanı" DIY-13 kaydı açar; tanık yoksa açmaz.

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


func _koy(kat: Katalog) -> Oturum:
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in 20:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	for i in 2:
		o.gece_sonu()
	return o


func _yalan_kaydi(o: Oturum) -> int:
	return o.dedikodu.kayitlar().filter(func(k: Dictionary) -> bool: return k.tur == "muhafizin_yalani").size()


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := _koy(kat)
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var konu: Dictionary = a.meclis_sikayeti_sec()
	dene(not konu.is_empty(), "Meclis şikâyeti var")
	var g: int = a.guvenilirlik_al(SoylentiKoprusu.MUHAFIZ)
	dene(not SoylentiKoprusu.nitele(o, false).is_empty(), "Muhafız söze yalan dedi")
	dene(a.ag_kayitlari[konu.olay_id].muhafiz_dugumu.nitelik == "yalan", "Muhafız düğümü kayıtta")
	dene(a.guvenilirlik_al(SoylentiKoprusu.MUHAFIZ) == g - 1, "Yanlış nitelik muhafızı −1")
	dene(_yalan_kaydi(o) == 1, "Tanıklı yalan DIY-13 kaydı 1")
	dene(SoylentiKoprusu.nitele(o, true).is_empty(), "Aynı konu ikinci kez nitelenmez")
	o = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(SoylentiKoprusu.ag(o).ag_kayitlari[konu.olay_id].has("muhafiz_dugumu") and _yalan_kaydi(o) == 1, "Kayıttan döner")
	var d := _koy(kat)
	var ad: RefCounted = SoylentiKoprusu.ag(d)
	SoylentiKoprusu.nitele(d, true)
	dene(ad.guvenilirlik_al(SoylentiKoprusu.MUHAFIZ) == mini(3, g + 1) and _yalan_kaydi(d) == 0, "Doğru nitelik +1, yalan kaydı yok")
	var t := _koy(kat)
	var tk := t.yonetim.koylu(int(SoylentiKoprusu.ag(t).meclis_sikayeti_sec().kaynak))
	t.yonetim.surgun(tk.id)
	dene(SoylentiKoprusu.nitele(t, false).is_empty() and _yalan_kaydi(t) == 0, "Tanık köyde yoksa kayıt 0")
	print("SÖYLENTİ MUHAFIZ: GEÇTİ" if hata == 0 else "SÖYLENTİ MUHAFIZ: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
