extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1801)
 var y:=o.yonetim
 for t in y.kaynaklar.stok: y.kaynaklar.stok[t]=0
 y.kaynaklar.stok.gida=100;y.kaynaklar.stok.odun=40;y.kaynaklar.stok.alet=5
 y.lojistik.hayvanlar.beygir=1
 for i in 2: y.kabul({"ad":"Köylü %d"%i,"sinif":"ciftci","stat":5})
 y.akce=9;o.muhafiz_akce=100
 var once:=JSON.stringify(o.kaydet())
 dene(not CeteAnlasmasi.ode(y) and JSON.stringify(o.kaydet())==once,"Kişisel zenginlik kamu eksikliğini kapatmaz")
 y.akce=10
 var korumasiz:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 var rng:=y._rng.state
 dene(CeteAnlasmasi.ode(y) and y.akce==0 and o.muhafiz_akce==100 and y._rng.state==rng and CeteAnlasmasi.aktif(y),"Gerçek kamu10,30gün ve RNG korunur")
 once=JSON.stringify(o.kaydet())
 CeteAnlasmasi.tip(y)
 dene(not CeteAnlasmasi.ode(y) and JSON.stringify(o.kaydet())==once,"Aktif anlaşma tekrar ödeme/uzatma yok, okuma saf")
 var olaylar: Array[Dictionary]=[]
 var normal: Array[Dictionary]=[]
 HusumetBaskini.uygula(y,olaylar)
 HusumetBaskini.uygula(korumasiz.yonetim,normal)
 dene(y.kaynaklar.miktar("gida")==100 and y.kaynaklar.miktar("odun")==40 and int(y.lojistik.hayvanlar.beygir)==1,"Gerçek baskın ambar/sürü korunur")
 dene(korumasiz.yonetim.kaynaklar.miktar("gida")==70 and korumasiz.yonetim.kaynaklar.miktar("odun")==32,"Anlaşmasız mevcut kayıp aynı")
 dene(y._rng.state==korumasiz.yonetim._rng.state and y.koylular[0].saglik==korumasiz.yonetim.koylular[0].saglik and y.asayis_riski==korumasiz.yonetim.asayis_riski,"Anlaşma yalnız ganimet, yaralanma/sosyal sonuç/RNG aynı")
 o=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())));y=o.yonetim
 dene(CeteAnlasmasi.aktif(y) and not CeteAnlasmasi.ode(y),"JSON ödeme ve süreyi korur")
 y.a=y.a.duplicate(true)
 y.a.sizma_esigi=10;y.a.baskin_esigi=9999;y.a.sizma_zar=1.0;y.a.husumet_sonum=0
 y.husumet.puan=11
 y._husumet(olaylar)
 dene(y.kaynaklar.miktar("gida")==100 and y.kaynaklar.miktar("alet")==5,"Aynı gerçek sızma korunan ambara dokunmaz")
 y.gun=29
 dene(CeteAnlasmasi.aktif(y),"Son korunan gün dahil")
 y.gun=30
 dene(not CeteAnlasmasi.aktif(y),"30.günde süre biter")
 y._husumet(olaylar)
 dene(y.kaynaklar.miktar("gida")<100 and y.kaynaklar.miktar("alet")==4 and y.akce==0,"Süre bitince gerçek kayıp döner; otomatik ücret yok")
 y.akce=10
 dene(CeteAnlasmasi.ode(y) and CeteAnlasmasi.durum(y).bitis==60,"Süre bitince yeni30gün tek gerçek ödeme")
 y.son="terk"
 once=JSON.stringify(o.kaydet())
 dene(not CeteAnlasmasi.ode(y) and not CeteAnlasmasi.aktif(y) and JSON.stringify(o.kaydet())==once,"Terminal saf ret")
 var eski:=o.kaydet();eski.koy_yonetimi.erase("cete_anlasmasi")
 dene(not CeteAnlasmasi.aktif(Oturum.kayittan(kat,eski).yonetim),"Legacy kayıt dokunulmazlık üretmez")
 dene(CeteAnlasmasi.oku({"gun":0,"bitis":999}).gun==-1 and CeteAnlasmasi.oku({"gun":"0","bitis":30}).gun==-1,"Bozuk sınırsız süre elenir")
 print("CETE ANLASMASI: GEÇTİ" if hata==0 else "CETE ANLASMASI: KALDI")
 quit(0 if hata==0 else 1)
