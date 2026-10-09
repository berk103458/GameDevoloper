extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new();kat.yukle()
 var o:=Oturum.new(kat,1901)
 var y:=o.yonetim
 var para:=o.muhafiz_akce
 var kamu:=y.akce
 var rng:=o._rng.state
 var yrng:=y._rng.state
 var r:={"gun":24,"olaylar":[{"mogol_oncusu":{"ad":"öncü","kalan":5,"sinirda":false}},{"tekfur_harac":{"akce":10,"bugday":20}},{"anahtar":"koy.olay.baskin","deger":[3,2]}]}
 HaberciAgi.gece(o,r)
 dene(HaberciAgi.oku(o.haberci_agi).bekleyen.size()==3,"Üç gerçek rapor kaynağı aynı kart defterinde")
 dene(o.muhafiz_akce==para and y.akce==kamu and o._rng.state==rng and y._rng.state==yrng,"Haber toplama kasa/RNG etkilemez")
 var once:=JSON.stringify(o.kaydet())
 HaberciAgi.gece(o,r)
 var e:=HaberciAgi.olay(o)
 dene(JSON.stringify(o.kaydet())==once and e!=null and e.baslik_anahtari.contains("Güvercin") and e.metin_anahtari.contains("5 gün"),"Tek gece tekrar yok; okuma saf gerçek güvercin haberi")
 dene(o.olay_sec().id==e.id,"Mevcut olay seçimine bağlandı")
 var sahte:=OlayVerisi.new();sahte.id=&"har09_haber_sahte_25"
 dene(not o.secenek_olur(e,1) and not o.olay_uygula(sahte,0).ok and JSON.stringify(o.kaydet())==once,"Foreign/eski veya yanlış seçenek saf ret")
 o=Oturum.kayittan(kat,JSON.parse_string(once));y=o.yonetim
 e=HaberciAgi.olay(o)
 dene(e!=null and o.secenek_olur(e,0) and o.olay_uygula(e,0).ok,"JSON aynı haber okunur")
 once=JSON.stringify(o.kaydet())
 dene(not o.olay_uygula(e,0).ok and JSON.stringify(o.kaydet())==once,"Eski kart ikinci teslim değildir")
 var ikinci:=HaberciAgi.olay(o)
 dene(ikinci.baslik_anahtari.contains("Ulak") and ikinci.metin_anahtari.contains("20 buğday"),"Tekfur aynı ulak kartına geçer")
 o.sancak_asker_talebi={"gun":8,"bekliyor":true,"secim":-1}
 dene(SancakAskerTalebi.tanimli(o.olay_sec()),"Mevcut ferman haberden önce")
 o.sancak_asker_talebi={}
 HaberciAgi.gece(o,{"gun":25,"olaylar":[{"tekfur_harac":{"akce":12,"bugday":24}}]})
 dene(HaberciAgi.oku(o.haberci_agi).bekleyen.size()==2 and HaberciAgi.olay(o).metin_anahtari.contains("24 buğday"),"Bekleyen aynı kaynak en yeni gerçek haberle birleştirilir")
 dene(not o.olay_uygula(ikinci,0).ok,"Birleştirmeden önceki kart bayat")
 while HaberciAgi.olay(o)!=null: dene(o.olay_uygula(HaberciAgi.olay(o),0).ok,"Aynı olay yüzeyinde okuma")
 dene(HaberciAgi.olay(o)==null,"Haberler tükenir; ikinci kapı kuyruğu yok")
 once=JSON.stringify(o.kaydet());HaberciAgi.gece(o,{"gun":26,"olaylar":[{"anahtar":"gizli_casus","gizli":true}]})
 dene(HaberciAgi.olay(o)==null,"Gizli/ilgisiz rapor haber olmaz")
 y.son="terk";once=JSON.stringify(o.kaydet())
 HaberciAgi.gece(o,{"gun":27,"olaylar":r.olaylar})
 dene(HaberciAgi.olay(o)==null and JSON.stringify(o.kaydet())==once,"Terminal haber üretmez")
 var eski:=o.kaydet();eski.erase("haberci_agi")
 dene(HaberciAgi.oku(Oturum.kayittan(kat,eski).haberci_agi).bekleyen.is_empty(),"Legacy boş haber")
 dene(HaberciAgi.oku({"bekleyen":[{"kaynak":"gizli","gun":1,"metin":"hile"}],"son_gece":"hata"}).bekleyen.is_empty(),"Bozuk/gizli kayıt elenir")
 var gercek:=Oturum.new(kat,1902)
 gercek.yonetim.gun=24
 var gece:=gercek.gece_sonu()
 dene(gece.son==&"" and gercek.gun==25 and HaberciAgi.tanimli(gece.olay) and String(gece.olay.metin_anahtari).contains("5 gün"),"Gerçek gece raporu ve aynı seçilen haber kartı")
 var tekfur:=Oturum.new(kat,1903)
 tekfur.yonetim.gun=5
 tekfur.yonetim.agalik=true
 var t:=tekfur.gece_sonu()
 dene(t.son==&"" and tekfur.yonetim.harac_bekliyor and HaberciAgi.tanimli(t.olay) and String(t.olay.metin_anahtari).contains("buğday"),"Gerçek altıncı gece haraç raporu ulak olur")
 print("HABERCI AGI: GEÇTİ" if hata==0 else "HABERCI AGI: KALDI")
 quit(0 if hata==0 else 1)
