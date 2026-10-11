extends SceneTree
var hata := 0
var kat: Katalog
func _initialize() -> void:
	# Kaynak kuyu/CAS testi; alışma kapısı ayrı tehdit_takvimi_test içindedir.
	preload("res://src/sistemler/tehdit_takvimi.gd").AYAR.tehdit_baslangic_gunu = 0
	kat = Katalog.new()
	kat.yukle()
	_su_ve_rng()
	_tifo_ve_tedavi()
	_tetikleyiciler()
	_kirec_ve_kayit()
	print("KUYU KİRLİLİĞİ: GEÇTİ" if hata == 0 else "KUYU KİRLİLİĞİ: KALDI")
	quit(hata)

func hazir(tohum: int = 22, n: int = 4) -> Oturum:
	var o := Oturum.new(kat, tohum)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.a.iyilesme = 0
	y.a.isyan_esigi = -1
	y.kaynaklar.kapasite = 10000
	for t in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 500)
	for i in n: y.kabul({"ad": "Su köylüsü %d" % i})
	return o

func _su_ve_rng() -> void:
	var o := hazir(77, 12)
	var y := o.yonetim
	var rng := y._rng.state
	KuyuKirliligi.gece(y, {"taze": 20}, [])
	dene(not KuyuKirliligi.kirli(y) and y._rng.state == rng, "Temiz kuyu RNG/hastalık üretmez")
	y.gun = 7 # Yaz: iki su/kişi, 20 taze suyu yalnız ilk on kişi kullanır.
	KuyuKirliligi.kirlet(y)
	dene(KuyuKirliligi.icenler(y, {"taze": 20}).size() == 10, "Yaz tüketimi mevcut su raporundan aynı ilk N kişiyi seçer")
	dene(KuyuKirliligi.icenler(y, {"taze": 0}).is_empty(), "Rezerv veya susuz kalanlar taze kuyuyu kullanmaz")
	var once := JSON.stringify(y.kaydet())
	dene(not SuDengesi.doldur(y) and JSON.stringify(y.kaydet()) == once, "Kirli kuyu yeni temiz rezerv yaratamaz; atomik ret")
	var kontrol := RandomNumberGenerator.new()
	kontrol.state = y._rng.state
	var beklenen: Array[int] = []
	for k in KuyuKirliligi.icenler(y, {"taze": 20}):
		if beklenen.size() == SaglikYoneticisi.AZAMI_YENI: break
		if kontrol.randi_range(1, 100) <= int(SaglikYoneticisi.AYAR.tifo.risk): beklenen.append(k.id)
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	var ol: Array[Dictionary] = []
	KuyuKirliligi.gece(y, {"taze": 20}, ol)
	KuyuKirliligi.gece(geri, {"taze": 20}, [])
	dene(y._rng.state == kontrol.state and y.koylular.filter(func(k: Koylu) -> bool: return SaglikYoneticisi.hasta(k)).map(func(k: Koylu) -> int: return k.id) == beklenen, "Mevcut RNG, kullanıcı sırası ve iki vaka tavanı")
	dene(y.kaydet() == geri.kaydet(), "Kirli kuyu ve yeni tifo JSON devamı birebir eşit")
	dene(not SaglikYoneticisi.hasta(y.koylular[10]) and not SaglikYoneticisi.hasta(y.koylular[11]), "Rezerv/susuz kullanıcıda tifo yok")
	once = JSON.stringify(y.kaydet())
	KuyuKirliligi.gece(y, {"taze": 20}, ol)
	dene(JSON.stringify(y.kaydet()) == once and ol.size() == 1, "Aynı gece ikinci tifo/RNG/rapor yok")
	y.gun = 10
	rng = y._rng.state
	KuyuKirliligi.gece(y, {"taze": 20}, [])
	dene(not KuyuKirliligi.kirli(y) and y._rng.state == rng, "Üç gece sonunda kirlenme biter, yeni zar çekilmez")
	dene(SuDengesi.doldur(y), "Temizlenince aynı rezerv hizmeti yeniden işler")
	o = hazir()
	y = o.yonetim
	KuyuKirliligi.kirlet(y)
	rng = y._rng.state
	KuyuKirliligi.gece(y, {"taze": 20}, [], SaglikYoneticisi.AZAMI_YENI)
	dene(y._rng.state == rng and y.koylular.all(func(k: Koylu) -> bool: return not SaglikYoneticisi.hasta(k)), "Temas iki vaka kotasını doldurunca su kaynaklı ek vaka/RNG yok")

