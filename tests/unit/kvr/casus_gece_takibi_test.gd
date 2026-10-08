extends SceneTree
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.a = y.a.duplicate(true)
 y.a.ambar_taban_kapasite = 10000
 kat.koy_ayarlari = y.a
 y.kaynaklar.kapasite = 10000
 y.akce = 1000
 for t in ["odun", "tas", "gida", "kereste"]: y.kaynaklar.ekle(t, 100)
 var ambar := kur(y, "ambar")
 var kuyu := kur(y, "sifahane")
 var kisla := kur(y, "muhafiz_kislasi")
 y._ambar_kapasitesi()
 var kundak := y.kabul({"ad":"Satı", "adli_id":"chr_001"})
 var zehir := y.kabul({"ad":"Meryem", "adli_id":"chr_002"})
 var casus := y.kabul({"ad":"İlyas", "adli_id":"chr_004"})
 var masum := y.kabul({"ad":"Kerem", "adli_id":"chr_003"})
 assert(CasusGeceTakibi.plan(y,kundak) == {"hedef":"ambar","bina":ambar.id})
 assert(CasusGeceTakibi.plan(y,zehir) == {"hedef":"kuyu","bina":kuyu.id})
 assert(CasusGeceTakibi.plan(y,casus) == {"hedef":"cephanelik","bina":kisla.id})
 assert(CasusGeceTakibi.plan(y,masum).is_empty())
 var once := y.kaynaklar.kaydet()
 var rng := y._rng.state
 var bayrak := kundak.bayraklar.duplicate()
 var gizli := kundak.gizli_bayraklar.duplicate()
 CasusGeceTakibi.gece(y)
 assert(CasusGeceTakibi.durum(y).izler.size() == 3 and CasusGeceTakibi.acik_izler(y).is_empty())
 assert(y._rng.state == rng and y.kaynaklar.kaydet() == once and kundak.bayraklar == bayrak and kundak.gizli_bayraklar == gizli)
 var kayit := JSON.stringify(o.kaydet())
 CasusGeceTakibi.gece(y)
 assert(JSON.stringify(o.kaydet()) == kayit)
 var geri := Oturum.kayittan(kat, JSON.parse_string(kayit))
 CasusGeceTakibi.gece(geri.yonetim)
 assert(normal(geri.kaydet()) == normal(o.kaydet()))
 var d := CasusGeceTakibi.durum(y)
 d.izler.clear()
 assert(CasusGeceTakibi.durum(y).izler.size() == 3)
 CasusGeceTakibi.kaydet(y,kundak,"ambar",ambar.id,"hirsizlik","gida",0,true)
 assert(CasusGeceTakibi.acik_izler(y).size() == 1 and CasusGeceTakibi.acik_izler(y)[0].kisi == kundak.id)
 CasusGeceTakibi.gece(y)
 assert(CasusGeceTakibi.acik_izler(y).size() == 1)
 CasusGeceTakibi.kaydet(y,kundak,"ambar",ambar.id,"hedef","",0,false)
 assert(CasusGeceTakibi.acik_izler(y).size() == 1)
 kuyu.insa_kalan = 2
 assert(CasusGeceTakibi.plan(y,zehir).bina == -1)
 kuyu.insa_kalan = 0
 zehir.saglik = 0
 assert(CasusGeceTakibi.plan(y,zehir).is_empty())
 zehir.saglik = 100
 zehir.kis_hastaligi = {"bitis":3,"son_gece":0}
 zehir.bayrak_ekle(KisHastaligi.FLAG)
 assert(CasusGeceTakibi.plan(y,zehir).is_empty())
 zehir.bayraklar.erase(KisHastaligi.FLAG)
 zehir.kis_hastaligi = {}
 zehir.is_yeri = KoyYonetimi.MUHAFIZ
 assert(CasusGeceTakibi.plan(y,zehir).is_empty())
 zehir.is_yeri = -1
 y.bina_el_koy(kuyu.id)
 assert(CasusGeceTakibi.plan(y,zehir).bina == -1)
 assert(CasusGeceTakibi.oku(null).izler.is_empty() and CasusGeceTakibi.oku({"izler":[{"kisi":1}]}).izler.is_empty())
 for i in range(1, 12):
  y.gun = i
  CasusGeceTakibi.gece(y)
 assert(CasusGeceTakibi.durum(y).izler.all(func(x: Dictionary) -> bool: return int(x.gun) >= 5) and CasusGeceTakibi.durum(y).izler.size() <= int(CasusGeceTakibi.AYAR.iz_azami))
 geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 var rapor := y.gece()
 assert(geri.yonetim.gece() == rapor and normal(geri.yonetim.kaydet()) == normal(y.kaydet()))
 var bulundu := false
 var gorulmedi := false
 for tohum in range(1, 100):
  var t := KoyYonetimi.new(y.a,y.katalog,tohum * 1009 + 17)
  var h := t.kabul({"ad":"Haydut", "adli_id":"chr_001"})
  t.kaynaklar.ekle("gida",50)
  var gida := t.kaynaklar.miktar("gida")
  var beklenen := RandomNumberGenerator.new()
  beklenen.state = t._rng.state
  var giris := beklenen.randf() < GizliEgilimler.HIRSIZLIK_RISKI
  if giris: beklenen.randf()
  GizliEgilimler.gece(t, {}, [])
  assert(t._rng.state == beklenen.state)
  var izler: Array = CasusGeceTakibi.durum(t).izler
  if not giris:
   assert(izler.is_empty())
  elif h.gizli_egilim.yakalanma:
   assert(izler.size() == 1 and izler[0].goruldu and izler[0].kayip == 0 and t.kaynaklar.miktar("gida") == gida)
   bulundu = true
  else:
   assert(izler.size() == 1 and not izler[0].goruldu and izler[0].kayip == gida - t.kaynaklar.miktar("gida") and CasusGeceTakibi.acik_izler(t).is_empty())
   gorulmedi = true
 print("Yakalandı:",bulundu," görülmedi:",gorulmedi)
 assert(bulundu and gorulmedi)
 print("CASUS GECE TAKİBİ: GEÇTİ")
 quit(0)
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 return null

func normal(v: Dictionary) -> Variant:
 return JSON.parse_string(JSON.stringify(v))
