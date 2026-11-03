extends SceneTree
var hata:=0
func dene(v: bool,ad: String) -> void:
 if not v: hata+=1; push_error(ad)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 for karar in DivanHukmu.KARARLAR:
  var o:=Oturum.new(kat,42)
  var y:=o.yonetim
  var g:=o._adli_gelen(&"chr_001")
  var rr:=o.karar_ver(g,&"kabul")
  var k:=y.koylu(rr.koylu_id)
  var diger:=y.kabul({"ad":"Diğer köylü"})
  y.asayis_riski=30
  var moral:=diger.moral
  var rng:=y._rng.state
  var stok:=y.kaynaklar.kaydet()
  var kamu:=y.akce
  dene(not DivanHukmu.uygula(o,k.id,String(karar)),"Niyet/habersiz kişi hüküm alamaz")
  CasusGeceTakibi.kaydet(y,k,"ambar",-1,"kundaklama","gida",0,true)
  var hukum_oncesi := o.kaydet()
  dene(not DivanHukmu.uygula(o,k.id,"is_cezasi") and o.kaydet()==hukum_oncesi,"ISG-80: is cezasi reddedilir ve kayit degismez")
  dene(DivanHukmu.uygula(o,k.id,String(karar)),"Gerçek fiile tek hüküm")
  dene(y.akce==kamu and y.kaynaklar.kaydet()==stok and y._rng.state==rng and diger.moral==moral+int(DivanHukmu.AYAR[karar].moral) and y.asayis_riski==30+int(DivanHukmu.AYAR[karar].asayis),"Sosyal delta gerçek, kasa/stok/zar korunur")
  var once:=JSON.stringify(o.kaydet())
  dene(not DivanHukmu.uygula(o,k.id,String(karar)) and JSON.stringify(o.kaydet())==once,"Çift hüküm etkisiz")
  dene(DivanOturumu.adaylar(y).is_empty(),"Karara bağlanmış dava yeniden açılmaz")
  if karar=="zindan":
   dene(y.koylu(k.id)!=null and DivanHukmu.zindanda(k) and not y.muhafiz_ata(k.id) and not YasRolleri.atanabilir(k,"koy_meydani") and not CirakEgitimi.saglam(k) and GizliEgilimler.risk(k)==0.0,"Zindan nüfusta; iş/meslek/nöbet/suç engeli")
   dene(VergiPolitikasi.bedel(y)==y.a.vergi_isci and int(TuketimDengesi.gerek(y).gida)==2,"Tutsak vergi üretmez ama gerçek gıda tüketir")
   var z:=Oturum.kayittan(kat,JSON.parse_string(once))
   dene(DivanHukmu.zindanda(z.yonetim.koylu(k.id)) and DivanHukmu.durum(z.yonetim)==DivanHukmu.durum(y),"JSON hüküm ve türetilen bayrak")
   y.kaynaklar.ekle("gida",30)
   var gece:=y.gece()
   dene(k.ev==-1 and k.is_yeri==-1 and int(gece.tuketim.gida)>=2 and CasusGeceTakibi.durum(y).izler.size()==1,"Gerçek gece tutsak işi/suç hedefi üretmez; tüketir")
  else:
   dene(y.koylu(k.id)==null and o.koy.adlilar.is_empty() and o.kadro.durumlar[&"chr_001"].durum==&"kalici_ayrildi","Sürgün/infaz aynı nüfus/kadrodan çıkar")
   dene(k.saglik==0 if karar=="infaz" else k.saglik>0,"İnfaz ölüm, sürgün ölüm değildir")
 # Hücre kapasitesi2: üçüncü tutuklu reddi; sürgün alternatifi açık.
 var o:=Oturum.new(kat,52)
 for i in 3:
  var k:=o.yonetim.kabul({"ad":"Dava %d"%i})
  CasusGeceTakibi.kaydet(o.yonetim,k,"ambar",-1,"hirsizlik","gida",0,true)
  dene(DivanHukmu.uygula(o,k.id,"zindan")== (i<2),"İki mevcut hücre yeri")
 dene(DivanHukmu.kalan(o.yonetim)==0 and DivanHukmu.uygun(o,3,"surgun"),"Dolu hücre diğer kararı kilitlemez")
 var sahte:=o.yonetim.kabul({"ad":"Sahte bayrak","bayraklar":["zindanda"]})
 DivanHukmu.kayit_esitle(o.yonetim)
 dene(not DivanHukmu.zindanda(sahte),"Tek hüküm kaydı dışında sahte tutukluluk yok")
 dene(DivanHukmu.oku({"1":{"karar":"uydurma","adli_id":"chr_001","gun":0}}).is_empty(),"Bozuk hüküm elenir")
 print("DIVAN HÜKMÜ: GEÇTİ" if hata==0 else "DIVAN HÜKMÜ: KALDI")
 quit(hata)
