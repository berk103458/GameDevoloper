extends SceneTree
var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_olum_ve_sure()
	_secim_ve_kayit()
	_temas_ve_is()
	_risk_siniri()
	_legacy()
	print("CENAZE YASI: GEÇTİ" if hata == 0 else "CENAZE YASI: KALDI")
	quit(hata)

func hazir(n: int = 8) -> KoyYonetimi:
	var y := Oturum.new(kat, 223).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.a.iyilesme = 0
	y.a.tok_moral = 0
	y.a.evsiz_moral = 0
	y.a.isyan_esigi = -1
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["gida", "odun", "tas", "kereste", "alet"]: y.kaynaklar.ekle(t, 500)
	for i in n:
		var k := y.kabul({"ad": "Yas köylüsü %d" % i, "sinif": "oduncu", "stat": 5})
		k.moral = 50
	return y

func geri(y: KoyYonetimi) -> KoyYonetimi:
	return KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))

func salgin_olumu(y: KoyYonetimi, sayi: int = 1) -> Dictionary:
	for k in y.koylular.slice(0, sayi):
		SaglikYoneticisi.enfekte(y, k, "veba")
		k.saglik = 1
	return y.gece()

func _olum_ve_sure() -> void:
	var y := hazir()
	var kontrol := geri(y)
	var r := y.gece()
	dene(not r.has("cenaze") and CenazeYasi.durum(y).is_empty(), "Ölümsüz raporda cenaze yok")
	dene(kontrol.gece() == r and y._rng.state == kontrol._rng.state, "Ölümsüz gece RNG ve raporu aynı")
	y = hazir(10)
	var son_kisi := y.koylular[-1]
	son_kisi.moral = 2
	r = salgin_olumu(y, 5)
	dene(r.olenler.size() == 5 and r.cenaze.sayi == 5 and r.cenaze.salgin and CenazeYasi.durum(y).ceza == 12, "Toplu salgın tek tarama/rapor, ölüm sayısı ve tavan12")
	dene(y.koylular[0].moral == 38 and son_kisi.moral == 0 and CenazeYasi.durum(y).uygulanan[str(son_kisi.id)] == 2, "Moral alt sınırı ve gerçekten kesilmiş makbuz")
	var rng := y._rng.state
	dene(CenazeYasi.sec(y, r.gun, "toplu_mezar") and KuyuKirliligi.kirli(y) and y._rng.state == rng, "Salgında ücretsiz mezar mevcut kuyu API'si; karar RNG çekmez")
	KuyuKirliligi.temizle(y) # Yas süresi deneyinden tifo hasarını ayırır.
	y.gece()
	dene(y.koylular[0].moral == 38 and son_kisi.moral == 0 and not CenazeYasi.durum(y).is_empty(), "İkinci gün kesinti üst üste eklenmez")
	var yeni := y.kabul({"ad": "İkinci gün gelen"})
	var yeni_moral := yeni.moral
	y.gece()
	dene(y.koylular[0].moral == 50 and son_kisi.moral == 2 and yeni.moral == yeni_moral and CenazeYasi.durum(y).is_empty(), "İki gün sonunda gerçek kesinti iade, yeni üyeye hayalet iade yok")
	y = hazir(10)
	r = salgin_olumu(y, 4)
	CenazeYasi.sec(y, r.gun, "toplu_mezar")
	KuyuKirliligi.temizle(y)
	r = salgin_olumu(y)
	dene(CenazeYasi.durum(y).ceza == 12 and CenazeYasi.durum(y).bitis == 3 and y.koylular[0].moral == 38, "Ertesi ölüm süreyi yeniler, cezalar toplanmaz")
	dene(CenazeYasi.sec(y, r.gun, "toren") and CenazeYasi.durum(y).ceza == 12, "Küçük yeni tören önceki büyük yası silemez")
	for soguk in [false, true]:
		y = hazir(7)
		for k in y.koylular.slice(0, 3): k.saglik = 1
		if soguk:
			y.gun = 21
			y.kaynaklar.azalt("odun", 10000)
		else: y.kaynaklar.azalt("gida", 10000)
		r = y.gece()
		dene(r.olenler.size() == 3 and r.cenaze.sayi == 3 and not r.cenaze.salgin, "MEV-02/kıtlık ölümü aynı cenaze yolunda")
		rng = y._rng.state
		dene(CenazeYasi.sec(y, r.gun, "toplu_mezar") and not KuyuKirliligi.kirli(y) and y._rng.state == rng, "Salgın olmayan mezar yeni kirlilik/zar yaratmaz")