func _tifo_ve_tedavi() -> void:
	var o := hazir(92, 2)
	var y := o.yonetim
	var k := y.koylular[0]
	var komsu := y.koylular[1]
	var ev := kur(y, "cadir")
	k.ev = ev.id
	komsu.ev = ev.id
	dene(SaglikYoneticisi.enfekte(y, k, "tifo") and SaglikYoneticisi.metin(k, y).is_empty(), "Tifo tek enfeksiyon API'sinde gizli kuluçkayla başlar")
	var rng := y._rng.state
	SaglikYoneticisi.gece(y, [])
	SaglikYoneticisi.saglik_kaybi(y, k)
	SaglikYoneticisi.saglik_kaybi(y, k)
	dene(k.saglik == 90 and not SaglikYoneticisi.hasta(komsu) and y._rng.state == rng, "Tifo sağlık makbuzu tek; ortak evden bulaşma/RNG yok")
	dene(SaglikYoneticisi.metin(k, y).contains("Tifo") and SaglikYoneticisi.metin(k, y).contains("su kaynaklı"), "Hasta kartı tifo ve su yolunu gösterir")
	var sif := kur(y, "sifahane")
	var hekim := y.kabul({"zanaat_turu": "CERRAH", "stat": 8})
	dene(y.ata(hekim.id, sif.id), "Mevcut Şifahane hekimi atandı")
	y.gun += 1
	SaglikYoneticisi.gece(y, [])
	SaglikYoneticisi.saglik_kaybi(y, k)
	dene(k.saglik == 88 and HekimIlac.etkin(y), "Tifoda mevcut yetkin hekim 10→2 kayıp")
	y.kaynaklar.ekle("ilac", 1)
	SaglikYoneticisi.tedavi(y, [])
	dene(not SaglikYoneticisi.hasta(k) and k.saglik == 100 and y.kaynaklar.miktar("ilac") == 0 and SifahaneKontenjani.durum(y).kullanilan == 1, "Tifo aynı ilaç tedavisi/ortak kontenjanla iyileşir")
	SaglikYoneticisi.enfekte(y, k, "tifo")
	y.gun += 5
	SaglikYoneticisi.gece(y, [])
	dene(not SaglikYoneticisi.hasta(k), "Tifo beş günlük doğal süreyle iyileşir")
	# Aynı temas kapısı: karantina/zindan/dış görev kuyuda rutin kullanıcısı sayılmaz.
	komsu.karantina = {"baslangic": y.gun, "bitis": y.gun + 2, "bina": sif.id}
	dene(not KuyuKirliligi.icenler(y, {"taze": 20}).has(komsu), "Karantina mevcut kuyu rutininden çıkarır")
	komsu.karantina.clear()
	komsu.bayraklar.append("zindanda")
	dene(not KuyuKirliligi.icenler(y, {"taze": 20}).has(komsu), "Zindan su rutininden çıkarır")
	komsu.bayraklar.erase("zindanda")
	y.kervan_koruma[str(komsu.id)] = {"baslangic": y.gun, "donus": y.gun + 2}
	dene(not KuyuKirliligi.icenler(y, {"taze": 20}).has(komsu), "Dış görev su rutininden çıkarır")

