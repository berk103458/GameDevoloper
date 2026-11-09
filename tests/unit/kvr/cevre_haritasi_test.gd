extends SceneTree

var _hata := 0
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1101)
 var once:=JSON.stringify(o.kaydet())
 var rng:=o._rng.state
 _dene(CevreHaritasi.bolgeler().size()==4, "cevre_haritasi_test.gd:8")
 _dene(CevreHaritasi.bilgi(o,"hisar").metin.contains("Gün: 1"), "cevre_haritasi_test.gd:9")
 for id in ["hisar","karaboran","tekfur","goc_yolu"]:
  var d:=CevreHaritasi.bilgi(o,id)
  _dene(not d.is_empty() and not String(d.ad).is_empty() and not String(d.metin).is_empty(), "cevre_haritasi_test.gd:12")
 var bolgeler:=CevreHaritasi.bolgeler()
 bolgeler[0].ad="sahte"
 _dene(CevreHaritasi.bolgeler()[0].ad!="sahte", "cevre_haritasi_test.gd:15")
 _dene(CevreHaritasi.bilgi(o,"bilinmeyen").is_empty() and CevreHaritasi.bilgi(null,"hisar").is_empty(), "cevre_haritasi_test.gd:16")
 _dene(JSON.stringify(o.kaydet())==once and o._rng.state==rng, "cevre_haritasi_test.gd:17")
 o.yonetim.tekfur_baski=3
 o.yonetim.savusturulan=2
 _dene(CevreHaritasi.bilgi(o,"tekfur").metin.contains("3") and CevreHaritasi.bilgi(o,"tekfur").metin.contains("2"), "cevre_haritasi_test.gd:20")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 _dene(CevreHaritasi.bilgi(geri,"tekfur")==CevreHaritasi.bilgi(o,"tekfur"), "cevre_haritasi_test.gd:22")
 print("CEVRE HARITASI: GEÇTİ" if _hata == 0 else "CEVRE HARITASI: KALDI (%d hata)" % _hata)
 quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
