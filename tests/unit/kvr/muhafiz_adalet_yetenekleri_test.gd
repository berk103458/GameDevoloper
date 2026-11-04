extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,981)
 o.muhafiz_akce=40
 o.muhafiz_tecrubesi=8
 o.yonetim.adalet=80
 var kamu:=o.koy_akce
 var rng:=o.yonetim._rng.state
 var stok:=o.yonetim.kaynaklar.kaydet()
 dene(not MuhafizYetenekleri.al(o,"gonul_bagi"),"Önkoşul olmadan Gönül yok")
 o.bayraklar[&"rusvet_sayisi"]=25
 dene(not MuhafizYetenekleri.al(o,"keskin_bakis"),"Yüksek yozlaşma adalet alımını kapatır")
 o.bayraklar.erase(&"rusvet_sayisi")
 o.yonetim.adalet=69
 dene(not MuhafizYetenekleri.al(o,"keskin_bakis"),"Adalet alım eşiği")
 o.yonetim.adalet=80
 dene(MuhafizYetenekleri.al(o,"keskin_bakis") and o.muhafiz_akce==30,"Keskin bedeli kişisel")
 dene(MuhafizYetenekleri.al(o,"gonul_bagi") and o.muhafiz_akce==10,"Gönül bağlı seçim kişisel bedel")
 var once:=JSON.stringify(o.kaydet())
 dene(not MuhafizYetenekleri.al(o,"gonul_bagi") and JSON.stringify(o.kaydet())==once,"Çift alım etkisiz")
 dene(o.koy_akce==kamu and o.yonetim.kaynaklar.kaydet()==stok and o.yonetim._rng.state==rng,"Alım kamu/stok/RNG değiştirmez")
 var h:=Heybe.new()
 h.ekle("test","mal",5,2,true)
 dene(MuhafizAdaletYetenekleri.heybe_incele(o,h) and h.yakalandi() and not h.alinan_var(),"Astar keşfi mevcut API, el koyma yok")
 dene(not MuhafizAdaletYetenekleri.heybe_incele(o,h),"Tekrarlı heybe keşfi etkisiz")
 var eski:=Oturum.new(kat,981)
 var sakli:=Heybe.new()
 sakli.ekle("test","mal",5,2,true)
 dene(not MuhafizAdaletYetenekleri.heybe_incele(eski,sakli) and not sakli.astar_yoklandi,"Yeteneksiz eski davranış")
 var y:=o.yonetim
 var k:=y.kabul({"ad":"Gerçek düşük moralli köylü"})
 k.moral=5
 var olaylar: Array[Dictionary]=[]
 var durum:=y.kaydet()
 rng=y._rng.state
 y._isyan(olaylar)
 dene(y.isyan_kalan==-1 and olaylar.is_empty() and y._rng.state==rng,"Gönül düşük moral isyanını önler, zar atmaz")
 y.isyan_kalan=2
 y._isyan(olaylar)
 dene(y.isyan_kalan==-1 and y.koylular.size()==1 and olaylar.size()==1,"Devam eden isyan biter, kişi/erzak korunur")
 var json: Dictionary=JSON.parse_string(JSON.stringify(o.kaydet()))
 var donen:=Oturum.kayittan(kat,json)
 dene(donen!=null and MuhafizYetenekleri.var_mi(donen,"gonul_bagi") and MuhafizAdaletYetenekleri.isyan_esigi(donen.yonetim,10)==1,"JSON tek sahiplikten runtime yeniden kurulur")
 dene(not json.koy_yonetimi.has(String(MuhafizAdaletYetenekleri.ETKIN)),"İkinci kayıt/kalıcı meta yok")
 y.adalet=59
 olaylar.clear()
 y._isyan(olaylar)
 dene(y.isyan_kalan==y.a.isyan_gun,"Düşen gerçek adalette eski isyan kuralı geri gelir")
 y.adalet=80
 y.isyan_kalan=-1
 o.bayraklar[&"rusvet_sayisi"]=25
 MuhafizAdaletYetenekleri.bagla(o)
 y._isyan(olaylar)
 dene(y.isyan_kalan==y.a.isyan_gun,"Yeni yüksek yozlaşma korumayı kaldırır")
 o.bayraklar.erase(&"rusvet_sayisi")
 MuhafizAdaletYetenekleri.bagla(o)
 y.isyan_kalan=-1
 k.moral=1
 olaylar.clear()
 y._isyan(olaylar)
 dene(y.isyan_kalan==y.a.isyan_gun,"Aşırı kriz bağışıklık değil")
 y.isyan_kalan=1
 y._isyan(olaylar)
 dene(y.son==KoyYonetimi.SON_ISYAN and y.koylular.is_empty(),"Gerçek firar/terminal zinciri korunur")
 var normal:=KoyYonetimi.kayittan(kat.koy_ayarlari,kat.binalar,durum)
 normal._isyan(olaylar)
 dene(normal.isyan_kalan==normal.a.isyan_gun,"Bağımsız eski köy eşiği değişmez")
 dene(MuhafizYetenekleri.oku({"alinan":["gonul_bagi"]}).alinan.is_empty(),"Bozuk önkoşulsuz kayıt elenir")
 # Tam Oturum gece akışı derived işareti yeniden kurar; tok/barınan fixture aynı zarla karşılaştırılır.
 var gece:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(json)))
 var yy:=gece.yonetim
 yy.a=yy.a.duplicate(true)
 yy.a.evsiz_moral=0
 yy.a.tok_moral=0
 yy.a.guvensiz_moral=0
 yy.kaynaklar.ekle("gida",100)
 yy.kaynaklar.ekle("su",100)
 yy.isyan_kalan=-1
 var eski_gece:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(gece.kaydet())))
 eski_gece.yonetim.a=yy.a.duplicate(true)
 eski_gece.muhafiz_yetenekleri=MuhafizYetenekleri.oku(null)
 gece.gece_sonu()
 eski_gece.gece_sonu()
 dene(yy.huzur()>1 and yy.huzur()<=yy.a.isyan_esigi and yy.isyan_kalan==-1 and eski_gece.yonetim.isyan_kalan>=0,"Tam gerçek gece bağlantısı yeni eşiği uygular, eski eşiği korur")
 print("MUHAFIZ ADALET YETENEK: GEÇTİ" if hata==0 else "MUHAFIZ ADALET YETENEK: KALDI")
 quit(hata)
