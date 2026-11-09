extends SceneTree

var _hata := 0
func _initialize() -> void:
 # Kaynak takip testi; alışma kapısı ayrı tehdit_takvimi_test içindedir.
 preload("res://src/sistemler/tehdit_takvimi.gd").AYAR.tehdit_baslangic_gunu = 0
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
 _dene(CasusGeceTakibi.plan(y,kundak) == {"hedef":"ambar","bina":ambar.id}, "casus_gece_takibi_test.gd:23")
 _dene(CasusGeceTakibi.plan(y,zehir) == {"hedef":"kuyu","bina":kuyu.id}, "casus_gece_takibi_test.gd:24")
 _dene(CasusGeceTakibi.plan(y,casus) == {"hedef":"cephanelik","bina":kisla.id}, "casus_gece_takibi_test.gd:25")
 _dene(CasusGeceTakibi.plan(y,masum).is_empty(), "casus_gece_takibi_test.gd:26")
 var once := y.kaynaklar.kaydet()
 var rng := y._rng.state
 var bayrak := kundak.bayraklar.duplicate()
 var gizli := kundak.gizli_bayraklar.duplicate()
 CasusGeceTakibi.gece(y)
 _dene(CasusGeceTakibi.durum(y).izler.size() == 3 and CasusGeceTakibi.acik_izler(y).is_empty(), "casus_gece_takibi_test.gd:32")
 _dene(y._rng.state == rng and y.kaynaklar.kaydet() == once and kundak.bayraklar == bayrak and kundak.gizli_bayraklar == gizli, "casus_gece_takibi_test.gd:33")
 var kayit := JSON.stringify(o.kaydet())
 CasusGeceTakibi.gece(y)
 _dene(JSON.stringify(o.kaydet()) == kayit, "casus_gece_takibi_test.gd:36")
 var geri := Oturum.kayittan(kat, JSON.parse_string(kayit))
 CasusGeceTakibi.gece(geri.yonetim)
 _dene(normal(geri.kaydet()) == normal(o.kaydet()), "casus_gece_takibi_test.gd:39")
 var d := CasusGeceTakibi.durum(y)
 d.izler.clear()
 _dene(CasusGeceTakibi.durum(y).izler.size() == 3, "casus_gece_takibi_test.gd:42")
 CasusGeceTakibi.kaydet(y,kundak,"ambar",ambar.id,"hirsizlik","gida",0,true)
 _dene(CasusGeceTakibi.acik_izler(y).size() == 1 and CasusGeceTakibi.acik_izler(y)[0].kisi == kundak.id, "casus_gece_takibi_test.gd:44")
 CasusGeceTakibi.gece(y)
 _dene(CasusGeceTakibi.acik_izler(y).size() == 1, "casus_gece_takibi_test.gd:46")
 CasusGeceTakibi.kaydet(y,kundak,"ambar",ambar.id,"hedef","",0,false)
 _dene(CasusGeceTakibi.acik_izler(y).size() == 1, "casus_gece_takibi_test.gd:48")
 kuyu.insa_kalan = 2
 _dene(CasusGeceTakibi.plan(y,zehir).bina == -1, "casus_gece_takibi_test.gd:50")
 kuyu.insa_kalan = 0
 zehir.saglik = 0
 _dene(CasusGeceTakibi.plan(y,zehir).is_empty(), "casus_gece_takibi_test.gd:53")
 zehir.saglik = 100
 zehir.kis_hastaligi = {"bitis":3,"son_gece":0}
 zehir.bayrak_ekle(KisHastaligi.FLAG)
 _dene(CasusGeceTakibi.plan(y,zehir).is_empty(), "casus_gece_takibi_test.gd:57")
 zehir.bayraklar.erase(KisHastaligi.FLAG)
 zehir.kis_hastaligi = {}
 zehir.is_yeri = KoyYonetimi.MUHAFIZ
 _dene(CasusGeceTakibi.plan(y,zehir).is_empty(), "casus_gece_takibi_test.gd:61")
 zehir.is_yeri = -1
 y.bina_el_koy(kuyu.id)
 _dene(CasusGeceTakibi.plan(y,zehir).bina == -1, "casus_gece_takibi_test.gd:64")
 _dene(CasusGeceTakibi.oku(null).izler.is_empty() and CasusGeceTakibi.oku({"izler":[{"kisi":1}]}).izler.is_empty(), "casus_gece_takibi_test.gd:65")
 for i in range(1, 12):
  y.gun = i
  CasusGeceTakibi.gece(y)
 _dene(CasusGeceTakibi.durum(y).izler.all(func(x: Dictionary) -> bool: return int(x.gun) >= 5) and CasusGeceTakibi.durum(y).izler.size() <= int(CasusGeceTakibi.AYAR.iz_azami), "casus_gece_takibi_test.gd:69")
 geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 var rapor := y.gece()
 _dene(geri.yonetim.gece() == rapor and normal(geri.yonetim.kaydet()) == normal(y.kaydet()), "casus_gece_takibi_test.gd:72")
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
  _dene(t._rng.state == beklenen.state, "casus_gece_takibi_test.gd:85")
  var izler: Array = CasusGeceTakibi.durum(t).izler
  if not giris:
   _dene(izler.is_empty(), "casus_gece_takibi_test.gd:88")
  elif h.gizli_egilim.yakalanma:
   _dene(izler.size() == 1 and izler[0].goruldu and izler[0].kayip == 0 and t.kaynaklar.miktar("gida") == gida, "casus_gece_takibi_test.gd:90")
   bulundu = true
  else:
   _dene(izler.size() == 1 and not izler[0].goruldu and izler[0].kayip == gida - t.kaynaklar.miktar("gida") and CasusGeceTakibi.acik_izler(t).is_empty(), "casus_gece_takibi_test.gd:93")
   gorulmedi = true
 print("Yakalandı:",bulundu," görülmedi:",gorulmedi)
 _dene(bulundu and gorulmedi, "casus_gece_takibi_test.gd:96")
 print("CASUS GECE TAKİBİ: GEÇTİ" if _hata == 0 else "CASUS GECE TAKİBİ: KALDI (%d hata)" % _hata)
 quit(1 if _hata > 0 else 0)
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 # YAP: oyundaki gibi önce yapı bilgisi, 2. kademe için hazır bir 1. kademe yapı.
 if YapiKilidi.durum(y, tur).neden == "yapi_bilgisi":
  var usta: Koylu = y.koylular[0] if not y.koylular.is_empty() else y.kabul({"ad": "Kurulum bilgisi", "sinif": "ciftci", "stat": 8})
  preload("res://src/koy/yapi_bilgisi.gd").ekle(usta, PackedStringArray([tur]))
 if YapiKilidi.durum(y, tur).neden == "yapi_on_kademe":
  kur(y, "kulube")
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 _dene(false, "Yer bulunamadı: " + tur)
 return null

func normal(v: Dictionary) -> Variant:
 return JSON.parse_string(JSON.stringify(v))


func _dene(kosul: bool, ad: String) -> void:
 if not kosul:
  _hata += 1
  push_error(ad)
