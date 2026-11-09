extends SceneTree

var _hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat,76)
 var y := o.yonetim
 var suphe := y.kabul({"ad":"Şüpheli", "adli_id":"chr_001"})
 var bekci := y.kabul({"ad":"Nöbetçi", "sinif":"asker"})
 var olaylar: Array[Dictionary] = []
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"hedef","",0,false)
 _dene(y.muhafiz_ata(bekci.id), "casus_devriyesi_test.gd:11")
 _dene(is_equal_approx(CasusDevriyesi.sans(y),0.25), "casus_devriyesi_test.gd:12")
 var rng := y._rng.state
 CasusDevriyesi.gece(y,olaylar)
 _dene(CasusDevriyesi.olay(o) == null and y._rng.state == rng, "casus_devriyesi_test.gd:15")
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
 _dene(CasusDevriyesi.durum(geri.yonetim) == CasusDevriyesi.durum(y) and geri.yonetim._rng.state == y._rng.state, "casus_devriyesi_test.gd:27")
 _dene(CasusGeceTakibi.acik_izler(y).size() == 1 and CasusDevriyesi.durum(y).bekliyor and y.kaynaklar.kaydet() == once and y.akce == kamu, "casus_devriyesi_test.gd:28")
 var r := y._rng.state
 CasusDevriyesi.gece(y,olaylar)
 _dene(y._rng.state == r and olaylar.size() == 1, "casus_devriyesi_test.gd:31")
 var e := o.olay_sec()
 _dene(CasusDevriyesi.tanimli(e) and o.secenek_olur(e,0), "casus_devriyesi_test.gd:33")
 var kayit := JSON.stringify(o.kaydet())
 geri = Oturum.kayittan(kat,JSON.parse_string(kayit))
 _dene(geri.olay_sec().id == e.id, "casus_devriyesi_test.gd:36")
 _dene(o.olay_uygula(e,0).ok and not CasusDevriyesi.durum(y).bekliyor and CasusGeceTakibi.acik_izler(y).size() == 1, "casus_devriyesi_test.gd:37")
 kayit = JSON.stringify(o.kaydet())
 _dene(not o.olay_uygula(e,0).ok and JSON.stringify(o.kaydet()) == kayit, "casus_devriyesi_test.gd:39")
 y.gun += 1
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"hirsizlik","gida",0,true)
 CasusDevriyesi.gece(y,[])
 _dene(suphe.bayrak_var("hirsiz") and CasusDevriyesi.durum(y).bekliyor, "casus_devriyesi_test.gd:43")
 e = o.olay_sec()
 _dene(o.olay_uygula(e,1).ok and CasusGeceTakibi.acik_izler(y).size() == 2 and CasusDevriyesi.durum(y).secim == 1, "casus_devriyesi_test.gd:45")
 y.bosalt(bekci.id)
 _dene(CasusDevriyesi.sans(y) == 0.0, "casus_devriyesi_test.gd:47")
 y.gun += 1
 CasusGeceTakibi.kaydet(y,suphe,"ambar",-1,"sabotaj","alet",1,false)
 r = y._rng.state
 CasusDevriyesi.gece(y,[])
 _dene(y._rng.state == r and not CasusDevriyesi.durum(y).bekliyor, "casus_devriyesi_test.gd:52")
 y.muhafiz_ata(bekci.id)
 bekci.bayrak_ekle("hasta")
 _dene(CasusDevriyesi.sans(y) == 0.0, "casus_devriyesi_test.gd:55")
 bekci.bayraklar.erase("hasta")
 _dene(CasusDevriyesi.sans(y) == 1.0, "casus_devriyesi_test.gd:57")
 CasusDevriyesi.AYAR.fener_taban = eski
 CasusDevriyesi.AYAR.yakalama_ust = ust
 _dene(not CasusDevriyesi.oku({"kisi":-1,"gun":2,"bekliyor":true}).bekliyor, "casus_devriyesi_test.gd:60")
 print("CASUS DEVRİYESİ: GEÇTİ" if _hata == 0 else "CASUS DEVRİYESİ: KALDI (%d hata)" % _hata)
 quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
