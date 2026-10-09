extends SceneTree
var hata := 0
var kat: Katalog
func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_kontenjan()
	_temas()
	_gece_ve_kayit()
	_gunluk_adaptorler()
	_bozuk_ve_legacy()
	print("KARANTINA: GEÇTİ" if hata == 0 else "KARANTINA: KALDI")
	quit(hata)

func _kontenjan() -> void:
	var o := hazir()
	var y := o.yonetim
	var k := y.kabul({"ad":"Şüpheli"})
	var sabit := y.kaydet()
	dene(not KarantinaYoneticisi.al(y, k.id) and y.kaydet() == sabit, "Şifahane yok: atomik ret")
	var b := kur(y, "sifahane")
	dene(KarantinaYoneticisi.bos(y) == 0, "Hekimsiz kontenjan yok")
	var hekim := doktor(y, b)
	dene(KarantinaYoneticisi.bos(y) == 2, "Seviye1 iki yatak")
	SifahaneKontenjani.kullan(y)
	dene(Sifahane.tedavi_kapasitesi(y) == 0 and KarantinaYoneticisi.bos(y) == 2, "Tedavi makbuzu yatak kotasını yeniden tüketmez")
	b.seviye = 2
	dene(KarantinaYoneticisi.bos(y) == 3, "Seviye2 +%20 yukarı yuvarlama")
	b.seviye = 100
	dene(KarantinaYoneticisi.bos(y) == 4, "Bina başına sert tavan4")
	b.seviye = 1
	b.insa_kalan = 1
	dene(KarantinaYoneticisi.bos(y) == 0, "Hazır olmayan bina kabul etmez")
	b.insa_kalan = 0
	y.isyan_kalan = 1
	dene(KarantinaYoneticisi.bos(y) == 0, "İsyanda hizmet durur")
	y.isyan_kalan = -1
	hekim.ac = true
	dene(KarantinaYoneticisi.bos(y) == 0, "İş göremeyen hekimde hizmet durur")
	hekim.ac = false
	var gida := y.kaynaklar.miktar("gida")
	var moral := k.moral
	var rng := y._rng.state
	dene(KarantinaYoneticisi.al(y, k.id), "Oyuncu sağlıklı şüpheliyi seçebilir")
	dene(y.kaynaklar.miktar("gida") == gida - 1 and k.moral == moral - 2 and y._rng.state == rng, "Küçük tek bedel, RNG yok")
	sabit = y.kaydet()
	dene(not KarantinaYoneticisi.al(y, k.id) and y.kaydet() == sabit, "Çift giriş süre/bedel eklemez")
	var ikinci := y.kabul({})
	var ucuncu := y.kabul({})
	dene(KarantinaYoneticisi.al(y, ikinci.id) and KarantinaYoneticisi.bos(y) == 0, "Kontenjan doldu")
	sabit = y.kaydet()
	dene(not KarantinaYoneticisi.al(y, ucuncu.id) and y.kaydet() == sabit, "Dolu kontenjana atomik ret")
	dene(KarantinaYoneticisi.cikar(y, k.id) and KarantinaYoneticisi.bos(y) == 1 and y.kaynaklar.miktar("gida") == gida - 2, "Erken çıkış yatak açar, bedel iade edilmez")
	dene(not KarantinaYoneticisi.cikar(y, k.id), "Çift çıkış etkisiz")
	y.kaynaklar.azalt("gida", y.kaynaklar.miktar("gida"))
	sabit = y.kaydet()
	dene(not KarantinaYoneticisi.al(y, k.id) and y.kaydet() == sabit, "Erzaksız giriş atomik ret")
	y.kaynaklar.ekle("gida", 10)
	dene(KarantinaYoneticisi.al(y, hekim.id) and KarantinaYoneticisi.bos(y) == 0 and Sifahane.tedavi_kapasitesi(y) == 0, "Hekim de oyuncu kararıyla izole olabilir; hizmeti durur")
	dene(KarantinaYoneticisi.aktif(ikinci), "Hizmet durması mevcut izolasyonu bozmaz")
	KarantinaYoneticisi.cikar(y, hekim.id)
	dene(KarantinaYoneticisi.bos(y) == 1, "Hekim dönünce hizmet açılır")
	k.bayrak_ekle(DivanHukmu.FLAG)
	sabit = y.kaydet()
	dene(not KarantinaYoneticisi.al(y, k.id) and y.kaydet() == sabit, "Zindandaki kişi alınmaz")
	k.bayraklar.erase(DivanHukmu.FLAG)
	k.saglik = 0
	dene(not KarantinaYoneticisi.al(y, k.id) and not KarantinaYoneticisi.al(y, 99999), "Ölü ve eksik kişi alınmaz")
	k.saglik = 100
	y.kervan_koruma[str(k.id)] = {"baslangic":y.gun,"donus":y.gun+2}
	dene(not KarantinaYoneticisi.al(y, k.id), "Kervan korumasındaki kişi alınmaz")
	y.kervan_koruma.clear()
	y.son = &"bitti"
	dene(not KarantinaYoneticisi.al(y, k.id) and not KarantinaYoneticisi.cikar(y, ikinci.id), "Biten oturum eylem üretmez")

