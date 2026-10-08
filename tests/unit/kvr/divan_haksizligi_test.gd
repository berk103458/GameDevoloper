extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,35)
 var y:=o.yonetim
 var g:=o._adli_gelen(&"chr_001")
 g.chr_sorgusu().obje_incele(1)
 g.chr_sorgusu().obje_incele(2)
 var rr:=o.karar_ver(g,&"kabul")
 var k:=y.koylu(rr.koylu_id)
 var kardes:=y.kabul({"ad":"İlyas","adli_id":"chr_004"})
 var komsu:=y.kabul({"ad":"Komşu","adli_id":"chr_003"})
 y.akce=0
 FisiltiGazetesi.gece(y,[])
 dene(o.olay_uygula(o.olay_sec(),0).ok and k.id in DivanOturumu.adaylar(y) and DivanOturumu.izler(y,k.id).is_empty(),"Arşiv iddiası ayrı kanıtsız dava")
 var ip: Array=DivanKanit.durum(k).ipuclar
 for id in ip: DivanKanit.sun(y,k.id,String(id))
 dene(not DivanKanit.sorgula(y,k.id),"Kapı Clue olsa da söylentiden gerçek fiil itirafı yok")
 dene(DivanHukmu.uygun(o,k.id,"zindan") and not DivanHukmu.uygun(o,k.id,"infaz") and not DivanHukmu.uygun(o,k.id,"surgun"),"Kanıtsız iddia yalnız haksız zindan seçeneği")
 var moral:=komsu.moral
 var adalet:=y.adalet
 var rng:=y._rng.state
 var stok:=y.kaynaklar.kaydet()
 var kese:=o.muhafiz_akce
 dene(DivanHukmu.uygula(o,k.id,"zindan"),"Haksız karar gerçek hüküm")
 dene(y.koylu(kardes.id)==null and y.koylu(komsu.id)!=null and DivanHukmu.zindanda(k),"Doğrulanmış kardeş ayrılır, komşu aile sayılmaz")
 dene(komsu.moral==moral-22 and y.adalet==adalet-15 and y._rng.state==rng and y.kaynaklar.kaydet()==stok and o.muhafiz_akce==kese,"Hüküm ve haksızlık sosyal delta tek, kasa/stok/zar koruma")
 dene(not DivanHaksizligi.tazmin(o,k.id) and y.akce==0,"Eksik kamu kasası borcu ödeyemez")
 var z:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(DivanHukmu.zindanda(z.yonetim.koylu(k.id)) and k.id in DivanOturumu.adaylar(z.yonetim),"JSON mağdur ve onarım davası")
 y.akce=15
 dene(DivanHaksizligi.tazmin(o,k.id) and y.akce==5 and not DivanHukmu.zindanda(k) and DivanHaksizligi.odendi(y,k.id) and y.adalet==adalet-10 and komsu.moral==moral-17,"Tam kamu tazminatı ve tahliye tek")
 var once:=JSON.stringify(o.kaydet())
 dene(not DivanHaksizligi.tazmin(o,k.id) and not DivanHukmu.uygula(o,k.id,"zindan") and JSON.stringify(o.kaydet())==once,"Tazmin/yeniden hüküm etkisiz")
 z=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(not DivanHukmu.zindanda(z.yonetim.koylu(k.id)) and DivanHukmu.verildi(z.yonetim,k.id) and z.yonetim.koylu(kardes.id)==null,"Tahliye JSON yeniden hapsetmez; aile geri yaratılmaz")
 # Gerçek fiil kaydı aynı kişinin haksızlık makbuzunu oluşturmaz.
 var dogru:=Oturum.new(kat,3)
 var kk:=dogru.yonetim.kabul({"ad":"Suçüstü kişi"})
 CasusGeceTakibi.kaydet(dogru.yonetim,kk,"ambar",-1,"hirsizlik","gida",0,true)
 dene(DivanHukmu.uygula(dogru,kk.id,"zindan") and DivanHaksizligi.durum(dogru.yonetim).is_empty() and not DivanHaksizligi.tazmin(dogru,kk.id),"Gerçek gözlenen fiil haksız pusula değildir")
 dene(DivanHaksizligi.oku({"1":{"gun":0,"odendi":"evet"}}).is_empty(),"Bozuk onarım makbuzu elenir")
 print("DIVAN HAKSIZLIĞI: GEÇTİ" if hata==0 else "DIVAN HAKSIZLIĞI: KALDI")
 quit(hata)
