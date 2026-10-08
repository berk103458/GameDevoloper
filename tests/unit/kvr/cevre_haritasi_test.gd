extends SceneTree
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1101)
 var once:=JSON.stringify(o.kaydet())
 var rng:=o._rng.state
 assert(CevreHaritasi.bolgeler().size()==4)
 assert(CevreHaritasi.bilgi(o,"hisar").metin.contains("Gün: 1"))
 for id in ["hisar","karaboran","tekfur","goc_yolu"]:
  var d:=CevreHaritasi.bilgi(o,id)
  assert(not d.is_empty() and not String(d.ad).is_empty() and not String(d.metin).is_empty())
 var bolgeler:=CevreHaritasi.bolgeler()
 bolgeler[0].ad="sahte"
 assert(CevreHaritasi.bolgeler()[0].ad!="sahte")
 assert(CevreHaritasi.bilgi(o,"bilinmeyen").is_empty() and CevreHaritasi.bilgi(null,"hisar").is_empty())
 assert(JSON.stringify(o.kaydet())==once and o._rng.state==rng)
 o.yonetim.tekfur_baski=3
 o.yonetim.savusturulan=2
 assert(CevreHaritasi.bilgi(o,"tekfur").metin.contains("3") and CevreHaritasi.bilgi(o,"tekfur").metin.contains("2"))
 var geri:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 assert(CevreHaritasi.bilgi(geri,"tekfur")==CevreHaritasi.bilgi(o,"tekfur"))
 print("CEVRE HARITASI: GEÇTİ")
 quit(0)
