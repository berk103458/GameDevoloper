extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat,22)
 var y := o.yonetim
 y.a=y.a.duplicate(true)
 y.a.ambar_taban_kapasite=10000
 kat.koy_ayarlari=y.a
 y.kaynaklar.kapasite=10000
 y.akce=100
 for i in 12:
  var k:=y.kabul({"ad":"Su köylüsü", "stat":5})
  k.moral=50
 dene(SuDengesi.gerek(y)==12,"Normal iklim kişi başına bir su")
 y.gun=7
 dene(SuDengesi.gerek(y)==24,"Yaz tüketimi iki kat")
 var once:=JSON.stringify(o.kaydet())
 var tuketim:Dictionary={}
 var r:=SuDengesi.gece(y,tuketim,[])
 dene(r.ihtiyac==24 and r.taze==20 and r.eksik==4 and y.koylular[10].saglik==97 and y.koylular[0].saglik==100,"Kuyu akışı ve yalnız karşılanamayan kişide susuzluk")
 once=JSON.stringify(o.kaydet())
 dene(SuDengesi.gece(y,{},[])==r and JSON.stringify(o.kaydet())==once,"Aynı gece tekrar su/sağlık yok")
 y.gun=8
 var para:=y.akce
 dene(SuDengesi.doldur(y) and SuDengesi.doldur(y) and y.kaynaklar.miktar("su")==20 and y.akce==para-2 and SuDengesi.taze(y)==0,"Tek ambar rezervi, günlük 20 kuyu akışı, kamu ödemesi")
 once=JSON.stringify(o.kaydet())
 dene(not SuDengesi.doldur(y) and JSON.stringify(o.kaydet())==once,"Üçüncü parti günlük arzı çoğaltamaz")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 r=SuDengesi.gece(y,{},[])
 dene(r.depo==20 and r.taze==0 and r.eksik==4 and SuDengesi.gece(geri.yonetim,{},[])==r,"Ayrılan kuyu suyu gece ikinci kez arz olmaz; restore eşit")
 dene(Kaynaklar.kayittan({"stok":{"gida":3},"kapasite":150}).miktar("su")==0,"Eski ambar sıfır su rezerviyle açılır")
 var risk:int=SuDengesi.AYAR.kivilcim_yuzde
 var mesafe:float=SuDengesi.AYAR.mesale_mesafe
 SuDengesi.AYAR.kivilcim_yuzde=100
 SuDengesi.AYAR.mesale_mesafe=100
 for t in ["odun","tas","kereste"]:y.kaynaklar.ekle(t,100)
 var b:=kur(y)
 y.gun=9
 y.kaynaklar.ekle("su",10)
 dene(YazYanginRiski.gece(y,[])==10 and y.bina(b.id)!=null and y.kaynaklar.miktar("su")==0,"Tek mevcut rezervle kıvılcım söndürülür")
 once=JSON.stringify(o.kaydet())
 dene(YazYanginRiski.gece(y,[])==0 and JSON.stringify(o.kaydet())==once,"Aynı gece ikinci kıvılcım/harcama/RNG yok")
 y.gun=10
 y.koylular[0].ev=b.id
 dene(YazYanginRiski.gece(y,[])==0 and y.bina(b.id)==null and y.koylular[0].ev==-1,"Susuz yangın aynı iadesiz yapı kaybı/ev temizliği")
 b=kur(y)
 y.gun=0
 once=JSON.stringify(o.kaydet())
 dene(YazYanginRiski.gece(y,[])==0 and JSON.stringify(o.kaydet())==once,"Ilık mevsimde kıvılcım/RNG etkisi yok")
 IklimDeneyi.degistir(o,1,"yagmur")
 once=JSON.stringify(o.kaydet())
 dene(YazYanginRiski.adaylar(y).is_empty() and YazYanginRiski.gece(y,[])==0 and JSON.stringify(o.kaydet())==once,"Yağmurda kuru ot yangını/RNG yok")
 var depo:=Kaynaklar.new(10,{"su":10})
 depo.kapasite=0
 dene(depo.miktar("su")==0 and depo.toplam()==0,"Su rezervi mevcut ambar taşma sınırını korur")
 SuDengesi.AYAR.kivilcim_yuzde=risk
 SuDengesi.AYAR.mesale_mesafe=mesafe
 print("YAZ SU/YANGIN: GEÇTİ" if hata==0 else "YAZ SU/YANGIN: KALDI")
 quit(hata)
func kur(y:KoyYonetimi)->KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h:=Vector2i(cx,cy)
   if y.yerlesim("kulube",h).olur:
    var b:=y.bina(y.bina_kur("kulube",h).id)
    b.insa_kalan=0
    return b
 return null
func dene(v:bool,ad:String)->void:
 if not v:
  hata+=1
  push_error(ad)
