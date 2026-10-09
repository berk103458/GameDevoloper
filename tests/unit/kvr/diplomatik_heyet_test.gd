extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1;push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1921)
 var y:=o.yonetim
 var normal:=Gelen.new()
 var liste: Array[Gelen]=[normal]
 var once:=JSON.stringify(o.kaydet())
 DiplomatikHeyet.ekle(o,liste)
 dene(liste==[normal] and JSON.stringify(o.kaydet())==once,"Kaynak talep/uyarı yoksa heyet/RNG yok")
 y.agalik=true;y.harac_bekliyor=true;y.gun=25
 o.mogol_oncusu={"son_gece":25,"uyarilar":[5]}
 once=JSON.stringify(o.kaydet())
 DiplomatikHeyet.ekle(o,liste)
 dene(liste.size()==3 and liste[2]==normal and DiplomatikHeyet.bilet(liste[0]).tur=="mogol" and DiplomatikHeyet.bilet(liste[1]).tur=="tekfur","Heyetler kuyruğun başında, normal korunur")
 dene(JSON.stringify(o.kaydet())==once,"Ekleme saf; asker/nüfus/kasa/RNG yaratmaz")
 DiplomatikHeyet.ekle(o,liste)
 dene(liste.size()==3,"Aynı kuyrukta çift heyet yok")
 var m:=liste[0]
 var t:=liste[1]
 dene(DiplomatikHeyet.kilitli(o,liste),"Heyet varken sıra atlama kilitli")
 dene(o.karar_ver(m,&"ret").engellendi and JSON.stringify(o.kaydet())==once,"Geçersiz heyet kararı atomik ret")
 dene(not o.karar_ver(m,&"kabul").engellendi and not DiplomatikHeyet.gecis_engeli(o,m),"Moğol dinleme gerçek karar; ileri açılır")
 dene(o.karar_ver(m,&"kabul").engellendi,"Aynı heyet ikinci karar ret")
 y.akce=9;y.kaynaklar.stok.bugday=20;o.muhafiz_akce=100
 once=JSON.stringify(o.kaydet())
 dene(not DiplomatikHeyet.karar_olur(o,t,&"harc") and o.karar_ver(t,&"harc").engellendi and JSON.stringify(o.kaydet())==once,"Eksik kamu: kişisel kese yardım etmez, atomik ret")
 y.akce=10
 var rng:=o._rng.state
 dene(not o.karar_ver(t,&"harc").engellendi and y.akce==0 and y.kaynaklar.miktar("bugday")==0 and not y.harac_bekliyor and o.muhafiz_akce==100 and o._rng.state==rng,"Tekfur yalnız gerçek10kamu/20buğday ödeme")
 dene(not DiplomatikHeyet.kilitli(o,liste) and y.nufus()==0,"Heyet dinlenince kilit kalkar; köylü yazılmaz")
 var yuk:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 var b: Array[Gelen]=[]
 DiplomatikHeyet.ekle(yuk,b)
 dene(b.is_empty(),"JSON makbuzla tekrar heyet yok")
 var g:=KapiAnlikGoruntusu.gelen_yukle(JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(t))),kat)
 dene(g!=null and DiplomatikHeyet.bilet(g)==DiplomatikHeyet.bilet(t),"Anlık görüntü optional bilet korunur")
 dene(DiplomatikHeyet.bilet_oku({"tur":"x","gun":1,"kalan":5}).is_empty() and DiplomatikHeyet.oku({"tekfur_gun":-100,"mogol":[5,2,0,0,99]}).mogol==[5,2,0],"Bozuk bilet/defter güvenli")
 dene(DiplomatikHeyet.bilet_oku({"tur":"tekfur","gun":1,"kalan":"bozuk"}).is_empty() and DiplomatikHeyet.bilet_oku({"tur":"tekfur","gun":1,"kalan":1e30}).is_empty(),"Bozuk sayı gerçek Tekfur bileti olamaz")
 y.gun=28;o.mogol_oncusu={"son_gece":28,"uyarilar":[5,2]}
 b=[];DiplomatikHeyet.ekle(o,b)
 dene(b.size()==1 and DiplomatikHeyet.bilet(b[0]).kalan==2,"İkinci gerçek uyarı tek heyet")
 var eski:=b[0]
 y.gun=29
 once=JSON.stringify(o.kaydet())
 dene(o.karar_ver(eski,&"kabul").engellendi and JSON.stringify(o.kaydet())==once,"Bayat gün atomik ret")
 y.gun=30;o.mogol_oncusu={"son_gece":30,"uyarilar":[5,2,0]}
 b=[];DiplomatikHeyet.ekle(o,b)
 dene(b.size()==1 and not o.karar_ver(b[0],&"kabul").engellendi,"Sınır heyeti bir kez dinlenir; yeni savaş motoru yok")
 y.gun=31;b=[];DiplomatikHeyet.ekle(o,b)
 dene(b.is_empty(),"Sınırda sonraki günlerde tekrar yok")
 y.son=&"yenilgi";y.harac_bekliyor=true
 DiplomatikHeyet.ekle(o,b)
 dene(b.is_empty(),"Terminal yeni heyet yok")
 var gercek:=Oturum.new(kat,1923)
 gercek.yonetim.gun=24
 var rapor:=gercek.gece_sonu()
 var q:=gercek.gece_kuyrugu()
 dene(rapor.son==&"" and not q.is_empty() and DiplomatikHeyet.bilet(q[0]).get("tur","")=="mogol","Gerçek25.gece raporu gerçek kapı kuyruğunda")
 gercek=Oturum.new(kat,1924)
 gercek.yonetim.agalik=true;gercek.yonetim.gun=5
 rapor=gercek.gece_sonu();q=gercek.gece_kuyrugu()
 dene(rapor.son==&"" and gercek.yonetim.harac_bekliyor and DiplomatikHeyet.bilet(q[0]).get("tur","")=="tekfur","Gerçek ikinci perde6.gece talebi kapı kuyruğunda")
 print("DIPLOMATIK HEYET: GEÇTİ" if hata==0 else "DIPLOMATIK HEYET: KALDI")
 quit(hata)
