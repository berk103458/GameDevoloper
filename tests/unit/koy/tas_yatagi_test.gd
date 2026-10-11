extends SceneTree
var hata := 0
var kontrol_sayisi := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	_yeni_oyun(kat)
	_uretim()
	_kurtarici()
	_bekletme_ve_ocak()
	_sayac_ve_erteleme()
	_kayit(kat)
	_tohum()
	_atama_ve_kapasite()
	_acilis()
	print("TAŞ YATAĞI: GEÇTİ (%d kontrol)" % kontrol_sayisi if hata == 0 else "TAŞ YATAĞI: KALDI")
	quit(hata)

func _yeni(tohum: int = 21) -> KoyYonetimi:
	return KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), tohum)

func _isci(y: KoyYonetimi) -> Koylu:
	return y.kabul({"ad": "Kazıcı", "sinif": "tasci", "stat": 5})

func _yeni_oyun(kat: Katalog) -> void:
	var o := Oturum.new(kat, 21)
	var y := o.yonetim
	_kontrol(y.tas_yatagi != null and y.tas_yatagi.kalan == 20 and y.tas_yatagi.toplam == 20, "Yeni gerçek oturumda toplam 20 taşlık yatak")
	var h := y.tas_yatagi.hucre
	_kontrol(h.x == 0 or h.y == 0 or h.x == y.izgara.boyut.x - 1 or h.y == y.izgara.boyut.y - 1, "Başlangıç yatağı köy kenarında")
	_kontrol(y.izgara.dolu.get(h) == TasYatagi.IS_YERI and not y.izgara.bos(h), "Yatağın hücresi yapı ve yola kapalı")
	_kontrol(not y.katalog.var_mi("tas_yatagi") and y.katalog.var_mi("tas_ocagi"), "Yatak ikinci ocak türü açmaz")
	_kontrol(y.kaynaklar.miktar("tas") == int(y.a.baslangic_kaynak.tas), "Yatak başlangıç ambar stoğunu değiştirmez")
	_kontrol(y.tas_yatagi.bilgi() == "Taş yatağı: 20 taştan 20 kaldı", "Yeni oyun bilgi satırı tam miktar")

func _uretim() -> void:
	var y := _yeni()
	var k := _isci(y)
	_kontrol(y.ata(k.id, TasYatagi.IS_YERI), "Gerçek atama API'si kazıcıyı kabul eder")
	var once := y.kaynaklar.miktar("tas")
	var r := y.gece()
	_kontrol(y.kaynaklar.miktar("tas") == once + 4 and r.uretim.tas == 4 and y.tas_yatagi.kalan == 16, "Gerçek gecede işçi başı 4 taş")
	_kontrol(y.tas_yatagi.bilgi() == "Taş yatağı: 20 taştan 16 kaldı", "Bilgi satırı kalan taşla birebir")
	var kazi: Array[Dictionary] = []
	for e in r.olaylar:
		if e.anahtar == "koy.tas_yatagi.kazi": kazi.append(e)
	_kontrol(kazi.size() == 1 and IflasYoneticisi.olay_metin(kazi[0]) == "Taş yatağından 4 taş çıkarıldı; kaldı: 16.", "Dictionary kazı olayı mevcut rapor formatter'ında okunur")
	var k2 := _isci(y)
	_kontrol(y.ata(k2.id, TasYatagi.IS_YERI), "İkinci işçi atanır")
	r = y.gece()
	_kontrol(r.uretim.tas == 8 and y.tas_yatagi.kalan == 8, "İki işçi günde 8 taş")
	r = y.gece()
	_kontrol(r.uretim.tas == 8 and y.tas_yatagi.kalan == 0, "Toplam üretim yatağın 20 taşını aşmaz")
	_kontrol(y.tas_yatagi.bilgi() == "Taş yatağı: 20 taştan 0 kaldı" and not y.ata(k.id, TasYatagi.IS_YERI), "Tükenince bilgi 0, kazı ataması kapalı")
	_kontrol(k.is_yeri == KoyYonetimi.BOSTA and k2.is_yeri == KoyYonetimi.BOSTA and y.izgara.bos(y.tas_yatagi.hucre), "Tükenince işçiler ve hücre serbest kalır")
	var tas := y.kaynaklar.miktar("tas")
	y.gece()
	_kontrol(y.kaynaklar.miktar("tas") == tas, "Tükenmiş yatak tekrar üretmez")

