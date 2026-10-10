extends SceneTree
const H = preload("res://src/koy/batil_inanc_histerisi.gd")
var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_tetik_ve_gizlilik()
	_koruma_ve_kayit()
	_haksizlik()
	_gercek_ve_oy()
	_diger_krizler()
	_bozuk_ve_legacy()
	_donem_ve_kilitler()
	print("BATIL İNANÇ HİSTERİSİ: GEÇTİ" if hata == 0 else "BATIL İNANÇ HİSTERİSİ: KALDI")
	quit(hata)

func hazir() -> Oturum:
	var o := Oturum.new(kat, 808)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.a.isyan_esigi = -1
	y.a.emniyet_nufus = 100000
	y.kaynaklar = Kaynaklar.new(10000, {"gida": 200, "su": 100, "kirec": 10, "odun": 100, "tas": 100, "kereste": 100})
	y.akce = 200
	y.gun = 6
	o.muhafiz_akce = 77
	for idx in 4:
		var k := y.kabul({"ad": "Komşu %d" % idx})
		k.moral = 60
		k.sadakat = 80
	return o

func hedef(o: Oturum) -> Koylu:
	return o.yonetim.kabul({"ad": "Otacı Dudu Hatun", "adli_id": "chr_008", "sinif": "esnaf"})

func baslat(o: Oturum) -> void:
	KuyuKirliligi.kirlet(o.yonetim)
	FisiltiGazetesi.gece(o.yonetim, [])

func geri(o: Oturum) -> Oturum:
	return Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))

func _tetik_ve_gizlilik() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := hedef(o)
	SaglikYoneticisi.enfekte(y, y.koylular[0], "veba")
	FisiltiGazetesi.gece(y, [])
	dene(not H.bekliyor(y), "Sakin köy/gizli kuluçka histeri tetiklemez")
	y.gun += 1
	var ilk_secim := geri(o)
	ilk_secim.yonetim.koylular.reverse()
	for kisi in ilk_secim.yonetim.koylular:
		kisi.ad = "Farklı açık ad"
		kisi.adli_id = &"chr_030"
		kisi.gizli_bayraklar = ["sir", "casus"]
		kisi.gizli_egilim.tur = "haydut"
	baslat(ilk_secim)
	baslat(o)
	dene(H.durum(ilk_secim.yonetim).vaka == H.durum(y).vaka, "İlk hedef seçimi de ad/CHR/gizli bilgi/dizi sırasından bağımsız")
	dene(H.bekliyor(y) and H.durum(y).vaka.hedef == k.id and H.durum(y).vaka.seviye == 1, "Kirli kuyuda açık otacı hedefi, ilk gece 1/3")
	dene(not DivanHukmu.verildi(y, k.id) and DivanOturumu.izler(y, k.id).is_empty(), "Söylenti kanıt/hüküm/suç bayrağı üretmez")
	var rng := y._rng.state
	var old := H.olay(o)
	var ayni := JSON.stringify(H.durum(y))
	FisiltiGazetesi.gece(y, [])
	dene(JSON.stringify(H.durum(y)) == ayni, "Aynı gece seviye iki kez yükselmez")
	var b := geri(o)
	b.yonetim.koylular.reverse()
	for kisi in b.yonetim.koylular:
		kisi.ad = "Başka ad"
		kisi.adli_id = &"chr_030"
		kisi.gizli_bayraklar = ["casus", "haydut", "sir"]
		kisi.gizli_egilim.tur = "haydut"
	for oturum in [o, b]:
		oturum.yonetim.gun += 1
		FisiltiGazetesi.gece(oturum.yonetim, [])
	dene(H.durum(y) == H.durum(b.yonetim) and y._rng.state == rng and H.durum(y).vaka.seviye == 2, "Ad/CHR/sır/gizli eğilim/dizi sırası ve RNG etkisiz")
	dene(not H.uygula(o, old, 0).ok, "Önceki seviyenin bayat kartı reddedilir")
	var metin := H.metin(b.yonetim)
	dene(not metin.contains("haydut") and not metin.contains("casus") and metin.contains("masum"), "UI masumiyet belirtir, sır ifşa etmez")
	var yok := hazir()
	var gizli := yok.yonetim.koylular[0]
	gizli.gizli_bayraklar.append("yabanci")
	baslat(yok)
	dene(not H.bekliyor(yok.yonetim), "Gizli yabancı bilgisi hedef yaratmaz")
	var acik := hazir()
	acik.yonetim.koylular[0].bayrak_ekle("yabanci")
	baslat(acik)
	dene(H.durum(acik.yonetim).vaka.hedef == acik.yonetim.koylular[0].id, "Açık yabancı bayrağı yeterli")
	var dis := hazir()
	var dk := hedef(dis)
	dis.yonetim.kervan_koruma[str(dk.id)] = {"baslangic": 6, "donus": 8}
	baslat(dis)
	dene(not H.bekliyor(dis.yonetim), "Dış görevde kişi hedef alınmaz")
	var cocuk := hazir()
	var ck := hedef(cocuk)
	ck.yas_grubu = &"cocuk"
	baslat(cocuk)
	dene(not H.bekliyor(cocuk.yonetim), "Çocuk hedef alınmaz")
	var zindan := hazir()
	var zk := hedef(zindan)
	zk.bayrak_ekle(DivanHukmu.FLAG)
	baslat(zindan)
	dene(not H.bekliyor(zindan.yonetim), "Zindandaki hedef hariç")

