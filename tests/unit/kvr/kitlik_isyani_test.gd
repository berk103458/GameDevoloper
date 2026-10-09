extends SceneTree
var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var y := hazir()
	var olaylar: Array[Dictionary] = []
	var sinyaller: Array[Dictionary] = []
	y.kitlik_tetiklendi.connect(func(r: Dictionary) -> void: sinyaller.append(r))
	var rng := y._rng.state
	dene(not KitlikIsyani.gece(y, olaylar) and KitlikIsyani.durum(y).kitlik_gece_sayisi == 1, "İlk sıfır gece yalnız sayaç")
	KitlikIsyani.gece(y, olaylar)
	dene(KitlikIsyani.durum(y).kitlik_gece_sayisi == 1, "Aynı gece sayaç ilerlemez")
	y.gun += 1
	var once := y.kaynaklar.stok.duplicate()
	dene(KitlikIsyani.gece(y, olaylar), "İkinci sıfır gece mevcut isyan tetiklenir")
	dene(y.isyan_kalan == y.a.isyan_gun and sinyaller.size() == 1, "Tek isyan/sinyal, ekstra firar yok")
	var r: Dictionary = sinyaller[0]
	var toplam := 0
	for tur in r.yagma:
		toplam += int(r.yagma[tur])
		dene(int(r.yagma[tur]) <= KitlikIsyani.TUR_TAVAN and y.kaynaklar.miktar(tur) == int(once[tur]) - int(r.yagma[tur]), "Tür tavanı ve gerçek stok makbuzu")
	dene(toplam <= KitlikIsyani.YAGMA_TAVAN and toplam > 0, "Toplam tavanlı gerçek yağma")
	for tur in KitlikIsyani.KORUNAN: dene(y.kaynaklar.miktar(tur) == int(once[tur]), "Yiyecek/su/yem yağmalanmaz")
	dene(y.huzur() == 72 and y.kaynaklar.kapasite == 800, "Moral/huzur ve onarıma kadar düşük kapasite")
	dene(r.guvenlik == maxi(0, KervanKorumasi.guvenlik(y) - 20), "Muhafızlar ikinci kez eklenmez")
	dene(y._rng.state == rng, "Tetik/yağma RNG çekmez")
	var kilitli := JSON.stringify(y.kaydet())
	KitlikIsyani.gece(y, olaylar)
	dene(JSON.stringify(y.kaydet()) == kilitli and sinyaller.size() == 1, "Tetik gecesi tekrar atomik")
	y._isyan(olaylar)
	dene(JSON.stringify(y.kaydet()) == kilitli and y._rng.state == rng, "Aynı tetik gecesi mevcut _isyan tekrar firar/zar çalıştırmaz")
	y.gun += 1
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	dene(KitlikIsyani.durum(geri) == KitlikIsyani.durum(y) and geri.kaynaklar.kapasite == 800, "JSON dönüşünde kilit ve kapı korunur")
	dene(not KitlikIsyani.gece(geri, olaylar), "Restore aynı kıtlığı yağmalamaz")
	var kisa := y.kaynaklar.stok.duplicate()
	dene(not KitlikIsyani.gece(y, olaylar) and y.kaynaklar.stok == kisa, "Kesintisiz kıtlık ikinci yağma üretmez")
	dene(KitlikIsyani.onar(y) and y.kaynaklar.kapasite == 1000 and not KitlikIsyani.durum(y).kapi_kirik, "Taş+kereste onarımı kapasiteyi geri getirir")
	dene(y.kaynaklar.miktar("tas") == int(kisa.tas) - 4 and y.kaynaklar.miktar("kereste") == int(kisa.kereste) - 6, "Tam onarım bedeli")
	var tam := JSON.stringify(y.kaydet())
	dene(not KitlikIsyani.onar(y) and JSON.stringify(y.kaydet()) == tam, "İkinci onarım bedel kesmez")
	y.gun += 1
	KitlikIsyani.gece(y, olaylar)
	dene(not KitlikIsyani.durum(y).kapi_kirik, "Onarım kıtlık kilidini açmaz")
	y.kaynaklar.ekle("gida", 1)
	dene(KitlikIsyani.durum(y).kitlik_gece_sayisi == 0 and not KitlikIsyani.durum(y).tetiklendi, "Erzak girişi anında seriyi sıfırlar")
	y.kaynaklar.azalt("gida", 1)
	y.gun += 1
	dene(not KitlikIsyani.gece(y, olaylar), "Gelen erzak tüketilirse yeni serinin ilk gecesi")
	y.gun += 1
	dene(KitlikIsyani.gece(y, olaylar) and sinyaller.size() == 2, "Ayrı kıtlık yeniden tetiklenebilir")
	y.kaynaklar.azalt("kereste", 1000)
	tam = JSON.stringify(y.kaydet())
	dene(not KitlikIsyani.onar(y) and JSON.stringify(y.kaydet()) == tam, "Eksik kaynakta onarım atomik reddedilir")
	y.kaynaklar.ekle("gida", 3)
	dene(KitlikIsyani.durum(y).kapi_kirik and KitlikIsyani.durum(y).kitlik_gece_sayisi == 0, "Erzak kapıyı kendiliğinden onarmaz")
	var eski := y.kaydet()
	eski.erase("kitlik_isyani")
	dene(not KitlikIsyani.durum(KoyYonetimi.kayittan(y.a, y.katalog, eski)).kapi_kirik, "Legacy kayıtta hayalet kapı hasarı yok")
	for bozuk in [null, [], "x", {"kitlik_gece_sayisi": 2.5, "son_gece": "x", "tetiklendi": "evet", "kapi_kirik": 1}, {"kitlik_gece_sayisi": NAN, "son_gece": INF}]:
		dene(KitlikIsyani.oku(bozuk) == KitlikIsyani.oku({}), "Bozuk optional kayıt güvenli")
	var dusuk := hazir()
	var yuksek := hazir()
	dusuk.asayis_riski = 100
	yuksek.asayis_riski = 0
	for model in [dusuk, yuksek]:
		KitlikIsyani.gece(model, olaylar)
		model.gun += 1
		KitlikIsyani.gece(model, olaylar)
	dene(yuksek.kaynaklar.miktar("tas") > dusuk.kaynaklar.miktar("tas"), "Yüksek tek Güvenlik yağmayı azaltır")
	var nobetli := hazir()
	nobetli.agalik = true
	nobetli.asayis_riski = 50
	var asker := nobetli.kabul({"sinif": "asker", "stat": 10})
	asker.moral = 100
	asker.saglik = 100
	dene(nobetli.muhafiz_ata(asker.id), "Gerçek muhafız ataması")
	var tek := KervanKorumasi.guvenlik(nobetli)
	dene(nobetli.etkin_muhafiz_sayisi() == 1 and tek > 50 and KitlikIsyani.koruma(nobetli) == tek, "Etkin devriye mevcut Güvenlik üzerinden bir kez")
	nobetli.maas_durumu[str(asker.id)] = {"borc": 1}
	dene(nobetli.etkin_muhafiz_sayisi() == 0 and KitlikIsyani.koruma(nobetli) == KervanKorumasi.guvenlik(nobetli) and KitlikIsyani.koruma(nobetli) < tek, "Borçlu nöbetçi ek yağma koruması vermez")
	var atlanan := hazir()
	KitlikIsyani.gece(atlanan, olaylar)
	atlanan.gun += 2
	dene(not KitlikIsyani.gece(atlanan, olaylar) and KitlikIsyani.durum(atlanan).kitlik_gece_sayisi == 1, "Atlanmış gün ardışık gece sayılmaz")
	# Cenaze makbuzu kıtlığın ayrı moral kaybını geri iade etmez.
	var yasli := hazir()
	var olen := yasli.kabul({"ad": "Yas nedeni"})
	var onceki: Array[Koylu] = yasli.koylular.duplicate()
	yasli.koylular.erase(olen)
	var yas_raporu := {"olenler": [olen.ad], "olaylar": olaylar}
	CenazeYasi.gece(yasli, yas_raporu, onceki)
	KitlikIsyani.gece(yasli, olaylar)
	yasli.gun += 1
	KitlikIsyani.gece(yasli, olaylar)
	dene(yasli.koylular[0].moral == 69, "Yas −3 ve kıtlık −8 ayrı etkiler")
	CenazeYasi.kaldir(yasli)
	dene(yasli.koylular[0].moral == 72, "Yas iadesi kıtlık moralini silmez")
	var bos := hazir()
	bos.koylular.clear()
	for i in 3:
		KitlikIsyani.gece(bos, olaylar)
		bos.gun += 1
	dene(not KitlikIsyani.durum(bos).tetiklendi, "Nüfussuz köyde isyan yok")
	var aktif := hazir()
	aktif.isyan_kalan = 1
	for i in 2:
		KitlikIsyani.gece(aktif, olaylar)
		aktif.gun += 1
	dene(aktif.isyan_kalan == 1, "Mevcut isyan süresi uzatılmaz")
	# Tam dolu ambar: EKO-12 taşma kaybı yağma değildir, aynı raporda bir kez.
	var dolu := hazir()
	dolu.kaynaklar = Kaynaklar.new(1000, {"tas": 500, "kereste": 500})
	var tasma_olay: Array[Dictionary] = []
	KitlikIsyani.gece(dolu, tasma_olay)
	dolu.gun += 1
	KitlikIsyani.gece(dolu, tasma_olay)
	dene(dolu.kaynaklar.toplam() == 800 and dolu.kaynaklar.bakim.tasma.is_empty(), "Kapasite düşüşü EKO-12 sınırını korur, tekrar raporlanmaz")
	dene(tasma_olay.any(func(e: Dictionary) -> bool: return e.get("anahtar") == "koy.olay.ambar_ziyan"), "Taşma gece raporunda ayrı görünür")
	var rapor := {"olaylar": tasma_olay, "ziyan": {}}
	KitlikIsyani.raporla(dolu, rapor)
	dene(rapor.ziyan.tasma.kereste == 190, "Yağmadan sonraki 190 kapasite kaybı bilanço alanında")
	var oturum := Oturum.new(kat, 306)
	oturum.yonetim = hazir()
	var model := oturum.yonetim
	model.gun = 1
	model.kaynaklar = Kaynaklar.new(1000, {"tas": 500, "kereste": 500})
	model.set_meta(KitlikIsyani.META, {"kitlik_gece_sayisi": 1, "son_gece": 0})
	var fotograf := GeceBilancosu.fotograf(oturum)
	var gece := model.gece()
	var bilanco := GeceBilancosu.olustur(oturum, fotograf, gece)
	dene(bilanco.stok.kereste.tasma_gece == 190 and bilanco.stok.kereste.diger_net == -5 and bilanco.stok.tas.diger_net == -5, "Gerçek gece bilançosunda kapasite kaybı ve yağma ayrı mutabık")
	var gozlem := JSON.stringify(y.kaydet())
	KitlikIsyani.metin(y)
	dene(JSON.stringify(y.kaydet()) == gozlem and y._rng.state == rng, "Bilgi/onarım/giriş RNG değiştirmez")
	print("KITLIK İSYANI TEST: GEÇTİ" if hata == 0 else "KITLIK İSYANI TEST: KALDI")
	quit(hata)

func hazir() -> KoyYonetimi:
	var a := kat.koy_ayarlari.duplicate(true) as KoyAyarlari
	a.ambar_taban_kapasite = 1000
	var y := KoyYonetimi.new(a, kat.binalar, 306)
	y.kabul({"ad": "Kıtlık köylüsü"})
	y.koylular[0].moral = 80
	y.asayis_riski = 70
	y.kaynaklar = Kaynaklar.new(1000, {"tas": 30, "kereste": 40, "odun": 40, "alet": 40, "demir": 40, "kurk": 40, "bugday": 5, "un": 5, "su": 5, "saman": 5})
	return y

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