func _bitir(y: KoyYonetimi) -> void:
	var k := _isci(y)
	y.ata(k.id, TasYatagi.IS_YERI)
	for i in 5:
		var u := {}
		var e: Array[Dictionary] = []
		y.tas_yatagi.gece(y, u, e, {})
		y.gun += 1
	y.kaynaklar.azalt("tas", y.kaynaklar.miktar("tas"))
	y.kaynaklar.azalt("odun", y.kaynaklar.miktar("odun"))

func _kurtarici() -> void:
	var y := _yeni()
	_bitir(y)
	_kontrol(y.tas_yatagi.kalan == 0 and not KaynakKurtarici.ocak_kurulabilir(y), "Gerçek kazıyla yatak tükenmiş, stok 0, ocak kurulamıyor")
	var r := y.gece()
	var kurtarma: Array[Dictionary] = []
	for e in r.olaylar:
		if e.anahtar == "koy.tas_yatagi.kurtarici": kurtarma.append(e)
	_kontrol(y.tas_yatagi.kalan == 10 and y.tas_yatagi.kurtarici_sayisi == 1 and y.kaynaklar.miktar("tas") == 0, "Sabah 10 taşlık yatak; doğrudan ambara hediye yok")
	_kontrol(kurtarma.size() == 1 and IflasYoneticisi.olay_metin(kurtarma[0]) == "Köy kenarında 10 taşlık yeni bir taş yatağı bulundu.", "Kurtarıcı tek Dictionary bilgi satırı")
	var e: Array[Dictionary] = []
	KaynakKurtarici.sabah(y, e)
	_kontrol(e.is_empty() and y.tas_yatagi.kurtarici_sayisi == 1, "Aynı sabah tekrar sayaç ve bilgi eklemez")
	_kontrol(y.tas_yatagi.bilgi() == "Taş yatağı: 10 taştan 10 kaldı", "Kurtarıcı bilgi satırında kendi toplamı ve kalanı")

func _bekletme_ve_ocak() -> void:
	var y := _yeni()
	y.kaynaklar.azalt("tas", 100)
	y.kaynaklar.azalt("odun", 100)
	for i in 4: y.gece()
	_kontrol(y.tas_yatagi.kalan == 20 and y.tas_yatagi.kurtarici_sayisi == 0, "İşçisiz beklemede stok 0 ve ocak kurulamaz olsa da kurtarıcı düşmez")
	y = _yeni()
	_bitir(y)
	y.kaynaklar.ekle("odun", int(y.katalog.maliyet("tas_ocagi").odun))
	var once := y.kaydet()
	_kontrol(KaynakKurtarici.ocak_kurulabilir(y) and y.kaydet() == once, "Kurulabilir denetimi stok, RNG, kayıt ve ızgarayı değiştirmez")
	var e: Array[Dictionary] = []
	KaynakKurtarici.sabah(y, e)
	_kontrol(e.is_empty() and y.tas_yatagi.kurtarici_sayisi == 0, "Kurmadı diye kurtarıcı verilmez; ocak kurulabiliyorsa yok")
	var b := _kur(y, "tas_ocagi")
	_kontrol(b != null, "Mevcut EKO-05 ocağı kuruluyor")
	if b != null: b.insa_kalan = 2
	y.kaynaklar.azalt("odun", 100)
	y.gun += 1
	KaynakKurtarici.sabah(y, e)
	_kontrol(e.is_empty() and y.tas_yatagi.kurtarici_sayisi == 0, "İnşa halindeki ocak da kurtarıcıyı engeller")
	y = _yeni()
	_bitir(y)
	y.kaynaklar.ekle("tas", 1)
	e.clear()
	KaynakKurtarici.sabah(y, e)
	_kontrol(e.is_empty(), "Ambarda bir taş bile varsa kurtarıcı yok")