func _temas() -> void:
	# Her iki yönü de %100 riskle, ev ve iş temasında ayrı ayrı doğrula.
	var oran: int = SaglikYoneticisi.AYAR.veba.risk
	SaglikYoneticisi.AYAR.veba.risk = 100
	for ev_temasi in [true, false]:
		for kaynak_izole in [true, false]:
			var y := hazir().yonetim
			var b := kur(y, "sifahane")
			doktor(y, b)
			var ortak := kur(y, "cadir" if ev_temasi else "tarla")
			var a := y.kabul({"gizli":["veba"]})
			var hedef := y.kabul({})
			if ev_temasi:
				a.ev = ortak.id
				hedef.ev = ortak.id
			else:
				a.is_yeri = ortak.id
				hedef.is_yeri = ortak.id
			var izole := a if kaynak_izole else hedef
			dene(KarantinaYoneticisi.al(y, izole.id), "İzolasyon seçimi")
			dene(not SaglikYoneticisi.temas_edebilir(y, izole), "Tek temas kapısı kapalı")
			var rng := y._rng.state
			SaglikYoneticisi.gece(y, [])
			dene(not SaglikYoneticisi.hasta(hedef) and y._rng.state == rng, "Karantina iki yönde ev/iş bulaşmasını ve temas zarını engeller")
			dene(KarantinaYoneticisi.cikar(y, izole.id) and SaglikYoneticisi.temas_edebilir(y, izole), "Erken çıkış temas kapısını açar")
			y.gun += 1
			SaglikYoneticisi.gece(y, [])
			dene(SaglikYoneticisi.hasta(hedef), "Çıkıştan sonraki gecede gerçek bulaşma yeniden açılır")
	SaglikYoneticisi.AYAR.veba.risk = oran

