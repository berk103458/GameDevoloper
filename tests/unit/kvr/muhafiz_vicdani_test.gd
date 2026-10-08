extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,372)
 for i in 2:
  var g:=Gelen.new()
  o.karar_ver(g,&"ret")
 var tehlike:=Gelen.new()
 tehlike.tehlikeli=true
 o.karar_ver(tehlike,&"ret")
 dene(MuhafizVicdani.oku(o.muhafiz_vicdani).haksiz_ret==2 and MuhafizVicdani.oku(o.muhafiz_vicdani).yuk==60,"Gerçek ret aynı kusurlu ölçütü")
 o.yonetim.kabul({"ad":"Sağ kalan tanık"})
 o.yonetim.kaynaklar.ekle("gida",100)
 o.yonetim.kaynaklar.ekle("su",100)
 var r:=o.gece_sonu()
 dene(MuhafizVicdani.aktif(o) and o.muhafiz_vicdani.yuk==55 and o.oda_gelisimi.yorgunluk==26,"Gerçek gece kabusu aynı yorgunluk alanı")
 dene(r.olaylar.back().has("muhafiz_kabus") and IflasYoneticisi.olay_metin(r.olaylar.back()).contains("kanıt"),"Tek typed sabah raporu rüya der")
 var once:=JSON.stringify(o.kaydet())
 var rng:=o._rng.state
 MuhafizVicdani.gece(o,r.rapor)
 dene(JSON.stringify(o.kaydet())==once and o._rng.state==rng,"Aynı gece yeniden kabus/zar yok")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(once))
 dene(geri!=null and geri.muhafiz_vicdani==MuhafizVicdani.oku(o.muhafiz_vicdani) and MuhafizVicdani.aktif(geri),"JSON tam rüya/gün devamı")
 geri.gun+=1
 dene(not MuhafizVicdani.aktif(geri),"Eski kabus yeni güne taşmaz")
 var olum:=Oturum.new(kat,373)
 olum.karar_ver(Gelen.new(),&"ret")
 var hasta:=olum.yonetim.kabul({"ad":"Gerçek gece kaybı"})
 hasta.saglik=1
 olum.yonetim.kabul({"ad":"Yaşayan"})
 olum.yonetim.kaynaklar.stok[&"gida"]=0
 var sonuc:=olum.gece_sonu()
 dene(sonuc.rapor.olenler.has("Gerçek gece kaybı") and olum.muhafiz_vicdani.olum==sonuc.rapor.olenler.size() and MuhafizVicdani.aktif(olum),"Gerçek ölüm dizisi yük üretir, yaşayan köyde kabus")
 var g:=o._adli_gelen(&"chr_001")
 g.chr_sorgusu().obje_incele(1)
 g.chr_sorgusu().tansiyon=6
 g.chr_sorgusu().secenek_sec(2)
 once=JSON.stringify(o.kaydet())
 dene(o.karar_ver(g,&"kabul").get("engellendi",false) and JSON.stringify(o.kaydet())==once,"Engellenmiş karar kişisel iz yaratmaz")
 dene(g.chr_sorgusu().ipuclari.size()==1,"Kabus yeni Clue üretmez")
 var temiz:=Oturum.new(kat,374)
 temiz.yonetim.kabul({"ad":"Temiz gündüz"})
 temiz.yonetim.kaynaklar.ekle("gida",100)
 temiz.yonetim.kaynaklar.ekle("su",100)
 temiz.gece_sonu()
 dene(not MuhafizVicdani.aktif(temiz) and temiz.muhafiz_vicdani.yuk==0,"Temiz gecede rüya/ek yorgunluk yok")
 dene(MuhafizVicdani.oku({"yuk":101,"haksiz_ret":"2","son_kabus":-2}).yuk==0 and MuhafizVicdani.oku(null).son_kabus==-1,"Eski/bozuk kayıt")
 print("MUHAFIZ VICDAN: GEÇTİ" if hata==0 else "MUHAFIZ VICDAN: KALDI")
 quit(hata)
