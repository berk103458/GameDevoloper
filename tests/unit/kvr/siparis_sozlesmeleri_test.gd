extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 dene(not y.siparisler.kabul(y), "Tüccar yokken teklif kabul edilemez")
 y.gun = 3
 var once := JSON.stringify(y.kaydet())
 var t := SiparisSozlesmeleri.teklif(y)
 dene(t.adet == 12 and t.urun == "un" and JSON.stringify(y.kaydet()) == once, "Saf haftaya un teklifi")
 t.adet = 1
 dene(SiparisSozlesmeleri.teklif(y).adet == 12, "Teklif çıktısı kaynak dengeyi değiştiremez")
 var rng := y._rng.state
 var kasa := y.akce
 var stok := y.kaynaklar.kaydet()
 dene(y.siparisler.kabul(y), "İlk konaklama günü gerçek kabul")
 var s: Dictionary = y.siparisler.sozlesmeler.values()[0]
 dene(s.vade == 11 and s.kabul_gunu == 4 and s.adet == 12, "Kabul gününden yedi gün vade")
 dene(y.akce == kasa and y._rng.state == rng and y.kaynaklar.kaydet() == stok, "Kabul stok/kasa/RNG harcamaz")
 y.gun = 4
 dene(not y.siparisler.kabul(y), "İkinci konaklama gününde aynı teklif tekrarlanmaz")
 dene(SiparisSozlesmeleri.kayittan(y.siparisler.kaydet()).kaydet() == y.siparisler.kaydet(), "Kabul şartları ve geçmiş kayıttan döner")
 for gun in [7, 11]:
  y.gun = gun
  dene(y.siparisler.kabul(y), "Farklı uzman teklifi kabul edilir")
 y.gun = 15
 dene(not y.siparisler.kabul(y) and y.siparisler.aktif_sayisi() == 3, "Üç açık sözleşme sınırı")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(geri.siparisler.kaydet() == y.siparisler.kaydet() and not geri.siparisler.kabul(y), "Ana kayıt açık defteri ve kabul sınırını korur")
 var eski := y.kaydet()
 eski.erase("siparisler")
 dene(KoyYonetimi.kayittan(y.a, y.katalog, eski).siparisler.aktif_sayisi() == 0, "Eski kayıtta defter boş")
 var bozuk := s.duplicate(true)
 bozuk.adet = -1
 dene(SiparisSozlesmeleri.kayittan({s.id: bozuk}).sozlesmeler.is_empty(), "Bozuk miktar reddedilir")
 print("SİPARİŞ SÖZLEŞMELERİ: GEÇTİ" if hata == 0 else "SİPARİŞ SÖZLEŞMELERİ: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
