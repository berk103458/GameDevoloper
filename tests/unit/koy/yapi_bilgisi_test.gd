extends SceneTree
const B = preload("res://src/koy/yapi_bilgisi.gd")
const G = preload("res://src/sistemler/muhafiz_gecmisi.gd")
const A = preload("res://src/sistemler/acilis_senaryosu.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 20202)
	dene(not G.sec(o,"olmayan"), "Tablosuz geçmiş seçilmez")
	A.kur(o)
	dene(not YapiKilidi.durum(o.yonetim,"ambar").acik, "Geçmiş seçilmeden bilgi uydurulmaz")
	var para := o.yonetim.akce
	var kese := o.muhafiz_akce
	dene(G.sec(o,"medrese_talebesi"), "Gerçek geçmiş seçimi")
	dene(YapiKilidi.durum(o.yonetim,"ambar").acik, "Geçmiş usta gelmeden K1 açar")
	dene(o.yonetim.akce == para and o.muhafiz_akce == kese and o.yonetim.nufus() == 2, "Bilgi para/kişi yaratmaz")
	o.yonetim.kaynaklar = Kaynaklar.new(10000,{"odun":100,"tas":100,"kereste":100})
	o.yonetim.akce = 1000
	dene(_kurabilir(o.yonetim,"ambar"),"Geçmişin açtığı yapı gerçek bina_kur yoluyla kurulabilir")
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null and YapiKilidi.durum(geri.yonetim,"ambar").acik, "Geçmiş bilgisi gerçek JSON yüklemede kalır")
	var muhafiz := o.yonetim.koylular[0]
	B.ekle(muhafiz,PackedStringArray(["ambar"]))
	dene(muhafiz.yapi_bilgisi.count("ambar") == 1,"Geçmiş ve ikinci bilgi kaynağı aynı bayrağı çoğaltmaz")
	var ret := Oturum.new(kat,22023)
	var gelen := ret._adli_gelen(&"chr_029")
	ret.karar_ver(gelen,&"ret")
	dene(ret.yonetim.koylular.is_empty() and not YapiKilidi.durum(ret.yonetim,"demir_ocagi").acik,"Gerçek kapıda reddedilen usta bilgi açmaz")
	var kabul := Oturum.new(kat,22024)
	kabul.karar_ver(kabul._adli_gelen(&"chr_029"),&"kabul")
	dene(kabul.yonetim.koylular.size() == 1 and "demir_ocagi" in kabul.yonetim.koylular[0].yapi_bilgisi,"Gerçek kabul edilen adlı ustanın meslek bilgisi kişide")
	var o2 := Oturum.new(kat,20203)
	dene(G.sec(o2,"medrese_talebesi"), "Kuruluştan önce geçmiş seçilir")
	A.kur(o2)
	dene(YapiKilidi.durum(o2.yonetim,"ambar").acik, "Gerçek yeni oyun sırası bilgiyi bağlar")
	var y := o.yonetim
	var u := y.kabul({"ad":"Bilgili usta","stat":8,"zanaat_turu":"DEMIRCI","yapi_bilgisi":["hizarhane","hizarhane"]})
	dene("demirhane" in u.yapi_bilgisi and "hizarhane" in u.yapi_bilgisi and u.yapi_bilgisi.count("hizarhane") == 1, "Usta mevcut meslek verisi ve tek optional bilgiyle kabul edilir")
	dene(YapiKilidi.durum(y,"hizarhane").acik, "Yaşayan usta bilgisi kurulum kilidini açar")
	y.koylular.erase(u)
	dene(not YapiKilidi.durum(y,"hizarhane").acik, "Usta ayrılınca yeni kurulum kapanır")
	y.koylular.append(u)
	u.saglik = 0
	dene(not YapiKilidi.durum(y,"hizarhane").acik, "Tek bilgi sahibi ölünce yeni kurulum kapanır")
	u.saglik = 100
	var b := KoyBinasi.new()
	b.id = 900
	b.tur = "demirhane"
	y.binalar.append(b)
	var c := y.kabul({"ad":"Çırak","stat":3,"zanaat_turu":"DEMIRCI"})
	u.is_yeri = b.id
	c.is_yeri = b.id
	c.egitim = {"usta":u.id,"bina":b.id,"gece":5,"tamamlandi":true}
	B.ciraklar(y)
	dene(c.yapi_bilgisi.is_empty(), "Yarı ustalık tek başına bilgi vermez")
	var kasa := y.akce
	for gun in 10:
		y.gun = gun
		KoyluGelisimYoneticisi.gece(y,{u.id:b.id,c.id:b.id},[])
		B.ciraklar(y)
	dene(KoyluGelisimYoneticisi.usta(c) and "hizarhane" in c.yapi_bilgisi, "UZM-11 gerçek çalışma terfisiyle öğretmenin bilgisi aktarılır")
	var adet := y.nufus()
	var bilgi := c.yapi_bilgisi.duplicate()
	B.ciraklar(y)
	dene(c.yapi_bilgisi == bilgi and y.nufus() == adet and y.akce == kasa, "Tekrar bilgi/kişi/akçe yaratmaz")
	u.saglik = 0
	dene(YapiKilidi.durum(y,"hizarhane").acik and y.bina(b.id) == b and y.nufus() == adet, "Usta ölünce çırak ustanın bilgisi ve duran bina kalır; kişi doğmaz")
	y.koylular.erase(u)
	dene(YapiKilidi.durum(y,"hizarhane").acik, "Usta ayrıldıktan sonra yetişen ustada bilgi kalır")
	_gercek_gece(kat)
	print("YAPI BİLGİSİ: GEÇTİ" if hata == 0 else "YAPI BİLGİSİ: KALDI")
	quit(hata)

func _gercek_gece(kat: Katalog) -> void:
	var o := Oturum.new(kat, 22022)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar = Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000,"tas":100,"kereste":100})
	y.akce = 1000
	var bina: KoyBinasi
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var hucre := Vector2i(cx,cy)
			if y.yerlesim("tarla",hucre).olur:
				bina = y.bina(y.bina_kur("tarla",hucre).id)
				bina.insa_kalan = 0
				break
		if bina != null: break
	dene(bina != null,"Gerçek eğitim tarlası kurulabilir")
	if bina == null: return
	var u := y.kabul({"ad":"Bilgili çiftçi","sinif":"ciftci","stat":8,"yapi_bilgisi":["hizarhane"]})
	var c := y.kabul({"ad":"Öğrenci","sinif":"ciftci","stat":5})
	dene(y.ata(u.id,bina.id) and y.ata(c.id,bina.id),"Gerçek öğretmen/çırak ataması")
	for gun in 10:
		y.gece()
		dene(y.gun == gun + 1 and y.son.is_empty(),"Gerçek gece tamamlandı")
		if gun == 4: dene(c.yapi_bilgisi.is_empty(),"Beşinci gecenin yarı ustası henüz bilgi edinmez")
	dene(KoyluGelisimYoneticisi.usta(c) and "hizarhane" in c.yapi_bilgisi,"On gerçek gecede üretim adaptörü bilgiyi aktarır")
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null and geri.yonetim.koylu(c.id).yapi_bilgisi == c.yapi_bilgisi,"Edinilen bilgi JSON kaydında kalır")

func _kurabilir(y: KoyYonetimi, tur: String) -> bool:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx,cy)
			if y.yerlesim(tur,h).olur: return bool(y.bina_kur(tur,h).olur)
	return false
