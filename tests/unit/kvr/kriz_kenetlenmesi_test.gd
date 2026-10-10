extends SceneTree
const KENET = preload("res://src/koy/kriz_kenetlenmesi.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir() -> KoyYonetimi:
	var y := Oturum.new(kat, 1910).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 100, "odun": 100, "su": 100, "kirec": 10})
	y.akce = 200
	var k := y.kabul({"ad": "Komşu"})
	k.moral = 80
	k.sadakat = 60
	k.refah = 50
	return y

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_temel()
	_ortusen()
	_sinirlar()
	_kayit()
	_gercek_gece()
	_yas_histeri()
	print("KRİZ KENETLENMESİ: GEÇTİ" if hata == 0 else "KRİZ KENETLENMESİ: KALDI")
	quit(hata)

func _temel() -> void:
	var y := hazir()
	var k := y.koylular[0]
	var olay: Array[Dictionary] = []
	var rng := y._rng.state
	var kaynak := y.kaynaklar.kaydet()
	var akce := y.akce
	KENET.baslat(y)
	KENET.bitir(y, olay)
	dene(olay.is_empty() and k.sadakat == 60 and k.refah == 50, "Krizsiz refah çiftçiliği yok")
	y.gun += 1
	KuyuKirliligi.kirlet(y)
	KENET.baslat(y)
	KENET.bitir(y, olay)
	dene(KENET.durum(y).turler == ["kuyu"] and olay.is_empty(), "Süren krizde bonus yok")
	# Aynı gece tekrar/temizlik ikinci bitiş veya ödül çalıştırmaz.
	KuyuKirliligi.temizle(y)
	KENET.bitir(y, olay)
	dene(olay.is_empty(), "Aynı gece tekrar kilitli")
	y.gun += 1
	KENET.baslat(y)
	KENET.bitir(y, olay)
	dene(k.sadakat == 60 + int(KENET.AYAR.sadakat) and k.refah == 50 + int(KENET.AYAR.refah) and olay.size() == 1, "Sadakat/tek ekonomik Refah formülü")
	dene(olay[0].kriz_kenetlenmesi.sadakat == int(KENET.AYAR.sadakat) and olay[0].kriz_kenetlenmesi.refah == int(KENET.AYAR.refah), "Rapor gerçek toplam kazanım")
	dene(IflasYoneticisi.olay_metin(olay[0]).contains("Toplumsal kenetlenme") and IflasYoneticisi.olay_metin(olay[0]).contains("Kirli kuyu"), "Mevcut rapor adaptörü")
	dene(y._rng.state == rng and y.akce == akce and y.kaynaklar.kaydet() == kaynak, "RNG, kasa ve stok değişmez")
	var once := JSON.stringify(y.kaydet())
	KENET.baslat(y)
	KENET.bitir(y, olay)
	dene(olay.size() == 1 and JSON.stringify(y.kaydet()) == once, "Kapanış makbuzu aynı gün idempotent")
	y.gun += 1
	KuyuKirliligi.kirlet(y)
	KENET.baslat(y)
	KuyuKirliligi.temizle(y)
	KENET.bitir(y, olay)
	dene(olay.size() == 1 and KENET.durum(y).baslangic == -1, "Bekleme içindeki yeni kriz kapanır, ertelenmiş bonus bankası yok")
	y.gun += int(KENET.AYAR.bekleme_gun)
	KENET.bitir(y, olay)
	dene(olay.size() == 1, "Bekleme dolması tek başına yeni ödül değil")
	y.gun += 1
	KuyuKirliligi.kirlet(y)
	KENET.baslat(y)
	KuyuKirliligi.temizle(y)
	KENET.bitir(y, olay)
	dene(olay.size() == 2, "Bekleme sonrası yeni bağımsız kriz tek bonus")

