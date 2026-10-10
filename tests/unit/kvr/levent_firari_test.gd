extends SceneTree
const FIRAR = preload("res://src/koy/levent_firari.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir() -> KoyYonetimi:
	var y := Oturum.new(kat, 1909).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 100, "odun": 100, "su": 100})
	y.akce = 200
	y.agalik = true
	y.a.muhafiz_azami = 20
	return y

func levent(y: KoyYonetimi, sadakat: int = 20) -> Koylu:
	var k := y.kabul({"ad": "Levent %d" % y.kabul_sayisi, "sinif": "asker", "stat": 8})
	k.sadakat = sadakat
	k.moral = 30
	dene(y.muhafiz_ata(k.id), "Gerçek nöbet ataması")
	return k

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var y := hazir()
	var ids: Array[int] = []
	for sadakat in [30, 10, 10, 20, 5]: ids.append(levent(y, sadakat).id)
	y.koylu(ids[1]).moral = 35
	y.koylu(ids[2]).moral = 20
	var olaylar: Array[Dictionary] = []
	var rng := y._rng.state
	var kaynak := y.kaynaklar.kaydet()
	var akce := y.akce
	FIRAR.gece(y, olaylar)
	dene(y.nufus() == 5 and olaylar.is_empty(), "Düşük sadakat tek başına krizde değilken firar yaratmaz")
	y.gun += 1
	KuyuKirliligi.kirlet(y)
	var guvenlik := KervanKorumasi.guvenlik(y)
	var savunma := y.savunma_gucu()
	dene(SavunmaKonuslanmasi.ata(y, ids[4], "kapi"), "Gerçek taktik rol")
	FIRAR.gece(y, olaylar)
	dene(y.nufus() == 2 and y.koylu(ids[4]) == null and y.koylu(ids[2]) == null and y.koylu(ids[1]) == null, "Sadakat, moral, ID sırasıyla tavan üç gerçek ayrılış")
	dene(y.koylu(ids[0]) != null and y.koylu(ids[3]) != null, "Kalan adaylar aynı krizde korunur")
	dene(SavunmaKonuslanmasi.durum(y).is_empty() and y.savunma_gucu() < savunma, "Ayrılan gerçek nöbet ve taktik rol katkısı kalkar")
	dene(y.asayis_riski == 46 and KervanKorumasi.guvenlik(y) < guvenlik and olaylar.size() == 1, "Tek mevcut Güvenlik, kişi başı +12 risk")
	dene(IflasYoneticisi.olay_metin(olaylar[0]).contains("Levent firarı") and IflasYoneticisi.olay_metin(olaylar[0]).contains("Güvenlik"), "CSV değiştirmeden mevcut gece raporu")
	dene(y.kaynaklar.kaydet() == kaynak and y.akce == akce and y._rng.state == rng and y.husumet.puan == 0, "İkinci yağma/kasa/sürgün husumeti/RNG yok")
	var kilit := JSON.stringify(y.kaydet())
	FIRAR.gece(y, olaylar)
	dene(JSON.stringify(y.kaydet()) == kilit and olaylar.size() == 1, "Aynı gece idempotent")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(kilit))
	dene(FIRAR.durum(geri) == FIRAR.durum(y) and geri.nufus() == y.nufus(), "JSON kilidi ve ayrılış kalıcı")
	y.gun += 1
	geri.gun = y.gun
	FIRAR.gece(y, olaylar)
	var geri_olay: Array[Dictionary] = []
	FIRAR.gece(geri, geri_olay)
	dene(y.nufus() == 2 and geri_olay.is_empty() and JSON.stringify(y.kaydet()) == JSON.stringify(geri.kaydet()), "Süren krizde yükleme ikinci dalga yaratmaz")
	y.gun += 3
	FIRAR.gece(y, olaylar)
	dene(not FIRAR.durum(y).kriz and not FIRAR.durum(y).firar_edildi, "Krizsiz gerçek gece yeni dönemin kilidini açar")
	y.gun += 1
	KuyuKirliligi.kirlet(y)
	FIRAR.gece(y, olaylar)
	dene(y.nufus() == 0 and y.asayis_riski == 70, "Yeni bağımsız kriz tekrar dalga yaratabilir; boş köy güvenli")
	_sinirlar()
	_kayit()
	_gece()
	_kitlik()
	print("LEVENT FİRARI: GEÇTİ" if hata == 0 else "LEVENT FİRARI: KALDI")
	quit(hata)

