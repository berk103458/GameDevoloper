extends SceneTree
const AKIS = preload("res://src/koy/ticaret/pusu_ticaret_akisi.gd")
const OZET = preload("res://src/sistemler/gozcu_kafile_ozeti.gd")
var hata := 0
func dene(v: bool, s: String) -> void:
	if not v: hata += 1; push_error(s)

func hazir(kat: Katalog, guc: int = 5) -> Oturum:
	var o := Oturum.new(kat,1941)
	o.ayarlar=o.ayarlar.duplicate(true)
	o.yonetim.a=o.yonetim.a.duplicate(true)
	o.gun=8; o.yonetim.asayis_riski=40
	for i in 2:
		var k := o.yonetim.kabul({"ad":"Pusu muhafızı %d" % i,"sinif":"asker","stat":guc})
		o.yonetim.muhafiz_ata(k.id)
	o.yonetim.husumet.puan=o.yonetim.a.sizma_esigi
	return o

func rngler(o: Oturum) -> Array:
	return [o._rng.state,o._rng_donus.state,o._rng_ad.state,o._rng_heybe.state,o.yonetim._rng.state]

func _initialize() -> void:
	var kat := Katalog.new(); kat.yukle()
	var o := hazir(kat)
	var rng := rngler(o)
	var kasa := [o.koy_akce,o.muhafiz_akce]
	dene(GocYoluGuvenligi.temizle(o).basari,"Gerçek HAR-05 başarı yolu")
	dene(AKIS.durum(o)=={"son_basari":1,"son_gorev":8,"baslangic":9,"bitis":12},"Başarıdan sonraki tam üç gün")
	dene(not AKIS.aktif(o) and GuvenlikKafileDengesi.sinif_agirliklar(o)==[1.0,1.0,1.0],"Görev günü önceden oluşan kuyruğa bonus yok")
	dene(rngler(o)==rng and [o.koy_akce,o.muhafiz_akce]==kasa,"Bonus ve görev beş RNG/iki kasa değiştirmez")
	var once := JSON.stringify(o.kaydet())
	AKIS.basari(o); GocYoluGuvenligi.temizle(o)
	dene(JSON.stringify(o.kaydet())==once,"Aynı başarı/görev çift ödül veya süre uzatmaz")
	var z := Oturum.kayittan(kat,JSON.parse_string(once))
	AKIS.basari(z)
	dene(JSON.stringify(z.kaydet())==once,"JSON sonrası aynı temizliğin tekrarı etkisiz")
	var ids: Array[StringName]=[&"chr_001",&"chr_003",&"chr_021"]
	for gun in [9,10,11]:
		o.gun=gun
		for guvenlik in [3,4,7,8]:
			o.yonetim.asayis_riski=100-guvenlik*10
			var w := GuvenlikKafileDengesi.adli_agirliklar(o,ids)
			dene(w==[3.0 if guvenlik<4 else 1.0,3.0 if guvenlik>7 else 2.0,1.0],"HAR-11 risk ağırlığı korunur; esnaf +1 ve tavan3")
			dene(GuvenlikKafileDengesi.sinif_agirliklar(o)==[1.0,3.0 if guvenlik>7 else 2.0,1.0],"Adsız esnaf da aynı mevcut seçimde")
		var kayit := JSON.stringify(o.kaydet())
		AKIS.tip(o); GocYoluGuvenligi.tip(o); GuvenlikKafileDengesi.adli_agirliklar(o,ids)
		dene(JSON.stringify(o.kaydet())==kayit,"Bilgi/ağırlık okumaları saf")
	o.gun=12; o.yonetim.asayis_riski=40
	dene(not AKIS.aktif(o) and AKIS.tip(o).is_empty(),"Üçüncü günün ardından kendiliğinden biter")
	var kopya := RandomNumberGenerator.new(); kopya.state=o._rng.state
	for i in 30:
		dene(GuvenlikKafileDengesi.adli_indeks(o,ids)==kopya.randi_range(0,2) and o._rng.state==kopya.state,"Bonus bitince eski tek zar tam eşit")
	o.gun=9; o.yonetim.asayis_riski=40
	kopya.state=o._rng.state
	for i in 30:
		var beklenen := GuvenlikKafileDengesi.aralik([1.0,2.0,1.0],kopya.randf())
		dene(GuvenlikKafileDengesi.adli_indeks(o,ids)==beklenen and o._rng.state==kopya.state,"Aktif bonus aynı RNG'den tek zar kullanır")
	# Yeni gerçek başarı yeniler; süreler veya ağırlıklar birikmez.
	o.yonetim.husumet.puan=o.yonetim.a.sizma_esigi
	dene(GocYoluGuvenligi.temizle(o).basari and AKIS.durum(o).bitis==13 and AKIS.durum(o).son_basari==2,"Yeni başarı mevcut üç günlük pencereyi yeniler")
	o.gun=10
	dene(GuvenlikKafileDengesi.sinif_agirliklar(o)[1]==2.0,"Tekrarlı başarı bonusu yığmaz")
	for k in o.yonetim.koylular: k.stat=3
	o.yonetim.husumet.puan=o.yonetim.a.sizma_esigi
	var pencere := AKIS.durum(o)
	dene(not GocYoluGuvenligi.temizle(o).basari and AKIS.durum(o)==pencere,"Başarısızlık eski pencereyi uzatmaz veya silmez")
	var zayif := hazir(kat,3)
	dene(not GocYoluGuvenligi.temizle(zayif).basari and AKIS.durum(zayif).is_empty(),"İlk başarısızlık bonus yaratmaz")
	var legacy: Dictionary=JSON.parse_string(once); legacy.erase("pusu_ticaret_akisi")
	z=Oturum.kayittan(kat,legacy); z.gun=9
	dene(AKIS.durum(z).is_empty() and not AKIS.aktif(z),"Eski başarı makbuzu yüklenince retroaktif ödül yok")
	legacy.pusu_ticaret_akisi=JSON.parse_string(once).pusu_ticaret_akisi
	legacy.erase("goc_yolu_guvenligi")
	z=Oturum.kayittan(kat,legacy); z.gun=9
	dene(AKIS.durum(z).is_empty() and not AKIS.aktif(z),"Gerçek temizlik makbuzu olmayan optional bonus elenir")
	for v in [null,{},true,{"son_basari":1,"son_gorev":8,"baslangic":9,"bitis":999999},
		{"son_basari":true,"son_gorev":8,"baslangic":9,"bitis":12},
		{"son_basari":1,"son_gorev":8,"baslangic":10,"bitis":12}]:
		dene(AKIS.oku(v).is_empty(),"Bozuk optional pencere atomik elenir")
	for n in [-1,1.5,INF,NAN,"1",1000000001]:
		var bozuk := pencere.duplicate(); bozuk.bitis=n
		dene(AKIS.oku(bozuk).is_empty(),"Bozuk sayısal alanlar güvenli")
	o.yonetim.son=KoyYonetimi.SON_TEKFUR
	dene(not AKIS.aktif(o) and AKIS.agirlik(o,&"esnaf",1.0)==1.0,"Terminal durumda etki yok")
	# Mevcut kuyruk: yeni ziyaret eklemek yerine aynı esnaf seçimi; JSON deterministik.
	o=Oturum.kayittan(kat,JSON.parse_string(once)); o.gun=9
	o.ayarlar=o.ayarlar.duplicate(true); o.ayarlar.adli_olasiligi=0.0; o.ayarlar.gece_basina_gelen=12
	o._gemini_sira=20 # Hazır KAP01 sırası bitince gerçek rastgele sınıf seçimi.
	var a := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	a.ayarlar=o.ayarlar.duplicate(true)
	var liste := o.gece_kuyrugu(); var ayni := a.gece_kuyrugu()
	dene(OZET.kuyruktan(liste)==OZET.kuyruktan(ayni) and rngler(o)==rngler(a),"JSON sonrası aynı gerçek kuyruk ve RNG devamı")
	dene(liste.size()==13,"HAR-05'in tek göç ziyaretine ek ikinci kuyruk yok")
	var esnaf := 0
	for g in liste:
		if g.sinif==&"esnaf" and not TuccarKapiGecisi.ilgilenir(g):
			esnaf+=1
			dene(g.heybe!=null and g.secenekler.has("kabul") and g.secenekler.has("ret"),"Esnaf gerçek heybe/karar API'sinde")
	dene(esnaf>0 and OZET.kuyruktan(liste).ticaret_yolcusu==esnaf,"HAR-13 gerçek esnafı uzman tüccardan ayrı sayar")
	var s := Gelen.new(); s.sinif=&"esnaf"
	dene(OZET.kuyruktan([s]).yolcu==1 and OZET.kuyruktan([s]).tuccar==0,"Esnaf uzman tüccar makbuzu kazanmaz")
	# İlk 20 hazır diyalog bonusla bile aynı sırada, aynı RNG tüketimiyle kalır.
	o=Oturum.kayittan(kat,JSON.parse_string(once)); o.gun=9
	a=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	a.remove_meta(AKIS.META)
	for i in 20:
		var g := o._figur_gelen(); var taban := a._figur_gelen()
		dene(g.sinif==taban.sinif and g.ad_anahtari==taban.ad_anahtari and g.secenekler==taban.secenekler and g.stat==taban.stat and rngler(o)==rngler(a),"Aktif bonusta KAP01 diyalog/RNG sırası aynen")
	var ticaret_olmayan: Array[StringName]=[&"chr_021"]
	kopya.state=o._rng.state
	dene(GuvenlikKafileDengesi.adli_indeks(o,ticaret_olmayan)==kopya.randi_range(0,0) and o._rng.state==kopya.state,"Esnaf adayı yoksa eski eşit ağırlık RNG yolu")
	print("PUSU TICARET AKISI: GEÇTİ" if hata==0 else "PUSU TICARET AKISI: KALDI")
	quit(hata)