func _koruma_ve_kayit() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := hedef(o)
	baslat(o)
	y.koylular[0].moral = 1
	var adalet := y.adalet
	var rng := y._rng.state
	var kaynak := y.kaynaklar.kaydet()
	var e := o.olay_sec()
	dene(H.tanimli(e) and o.secenek_olur(e, 0), "Mevcut Fisilti/Oturum olay yönlendirmesi")
	dene(o.olay_uygula(e, 0).ok and y.adalet == mini(100, adalet + 8), "Muhafız adalet kararı korur")
	dene(y.koylu(k.id) != null and y.koylular[0].moral == 0 and not H.bekliyor(y), "Koruma masumu tutar, kısa moral kesintisi")
	var once := JSON.stringify(o.kaydet())
	dene(not o.olay_uygula(e, 0).ok and JSON.stringify(o.kaydet()) == once, "Çift tık/bayat karar ödül ve bedel tekrarlamaz")
	var b := geri(o)
	dene(H.durum(y) == H.durum(b.yonetim), "Koruma/moral iadesi makbuzu JSON restore")
	H.kaldir(y)
	dene(y.koylular[0].moral == 0, "Aynı gün moral bedeli sürer")
	y.gun += 1
	H.kaldir(y)
	dene(y.koylular[0].moral == 1, "Düşük moralde yalnız gerçek kesinti iade, kazanç yok")
	H.kaldir(y)
	FisiltiGazetesi.gece(y, [])
	dene(y.koylular[0].moral == 1 and H.durum(y).vaka.karar == "koru", "İade tek kez, süren krizde yeniden hedefleme yok")
	dene(y._rng.state == rng and y.kaynaklar.kaydet() == kaynak and o.muhafiz_akce == 77, "Koruma RNG/kaynak/kişisel kese kullanmaz")

