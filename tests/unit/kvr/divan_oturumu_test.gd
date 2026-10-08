extends SceneTree
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
 assert(DivanOturumu.adaylar(y)==[k.id] and DivanOturumu.izler(y,k.id).size()==1 and DivanOturumu.izler(y,masum.id).is_empty())
 var once := y.kaynaklar.kaydet()
 var akce := y.akce
 var rng := y._rng.state
 assert(not DivanOturumu.sec(y,masum.id) and DivanOturumu.sec(y,k.id))
 assert(y.kaynaklar.kaydet()==once and y.akce==akce and y._rng.state==rng and k.saglik==100)
 var z := KoyYonetimi.kayittan(kat.koy_ayarlari,kat.binalar,JSON.parse_string(JSON.stringify(y.kaydet())))
 assert(DivanOturumu.durum(z).kisi==k.id and DivanOturumu.adaylar(z)==[k.id])
 var iz := DivanOturumu.izler(y,k.id)
 iz[0].kayip=100
 assert(DivanOturumu.izler(y,k.id)[0].kayip==0)
 k.saglik=0
 assert(DivanOturumu.adaylar(y).is_empty() and not DivanOturumu.sec(y,k.id))
 k.saglik=100
 y.son="isyan"
 assert(DivanOturumu.adaylar(y).is_empty())
 assert(DivanOturumu.oku({"kisi":"fake","inceleme_gunu":INF}).kisi==-1)
 print("DIVAN OTURUMU: GEÇTİ")
 quit(0)