func _secim_ve_kayit() -> void:
	var y := hazir()
	var r := salgin_olumu(y, 2)
	var k := y.koylular[0]
	var pending := geri(y)
	dene(CenazeYasi.bekliyor(pending) and JSON.parse_string(JSON.stringify(pending.kaydet())) == JSON.parse_string(JSON.stringify(y.kaydet())), "Bekleyen cenaze JSON dönüşünde korunur")
	var once := JSON.stringify(y.kaydet())
	dene(not CenazeYasi.sec(y, r.gun - 1, "toren") and not CenazeYasi.sec(y, r.gun, "yanlis") and JSON.stringify(y.kaydet()) == once, "Bayat/geçersiz seçim atomik ret")
	y.akce = 3
	once = JSON.stringify(y.kaydet())
	dene(not CenazeYasi.sec(y, r.gun, "toren") and JSON.stringify(y.kaydet()) == once, "Yetersiz kamu akçesi ücret/moral/süre/RNG değiştirmez")
	y.akce = 100
	y.kaynaklar.azalt("gida", 10000)
	once = JSON.stringify(y.kaydet())
	dene(not CenazeYasi.sec(y, r.gun, "toren") and JSON.stringify(y.kaydet()) == once, "Yetersiz erzak atomik ret")
	y.kaynaklar.ekle("gida", 100)
	var rng := y._rng.state
	dene(CenazeYasi.sec(y, r.gun, "toren") and y.akce == 96 and y.kaynaklar.miktar("gida") == 96 and k.moral == 47 and CenazeYasi.durum(y).ceza == 3 and y._rng.state == rng, "Tören 4+4 bedel, yeni yas yarıya iner, kaynak RNG değişmez")
	once = JSON.stringify(y.kaydet())
	dene(not CenazeYasi.sec(y, r.gun, "toren") and not CenazeYasi.sec(y, r.gun, "toplu_mezar") and JSON.stringify(y.kaydet()) == once, "Çift tıklama/karar değişimi ikinci ücret/iade yok")
	var yuklenen := geri(y)
	for i in 2:
		var ana_rapor := y.gece()
		var geri_rapor := yuklenen.gece()
		dene(ana_rapor == geri_rapor and esit(y.kaydet(), yuklenen.kaydet()), "Aktif/bitmiş yas gerçek JSON gece devamı aynı")
	dene(CenazeYasi.durum(y).is_empty() and k.moral == 50, "Tören yası iki gün sonunda biter")
	y = hazir()
	r = salgin_olumu(y)
	y.gece()
	dene(CenazeYasi.durum(y).secim == "toplu_mezar" and KuyuKirliligi.kirli(y), "Doğrudan otomatik gece bekleyen ücretsiz mezarı uygular")
	y.son = KoyYonetimi.SON_HALK
	once = JSON.stringify(y.kaydet())
	dene(not CenazeYasi.sec(y, r.gun, "toren") and JSON.stringify(y.kaydet()) == once, "Bitmiş oturumda karar yok")

