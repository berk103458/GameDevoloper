extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.gun = 3
 y.kaynaklar.ekle("kereste", 10)
 var stok := y.kaynaklar.miktar("kereste")
 var kasa := y.akce
 var rng := y._rng.state
 var teklif := PazarSatisi.onizle(y, "kereste", 5, true)
 var r := PazarSatisi.uygula(o, "kereste", 5, true, false)
 dene(r == teklif and y.akce == kasa + 5 and o.muhafiz_akce == 0 and y.kaynaklar.miktar("kereste") == stok - 5, "Kamu satışına eski yol")
 kasa = y.akce
 r = PazarSatisi.uygula(o, "kereste", 5, true, true)
 dene(r.akce == 5 and y.akce == kasa and o.muhafiz_akce == 5 and o.kasa_transferleri.zimmet_toplam == 5, "Kişisel satış mevcut zimmet defterine; kamu para yaratmaz")
 dene(y.adalet == 65 and y.asayis_riski == 15, "Mevcut zimmet sosyal bedeli aynıdır")
 var once := JSON.stringify(o.kaydet())
 dene(PazarSatisi.uygula(o, "odun", 20, true, true).akce == 0 and JSON.stringify(o.kaydet()) == once, "Aynı gün ikinci kişisel satış atomik engellenir")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(not PazarSatisi.uygun(geri, "odun", 20, true, true), "Kayıt sonrası günlük zimmet sınırı korunur")
 y.gun = 4
 y.akce = 0
 r = PazarSatisi.uygula(o, "odun", 20, true, true)
 dene(r.akce == 5 and y.akce == 0 and o.muhafiz_akce == 10, "Sıfır kamu kasası satış gelirini kişisele yönlendirebilir")
 y.gun = 5
 once = JSON.stringify(o.kaydet())
 dene(not PazarSatisi.uygun(o, "gida", 20, true, false) and PazarSatisi.uygula(o, "gida", -5, false, true).akce == 0 and JSON.stringify(o.kaydet()) == once, "Kervansız/negatif satış durumu değiştirmez")
 dene(y._rng.state == rng, "Satış yönü RNG kullanmaz")
 # Önizleme, mevcut gerçek satış yolu ile mevsim/miktar/kanal sınırlarında eşleşir.
 for gun in [3, 7, 23]:
  for kervan in [true, false]:
   for tur in ["gida", "odun", "kereste"]:
    var a := Oturum.new(kat, 76).yonetim
    a.gun = gun
    var q := PazarSatisi.onizle(a, tur, 20, kervan)
    var gercek := a.kervana_sat(tur, 20) if kervan else a.tezgah_sat(tur, 20)
    dene(q == gercek, "Önizleme gerçek satışın mevsim/stok/günlük sınırıyla eşleşir")
 print("PAZAR SATIŞI: GEÇTİ" if hata == 0 else "PAZAR SATIŞI: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
