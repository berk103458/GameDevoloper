extends SceneTree
var hata:=0
func _initialize()->void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,22)
 var y:=o.yonetim
 for i in 3:
  var k:=y.kabul({"ad":"Hasat köylüsü","stat":5})
  k.moral=40
 y.gun=14
 var bos:=y.kaynaklar.bos_yer()
 y.kaynaklar.ekle("gida",bos)
 var once:=JSON.stringify(o.kaydet())
 dene(HasatSenligi.hazir(y) and JSON.stringify(o.kaydet())==once,"Dolu erzak ambarı salt okunur aday")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 var r:=y.gece()
 dene(y.koylular.all(func(k:Koylu)->bool:return k.moral==100) and y.huzur()==100 and HasatSenligi.son_yil(y)==1,"Gerçek gece normal tüketimden sonra moral zirvesi")
 dene(geri.yonetim.gece()==r,"Restore aynı şenlik/gece raporu")
 once=JSON.stringify(o.kaydet())
 HasatSenligi.uygula(y,true,[])
 dene(JSON.stringify(o.kaydet())==once and not HasatSenligi.hazir(y),"Aynı yıl ikinci bedelsiz moral yok")
 y.gun=42
 y.kaynaklar.ekle("gida",y.kaynaklar.bos_yer())
 dene(HasatSenligi.hazir(y),"Sonraki yıl yeniden dolu ambar kutlayabilir")
 y.kaynaklar.azalt("gida",10000)
 y.kaynaklar.ekle("tas",y.kaynaklar.bos_yer())
 dene(not HasatSenligi.hazir(y),"Taşla dolu, aç köy kutlamaz")
 y.gun=0
 dene(not HasatSenligi.hazir(y),"Sonbahar dışında kutlama yok")
 dene(HasatSenligi.oku("x")==0 and HasatSenligi.oku(-1)==0 and HasatSenligi.oku(1.5)==0,"Bozuk/eski optional yıl güvenli")
 print("HASAT ŞENLİĞİ: GEÇTİ" if hata==0 else "HASAT ŞENLİĞİ: KALDI")
 quit(hata)
func dene(v:bool,ad:String)->void:
 if not v:
  hata+=1
  push_error(ad)