func _gece_ve_kayit() -> void:
	var o := hazir()
	var y := o.yonetim
	var b := kur(y, "sifahane")
	doktor(y, b)
	var isyeri := kur(y, "tarla")
	var ev := kur(y, "cadir")
	var k := y.kabul({"ad":"Şüpheli çalışan"})
	dene(y.ata(k.id, isyeri.id), "Gerçek iş ataması")
	k.ev = ev.id
	var gizli := k.gizli_bayraklar.duplicate()
	var acik := k.bayraklar.duplicate()
	dene(KarantinaYoneticisi.al(y, k.id), "Çalışan karantinada")
	var gun := y.gun
	var rng := y._rng.state
	var gorunen := KarantinaYoneticisi.metin(y, k)
	dene(not gorunen.contains("hasta") and not gorunen.contains("Humma") and not gorunen.contains("Veba") and k.gizli_bayraklar == gizli and k.bayraklar == acik, "Şüphe eylemi hastalık/bayrak yaratmaz")
	dene(not CirakEgitimi.saglam(k) and not y.ata(k.id, b.id) and not y.muhafiz_ata(k.id) and not KoyluKartiVerisi.ata(y,k.id,KoyYonetimi.BOSTA), "Çalışma ve atama kilitleri")
	y.bosalt(k.id)
	dene(k.is_yeri == isyeri.id and y.calisanlar(isyeri.id).has(k), "İş yuvası rezerve")
	var calismalar := {}
	y._uret({}, [], calismalar)
	dene(not calismalar.has(k.id), "İzolasyonda gerçek üretim yok")
	var geri := geri_yukle(o)
	dene(geri.yonetim.koylu(k.id).karantina == k.karantina and geri.yonetim._rng.state == rng, "JSON optional kayıt/RNG")
	var rapor := y.gece()
	var geri_rapor := geri.yonetim.gece()
	dene(geri_rapor == rapor and ayni_kayit(y,geri.yonetim), "Birinci gerçek gece restore eşitliği")
	dene(y.gun == gun + 1 and KarantinaYoneticisi.aktif(k) and k.ev == ev.id and k.is_yeri == isyeri.id and rapor.uretim.is_empty(), "İlk gün dönüş yok; atama ve üretim korunur")
	geri = geri_yukle(o)
	rapor = y.gece()
	geri_rapor = geri.yonetim.gece()
	dene(geri_rapor == rapor and ayni_kayit(y,geri.yonetim), "İkinci gerçek gece restore eşitliği")
	dene(y.gun == gun + 2 and not KarantinaYoneticisi.aktif(k) and k.ev == ev.id and k.is_yeri == isyeri.id and rapor.uretim.is_empty(), "İki gecede de çalışmaz; ikinci sabah döner")
	calismalar.clear()
	y._uret({}, [], calismalar)
	dene(calismalar.has(k.id), "Dönüşte aynı işte gerçek üretim")
	# Sağlıklı muhafızın ataması/borcu korunur, etkin savunma ve kervan adaylığı kapanır.
	var guard := y.kabul({"sinif":"asker"})
	var kisla := kur(y, "muhafiz_kislasi")
	dene(y.ata(guard.id, kisla.id), "Kışla ataması")
	var etkin := y.etkin_muhafiz_sayisi()
	var savunma := y.savunma_gucu()
	dene(KarantinaYoneticisi.al(y, guard.id) and y.etkin_muhafiz_sayisi() == etkin - 1 and y.savunma_gucu() < savunma and not KervanKorumasi.aday(y, guard.id), "İzole nöbetçi/asker savunmaz ve kiralanmaz")
	var para := y.akce
	MuhafizMaasi.ode(y, [])
	dene(y.akce == para and guard.is_yeri == kisla.id and not y.maas_durumu.has(str(guard.id)), "Çalışılmayan nöbette yeni maaş/borç ve atama değişimi yok")
	KarantinaYoneticisi.cikar(y, guard.id)
	dene(y.etkin_muhafiz_sayisi() == etkin, "Nöbetçi görevine döner")
	# Kış kaydırması/bahar dönüşü, evsiz barındırma ve inşaat yardımı.
	dene(KarantinaYoneticisi.al(y, k.id), "Yeniden isteğe bağlı izolasyon")
	y.gun = int(k.karantina.baslangic)
	y._kis_kaydirmasi()
	dene(k.is_yeri == isyeri.id and k.kis_oncesi_is == -1, "Karantinada mevsim işi değiştirmez")
	k.ev = -1
	y._barindir()
	dene(k.ev == -1, "Evsiz ataması izolasyonda korunur")
	y.binalar.erase(b)
	KarantinaYoneticisi.esitle(y)
	dene(not KarantinaYoneticisi.aktif(k) and k.is_yeri == isyeri.id, "Koğuş binası kaldırıldıysa hayalet izolasyon kalmaz")

func _bozuk_ve_legacy() -> void:
	var y := hazir().yonetim
	var b := kur(y,"sifahane")
	doktor(y,b)
	var k := y.kabul({})
	KarantinaYoneticisi.al(y,k.id)
	var v := k.kaydet()
	v.erase("karantina")
	dene(not KarantinaYoneticisi.aktif(Koylu.kayittan(v)), "Legacy kayıt güvenli")
	for bozuk in [null, [], "karantina", {}, {"baslangic":0,"bitis":3,"bina":b.id}, {"baslangic":0,"bitis":2,"bina":0}]:
		dene(KarantinaYoneticisi.oku(bozuk).is_empty(), "Bozuk optional kayıt ret")
	for alan in ["baslangic","bitis","bina"]:
		for n in [null,"1",true,0.5,-1,INF,NAN,1000000001]:
			var d := k.karantina.duplicate()
			d[alan] = n
			dene(KarantinaYoneticisi.oku(d).is_empty(), "Bozuk sayısal alan ret")
	for d in [{"baslangic":10,"bitis":12,"bina":b.id}, {"baslangic":0,"bitis":2,"bina":9999}]:
		k.karantina = d
		KarantinaYoneticisi.esitle(y)
		dene(not KarantinaYoneticisi.aktif(k), "Gelecek/olmayan bina bağlamı güvenli")
	k.karantina = {"baslangic":0,"bitis":2,"bina":b.id}
	y.gun = 2
	KarantinaYoneticisi.esitle(y)
	dene(not KarantinaYoneticisi.aktif(k), "Süresi geçmiş kayıt geri kilitlemez")
	var eski := y.kaydet()
	for x in eski.koylular: x.erase("karantina")
	var legacy := KoyYonetimi.kayittan(y.a,y.katalog,eski)
	dene(legacy.koylular.all(func(a: Koylu)->bool: return not KarantinaYoneticisi.aktif(a)), "Legacy yönetim yükleme yeni karantina üretmez")