func _tetikleyiciler() -> void:
	var o := hazir(77, 1)
	var y := o.yonetim
	var sonuc := o.karar_ver(o._adli_gelen(&"chr_002"), &"kabul")
	y.gun = 2
	var ol: Array[Dictionary] = []
	KuyuZehirleme.gece(y, {"taze": 20}, ol)
	dene(KuyuKirliligi.kirli(y) and CasusGeceTakibi.acik_izler(y).is_empty(), "Gerçek CAS sabotajı kirlenme getirir; fail ifşa edilmez")
	dene(not KuyuKirliligi.metin(y).contains(y.koylu(sonuc.koylu_id).ad) and not KuyuKirliligi.durum(y).has("kisi"), "Kuyu bilgisi gizli fail/kimlik tutmaz")
	y.kaynaklar.ekle("kirec", 2)
	var kanit := CasusGeceTakibi.durum(y)
	var cas := KuyuZehirleme.durum(y)
	dene(KuyuKirliligi.kirecle(y) and CasusGeceTakibi.durum(y) == kanit and KuyuZehirleme.durum(y) == cas, "Dezenfeksiyon CAS fiil/karar kanıtını silmez")
	o = hazir()
	y = o.yonetim
	dene(KrizEnjektoru.tetikle(o, "kuyu").ok and KuyuKirliligi.kirli(y), "ADM-14 gerçek kuyu kirlenmesini başlatır")
	y.kaynaklar.ekle("kirec", 2)
	dene(KuyuKirliligi.kirecle(y) and KrizEnjektoru.kalan(y) == 0, "Acil kireçleme debug zehir kaynağını da durdurur")
	var saglik := y.koylular[0].saglik
	KrizEnjektoru.gece(y, [])
	dene(y.koylular[0].saglik == saglik, "Dezenfeksiyondan sonra debug sağlık hasarı yok")
	y.gun = 28
	IlkbaharTaskini.gece(y, [])
	dene(KuyuKirliligi.kirli(y), "MEV-06 taşkını kuyu kirlenmesini besler")
	y.kaynaklar.ekle("kirec", 2)
	dene(KuyuKirliligi.kirecle(y) and IlkbaharTaskini.durum(y).hasar, "Kireçleme bent onarımı yerine geçmez")
	y.gun += 1
	IlkbaharTaskini.gece(y, [])
	dene(KuyuKirliligi.kirli(y), "Kırık bent ertesi gece yeniden kirletir")
	y.kaynaklar.ekle("kirec", 2)
	dene(o.olay_uygula(o.olay_sec(), 0).ok and not KuyuKirliligi.kirli(y), "Mevcut taş/kireçli bent seçimi ikinci bedelsiz temizlik yapar")
	o = hazir(44, 5)
	y = o.yonetim
	for i in 3: SaglikYoneticisi.enfekte(y, y.koylular[i], "humma")
	KuyuKirliligi.gece(y, {"taze": 0}, [])
	dene(not KuyuKirliligi.kirli(y), "Gizli kuluçka hasta yoğunluğu olarak ifşa edilmez")
	y.gun += 1
	for i in 3: y.koylular[i].bayrak_ac("hasta")
	KuyuKirliligi.gece(y, {"taze": 0}, [])
	dene(KuyuKirliligi.kirli(y), "Üç açık belirti ve yüzde25 eşiği kirletir")
	y.kaynaklar.ekle("kirec", 2)
	KuyuKirliligi.kirecle(y)
	y.gun += 1
	KuyuKirliligi.gece(y, {"taze": 0}, [])
	dene(not KuyuKirliligi.kirli(y), "Aynı yoğunlukta başarılı temizlik ertesi gün geri alınmaz")
	SaglikYoneticisi.iyilestir(y.koylular[0])
	y.gun += 1
	KuyuKirliligi.gece(y, {"taze": 0}, [])
	SaglikYoneticisi.enfekte(y, y.koylular[0], "humma")
	y.koylular[0].bayrak_ac("hasta")
	y.gun += 1
	KuyuKirliligi.gece(y, {"taze": 0}, [])
	dene(KuyuKirliligi.kirli(y), "Yeni yoğunluk eşik geçişi yeni kirlenme üretir")

