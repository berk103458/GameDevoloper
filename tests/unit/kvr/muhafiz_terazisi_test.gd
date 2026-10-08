extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,95)
 var bas:=MuhafizTerazisi.durum(o)
 dene(bas.yozlasma==0 and bas.unvan=="Adil muhafız","Eski/sıfır makbuz adalet yönünde")
 o.muhafiz_akce=1000000
 dene(MuhafizTerazisi.durum(o)==bas,"Para varlığı tek başına yozlaşma değil")
 o.karar_ver(o._adli_gelen(&"chr_001"),&"rusvet")
 var d:=MuhafizTerazisi.durum(o)
 dene(d.rusvet==1 and d.yozlasma==5,"Gerçek rüşvet kararı makbuzu")
 o.koy_akce=100
 dene(KasaTransferi.uygula(o,"zimmet",5),"Gerçek zimmet işlemi")
 d=MuhafizTerazisi.durum(o)
 dene(d.zimmet==5 and d.yozlasma==10,"Tek EKO makbuzu skora bağlandı")
 var once:=JSON.stringify(o.kaydet())
 for i in range(4): dene(MuhafizTerazisi.durum(o)==d,"Saf tekrar okuma")
 dene(JSON.stringify(o.kaydet())==once,"Okuma kayıt/kasa/stok/RNG değiştirmedi")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(MuhafizTerazisi.durum(geri)==d,"Tam JSON aynı kaynaklardan aynı terazi")
 var h:=Oturum.new(kat,35)
 var y:=h.yonetim
 var rr:=h.karar_ver(h._adli_gelen(&"chr_001"),&"kabul")
 var id:=int(rr.koylu_id)
 FisiltiGazetesi.gece(y,[])
 dene(h.olay_uygula(h.olay_sec(),0).ok and DivanHukmu.uygula(h,id,"zindan"),"Gerçek kanıtsız hüküm")
 var haksiz:=MuhafizTerazisi.durum(h)
 dene(haksiz.haksizlik==1 and haksiz.yozlasma==15,"Tek onarılmamış haksızlık makbuzu")
 y.akce=15
 dene(DivanHaksizligi.tazmin(h,id),"Gerçek onarım/tahliye")
 dene(MuhafizTerazisi.durum(h).haksizlik==0 and MuhafizTerazisi.durum(h).denge>haksiz.denge,"Onarım katkıyı kaldırır, borç çoğalmaz")
 var s:=Oturum.new(kat,96)
 s.yonetim.adalet=0
 dene(MuhafizTerazisi.durum(s).denge==50 and MuhafizTerazisi.durum(s).unvan=="Kararsız muhafız","Nötr sınır")
 s.bayraklar[&"rusvet_sayisi"]=1000000000
 dene(MuhafizTerazisi.durum(s).denge==0 and MuhafizTerazisi.durum(s).unvan=="Yozlaşmış derebeyi","Büyük sayaç clamp ve yoz uç")
 for bozuk in [-1,1.5,"99",true,INF,NAN]:
  s.bayraklar[&"rusvet_sayisi"]=bozuk
  dene(MuhafizTerazisi.durum(s).rusvet==0,"Bozuk sayaç güvenli sıfır")
 print("MUHAFIZ TERAZISI: GEÇTİ" if hata==0 else "MUHAFIZ TERAZISI: KALDI")
 quit(hata)
