extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func kur(kat: Katalog,karar: String="zindan",adli: StringName=&"chr_004") -> Oturum:
 var o:=Oturum.new(kat,73)
 var rr:=o.karar_ver(o._adli_gelen(adli),&"kabul")
 var k:=o.yonetim.koylu(rr.koylu_id)
 CasusGeceTakibi.kaydet(o.yonetim,k,"cephanelik",-1,"sabotaj","alet",0,true)
 dene(DivanHukmu.uygula(o,k.id,karar),"Gerçek kaynak kişinin hükmü")
 o.yonetim.kaynaklar.ekle("gida",80)
 o.yonetim.kaynaklar.ekle("odun",80)
 return o
func baskin(r: Dictionary) -> int:
 var n:=0
 for x in r.olaylar:
  if x.anahtar=="koy.olay.baskin": n+=1
 return n
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=kur(kat)
 for i in 2: dene(baskin(o.yonetim.gece())==0,"İlk iki gerçek gece baskın yok")
 var z:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 var r:=o.yonetim.gece()
 dene(baskin(r)==1 and KaraboranIntikami.durum(o.yonetim)==[1],"Üçüncü gece yalnız bir gerçek baskın")
 dene(baskin(z.yonetim.gece())==1,"İkinci gece sonrası JSON aynı tarihte tetikler")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 var olaylar: Array[Dictionary]=[]
 var stok:=geri.yonetim.kaynaklar.kaydet()
 var rng:=geri.yonetim._rng.state
 dene(KaraboranIntikami.tetikle(geri.yonetim,olaylar)=="" and olaylar.is_empty() and stok==geri.yonetim.kaynaklar.kaydet() and rng==geri.yonetim._rng.state,"Teslim makbuzu tekrarı kasa/stok/zar değiştirmez")
 for i in 3: dene(baskin(geri.yonetim.gece())==0,"Teslimden sonraki geceler tekrar yok")
 for karar in ["surgun","infaz"]:
  var n:=kur(kat,karar)
  n.yonetim.gun=10
  dene(KaraboranIntikami.tetikle(n.yonetim,olaylar)=="","Sürgün/infaz zindan intikamı değildir")
 var farkli:=kur(kat,"zindan",&"chr_001")
 farkli.yonetim.gun=10
 dene(KaraboranIntikami.tetikle(farkli.yonetim,olaylar)=="","Başka CHR intikam üretmez")
 var olu:=kur(kat)
 olu.yonetim.koylu(1).saglik=0
 olu.yonetim.gun=10
 dene(KaraboranIntikami.tetikle(olu.yonetim,olaylar)=="","Ölmüş reis için canlı tutsak tetiklemesi yok")
 var biten:=kur(kat)
 biten.yonetim.gun=10
 biten.yonetim.son="terk"
 dene(KaraboranIntikami.tetikle(biten.yonetim,olaylar)=="","Bitmiş oyunda tetik yok")
 dene(KaraboranIntikami.oku([1,1,-1,"2",2.5,2])==[1,2] and KaraboranIntikami.oku({}).is_empty(),"Bozuk/tekrar makbuz elenir")
 # Zorunlu baskın doğal %100 baskın zarı ile üst üste binmez.
 var c:=kur(kat)
 c.yonetim.gun=2
 c.yonetim.husumet.puan=1000
 c.yonetim.a.baskin_zar=1.0
 var cc: Array[Dictionary]=[]
 c.yonetim._husumet(cc)
 var sayi:=0
 for x in cc:
  if x.anahtar=="koy.olay.baskin": sayi+=1
 dene(sayi==1,"Doğal ve intikam baskını aynı gecede çift hasar değildir")
 print("KARABORAN İNTİKAMI: GEÇTİ" if hata==0 else "KARABORAN İNTİKAMI: KALDI")
 quit(hata)