func _sinirlar() -> void:
	var y := hazir()
	var k := levent(y, 31)
	dene(not FIRAR.aday(y, k), "Sadakat31 korunur")
	k.sadakat = 30
	dene(FIRAR.aday(y, k), "Sadakat30/moral30 dahil")
	k.moral = 36
	dene(not FIRAR.aday(y, k), "Moral36 ve tok/borçsuz korunur")
	k.ac = true
	dene(FIRAR.aday(y, k), "Gerçek açlık düşük sadakatle risk")
	k.ac = false
	y.maas_durumu[str(k.id)] = {"borc": 1, "rusvet_akce": 0, "son_gece": 0}
	dene(FIRAR.aday(y, k), "Bordro borcu atama boşalsa da risk")
	y.maas_durumu.clear()
	k.moral = 35
	for yas in [&"cocuk", &"yasli"]:
		k.yas_grubu = yas
		dene(not FIRAR.aday(y, k), "Yalnız yetişkin levent")
	k.yas_grubu = &"yetiskin"
	k.adli_id = &"chr_021"
	dene(not FIRAR.aday(y, k), "Adlı hikâye kişisi korunur")
	k.adli_id = &""
	k.saglik = 0
	dene(not FIRAR.aday(y, k), "Ölüm ikinci kez firar sayılmaz")
	k.saglik = 100
	k.bayraklar.append("zindanda")
	dene(not FIRAR.aday(y, k), "Tutuklu korunur")
	k.bayraklar.clear()
	k.karantina = {"baslangic": 0, "bitis": 2, "bina": 1}
	dene(not FIRAR.aday(y, k), "Karantina korunur")
	k.karantina = {}
	y.kervan_koruma[str(k.id)] = {"baslangic": 0, "donus": 3}
	dene(not FIRAR.aday(y, k), "Dış görevdeki levent korunur")
	y.kervan_koruma.clear()
	k.sinif = &"ciftci"
	k.zanaat_turu = ZanaatTuru.Tur.CIFTCI
	dene(not FIRAR.aday(y, k), "Nöbetteki çiftçi levent değil")
	k.zanaat_turu = ZanaatTuru.Tur.ASKER
	dene(FIRAR.aday(y, k), "Birincil asker mesleği dahil")
	k.gizli_bayraklar = PackedStringArray(["casus", "hasta"])
	SaglikYoneticisi.enfekte(y, k, "humma")
	dene(FIRAR.kriz(y) == "", "Gizli hasta/casus açık kriz yaratmaz")
	k.bayraklar.append("hasta")
	dene(FIRAR.kriz(y) == "salgın", "Görünür belirtili salgın krizi")
	y.set_meta(KitlikIsyani.META, {"kitlik_gece_sayisi": 2, "tetiklendi": true, "kapi_kirik": true, "son_gece": 0})
	y.isyan_kalan = 3
	dene(FIRAR.kriz(y) == "kıtlık isyanı", "KRI06 mevcut kıtlık tetikleyicisi")
	y.asayis_riski = 99
	var olay: Array[Dictionary] = []
	FIRAR.gece(y, olay)
	dene(y.asayis_riski == 100 and KervanKorumasi.guvenlik(y) == 0 and olay[0].levent_firari.asayis_kaybi == 1, "Risk100/Güvenlik0 ve gerçek kesinti makbuzu")
	var z := hazir()
	levent(z)
	z.son = KoyYonetimi.SON_ISYAN
	KuyuKirliligi.kirlet(z)
	var once := JSON.stringify(z.kaydet())
	FIRAR.gece(z, olay)
	dene(JSON.stringify(z.kaydet()) == once, "Terminal durum salt okunur")
	var bekleyen := hazir()
	var sadik := levent(bekleyen, 60)
	KuyuKirliligi.kirlet(bekleyen)
	FIRAR.gece(bekleyen, olay)
	dene(not FIRAR.durum(bekleyen).firar_edildi, "Aday yoksa dönem hakkı tüketilmez")
	bekleyen.gun += 1
	sadik.sadakat = 20
	FIRAR.gece(bekleyen, olay)
	dene(bekleyen.nufus() == 0, "Süren krizde sonradan risk eşiğine gelen levent")

func _kayit() -> void:
	var y := hazir()
	levent(y)
	var eski := y.kaydet()
	eski.erase("levent_firari")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, eski)
	dene(FIRAR.durum(geri) == FIRAR.oku({}), "Legacy kayıtta hayalet geçmiş yok")
	for bozuk in [null, [], "x", {"son_gece": NAN, "kriz": true, "firar_edildi": true}, {"son_gece": INF, "kriz": false, "firar_edildi": false}, {"son_gece": 0.5, "kriz": true, "firar_edildi": false}, {"son_gece": 0, "kriz": false, "firar_edildi": true}, {"son_gece": -1, "kriz": true, "firar_edildi": false}, {"son_gece": 0, "kriz": 1, "firar_edildi": "evet"}]:
		dene(FIRAR.oku(bozuk) == FIRAR.oku({}), "Bozuk optional alan güvenli")
	FIRAR.yukle(y, {"son_gece": 500, "kriz": true, "firar_edildi": true})
	dene(FIRAR.durum(y) == FIRAR.oku({}), "Gelecek gece kilidi reddedilir")

func _gece() -> void:
	var y := hazir()
	var k := levent(y)
	# Kirli kuyu gerçek geceye mevcut API ile girer; eski moral isyanı başlamaz.
	KuyuKirliligi.kirlet(y)
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
	var r := y.gece()
	var rr := geri.gece()
	dene(r == rr and JSON.stringify(y.kaydet()) == JSON.stringify(geri.kaydet()), "Gerçek gece ve RNG JSON devam eşit")
	dene(y.koylu(k.id) == null and r.olenler.is_empty() and r.olaylar.any(func(e: Dictionary) -> bool: return e.has("levent_firari")), "Gerçek gece firarı ölüm/yas değildir")

func _kitlik() -> void:
	var y := hazir()
	y.kaynaklar.azalt("gida", 1000)
	for i in 2:
		var k := levent(y)
		k.moral = 100
	var r := y.gece()
	dene(y.nufus() == 2 and not r.olaylar.any(func(e: Dictionary) -> bool: return e.has("levent_firari")), "İlk gerçek açlık gecesi ağır kıtlık değildir")
	r = y.gece()
	dene(r.olaylar.any(func(e: Dictionary) -> bool: return e.has("kitlik_isyani")) and r.olaylar.any(func(e: Dictionary) -> bool: return e.has("levent_firari")), "İkinci gerçek sıfır gece mevcut yağma + tek levent dalgası")
	dene(y.nufus() == 0 and r.olenler.is_empty() and r.olaylar.filter(func(e: Dictionary) -> bool: return e.get("anahtar") == "koy.olay.firar").is_empty(), "KRI06 eski rastgele firar kilidi korunur; iki gerçek levent ölüm değildir")