func _gunluk_adaptorler() -> void:
	var y := hazir().yonetim
	var sif := kur(y,"sifahane")
	doktor(y,sif)
	var k := y.kabul({"ad":"Şüpheli yardımcı"})
	y.a.insa_yardim_bolen = 1
	var insaat := kur(y,"tarla")
	insaat.insa_kalan = 5
	KarantinaYoneticisi.al(y,k.id)
	y._insaat()
	dene(insaat.insa_kalan == 4, "Karantinadaki boşta kişi inşaat yardımına katılmaz")
	k.gizli_egilim = {"tur":"haydut","calinan":0,"son_gece":0,"yakalanma":false}
	var rng := y._rng.state
	GizliEgilimler.gece(y,{},[])
	dene(y._rng.state == rng and k.gizli_egilim.calinan == 0, "İzolasyonda ambar teması/hırsızlık zarı yok")
	KarantinaYoneticisi.cikar(y,k.id)
	insaat.insa_kalan = 0
	dene(y.ata(k.id,insaat.id), "İş ortaklığı ataması")
	var diger := y.kabul({})
	dene(y.ata(diger.id,insaat.id), "İkinci iş ortağı")
	k.toplumsal_bag = {"grup":"a","dusman_gruplar":["b"]}
	diger.toplumsal_bag = {"grup":"b","dusman_gruplar":["a"]}
	dene(KanDavasi.engel(y,insaat.id), "Düşmanlar normalde aynı işte engel")
	KarantinaYoneticisi.al(y,k.id)
	dene(not KanDavasi.engel(y,insaat.id), "Ataması korunsa da izole kişi işyerinde kavga etmez")
	var onizleme := AtamaOnizlemesi.brut(y,insaat)
	dene(not onizleme.is_empty() and not AtamaOnizlemesi.oku(y,k.id,sif.id).olur, "Önizleme izole atamayı reddeder, kalan çalışanı hesaplar")
	KarantinaYoneticisi.cikar(y,k.id)
	var degirmen := kur(y,"degirmen")
	dene(y.ata(k.id,degirmen.id) and DegirmenHareketi.aday(y,k,&"gunduz"), "Değirmenci normalde görsel işi yapar")
	KarantinaYoneticisi.al(y,k.id)
	dene(not DegirmenHareketi.aday(y,k,&"gunduz") and not DegirmenHareketi.aktif(y,degirmen.id,&"gunduz"), "İzole çalışan değirmen çarkını da çalıştırmaz")

func hazir() -> Oturum:
	var o := Oturum.new(kat,222)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida","odun","tas","kereste"]: y.kaynaklar.ekle(tur,500)
	return o
func ayni_kayit(y: KoyYonetimi,g: KoyYonetimi) -> bool:
	# JSON sayıları float yükler; mevcut bina maliyeti int/float farkı mekanik fark değildir.
	return JSON.parse_string(JSON.stringify(y.kaydet())) == JSON.parse_string(JSON.stringify(g.kaydet()))
func geri_yukle(o: Oturum) -> Oturum:
	var a := kat.koy_ayarlari
	kat.koy_ayarlari = o.yonetim.a
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	kat.koy_ayarlari = a
	return geri
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx,cy)
			if y.yerlesim(tur,h).olur:
				var b := y.bina(y.bina_kur(tur,h).id)
				b.insa_kalan = 0
				return b
	return null
func doktor(y: KoyYonetimi,b: KoyBinasi) -> Koylu:
	var k := y.kabul({"ad":"Hekim"})
	k.zanaat_turu = ZanaatTuru.Tur.CERRAH
	dene(y.ata(k.id,b.id), "Şifahane gerçek hekim ataması")
	return k
func dene(olur: bool, ad: String) -> void:
	if not olur:
		hata += 1
		push_error(ad)