func _sayac_ve_erteleme() -> void:
	var y := _yeni()
	_bitir(y)
	var e: Array[Dictionary] = []
	for i in 3:
		KaynakKurtarici.sabah(y, e)
		_kontrol(y.tas_yatagi.kurtarici_sayisi == i + 1 and y.tas_yatagi.kalan == 10, "Kurtarıcı %d üretildi" % (i + 1))
		var k := y.koylular[0]
		y.ata(k.id, TasYatagi.IS_YERI)
		for n in 3:
			var u := {}
			y.tas_yatagi.gece(y, u, e, {})
			y.gun += 1
		y.kaynaklar.azalt("tas", 100)
	KaynakKurtarici.sabah(y, e)
	_kontrol(y.tas_yatagi.kurtarici_sayisi == 3 and y.tas_yatagi.kalan == 0, "Sayaç 3'te durur; dördüncü yatak yok")
	var adet := 0
	for olay in e:
		if olay.anahtar == "koy.tas_yatagi.kurtarici": adet += 1
	_kontrol(adet == 3, "Üç kurtarıcı toplam üç bildirim")
	y = _yeni()
	_bitir(y)
	for cy in y.izgara.boyut.y:
		for cx in y.izgara.boyut.x: y.izgara.engeller[Vector2i(cx, cy)] = true
	var rng_once := y.tas_yatagi.rng.state
	e.clear()
	KaynakKurtarici.sabah(y, e)
	_kontrol(e.is_empty() and y.tas_yatagi.kurtarici_sayisi == 0 and y.tas_yatagi.rng.state == rng_once, "Boş hücre yoksa çökmeden erteler; sayaç ve RNG harcanmaz")
	var h := Vector2i(0, 0)
	y.izgara.engeller.erase(h)
	y.gun += 1
	KaynakKurtarici.sabah(y, e)
	_kontrol(y.tas_yatagi.hucre == h and y.tas_yatagi.kalan == 10 and e.size() == 1, "Ertesi sabah boşalan hücreye tek yatak ve bilgi")

func _kayit(kat: Katalog) -> void:
	var o := Oturum.new(kat, 30)
	var y := o.yonetim
	var k := _isci(y)
	y.ata(k.id, TasYatagi.IS_YERI)
	y.gece()
	var v: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat, v)
	_kontrol(geri.yonetim.tas_yatagi.kaydet() == y.tas_yatagi.kaydet(), "Optional yatak ve RNG gerçek Oturum JSON dönüşümünde korunur")
	_kontrol(geri.yonetim.koylu(k.id).is_yeri == TasYatagi.IS_YERI and geri.yonetim.izgara.dolu.get(y.tas_yatagi.hucre) == TasYatagi.IS_YERI, "Restore kazıcı ve hücre sahipliğini korur")
	_kontrol(geri.yonetim.gece().uretim.tas == 4, "Restore ertesi gece doğru üretir")
	v.koy_yonetimi.erase("tas_yatagi")
	var stok: Dictionary = Kaynaklar.kayittan(v.koy_yonetimi.kaynaklar).stok.duplicate()
	geri = Oturum.kayittan(kat, v)
	_kontrol(geri.yonetim.tas_yatagi == null and geri.yonetim.kaynaklar.stok == stok, "Eski kayıt yatak eklemez, başlangıç stokunu değiştirmez")
	geri.yonetim.kaynaklar.azalt("tas", 100)
	geri.yonetim.kaynaklar.azalt("odun", 100)
	geri.yonetim.gece()
	_kontrol(geri.yonetim.tas_yatagi == null and geri.yonetim.kaydet().tas_yatagi == null, "Eski kayıt sabahında da yatak uydurulmaz")
	var bozuk: Dictionary = y.kaydet().duplicate(true)
	bozuk.tas_yatagi.kalan = "bozuk"
	_kontrol(KoyYonetimi.kayittan(y.a, y.katalog, bozuk).tas_yatagi == null, "Bozuk optional alan çökmeden reddedilir")
	var kurt := _yeni()
	_bitir(kurt)
	var e: Array[Dictionary] = []
	KaynakKurtarici.sabah(kurt, e)
	var restored := KoyYonetimi.kayittan(kurt.a, kurt.katalog, JSON.parse_string(JSON.stringify(kurt.kaydet())))
	e.clear()
	KaynakKurtarici.sabah(restored, e)
	_kontrol(restored.tas_yatagi.kurtarici_sayisi == 1 and e.is_empty(), "Kurtarıcı sayacı ve aynı sabah kilidi restore edilir")

