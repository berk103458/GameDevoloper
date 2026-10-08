extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,641)
 for i in 12:
  var g:=Gelen.new()
  g.id=StringName("oda_gelisim_%d"%i)
  o.karar_ver(g,&"kabul")
 dene(o.muhafiz_tecrubesi==12 and MuhafizOdaGelisimi.oku(o.oda_gelisimi).yorgunluk==24 and MuhafizOdaGelisimi.etkin_tecrube(o)==11,"Gerçek kararlar kişisel yorgunluk, tecrübe silinmez")
 var kamu:=o.koy_akce
 var rng:=o.yonetim._rng.state
 var stok:=o.yonetim.kaynaklar.kaydet()
 dene(not MuhafizOdaGelisimi.al(o,"yatak") and not MuhafizOdaGelisimi.al(o,"askilik") and not MuhafizOdaGelisimi.dinlen(o),"Eksik bedel/yatak red")
 o.muhafiz_akce=75
 dene(not MuhafizOdaGelisimi.al(o,"askilik") and not MuhafizOdaGelisimi.al(o,"uydurma"),"Önkoşul/bilinmeyen red")
 dene(MuhafizOdaGelisimi.al(o,"yatak") and o.muhafiz_akce==55 and MuhafizOdaGelisimi.etkin_tecrube(o)==12,"Yatak bedeli, yorgunluk sıfır")
 var once:=JSON.stringify(o.kaydet())
 dene(not MuhafizOdaGelisimi.al(o,"yatak") and JSON.stringify(o.kaydet())==once,"Çift alım etkisiz")
 for i in 4: MuhafizOdaGelisimi.karar(o)
 dene(MuhafizOdaGelisimi.dinlen(o) and MuhafizOdaGelisimi.oku(o.oda_gelisimi).yorgunluk==0,"Yatak günlük dinlenme")
 MuhafizOdaGelisimi.karar(o)
 once=JSON.stringify(o.kaydet())
 dene(not MuhafizOdaGelisimi.dinlen(o) and JSON.stringify(o.kaydet())==once,"Aynı gün yeniden dinlenme yok")
 MuhafizOdaGelisimi.gece(o)
 dene(MuhafizOdaGelisimi.oku(o.oda_gelisimi).yorgunluk==7,"Gerçek gece yük10/yatak dinlenme5")
 once=JSON.stringify(o.kaydet())
 MuhafizOdaGelisimi.gece(o)
 dene(JSON.stringify(o.kaydet())==once,"Tek gece idempotansı")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(geri!=null and geri.oda_gelisimi==MuhafizOdaGelisimi.oku(o.oda_gelisimi) and not MuhafizOdaGelisimi.dinlen(geri),"JSON günlük makbuz korunur")
 o.gun+=1
 dene(MuhafizOdaGelisimi.dinlen(o),"Ertesi gün dinlenme açılır")
 dene(MuhafizOdaGelisimi.al(o,"askilik") and MuhafizOdaGelisimi.al(o,"kutuphane") and o.muhafiz_akce==15,"İki geliştirme kişisel bedeli")
 for i in 200: MuhafizOdaGelisimi.karar(o)
 dene(MuhafizOdaGelisimi.oku(o.oda_gelisimi).yorgunluk==100,"Yorgunluk sınırı")
 MuhafizOdaGelisimi.gece(o)
 dene(MuhafizOdaGelisimi.oku(o.oda_gelisimi).yorgunluk==80,"Tam oda gece pasif dinlenme30")
 dene(o.koy_akce==kamu and o.yonetim.kaynaklar.kaydet()==stok and o.yonetim._rng.state==rng,"Geliştirme/dinlenme kamu stok RNG değiştirmez")
 var g:=o._adli_gelen(&"chr_001")
 g.chr_sorgusu().obje_incele(1)
 g.chr_sorgusu().tansiyon=6
 dene(g.chr_sorgusu().secenek_sec(2),"Gerçek panik seçeneği")
 once=JSON.stringify(o.kaydet())
 dene(o.karar_ver(g,&"kabul").get("engellendi",false) and JSON.stringify(o.kaydet())==once,"Engellenmiş gerçek karar yorgunluk eklemez")
 var gece:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 gece.gun+=1
 gece.oda_gelisimi.yorgunluk=100
 gece.yonetim.kaynaklar.ekle("gida",100)
 gece.yonetim.kaynaklar.ekle("su",100)
 var gun:=gece.gun
 gece.gece_sonu()
 dene(gece.gun==gun+1 and gece.oda_gelisimi.yorgunluk==80 and gece.oda_gelisimi.son_gece==gun,"Tam Oturum gece bağlantısı pasif dinlenme uygular")
 for k in gece.yonetim.koylular: dene(k.yorgunluk.is_empty(),"Köylü nöbet makbuzu kişisel oda değildir")
 o.yonetim.son="tekfur"
 once=JSON.stringify(o.kaydet())
 MuhafizOdaGelisimi.gece(o)
 MuhafizOdaGelisimi.karar(o)
 dene(not MuhafizOdaGelisimi.dinlen(o) and JSON.stringify(o.kaydet())==once,"Terminal kişisel işlemleri durdurur")
 dene(MuhafizOdaGelisimi.oku({"alinan":["askilik","kutuphane"],"yorgunluk":"100"}).alinan.is_empty() and MuhafizOdaGelisimi.oku(null).yorgunluk==0,"Legacy/bozuk kayıt")
 print("MUHAFIZ ODA GELISIM: GEÇTİ" if hata==0 else "MUHAFIZ ODA GELISIM: KALDI")
 quit(hata)
