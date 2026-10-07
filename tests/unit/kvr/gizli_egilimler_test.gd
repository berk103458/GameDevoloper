extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 71)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 100
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	var karar := o.karar_ver(o._adli_gelen(&"chr_004"), &"kabul")
	var k := y.koylu(karar["koylu_id"])
	k.stat = 5
	k.moral = 50
	var b := _kur(y)
	y.ata(k.id, b.id)
	_kontrol(k.gizli_egilim["tur"] == "haydut" and GizliEgilimler.oyuncu_metin(k) == "Gizli eğilimler bilinmiyor", "Gerçek kapı kabulü gizli haydut eğilimini taşır; oyuncuya açıklamaz")
	y._rng.seed = _tohum(false)
	var gida := y.kaynaklar.miktar("gida")
	var rapor := y.gece()
	_kontrol(int(rapor["uretim"]["gida"]) == 2 and k.gizli_egilim["calinan"] == 3 and y.kaynaklar.miktar("gida") == gida + 2 - 3 - int(rapor["tuketim"]["gida"]), "Gündüz gerçek üretim sürer; gece ambar/tüketim üç erzak kaybını kullanır")
	var kayiplar: Array = rapor["olaylar"].filter(func(e: Dictionary) -> bool: return e["anahtar"].begins_with("Gece ambardan"))
	_kontrol(kayiplar.size() == 1 and kayiplar[0]["deger"] == [3] and not k.bayrak_var("hirsiz"), "Yakalanmamış faili gece raporu ifşa etmez")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	_kontrol(geri.yonetim.koylu(k.id).gizli_egilim == k.gizli_egilim and geri.yonetim._rng.state == y._rng.state, "Gizli sayaç ve RNG JSON ile korunur")
	y._rng.seed = _tohum(true)
	geri.yonetim._rng.seed = _tohum(true)
	var yakalama := y.gece()
	geri.yonetim.gece()
	_kontrol(k.bayrak_var("hirsiz") and k.gizli_egilim["yakalanma"] and k.gizli_egilim["calinan"] == 3 and yakalama["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("yakalandı")), "Gerçek nöbet yakalaması girişimi durdurur, açık bayrak ve rapor üretir")
	_kontrol(y._rng.state == geri.yonetim._rng.state and k.gizli_egilim == geri.yonetim.koylu(k.id).gizli_egilim, "Yükleme aynı sonraki yakalama sonucunu üretir")
	_kontrol(GizliEgilimler.oyuncu_metin(k) == "Hırsızlık açığa çıktı", "Oyuncu bilgisi yalnız açık kanıttan sonra")
	for id in [&"chr_025", &"chr_028", &"chr_030"]:
		var masum := y.kabul({"adli_id": id, "gizli": ["hirsiz"]})
		_kontrol(masum.gizli_egilim["tur"] == "yok", "Yeni CHR aile hikâyesi eski hirsiz flaginden öncelikli: " + String(id))
	var firsatci := y.kabul({"gizli": ["hirsiz"]})
	_kontrol(firsatci.gizli_egilim["tur"] == "firsatci" and GizliEgilimler.risk(firsatci) == 0.0, "Genel hırsızlık eğilimi tok/sadıkken pasif")
	firsatci.ac = true
	_kontrol(GizliEgilimler.risk(firsatci) == 0.35, "Açlık fırsat riskini açar")
	y.kaynaklar.stok["gida"] = 0
	var rng := y._rng.state
	GizliEgilimler.gece(y, {}, [])
	_kontrol(y._rng.state == rng, "Boş ambarda suç zarı/negatif stok yok")
	# İzole sınırlar: bir erzak tümüyle alınır; hastalık suç zarı tüketmez.
	var sinir := Oturum.new(kat, 81).yonetim
	var haydut := sinir.kabul({"gizli": ["haydut"]})
	sinir.kaynaklar.stok["gida"] = 1
	sinir._rng.seed = _tohum(false)
	# Örtüsüz yakalama %10; güvenli başarısız yakalama tohumu seç.
	var zar := RandomNumberGenerator.new()
	for n in range(1, 10000):
		zar.seed = n
		if zar.randf() < 0.2 and zar.randf() >= 0.10:
			sinir._rng.seed = n
			break
	GizliEgilimler.gece(sinir, {}, [])
	_kontrol(sinir.kaynaklar.miktar("gida") == 0 and haydut.gizli_egilim["calinan"] == 1, "Bir erzak sınırı: gerçek kayıp sayılır, negatif stok oluşmaz")
	sinir.kaynaklar.stok["gida"] = 5
	haydut.bayrak_ac("hasta")
	var hasta_rng := sinir._rng.state
	GizliEgilimler.gece(sinir, {}, [])
	_kontrol(sinir._rng.state == hasta_rng and sinir.kaynaklar.miktar("gida") == 5, "Hasta haydut suç işlemez ve RNG tüketmez")
	var once := o.kaydet()
	KoyluDenetcisi.satirlar(o)
	_kontrol(o.kaydet() == once and GizliEgilimler.debug_metin(k).contains("DEBUG"), "Geliştirici gizli denetimi salt okunur ve açıkça debug")
	var eski := k.kaydet()
	eski.erase("gizli_egilim")
	_kontrol(Koylu.kayittan(eski).gizli_egilim["tur"] == "haydut", "Eski kayıtta güvenli kaynak eğilimi")
	for bozuk in [null, {}, {"tur": "haydut", "calinan": -1, "son_gece": 0, "yakalanma": false}, {"tur": "yok", "calinan": 1.5, "son_gece": 0, "yakalanma": false}]:
		_kontrol(GizliEgilimler.oku(bozuk, k) == GizliEgilimler.kaynak(k), "Bozuk gizli kayıt kaynak varsayılanına döner")
	print("GİZLİ EĞİLİMLER: GEÇTİ" if hata == 0 else "GİZLİ EĞİLİMLER: KALDI")
	quit(hata)
func _tohum(yakala: bool) -> int:
	var zar := RandomNumberGenerator.new()
	var n := 1
	while true:
		zar.seed = n
		var hirsizlik := zar.randf()
		var yakalama := zar.randf()
		if hirsizlik < 0.2 and ((yakalama < 0.05) == yakala): return n
		n += 1
	return n
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var b := y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