func _tohum() -> void:
	var a := _yeni(555)
	var b := _yeni(555)
	_kontrol(a.tas_yatagi.hucre == b.tas_yatagi.hucre, "Aynı tohum aynı başlangıç hücresi")
	_bitir(a)
	_bitir(b)
	var e: Array[Dictionary] = []
	KaynakKurtarici.sabah(a, e)
	KaynakKurtarici.sabah(b, e)
	_kontrol(a.tas_yatagi.hucre == b.tas_yatagi.hucre and a.tas_yatagi.rng.state == b.tas_yatagi.rng.state, "Aynı tohum aynı kurtarıcı hücresi")
	var r := RandomNumberGenerator.new()
	r.seed = 555
	_kontrol(a._rng.state == r.state, "Yatak ve kurtarıcı oyun RNG'sini tüketmez")

func _atama_ve_kapasite() -> void:
	var y := _yeni()
	var k := _isci(y)
	k.yas_grubu = &"cocuk"
	_kontrol(not y.ata(k.id, TasYatagi.IS_YERI), "Çocuk kazıya atanmaz")
	k.yas_grubu = &"yetiskin"
	k.bayraklar.append("agir_yarali")
	_kontrol(not y.ata(k.id, TasYatagi.IS_YERI), "Ağır yaralı kazıya atanmaz")
	k.bayraklar.erase("agir_yarali")
	y.ata(k.id, TasYatagi.IS_YERI)
	y.kaynaklar.kapasite = y.kaynaklar.toplam()
	var e: Array[Dictionary] = []
	var u := {}
	y.tas_yatagi.gece(y, u, e, {})
	_kontrol(y.tas_yatagi.kalan == 20 and u.is_empty(), "Ambar doluyken taş yatakta korunur")
	y.kaynaklar.azalt("gida", 2)
	y.gun += 1
	y.tas_yatagi.gece(y, u, e, {})
	_kontrol(y.tas_yatagi.kalan == 18 and u.tas == 2, "Kısmi kapasiteye sığan taş kadar yatak azalır")
	var once := y.kaydet()
	y.tas_yatagi.gece(y, u, e, {})
	_kontrol(y.kaydet() == once, "Aynı gece ikinci üretim yok")

func _acilis() -> void:
	var y := _yeni()
	for tur in ["hizarhane", "cadir", "cadir", "tarla"]:
		_kontrol(_kur(y, tur) != null, "Gerçek başlangıç stoğuyla açılış yapısı: " + tur)
	var k := _isci(y)
	y.ata(k.id, TasYatagi.IS_YERI)
	# BUG-22 stok dengesi bu maddede değiştirilmez. Mevcut tüccarı gerçek gecelerle bekle.
	var alindi := false
	for i in 9:
		if y.kervandan_al("odun", 3):
			alindi = true
			break
		y.gece()
	_kontrol(alindi, "Mevcut ticaret açılışın eksik odununu karşılar")
	_kontrol(y.gun < 10 and KaynakKurtarici.ocak_kurulabilir(y) and _kur(y, "tas_ocagi") != null, "Hızar + 2 çadır + tarla sonrası 10 gün içinde mevcut ocak kurulabilir")

func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.izgara.boyut.y:
		for cx in y.izgara.boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h).olur:
				var r := y.bina_kur(tur, h)
				if r.olur: return y.bina(r.id)
	return null

func _kontrol(olur: bool, metin: String) -> void:
	kontrol_sayisi += 1
	if not olur:
		hata += 1
		push_error(metin)
