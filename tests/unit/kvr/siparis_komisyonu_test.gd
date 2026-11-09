extends SceneTree
var hata := 0
var kat := Katalog.new()
func _initialize() -> void:
 kat.yukle()
 var o := hazir()
 var id := String(o.yonetim.siparisler.sozlesmeler.keys()[0])
 var y := o.yonetim
 var once := JSON.stringify(o.kaydet())
 dene(SiparisKomisyonu.onizle(o, id, 10).komisyon == 2 and SiparisKomisyonu.onizle(o, id, 20).komisyon == 4, "Komisyon tam akçeye aşağı yuvarlanır")
 dene(SiparisKomisyonu.onizle(o, id, 15).is_empty() and JSON.stringify(o.kaydet()) == once, "Desteklenmeyen oran ve önizleme değişiklik yapmaz")
 var para := y.akce
 var rng := y._rng.state
 dene(SiparisKomisyonu.teslim(o, id, 20), "Yüzde yirmi tek teslim")
 dene(y.akce == para + 20 and o.muhafiz_akce == 4 and y.kaynaklar.miktar("un") == 0 and y._rng.state == rng, "Ödül korunur, iki kasaya bölünür, tek stok tüketilir")
 dene(y.tuccar_itibari.celep_hamdullah.puan == 10 and y.adalet == 65 and y.asayis_riski == 15 and o.kasa_transferleri.zimmet_toplam == 4, "Mevcut itibar ve zimmet bedeli")
 once = JSON.stringify(o.kaydet())
 dene(not SiparisKomisyonu.teslim(o, id, 10) and JSON.stringify(o.kaydet()) == once, "İkinci teslim/komisyon yok")
 var geri := Oturum.kayittan(kat, JSON.parse_string(once))
 dene(geri.yonetim.siparisler.sozlesmeler[id].komisyon == 4 and geri.yonetim.siparisler.sozlesmeler[id].komisyon_orani == 20 and geri.muhafiz_akce == 4, "Makbuz ve çift kasa yüklenir")
 o = hazir()
 dene(KasaTransferi.uygula(o, "zimmet", 1), "Mevcut günlük zimmet")
 once = JSON.stringify(o.kaydet())
 dene(not SiparisKomisyonu.teslim(o, id, 10) and JSON.stringify(o.kaydet()) == once, "Günlük zimmet başka yoldan atlanmaz")
 dene(SiparisTeslimati.teslim(o.yonetim, id) and not o.yonetim.siparisler.sozlesmeler[id].has("komisyon"), "Normal kamu teslimi korunur")
 o = hazir()
 o.koy_akce = -20
 dene(SiparisKomisyonu.teslim(o, id, 20) and o.koy_akce == 0 and o.muhafiz_akce == 4, "Gerçek tam kamu ödülü ön denetlenir")
 o = hazir()
 o.koy_akce = -23
 once = JSON.stringify(o.kaydet())
 dene(not SiparisKomisyonu.teslim(o, id, 10) and JSON.stringify(o.kaydet()) == once, "Ödül sonrası yetersiz kamu atomik ret")
 o = hazir()
 o.yonetim.kaynaklar.azalt("un", 1)
 once = JSON.stringify(o.kaydet())
 dene(not SiparisKomisyonu.teslim(o, id, 20) and JSON.stringify(o.kaydet()) == once, "Eksik stokta kasalar/defter değişmez")
 o = hazir()
 o.yonetim.siparisler.sozlesmeler[id].odul = 100
 once = JSON.stringify(o.kaydet())
 dene(not SiparisKomisyonu.teslim(o, id, 20) and JSON.stringify(o.kaydet()) == once, "Günlük on akçe üst sınırı")
 o = hazir()
 o.muhafiz_akce = 9223372036854775807
 once = JSON.stringify(o.kaydet())
 dene(not SiparisKomisyonu.teslim(o, id, 10) and JSON.stringify(o.kaydet()) == once, "Kişisel kasa taşma ret")
 var hedef := {"durum": "teslim", "odul": 24}
 SiparisKomisyonu.kayit({"komisyon": 4, "komisyon_orani": 10}, hedef)
 dene(not hedef.has("komisyon"), "Yanlış makbuz yüklenmez")
 print("SİPARİŞ KOMİSYONU: GEÇTİ" if hata == 0 else "SİPARİŞ KOMİSYONU: KALDI")
 quit(hata)
func hazir() -> Oturum:
 var o := Oturum.new(kat, 76)
 o.yonetim.gun = 3
 dene(o.yonetim.siparisler.kabul(o.yonetim), "Sipariş kabul edilir")
 o.yonetim.kaynaklar.ekle("un", 12)
 return o
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
