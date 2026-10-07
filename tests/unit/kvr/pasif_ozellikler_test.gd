extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 97)
	var rng := o.yonetim._rng.state
	for i in 30:
		var id := StringName("chr_%03d" % (i + 1))
		var kaynak: KarakterVerisi = kat.karakter(id)
		var p := kaynak.pasif_ozellikler
		_kontrol(p["guclu"].size() == 1 and p["zayif"].size() == 1 and PasifOzellikler.GUCLU.has(p["guclu"][0]) and PasifOzellikler.ZAYIF.has(p["zayif"][0]), "Gerçek CHR çiftine katalogdan iki ayrı yön atanır: " + String(id))
		var g := o._adli_gelen(id)
		var k := o.yonetim.kabul({"adli_id": id, "sinif": g.sinif})
		_kontrol(k.pasif_ozellikler == p, "Kabul çift matrisi taşır")
		p["guclu"].clear()
		_kontrol(k.pasif_ozellikler["guclu"].size() == 1 and kaynak.pasif_ozellikler["guclu"].size() == 1, "Resource/model/diğer ziyaret kopyaları ayrıdır")
		var veri := k.kaydet()
		_kontrol(Koylu.kayittan(JSON.parse_string(JSON.stringify(veri))).pasif_ozellikler == k.pasif_ozellikler, "Gerçek çift JSON'da korunur")
		veri.erase("pasif_ozellikler")
		_kontrol(Koylu.kayittan(veri).pasif_ozellikler == k.pasif_ozellikler, "Eski CHR kaydı kaynak eşlemesinden tamamlanır")
	_kontrol(kat.karakter(&"chr_003").pasif_ozellikler == {"guclu": ["zanaat_ustasi"], "zayif": ["gecmis_yuku"]}, "Haydar: ustalık / geçmişin yükü")
	_kontrol(kat.karakter(&"chr_011").pasif_ozellikler == {"guclu": ["agir_yuk_ustasi"], "zayif": ["hirsizliga_meyilli"]}, "İdris: güçlü omuzlar / tahıl hırsızlığı")
	_kontrol(kat.karakter(&"chr_021").pasif_ozellikler["guclu"][0] == "gece_nobetcisi", "Cemil: eski piyade nöbet gücü")
	var cesitler := {}
	for i in 12:
		var k := o.yonetim.kabul({"sinif": "ciftci"})
		cesitler[str(k.pasif_ozellikler)] = true
		var v := k.kaydet()
		v.erase("pasif_ozellikler")
		_kontrol(Koylu.kayittan(v).pasif_ozellikler == k.pasif_ozellikler, "Eski üretilen köylü aynı çiftle açılır")
	_kontrol(cesitler.size() > 3 and o.yonetim._rng.state == rng, "Deterministik çiftler çeşitlidir; oyun RNG'si tüketilmez")
	var normal := Oturum.new(kat, 99)
	var r := normal.karar_ver(normal._adli_gelen(&"chr_003"), &"kabul")
	_kontrol(normal.yonetim.koylu(r["koylu_id"]).pasif_ozellikler == kat.karakter(&"chr_003").pasif_ozellikler, "Gerçek kapı kararı trait çiftini taşır")
	var fallback := PasifOzellikler.cift(&"chr_003", &"esnaf")
	for bozuk in [null, {}, {"guclu": ["uydurma"], "zayif": ["korkak"]}, {"guclu": ["cesur", "sessiz"], "zayif": []}, {"guclu": "cesur", "zayif": ["korkak"]}]:
		_kontrol(PasifOzellikler.oku(bozuk, fallback) == fallback, "Geçersiz matris güvenli çifte döner")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.koylular.back().pasif_ozellikler == o.yonetim.koylular.back().pasif_ozellikler, "Tam oturum kaydı matrisi korur")
	print("PASİF ÖZELLİKLER: GEÇTİ" if hata == 0 else "PASİF ÖZELLİKLER: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
