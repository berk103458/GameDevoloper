extends SceneTree
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat,76)
 var y := o.yonetim
 var suphe := y.kabul({"ad":"Şüpheli", "adli_id":"chr_001"})
 var bekci := y.kabul({"ad":"Nöbetçi", "sinif":"asker"})
 var olaylar: Array[Dictionary] = []
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"hedef","",0,false)
 assert(y.muhafiz_ata(bekci.id))
 assert(is_equal_approx(CasusDevriyesi.sans(y),0.25))
 var rng := y._rng.state
 CasusDevriyesi.gece(y,olaylar)
 assert(CasusDevriyesi.olay(o) == null and y._rng.state == rng)
 y.gun += 1
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"sabotaj","gida",3,false)
 var eski: float = CasusDevriyesi.AYAR.fener_taban
 CasusDevriyesi.AYAR.fener_taban = 1.0
 var ust: float = CasusDevriyesi.AYAR.yakalama_ust
 CasusDevriyesi.AYAR.yakalama_ust = 1.0
 var once := y.kaynaklar.kaydet()
 var kamu := y.akce
 var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 CasusDevriyesi.gece(y,olaylar)
 CasusDevriyesi.gece(geri.yonetim,[])
 assert(CasusDevriyesi.durum(geri.yonetim) == CasusDevriyesi.durum(y) and geri.yonetim._rng.state == y._rng.state)
 assert(CasusGeceTakibi.acik_izler(y).size() == 1 and CasusDevriyesi.durum(y).bekliyor and y.kaynaklar.kaydet() == once and y.akce == kamu)
 var r := y._rng.state
 CasusDevriyesi.gece(y,olaylar)
 assert(y._rng.state == r and olaylar.size() == 1)
 var e := o.olay_sec()
 assert(CasusDevriyesi.tanimli(e) and o.secenek_olur(e,0))
 var kayit := JSON.stringify(o.kaydet())
 geri = Oturum.kayittan(kat,JSON.parse_string(kayit))
 assert(geri.olay_sec().id == e.id)
 assert(o.olay_uygula(e,0).ok and not CasusDevriyesi.durum(y).bekliyor and CasusGeceTakibi.acik_izler(y).size() == 1)
 kayit = JSON.stringify(o.kaydet())
 assert(not o.olay_uygula(e,0).ok and JSON.stringify(o.kaydet()) == kayit)
 y.gun += 1
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"hirsizlik","gida",0,true)
 CasusDevriyesi.gece(y,[])
 assert(suphe.bayrak_var("hirsiz") and CasusDevriyesi.durum(y).bekliyor)
 e = o.olay_sec()
 assert(o.olay_uygula(e,1).ok and CasusGeceTakibi.acik_izler(y).size() == 2 and CasusDevriyesi.durum(y).secim == 1)
 y.bosalt(bekci.id)
 assert(CasusDevriyesi.sans(y) == 0.0)
 y.gun += 1
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"sabotaj","alet",1,false)
 r = y._rng.state
 CasusDevriyesi.gece(y,[])
 assert(y._rng.state == r and not CasusDevriyesi.durum(y).bekliyor)
 y.muhafiz_ata(bekci.id)
 bekci.bayrak_ekle("hasta")
 assert(CasusDevriyesi.sans(y) == 0.0)
 bekci.bayraklar.erase("hasta")
 assert(CasusDevriyesi.sans(y) == 1.0)
 CasusDevriyesi.AYAR.fener_taban = eski
 CasusDevriyesi.AYAR.yakalama_ust = ust
 assert(not CasusDevriyesi.oku({"kisi":-1,"gun":2,"bekliyor":true}).bekliyor)
 print("CASUS DEVRİYESİ: GEÇTİ")
 quit(0)