func _haksizlik() -> void:
	for idx in [2, 3]:
		var o := hazir()
		var y := o.yonetim
		var k := hedef(o)
		var sif := kur(y, "sifahane")
		dene(sif != null and y.ata(k.id, sif.id) and Sifahane.tedavi_kapasitesi(y) == 1 and HekimIlac.etkin(y), "Gerçek Dudu/Şifahane kapasitesi")
		baslat(o)
		var adalet := y.adalet
		var nufus := y.nufus()
		var stok := y.kaynaklar.kaydet()
		var rng := y._rng.state
		var e := H.olay(o)
		dene(H.uygula(o, e, idx).ok, "Göz yum/sürgün kararı")
		dene(y.koylu(k.id) == null and y.nufus() == nufus - 1 and Sifahane.tedavi_kapasitesi(y) == 0 and not HekimIlac.etkin(y), "Masum gerçekten ayrılır, hekim kapasitesi/koruması kaybolur")
		dene(y.adalet == maxi(0, adalet - 25) and o.muhafiz_vicdani.yuk == 50 and o.muhafiz_vicdani.haksiz_ret == 1 and y.koylular[0].moral == 52, "Adalet, moral ve mevcut vicdan bedeli")
		dene(DivanHaksizligi.durum(y).has(str(k.id)) and not DivanHukmu.verildi(y, k.id) and o.kadro.durumlar[k.adli_id].durum == &"kalici_ayrildi", "Ortak haksızlık makbuzu ve kalıcı kadro, suç hükmü yok")
		dene(KuyuKirliligi.kirli(y) and y.kaynaklar.kaydet() == stok and y._rng.state == rng and o.muhafiz_akce == 77, "Haksızlık krizi çözmez; kaynak/kese/RNG ödülü yok")
		var b := geri(o)
		dene(b.yonetim.koylu(k.id) == null and b.muhafiz_vicdani == o.muhafiz_vicdani and H.durum(b.yonetim) == H.durum(y), "Ayrılık/vicdan/histeri kayıt dönüşü")
		var once := JSON.stringify(o.kaydet())
		dene(not H.uygula(o, e, idx).ok and JSON.stringify(o.kaydet()) == once, "Haksızlık çift işleminde ikinci bedel yok")
		o.gece_sonu()
		dene(MuhafizVicdani.aktif(o), "Haksızlığın yükü mevcut kabus/yorgunluk akışına girer")

func _gercek_ve_oy() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := hedef(o)
	baslat(o)
	var e := H.olay(o)
	dene(not o.secenek_olur(e, 1) and not o.olay_uygula(e, 1).ok, "Kirli kuyu çözülmeden gerçek sebep seçimi kilitli")
	var oy_ilk := CinarAltiMeclisi.puan(y, y.koylular[0], "kuyu", "kirec")
	for idx in 2:
		y.gun += 1
		KuyuKirliligi.kirlet(y)
		FisiltiGazetesi.gece(y, [])
	dene(H.durum(y).vaka.seviye == 3 and CinarAltiMeclisi.puan(y, y.koylular[0], "kuyu", "kirec") < oy_ilk, "Üç gecede histeri artar, gerçek çözüme güven azalır")
	dene(H.oy_cezasi(y, k) == 0, "Mağdur kendi aleyhine önyargı oyu vermez")
	k.toplumsal_bag.grup = "ortak"
	y.koylular[0].toplumsal_bag.grup = "ortak"
	dene(H.oy_cezasi(y, y.koylular[0]) == 0, "Açık toplumsal bağ dayanışması")
	y.koylular[0].toplumsal_bag.grup = ""
	dene(CinarAltiMeclisi.topla(y, "kuyu") and CinarAltiMeclisi.durum(y).oylama.oylar[1] >= 4, "Histeri gerçek meclis oy dağılımını etkiler; sürgün oyu yok")
	dene(KuyuKirliligi.kirecle(y), "Mevcut iki kireç API'si")
	e = H.olay(o)
	var n := y.nufus()
	var adalet := y.adalet
	dene(H.uygun(o, e, 1) and H.uygula(o, e, 1).ok and not H.bekliyor(y), "Kireçleme sonrası gerçek sebep histeriyi hemen söndürür")
	dene(y.nufus() == n and y.adalet == adalet and MuhafizVicdani.oku(o.muhafiz_vicdani).yuk == 0, "Sebep gösterme masumu ve vicdanı korur")
	var b := geri(o)
	dene(H.durum(b.yonetim).vaka.karar == "gercek", "Gerçek sebep sonucu kayıtta")
	var giden := hazir()
	var gk := hedef(giden)
	baslat(giden)
	var old := H.olay(giden)
	giden.yonetim.surgun(gk.id)
	dene(not H.uygula(giden, old, 0).ok, "Dışarıdan ayrılmış hedefe bayat ödül yok")