func _ortusen() -> void:
	var y := hazir()
	var k := y.koylular[0]
	var olay: Array[Dictionary] = []
	KuyuKirliligi.kirlet(y)
	y.isyan_kalan = 3
	SaglikYoneticisi.enfekte(y, k, "humma")
	k.bayrak_ac("hasta")
	KENET.baslat(y)
	KENET.bitir(y, olay)
	y.gun += 1
	KuyuKirliligi.temizle(y)
	KENET.bitir(y, olay)
	dene(olay.is_empty(), "Temiz kuyu, isyan/salgın sürerken zafer değil")
	y.gun += 1
	y.isyan_kalan = -1
	SaglikYoneticisi.iyilestir(k)
	# Yeni gizli hasta kapanışa engel, kamuya açık yeni kriz değildir.
	SaglikYoneticisi.enfekte(y, k, "tifo")
	KENET.bitir(y, olay)
	dene(olay.is_empty() and KENET.krizler(y).is_empty(), "Gizli kuluçka ifşa edilmeden iyileşme beklenir")
	y.gun += 1
	SaglikYoneticisi.iyilestir(k)
	k.ac = true
	KENET.bitir(y, olay)
	dene(olay.is_empty(), "Aç halkla kenetlenme ilan edilmez")
	y.gun += 1
	k.ac = false
	y.kaynaklar.azalt("gida", 1000)
	KENET.bitir(y, olay)
	dene(olay.is_empty(), "Sıfır erzak, krizden çıkış değil")
	y.gun += 1
	y.kaynaklar.ekle("gida", 100)
	KENET.bitir(y, olay)
	dene(olay.size() == 1 and olay[0].kriz_kenetlenmesi.turler == ["isyan", "salgin", "kuyu"], "Örtüşen krizler tek toplu makbuz")
	var z := hazir()
	var hasta := z.koylular[0]
	SaglikYoneticisi.enfekte(z, hasta)
	KENET.baslat(z)
	SaglikYoneticisi.iyilestir(hasta)
	var sessiz: Array[Dictionary] = []
	KENET.bitir(z, sessiz)
	dene(sessiz.is_empty(), "Yalnız gizli hastalıktan yeni dönem/bonus yok")

func _sinirlar() -> void:
	var y := hazir()
	var k := y.koylular[0]
	k.sadakat = 98
	k.refah = 99
	k.yas_grubu = &"cocuk"
	k.karantina = {"baslangic": 0, "bitis": 2, "bina": 1}
	var tutuklu := y.kabul({"ad": "Tutuklu"})
	tutuklu.bayrak_ac("zindanda")
	var dis := y.kabul({"ad": "Kervancı"})
	y.kervan_koruma[str(dis.id)] = {"baslangic": 0, "donus": 3}
	var once := [tutuklu.sadakat, tutuklu.refah, dis.sadakat, dis.refah]
	KuyuKirliligi.kirlet(y)
	KENET.baslat(y)
	KuyuKirliligi.temizle(y)
	var olay: Array[Dictionary] = []
	KENET.bitir(y, olay)
	dene(k.sadakat == 100 and k.refah == 100 and olay[0].kriz_kenetlenmesi.sadakat == 2 and olay[0].kriz_kenetlenmesi.refah == 1, "100 tavanı/gerçek delta, çocuk karantina temsil yoluyla dahil")
	dene([tutuklu.sadakat, tutuklu.refah, dis.sadakat, dis.refah] == once and olay[0].kriz_kenetlenmesi.kisi == 1, "Dış görev ve zindana yerel bonus yok")
	for terminal in [KoyYonetimi.SON_ISYAN, KoyYonetimi.SON_TEKFUR, KoyYonetimi.SON_ZAFER]:
		var z := hazir()
		KuyuKirliligi.kirlet(z)
		KENET.baslat(z)
		KuyuKirliligi.temizle(z)
		z.son = terminal
		var kayit := JSON.stringify(z.kaydet())
		KENET.bitir(z, olay)
		dene(JSON.stringify(z.kaydet()) == kayit, "Terminal durum ödül/model değişmez")
	var bos := hazir()
	KuyuKirliligi.kirlet(bos)
	KENET.baslat(bos)
	KuyuKirliligi.temizle(bos)
	bos.koylular.clear()
	var sessiz: Array[Dictionary] = []
	KENET.bitir(bos, sessiz)
	dene(sessiz.is_empty() and KENET.durum(bos).son_bonus == -1, "Boş köy zafer sayılmaz")

func _kayit() -> void:
	var y := hazir()
	y.gun = 20
	KuyuKirliligi.kirlet(y)
	KENET.baslat(y)
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	dene(KENET.durum(geri) == KENET.durum(y) and KENET.durum(geri).baslangic == 20, "İleri gün legacy ilk fotoğraf/JSON eşit")
	KuyuKirliligi.temizle(y)
	KuyuKirliligi.temizle(geri)
	var olay: Array[Dictionary] = []
	var rr: Array[Dictionary] = []
	KENET.bitir(y, olay)
	KENET.bitir(geri, rr)
	dene(olay == rr and JSON.stringify(y.kaydet()) == JSON.stringify(geri.kaydet()), "Aktif kayıt devamında aynı bonus")
	geri = KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	KENET.bitir(geri, rr)
	dene(rr.size() == 1 and JSON.stringify(y.kaydet()) == JSON.stringify(geri.kaydet()), "Kapanmış kayıt yeniden ödül vermez")
	var eski := y.kaydet()
	eski.erase("kriz_kenetlenmesi")
	geri = KoyYonetimi.kayittan(y.a, y.katalog, eski)
	dene(KENET.durum(geri) == KENET.oku({}) and geri.koylular[0].sadakat == y.koylular[0].sadakat, "Legacy alan yok: geçmiş uydurulmaz, kişi puanı korunur")
	for v in [null, [], "x", {"son_gece": NAN, "baslangic": -1, "son_bonus": -1, "turler": []}, {"son_gece": INF, "baslangic": -1, "son_bonus": -1, "turler": []}, {"son_gece": 1.5, "baslangic": -1, "son_bonus": -1, "turler": []}, {"son_gece": 1, "baslangic": 0, "son_bonus": -1, "turler": ["sahte"]}, {"son_gece": 1, "baslangic": 0, "son_bonus": -1, "turler": ["kuyu", "kuyu"]}, {"son_gece": 1, "baslangic": -1, "son_bonus": 2, "turler": []}, {"son_gece": 1, "baslangic": 1, "son_bonus": 1, "turler": ["kuyu"]}, {"son_gece": 1, "baslangic": 0, "son_bonus": -1, "turler": []}]:
		dene(KENET.oku(v) == KENET.oku({}), "Bozuk optional makbuz güvenli")
	KENET.yukle(y, {"son_gece": 100, "baslangic": -1, "son_bonus": 100, "turler": []})
	dene(KENET.durum(y) == KENET.oku({}), "Gelecek gün reddedilir")

