extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1701)
 var y:=o.yonetim
 y.kaynaklar.stok.bugday=100
 var once:=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"at").ok and JSON.stringify(o.kaydet())==once,"Ahır olmadan bedel/ittifak yok")
 var ahir:=KoyBinasi.new()
 ahir.id=801;ahir.tur="ahir";ahir.insa_kalan=1
 y.binalar.append(ahir)
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"at").ok and JSON.stringify(o.kaydet())==once,"İnşaat bitmeden takas yok")
 ahir.insa_kalan=0
 var kamu:=y.akce
 var para:=o.muhafiz_akce
 var rng:=o._rng.state
 var yrng:=y._rng.state
 y.lojistik.hayvanlar.okuz=2
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"at").ok and JSON.stringify(o.kaydet())==once,"Öküz ve at ortak kapasiteyi paylaşır")
 y.lojistik.hayvanlar.okuz=0
 var r:=ObaIttifaki.takas(o,"at")
 dene(r.ok and y.kaynaklar.miktar("bugday")==80 and int(y.lojistik.hayvanlar.beygir)==1,"Gerçek buğday ve aynı beygir kaydı")
 dene(ObaIttifaki.muttefik(o) and y.akce==kamu and o.muhafiz_akce==para and o._rng.state==rng and y._rng.state==yrng,"İttifak, kasalar ve RNG")
 once=JSON.stringify(o.kaydet())
 ObaIttifaki.tip(o)
 dene(not ObaIttifaki.takas(o,"alp").ok and JSON.stringify(o.kaydet())==once,"Okuma saf ve günlük tek takas")
 o=Oturum.kayittan(kat,JSON.parse_string(once));y=o.yonetim
 dene(ObaIttifaki.muttefik(o) and not ObaIttifaki.takas(o,"at").ok and int(y.lojistik.hayvanlar.beygir)==1,"JSON kalıcı ittifak/hayvan/tekrar engeli")
 y.gun+=1
 dene(ObaIttifaki.takas(o,"at").ok and int(y.lojistik.hayvanlar.beygir)==2,"Ertesi gün tek boş ahır yeri")
 y.gun+=1
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"at").ok and JSON.stringify(o.kaydet())==once,"Ortak ahır dolunca atomik ret")
 y.kaynaklar.stok.bugday=29
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"alp").ok and JSON.stringify(o.kaydet())==once,"Buğday yetmezse atomik ret")
 y.kaynaklar.stok.bugday=100
 for b in y.binalar: if b.yatak(y.katalog)>0: b.insa_kalan=1
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"alp").ok and JSON.stringify(o.kaydet())==once,"Hazır yatak yoksa alp yok")
 var ev:=KoyBinasi.new()
 ev.id=802;ev.tur="kulube";ev.seviye=10
 y.binalar.append(ev)
 var n:=y.nufus()
 var kabul:=y.kabul_sayisi
 var asker_once:=int(o.koy.sayilar.get(&"asker",0))
 var a:=ObaIttifaki.takas(o,"alp")
 dene(a.ok and y.kaynaklar.miktar("bugday")==70 and y.nufus()==n+1 and y.kabul_sayisi==kabul+1,"Buğday gerçek yeni köylüye çevrilir")
 var k:=y.koylular.back() as Koylu
 dene(k.sinif==&"asker" and k.stat==6 and k.adli_id==&"" and int(o.koy.sayilar.get(&"asker",0))==asker_once+1,"Alp normal asker ve gerçek köy köprüsü")
 var yuklu:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(yuklu.yonetim.nufus()==y.nufus() and (yuklu.yonetim.koylular.back() as Koylu).stat==6 and not ObaIttifaki.takas(yuklu,"alp").ok,"Alp ve makbuz JSON sonrası kalır")
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"bilinmeyen").ok and JSON.stringify(o.kaydet())==once,"Bilinmeyen tür saf ret")
 y.gun+=1;y.son="iflas"
 once=JSON.stringify(o.kaydet())
 dene(not ObaIttifaki.takas(o,"at").ok and JSON.stringify(o.kaydet())==once,"Terminal modelde takas yok")
 var eski:=o.kaydet();eski.erase("oba_ittifaki")
 dene(int(Oturum.kayittan(kat,eski).oba_ittifaki.son_gun)==-1,"Legacy optional defter")
 dene(int(ObaIttifaki.oku({"son_gun":"hata","takas":"hile"}).son_gun)==-1 and ObaIttifaki.oku({"takas":"hile"}).takas=="","Bozuk makbuz temizlenir")
 print("OBA ITTIFAKI: GEÇTİ" if hata==0 else "OBA ITTIFAKI: KALDI")
 quit(0 if hata==0 else 1)