func _temas_ve_is() -> void:
	var y := hazir(10)
	var kaynak := y.koylular[1]
	SaglikYoneticisi.enfekte(y, kaynak, "veba")
	var r := salgin_olumu(y)
	KuyuKirliligi.temizle(y)
	var dis := y.koylular[-1]
	dis.bayraklar.append("zindanda")
	dene(CenazeYasi.sec(y, r.gun, "toren"), "Salgın töreni seçildi")
	var d := CenazeYasi.durum(y)
	dene(d.katilanlar.size() == 6 and dis.id not in d.katilanlar and not KuyuKirliligi.kirli(y), "En fazla6 temas uygun katılımcı; tören kuyu kirletmez")
	var hedef := y.koylular[1]
	hedef.karantina = {"baslangic": y.gun, "bitis": y.gun + 2, "bina": 99}
	var zindan := y.koylular[2]
	zindan.bayraklar.append("zindanda")
	var kervan := y.koylular[3]
	y.kervan_koruma[str(kervan.id)] = {"baslangic": y.gun, "donus": y.gun + 2}
	var risk: int = SaglikYoneticisi.AYAR.veba.risk
	SaglikYoneticisi.AYAR.veba.risk = 100
	var ol: Array[Dictionary] = []
	var yeni := SaglikYoneticisi.gece(y, ol)
	dene(yeni == 2 and not SaglikYoneticisi.hasta(hedef) and not SaglikYoneticisi.hasta(zindan) and not SaglikYoneticisi.hasta(kervan), "Aynı KRI-01 temas kapısı, iki vaka kotası ve izolasyon iki yönde")
	var rng := y._rng.state
	KuyuKirliligi.kirlet(y)
	KuyuKirliligi.gece(y, {"taze": 30}, [], yeni)
	dene(y._rng.state == rng, "Cenaze vakaları ortak temas/su kotasını doldurunca yeni su zarı yok")
	SaglikYoneticisi.AYAR.veba.risk = risk
	dene(CenazeYasi.is_carpani(y, kaynak) == 0.9 and CenazeYasi.is_carpani(y, dis) == 1.0, "Sınırlı üretim kaybı, tüm köy bir gün durmaz")
	y.gun += 1
	dene(CenazeYasi.is_carpani(y, kaynak) == 1.0, "Tören iş kaybı yalnız bir gece")
	# Mevcut gerçek üretimin kesirli artığı da azalır; atama değişmez.
	y = hazir()
	r = salgin_olumu(y)
	CenazeYasi.sec(y, r.gun, "toren")
	var b := kur(y, "odunluk")
	var isci := y.koylular[0]
	dene(y.ata(isci.id, b.id), "Mevcut çalışan ataması")
	var normal := geri(y)
	normal.remove_meta(CenazeYasi.META)
	var u := {}
	var nu := {}
	y._uret(u, [])
	normal._uret(nu, [])
	dene(int(u.get("tomruk", 0)) < int(nu.get("tomruk", 0)) and isci.is_yeri == b.id, "Gerçek üretim×0,9 kesir/artık yolunda, atama korunur")
	# Tifo temas kaynağı değildir; ölüm sonrası sağlıklı halktan kendiliğinden hastalık yok.
	y = hazir()
	SaglikYoneticisi.enfekte(y, y.koylular[1], "tifo")
	r = salgin_olumu(y)
	CenazeYasi.sec(y, r.gun, "toren")
	rng = y._rng.state
	dene(SaglikYoneticisi.gece(y, []) == 0 and y._rng.state == rng, "Tifolu tören katılımcısı ikinci bulaşma sistemi üretmez")

