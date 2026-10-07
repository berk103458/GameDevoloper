extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 17)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.a.tok_moral = 0
	y.a.evsiz_moral = 0
	y.a.guvensiz_moral = 0
	y.a.adaletsiz_moral = 0
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	y.kaynaklar.stok["alet"] = 0
	var b := _kur(y)
	var k := y.kabul({"sinif": "ciftci", "stat": 5})
	k.moral = 50
	_kontrol(y.ata(k.id, b.id), "Fiilî tarla ataması")
	var rng := y._rng.state
	y.gece()
	_kontrol(k.moral == 52 and y._rng.state == rng, "Uyumlu gerçek üretim +2 moral; sabotaj zarı yok")
	y.bosalt(k.id)
	y.gece()
	_kontrol(k.moral == 52, "Boşta iş morali uydurulmaz")
	k.zanaat_turu = ZanaatTuru.Tur.BELIRSIZ
	y.ata(k.id, b.id)
	y.gece()
	_kontrol(k.moral == 52, "Belirsiz meslek nötr")
	k.zanaat_turu = ZanaatTuru.Tur.ASKER
	k.pasif_ozellikler = {"guclu": ["cesur"], "zayif": ["korkak"]}
	k.moral = 19
	var esik := IsMemnuniyeti.esik(k)
	_kontrol(esik == 20 and IsMemnuniyeti.isyanci(k, y), "Kişisel eşik yanlış işe bağımsız iş reddi getirir")
	var once := y.kaynaklar.miktar("gida")
	y._rng.seed = _tohum(0.12)
	var rapor := y.gece()
	_kontrol(rapor["uretim"].is_empty() and k.moral == 17, "İsyancı kendi üretimini durdurur, uyumsuz iş morali azalır")
	_kontrol(rapor["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("sabotaj yaptı")) and y.kaynaklar.miktar("gida") == once - 3 - int(rapor["tuketim"]["gida"]), "Gerçek gece sabotajı gerçek ambar ve rapora işler")
	_kontrol(k.sadakat == 58, "Sabotaj kişisel sadakati azaltır")
	k.pasif_ozellikler["zayif"] = ["inatci"]
	_kontrol(IsMemnuniyeti.esik(k) == 30, "İnatçı kişisel eşik 30")
	k.pasif_ozellikler = {"guclu": ["dayanikli"], "zayif": ["korkak"]}
	_kontrol(IsMemnuniyeti.esik(k) == 10, "Dayanıklı kişisel eşik 10")
	k.zanaat_turu = ZanaatTuru.Tur.CIFTCI
	_kontrol(not IsMemnuniyeti.isyanci(k, y) and IsMemnuniyeti.sabotaj_riski(k, y) == 0.0, "Sevdiği işe atama kişisel iş reddini kaldırır")
	k.moral = 50
	y.muhafiz_ata(k.id)
	_kontrol(is_equal_approx(IsMemnuniyeti.sabotaj_riski(k, y), 0.04), "Zorla nöbet yüksek moralle %4 sabotaj")
	k.moral = 10
	_kontrol(is_equal_approx(IsMemnuniyeti.sabotaj_riski(k, y), 0.24) and y.muhafiz_sayisi() == 1 and y.etkin_muhafiz_sayisi() == 0, "İsyan eşiği altında zorla nöbet %24; yuva korunur, etkin savunma yok")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	_kontrol(IsMemnuniyeti.isyanci(geri.yonetim.koylu(k.id), geri.yonetim) and geri.yonetim._rng.state == y._rng.state, "Kayıt aynı eşik/isyancı/RNG sonucunu korur")
	y.akce = 100
	geri.yonetim.akce = 100
	y.gece()
	geri.yonetim.gece()
	_kontrol(k.moral == geri.yonetim.koylu(k.id).moral and k.sadakat == geri.yonetim.koylu(k.id).sadakat and y.kaynaklar.kaydet() == geri.yonetim.kaynaklar.kaydet() and y._rng.state == geri.yonetim._rng.state, "Yükleme aynı gerçek sonraki geceyi üretir")
	var snapshot := o.kaydet()
	var satirlar := KoyluDenetcisi.satirlar(o)
	_kontrol(o.kaydet() == snapshot and satirlar[0]["memnuniyet"].contains("kişisel isyan eşiği"), "Canlı eşik/uyum bilgisi salt okunur")
	print("İŞ MEMNUNİYETİ: GEÇTİ" if hata == 0 else "İŞ MEMNUNİYETİ: KALDI")
	quit(hata)
func _tohum(risk: float) -> int:
	var zar := RandomNumberGenerator.new()
	var n := 1
	while true:
		zar.seed = n
		if zar.randf() < risk: return n
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
