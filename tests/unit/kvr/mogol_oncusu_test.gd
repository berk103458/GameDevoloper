extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func rapor(no: int) -> Dictionary:
 var olaylar: Array[Dictionary]=[]
 return {"gun":no-1,"olaylar":olaylar,"son":""}
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1201)
 dene(MogolOncusu.durum(o).kalan==30,"Başlangıç kalan30 dış JSON")
 var once:=JSON.stringify(o.kaydet())
 var rng:=o._rng.state
 MogolOncusu.metin(o)
 dene(JSON.stringify(o.kaydet())==once and o._rng.state==rng,"Harita okuması saf")
 for no in [24,25,28,30,31]:
  o.gun=no
  var r:=rapor(no)
  var para:=o.muhafiz_akce
  var stok:=o.yonetim.kaynaklar.kaydet()
  MogolOncusu.gece(o,r)
  dene(r.olaylar.size()==(1 if no in [25,28,30] else 0),"Gerçek eşiğin tek uyarısı")
  dene(o.muhafiz_akce==para and o.yonetim.kaynaklar.kaydet()==stok and o._rng.state==rng and o.yonetim.son=="","Uyarı para/RNG/savaş/terminal üretmez")
  once=JSON.stringify(o.kaydet())
  MogolOncusu.gece(o,r)
  dene(JSON.stringify(o.kaydet())==once,"Aynı gecede tekrar yok")
  o=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(MogolOncusu.durum(o).kalan==0 and MogolOncusu.metin(o).contains("sınırda"),"Varış sonrası negatif süre yok")
 var son:=Oturum.new(kat,1202)
 son.gun=30
 son.yonetim.son="tekfur"
 var rr:=rapor(30)
 once=JSON.stringify(son.kaydet())
 MogolOncusu.gece(son,rr)
 dene(rr.olaylar.is_empty() and JSON.stringify(son.kaydet())==once,"Mevcut terminal korunur")
 for bozuk in [null,{}, {"son_gece":"25","uyarilar":[true,-1,1.5,"0",INF,NAN,5,5,2,0]}]:
  var d:=MogolOncusu.oku(bozuk)
  dene(d.son_gece==-1 and d.uyarilar.size()<=3,"Bozuk optional alanlar elenir")
 var tam:=Oturum.new(kat,1203)
 tam.yonetim.kabul({"ad":"Öncü tanığı"})
 tam.yonetim.kaynaklar.ekle("gida",100)
 tam.yonetim.kaynaklar.ekle("su",100)
 tam.gun=24
 var gece:=tam.gece_sonu()
 var bulunan:=false
 for olay in gece.olaylar:
  if olay.has("mogol_oncusu"):
   bulunan=true
   dene(olay.mogol_oncusu.kalan==5 and IflasYoneticisi.olay_metin(olay).contains("5 gün"),"Tam gece aynı sabah kartına insan metni")
 dene(bulunan and tam.gun==25,"Gerçek Oturum gecesi bağlandı")
 print("MOGOL ONCUSU: GEÇTİ" if hata==0 else "MOGOL ONCUSU: KALDI")
 quit(hata)