func _risk_siniri() -> void:
	var y := hazir(10)
	var r := salgin_olumu(y)
	CenazeYasi.sec(y, r.gun, "toren")
	var rng := y._rng.state
	dene(SaglikYoneticisi.gece(y, []) == 0 and y._rng.state == rng, "Ölen kaynak geri dirilmez; sağlıklı tören gereksiz RNG/hastalık üretmez")
	var kaynak := y.koylular[0]
	SaglikYoneticisi.enfekte(y, kaynak, "veba")
	var risk: int = SaglikYoneticisi.AYAR.veba.risk
	SaglikYoneticisi.AYAR.veba.risk = 0
	var kontrol := RandomNumberGenerator.new()
	kontrol.state = y._rng.state
	for i in SaglikYoneticisi.AZAMI_TEMAS: kontrol.randi_range(1, 100)
	dene(SaglikYoneticisi.gece(y, []) == 0 and y._rng.state == kontrol.state, "Törende mevcut kaynak başına3 temas tavanı; aynı RNG tam üç kez")
	SaglikYoneticisi.AYAR.veba.risk = risk
	y = hazir()
	r = salgin_olumu(y)
	kaynak = y.koylular[0]
	SaglikYoneticisi.enfekte(y, kaynak, "veba")
	CenazeYasi.sec(y, r.gun, "toren")
	kaynak.karantina = {"baslangic": y.gun, "bitis": y.gun + 2, "bina": 99}
	rng = y._rng.state
	dene(SaglikYoneticisi.gece(y, []) == 0 and y._rng.state == rng, "Karar sonrasında izole edilen kaynak da mevcut temas kapısından geçemez")
	y = hazir(10)
	r = salgin_olumu(y)
	SaglikYoneticisi.enfekte(y, y.koylular[0], "veba")
	CenazeYasi.sec(y, r.gun, "toren")
	var yuklenen := geri(y)
	var ol: Array[Dictionary] = []
	var yol: Array[Dictionary] = []
	dene(SaglikYoneticisi.gece(y, ol) == SaglikYoneticisi.gece(yuklenen, yol) and ol == yol and y._rng.state == yuklenen._rng.state and esit(y.kaydet(), yuklenen.kaydet()), "Törenin yaşayan kaynak teması JSON devamında aynı vaka ve RNG")

func _legacy() -> void:
	var y := hazir()
	var v := y.kaydet()
	v.erase("cenaze_yasi")
	dene(CenazeYasi.durum(KoyYonetimi.kayittan(y.a, y.katalog, v)).is_empty(), "Legacy kayıt etkisiz")
	var r := salgin_olumu(y)
	var d := CenazeYasi.durum(y)
	for alan in ["baslangic", "bitis", "olum_gecesi", "ceza", "sayi", "onceki_ceza", "toren_gun"]:
		for bozuk in ["2", true, NAN, INF, 1.5, -2, 1000000001]:
			var kopya := d.duplicate(true)
			kopya[alan] = bozuk
			dene(CenazeYasi.oku(kopya).is_empty(), "Bozuk sayısal yas kaydı reddedilir")
	for alan in ["uygulanan", "katilanlar", "salgin", "secim"]:
		var kopya := d.duplicate(true)
		kopya[alan] = 42
		dene(CenazeYasi.oku(kopya).is_empty(), "Bozuk yas şeması reddedilir")
	var future := d.duplicate(true)
	future.baslangic += 10
	future.olum_gecesi += 10
	future.bitis += 10
	CenazeYasi.yukle(y, future)
	dene(CenazeYasi.durum(y).is_empty(), "Gelecek kaydı etkisiz")
	CenazeYasi.yukle(y, d)
	y.gun = r.gun + 3
	CenazeYasi.yukle(y, d)
	dene(CenazeYasi.durum(y).is_empty(), "Süresi geçmiş optional kayıt etkisiz")

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

## Mevcut ambar kesirleri JSON'da kayan nokta yuvarlaması yaşar; tam sayılar/RNG birebir.
func esit(a: Variant, b: Variant) -> bool:
	if a is Dictionary and b is Dictionary:
		if a.size() != b.size(): return false
		for alan in a:
			if not b.has(alan) or not esit(a[alan], b[alan]): return false
		return true
	if a is Array and b is Array:
		if a.size() != b.size(): return false
		for i in a.size():
			if not esit(a[i], b[i]): return false
		return true
	if a is float and b is float: return is_equal_approx(a, b)
	return a == b