func _kirec_ve_kayit() -> void:
	var o := hazir()
	var y := o.yonetim
	KuyuKirliligi.kirlet(y)
	SaglikYoneticisi.enfekte(y, y.koylular[0], "tifo")
	var once := JSON.stringify(y.kaydet())
	dene(not KuyuKirliligi.kirecle(y) and not KuyuKirliligi.kirecle(y, 999) and JSON.stringify(y.kaydet()) == once, "Yetersiz kireç/olmayan bina atomik ret")
	y.kaynaklar.ekle("kirec", 2)
	var kayit := y.kaydet()
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(kayit)))
	dene(KuyuKirliligi.kirli(geri) and geri.koylular[0].enfeksiyon == y.koylular[0].enfeksiyon, "Optional kirlenme ve tifo aynı kayıtta korunur")
	var r1 := y.gece()
	var r2 := geri.gece()
	dene(r1 == r2 and y.kaydet() == geri.kaydet(), "Gerçek gece sağlık/RNG/rapor kayıt devamı eşit")
	var enfeksiyon := y.koylular[0].enfeksiyon.duplicate()
	var rng := y._rng.state
	dene(KuyuKirliligi.kirecle(y) and SaglikYoneticisi.hasta(y.koylular[0]) and y.koylular[0].enfeksiyon == enfeksiyon and y._rng.state == rng, "2 kireç yalnız suyu temizler; tifo tedavisi/RNG yok")
	once = JSON.stringify(y.kaydet())
	dene(not KuyuKirliligi.kirecle(y) and JSON.stringify(y.kaydet()) == once, "Çift tıklama ikinci bedel çıkarmaz")
	geri = KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(once))
	dene(not KuyuKirliligi.kirli(geri), "Temizlenen kuyu kayıtta temiz açılır")
	kayit.erase("kuyu_kirliligi")
	dene(not KuyuKirliligi.kirli(KoyYonetimi.kayittan(y.a, y.katalog, kayit)), "Legacy alan yoksa temiz kuyu")
	for v in [null, [], "kirli", {"baslangic": 0, "bitis": 3, "son_gece": -1, "yogunluk": "evet"}]:
		dene(KuyuKirliligi.oku(v).bitis == -1, "Bozuk optional kayıt güvenli temiz")
	for alan in ["baslangic", "bitis", "son_gece"]:
		for bozuk in [NAN, INF, 0.5, -2, "3", 1000000001]:
			var d := {"baslangic": 0, "bitis": 3, "son_gece": -1, "yogunluk": false}
			d[alan] = bozuk
			dene(KuyuKirliligi.oku(d).bitis == -1, "Bozuk sayı reddi: " + alan)
	KuyuKirliligi.yukle(y, {"baslangic": 50, "bitis": 53, "son_gece": -1, "yogunluk": false})
	dene(not KuyuKirliligi.kirli(y), "Gelecek tarihli kirlilik güvenli temiz")
	KuyuKirliligi.kirlet(y)
	y.gun += 3
	geri = KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	dene(KuyuKirliligi.durum(y) == KuyuKirliligi.durum(geri), "Süresi bitmiş kirlenme kayıt/sorguda aynı normalize edilir")
	# Mevcut legacy CHR hedef bina kaydı: yeni kurulabilir bina üretilmez.
	var b := KoyBinasi.new()
	b.id = 999
	b.tur = "su_kuyusu"
	b.insa_kalan = 1
	y.binalar.append(b)
	KuyuKirliligi.kirlet(y)
	y.kaynaklar.ekle("kirec", 2)
	once = JSON.stringify(y.kaydet())
	dene(not KuyuKirliligi.kirecle(y, b.id) and JSON.stringify(y.kaydet()) == once, "Hazır olmayan kuyu bina bilgisi bedel almaz")
	b.insa_kalan = 0
	dene(KuyuKirliligi.kirecle(y, b.id), "Hazır mevcut kuyu bina kaydı aynı kaynağı temizler")
	KuyuKirliligi.kirlet(y)
	y.binalar.erase(b)
	once = JSON.stringify(y.kaydet())
	dene(not KuyuKirliligi.kirecle(y, b.id) and JSON.stringify(y.kaydet()) == once, "Silinmiş binanın bayat kartı bedel almaz")
	y.son = "halk_kirildi"
	once = JSON.stringify(y.kaydet())
	KuyuKirliligi.kirlet(y)
	dene(not KuyuKirliligi.kirecle(y) and JSON.stringify(y.kaydet()) == once, "Bitmiş oturum kirlilik/bedel üretmez")

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