func _gercek_gece() -> void:
	var y := hazir()
	var k := y.koylular[0]
	SaglikYoneticisi.enfekte(y, k, "humma")
	k.bayrak_ac("hasta")
	k.enfeksiyon.bitis = y.gun # Bu gerçek gecenin başında son hasta iyileşir.
	var r := y.gece()
	dene(not SaglikYoneticisi.hasta(k) and r.olaylar.any(func(e: Dictionary) -> bool: return e.has("kriz_kenetlenmesi")), "Gece başı son hasta fotoğrafı bitişe kadar korunur")
	var z := hazir()
	SaglikYoneticisi.enfekte(z, z.koylular[0])
	z.koylular[0].bayrak_ac("hasta")
	z.koylular[0].saglik = 1
	r = z.gece()
	dene(not r.olenler.is_empty() and not r.olaylar.any(func(e: Dictionary) -> bool: return e.has("kriz_kenetlenmesi")), "Son hastanın ölümü başarı sayılmaz; gerçek yas/terminal kapısı")

func _yas_histeri() -> void:
	var y := hazir()
	var kayip := y.kabul({"ad": "Kaybedilen komşu"})
	SaglikYoneticisi.enfekte(y, kayip)
	kayip.bayrak_ac("hasta")
	kayip.saglik = 1
	var r := y.gece()
	dene(r.olenler.size() == 1 and not r.olaylar.any(func(e: Dictionary) -> bool: return e.has("kriz_kenetlenmesi")), "Yaşayan halk olsa da yeni yas bitmeden ödül yok")
	dene(CenazeYasi.sec(y, int(CenazeYasi.durum(y).olum_gecesi), "toplu_mezar"), "Gerçek cenaze kararı")
	# Salgın mezarı kuyu kirletebilir: tüm yas/kuyu geceleri birlikte bitmeli.
	# Bu sınır testi yeni tifo olasılığını kapatır; salgın yayılması ayrı akışta.
	var risk: int = SaglikYoneticisi.AYAR.tifo.risk
	SaglikYoneticisi.AYAR.tifo.risk = 0
	var bonus := 0
	for _i in 4:
		r = y.gece()
		bonus += r.olaylar.filter(func(e: Dictionary) -> bool: return e.has("kriz_kenetlenmesi")).size()
	SaglikYoneticisi.AYAR.tifo.risk = risk
	dene(CenazeYasi.durum(y).is_empty() and not KuyuKirliligi.kirli(y) and bonus == 1, "Yas/kuyu gerçek süre sonu tek birleşik ödül")
	var o := Oturum.new(kat, 1911)
	o.yonetim = hazir()
	y = o.yonetim
	y.koylular[0].bayrak_ac("yabanci")
	KuyuKirliligi.kirlet(y)
	KENET.baslat(y)
	var olay: Array[Dictionary] = []
	FisiltiGazetesi.HISTERI.gece(y, olay)
	KuyuKirliligi.temizle(y)
	KENET.bitir(y, olay)
	dene(FisiltiGazetesi.HISTERI.bekliyor(y) and not olay.any(func(e: Dictionary) -> bool: return e.has("kriz_kenetlenmesi")), "Çözülmemiş haksız söylenti iyileşme kapısını tutar")
	var e := FisiltiGazetesi.HISTERI.olay(o)
	dene(FisiltiGazetesi.HISTERI.uygula(o, e, 1).ok, "Mevcut gerçek sebebi göster kararı")
	y.gun += 1
	KENET.bitir(y, olay)
	dene(olay.filter(func(v: Dictionary) -> bool: return v.has("kriz_kenetlenmesi")).size() == 1, "Söylenti çözümünden sonraki gece tek kenetlenme")
