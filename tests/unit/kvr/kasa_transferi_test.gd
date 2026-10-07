extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 71)
 o.koy_akce = -12
 o.muhafiz_akce = 20
 var k := o.yonetim.kabul({"ad": "Tanık", "stat": 5})
 var moral := k.moral
 var adalet := o.yonetim.adalet
 var asayis := o.yonetim.asayis_riski
 var rng := o.yonetim._rng.state
 var reddedilen := o.kaydet()
 dene(not KasaTransferi.uygula(o, "kurtarma", 13) and o.kaydet() == reddedilen, "Kamu açığından fazla kurtarma reddedilir")
 o.muhafiz_akce = 3
 reddedilen = o.kaydet()
 dene(not KasaTransferi.uygula(o, "kurtarma", 4) and o.kaydet() == reddedilen, "Yetersiz kişisel para atomik")
 o.muhafiz_akce = 20
 dene(KasaTransferi.uygula(o, "kurtarma", 12), "Gerçek kamu açığı kişisel keseden kurtarılır")
 dene(o.koy_akce == 0 and o.muhafiz_akce == 8 and k.moral == moral, "Transfer para yaratmaz; ödül farmı yok")
 var once := o.kaydet()
 for n in [0, -1, 13, 1000000001]:
  dene(not KasaTransferi.uygula(o, "kurtarma", n) and o.kaydet() == once, "Başarısız transfer atomik")
 o.koy_akce = 30
 reddedilen = o.kaydet()
 dene(not KasaTransferi.uygula(o, "zimmet", 11) and o.kaydet() == reddedilen, "Günlük zimmet azami uygulanır")
 dene(KasaTransferi.uygula(o, "zimmet", 5), "Gerçek kamu kasasından zimmet")
 dene(o.koy_akce == 25 and o.muhafiz_akce == 13 and k.moral == moral - 3 and o.yonetim.adalet == maxi(0, adalet - 5) and o.yonetim.asayis_riski == mini(100, asayis + 5), "Gerçek transfer ve sosyal bedel")
 dene(o.yonetim._rng.state == rng, "Transfer RNG tüketmez")
 once = o.kaydet()
 dene(not KasaTransferi.uygula(o, "zimmet", 5) and o.kaydet() == once, "Aynı gün ikinci zimmet yok")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(once)))
 dene(geri.kasa_transferleri == o.kasa_transferleri and not KasaTransferi.uygula(geri, "zimmet", 5), "JSON aynı gün korumasını sürdürür")
 o.gun += 1
 dene(KasaTransferi.uygula(o, "zimmet", 10), "Sonraki gün yeniden mümkündür")
 once = o.kaydet()
 dene(not KasaTransferi.uygula(o, "bilinmeyen", 1) and o.kaydet() == once, "Bilinmeyen işlem atomik")
 var eski := once.duplicate(true)
 eski.erase("kasa_transferleri")
 dene(Oturum.kayittan(kat, eski).kasa_transferleri.kurtarma_toplam == 0, "Eski kayıt varsayılanı")
 dene(KasaTransferi.oku({"son_zimmet": "x", "zimmet_toplam": -8}).son_zimmet == -1, "Bozuk optional kayıt")
 o.gun += 1
 o.muhafiz_akce = 9223372036854775807
 reddedilen = o.kaydet()
 dene(not KasaTransferi.uygula(o, "zimmet", 1) and o.kaydet() == reddedilen, "Hedef kesede sayısal taşma atomik reddedilir")
 o.koy_akce = -9223372036854775807 - 1
 dene(KasaTransferi.kurtarma_adedi(o) == 1000000000, "Aşırı negatif kamu bakiyesinde pazar hesabı taşmaz")
 o.yonetim.son = "tekfur"
 dene(not KasaTransferi.uygula(o, "zimmet", 1), "Biten oyun transfer yapmaz")
 print("KASA TRANSFERİ: GEÇTİ" if hata == 0 else "KASA TRANSFERİ: KALDI")
 quit(hata)
