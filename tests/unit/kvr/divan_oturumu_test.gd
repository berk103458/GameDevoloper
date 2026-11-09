extends SceneTree

var _hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat,24)
 var y := o.yonetim
 var k := y.kabul({"ad":"Gözlenen kişi"})
 var masum := y.kabul({"ad":"Şüphe kişisi"})
 CasusGeceTakibi.kaydet(y,k,"ambar",-1,"hirsizlik","gida",0,true)
 CasusGeceTakibi.kaydet(y,k,"kuyu",-1,"zehirleme","saglik",4,false)
 CasusGeceTakibi.kaydet(y,masum,"ambar",-1,"hedef","",0,true)
 _dene(DivanOturumu.adaylar(y)==[k.id] and DivanOturumu.izler(y,k.id).size()==1 and DivanOturumu.izler(y,masum.id).is_empty(), "divan_oturumu_test.gd:12")
 var once := y.kaynaklar.kaydet()
 var akce := y.akce
 var rng := y._rng.state
 _dene(not DivanOturumu.sec(y,masum.id) and DivanOturumu.sec(y,k.id), "divan_oturumu_test.gd:16")
 _dene(y.kaynaklar.kaydet()==once and y.akce==akce and y._rng.state==rng and k.saglik==100, "divan_oturumu_test.gd:17")
 var z := KoyYonetimi.kayittan(kat.koy_ayarlari,kat.binalar,JSON.parse_string(JSON.stringify(y.kaydet())))
 _dene(DivanOturumu.durum(z).kisi==k.id and DivanOturumu.adaylar(z)==[k.id], "divan_oturumu_test.gd:19")
 var iz := DivanOturumu.izler(y,k.id)
 iz[0].kayip=100
 _dene(DivanOturumu.izler(y,k.id)[0].kayip==0, "divan_oturumu_test.gd:22")
 k.saglik=0
 _dene(DivanOturumu.adaylar(y).is_empty() and not DivanOturumu.sec(y,k.id), "divan_oturumu_test.gd:24")
 k.saglik=100
 y.son="isyan"
 _dene(DivanOturumu.adaylar(y).is_empty(), "divan_oturumu_test.gd:27")
 _dene(DivanOturumu.oku({"kisi":"fake","inceleme_gunu":INF}).kisi==-1, "divan_oturumu_test.gd:28")
 print("DIVAN OTURUMU: GEÇTİ" if _hata == 0 else "DIVAN OTURUMU: KALDI (%d hata)" % _hata)
 quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