func _diger_krizler() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := hedef(o)
	var olen := y.koylular[0]
	SaglikYoneticisi.enfekte(y, olen, "veba")
	olen.saglik = 1
	var r := o.gece_sonu()
	dene(r.rapor.olenler.size() == 1 and H.durum(y).vaka.sebep == "salgin" and H.durum(y).vaka.hedef == k.id, "Gerçek salgın ölümü→yas→masum hedef")
	var kitlik := hazir()
	hedef(kitlik)
	kitlik.yonetim.kaynaklar.azalt("gida", 10000)
	kitlik.gece_sonu()
	kitlik.gece_sonu()
	# Fısıltı gece gözlemi kıtlık _isyan işleminden önce; sonraki gece görünür.
	kitlik.gece_sonu()
	dene(H.durum(kitlik.yonetim).vaka.get("sebep") == "kitlik", "Mevcut iki gece kıtlık/isyan sonrası söylenti")

func _bozuk_ve_legacy() -> void:
	var o := hazir()
	hedef(o)
	baslat(o)
	var v := o.kaydet()
	v.koy_yonetimi.erase("batil_inanc_histerisi")
	dene(H.durum(Oturum.kayittan(kat, v).yonetim).vaka.is_empty(), "Optional eski kayıtta histeri yok")
	for bozuk in [null, [], {"son_gece": "6"}, {"son_gece": INF}, {"son_gece": 6, "kriz": true, "vaka": {}, "iade": {"1": 4}}]:
		dene(H.oku(bozuk).vaka.is_empty() and H.oku(bozuk).iade.is_empty(), "Bozuk optional kayıt bedel/ödül yaratmaz")
	var d := H.durum(o.yonetim)
	d.vaka.seviye = 99
	dene(H.oku(d).vaka.is_empty(), "Seviye sınırı")
	d = H.durum(o.yonetim)
	d.son_gece = o.yonetim.gun + 1
	H.yukle(o.yonetim, d)
	dene(H.durum(o.yonetim).vaka.is_empty(), "Gelecek kayıt güvenli reset")

func _donem_ve_kilitler() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := hedef(o)
	baslat(o)
	var e := H.olay(o)
	var once := JSON.stringify(o.kaydet())
	for idx in [-1, 4, 99]: dene(not H.uygula(o, e, idx).ok, "Geçersiz karar indeksi")
	dene(JSON.stringify(o.kaydet()) == once, "Geçersiz karar model değiştirmez")
	y.son = &"isyan"
	dene(not H.uygula(o, e, 0).ok and H.olay(o) == null, "Oyun sonunda karar yok")
	y.son = &""
	dene(H.uygula(o, e, 0).ok, "Kilit sonrası güncel koruma")
	y.gun += 1
	H.kaldir(y)
	KuyuKirliligi.temizle(y)
	FisiltiGazetesi.gece(y, [])
	dene(not H.durum(y).kriz, "Bitmiş kriz gözlenir")
	y.gun += 1
	KuyuKirliligi.kirlet(y)
	FisiltiGazetesi.gece(y, [])
	dene(H.bekliyor(y) and H.durum(y).vaka.gun == y.gun and H.durum(y).vaka.hedef == k.id, "Kapanmış krizden sonra yeni dönem")
	k.saglik = 0
	y.gun += 1
	FisiltiGazetesi.gece(y, [])
	dene(H.durum(y).vaka.karar == "dagildi" and not H.bekliyor(y), "Ölmüş hedefte ücretsiz kapanış; yeni suçlama yok")
	var b := hazir()
	hedef(b)
	baslat(b)
	KuyuKirliligi.temizle(b.yonetim)
	var yeni := H.olay(b)
	KuyuKirliligi.kirlet(b.yonetim)
	dene(not H.uygula(b, yeni, 1).ok, "Kart sonrası yeniden kirlenme gerçek sebep kararını kilitler")

func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var b := y.bina(y.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
