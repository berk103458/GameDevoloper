extends SceneTree

var _hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat,76)
 var g := o._adli_gelen(&"chr_001")
 var s := g.chr_sorgusu()
 var v: KarakterVerisi=s.karakter
 var kaynak_once := var_to_str(v)
 s.obje_incele(1)
 s.obje_incele(2)
 s.obje_incele(2)
 var rr := o.karar_ver(g,&"kabul")
 var y:=o.yonetim
 var k:=y.koylu(rr.koylu_id)
 _dene(DivanKanit.durum(k).ipuclar.size()==2 and DivanKanit.durum(k).sunulan.is_empty() and s.ipuclari.size()==2, "divan_kanit_test.gd:16")
 var once:=JSON.stringify(y.kaydet())
 _dene(not DivanKanit.sun(y,k.id,String(v.obje_ipucu(1))) and JSON.stringify(y.kaydet())==once, "divan_kanit_test.gd:18")
 CasusGeceTakibi.kaydet(y,k,"ambar",-1,"kundaklama","gida",0,true)
 _dene(not DivanKanit.sun(y,k.id,"Clue_CHR009_EngerekZehri"), "divan_kanit_test.gd:20")
 _dene(not DivanKanit.sun(y,k.id,String(v.gorsel_hata_ipucu)), "divan_kanit_test.gd:21")
 _dene(DivanKanit.sun(y,k.id,String(v.obje_ipucu(1))) and not DivanKanit.sorgula(y,k.id), "divan_kanit_test.gd:22")
 _dene(not DivanKanit.sun(y,k.id,String(v.obje_ipucu(1))), "divan_kanit_test.gd:23")
 var akce:=y.akce
 var stok:=y.kaynaklar.kaydet()
 var rng:=y._rng.state
 _dene(DivanKanit.sun(y,k.id,String(v.obje_ipucu(2))) and DivanKanit.sorgula(y,k.id), "divan_kanit_test.gd:27")
 _dene(not DivanKanit.sorgula(y,k.id) and DivanKanit.durum(k).itiraf and y.akce==akce and y.kaynaklar.kaydet()==stok and y._rng.state==rng and var_to_str(v)==kaynak_once and s.ipuclari.size()==2, "divan_kanit_test.gd:28")
 var ilerleme:=DivanKanit.durum(k)
 DivanKanit.devral(k,g)
 _dene(DivanKanit.durum(k)==ilerleme, "divan_kanit_test.gd:31")
 var foreign:=o._adli_gelen(&"chr_009")
 foreign.chr_sorgusu().obje_incele(1)
 DivanKanit.devral(k,foreign)
 _dene(DivanKanit.durum(k)==ilerleme, "divan_kanit_test.gd:35")
 var z:=KoyYonetimi.kayittan(kat.koy_ayarlari,kat.binalar,JSON.parse_string(JSON.stringify(y.kaydet())))
 _dene(DivanKanit.durum(z.koylu(k.id))==DivanKanit.durum(k), "divan_kanit_test.gd:37")
 var eski:=Koylu.kayittan({"id":5,"adli_id":"chr_001"})
 _dene(DivanKanit.durum(eski).ipuclar.is_empty() and not DivanKanit.durum(eski).itiraf, "divan_kanit_test.gd:39")
 var masum:=y.kabul({"ad":"Demirci","adli_id":"chr_003"})
 var mv:=DivanKanit.kaynak(masum)
 masum.set_meta(DivanKanit.META,{"ipuclar":[String(mv.obje_ipucu(1)),String(mv.obje_ipucu(2))],"sunulan":[String(mv.obje_ipucu(1)),String(mv.obje_ipucu(2))],"itiraf":true})
 CasusGeceTakibi.kaydet(y,masum,"ambar",-1,"sabotaj","gida",3,true)
 _dene(not DivanKanit.durum(masum).itiraf and not DivanKanit.sorgula(y,masum.id), "divan_kanit_test.gd:44")
 _dene(DivanKanit.oku(k,{"ipuclar":[String(v.obje_ipucu(1)),String(v.obje_ipucu(1)),"Clue_fake"],"sunulan":["Clue_fake"],"itiraf":true}).ipuclar.size()==1, "divan_kanit_test.gd:45")
 var d:=DivanKanit.durum(k)
 d.ipuclar.clear()
 _dene(DivanKanit.durum(k).ipuclar.size()==2, "divan_kanit_test.gd:48")
 print("DIVAN KANIT: GEÇTİ" if _hata == 0 else "DIVAN KANIT: KALDI (%d hata)" % _hata)
 quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
