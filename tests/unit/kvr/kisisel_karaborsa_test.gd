extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.gun = 15
 y.akce = 1000
 var once := JSON.stringify(o.kaydet())
 dene(not KaraborsaAdaptoru.al(o, "yasak_muhur") and JSON.stringify(o.kaydet()) == once, "Kamu parası kişisel mal satın alamaz")
 o.muhafiz_akce = 100
 var stok := y.kaynaklar.kaydet()
 var rng := y._rng.state
 for id in KaraborsaAdaptoru.AYAR:
  var para := o.muhafiz_akce
  dene(KaraborsaAdaptoru.al(o, id) and o.muhafiz_akce == para - int(KaraborsaAdaptoru.AYAR[id].fiyat), "Yalnız kişisel tahsilat")
 dene(y.akce == 1000 and y.kaynaklar.kaydet() == stok and y._rng.state == rng, "Kamu/ambar/RNG korunur")
 dene(o.muhafiz_esyalari.size() == 2 and KaraborsaAdaptoru.kalan(o, "yasak_muhur") == 0, "Tek mevcut oda envanteri ve ziyaret stoğu")
 once = JSON.stringify(o.kaydet())
 dene(not KaraborsaAdaptoru.al(o, "yasak_muhur") and not KaraborsaAdaptoru.al(o, "bilinmeyen") and JSON.stringify(o.kaydet()) == once, "Tükenen/bilinmeyen alım atomik")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(KaraborsaAdaptoru.kalan(geri, "yasak_muhur") == 0 and geri.muhafiz_esyalari == o.muhafiz_esyalari, "Kayıt kişi eşyası ve ziyaret makbuzunu korur")
 y.gun = 16
 dene(KaraborsaAdaptoru.kalan(o, "yasak_muhur") == 0, "İkinci gün stoğu yenilemez")
 y.gun = 31
 dene(KaraborsaAdaptoru.al(o, "yasak_muhur") and o.muhafiz_esyalari.size() == 2 and o.muhafiz_esyalari[0].adet == 2, "Sonraki ziyaret aynı envanter satırını arttırır")
 y.tuccar_cezasi.silah_tuccari = {"borc": 1, "donus": 0, "son_faiz": 32}
 dene(not KaraborsaAdaptoru.al(o, "kacak_iksir"), "Tüccar ambargosu kişisel alımı da kapatır")
 y.gun = 3
 dene(not KaraborsaAdaptoru.al(o, "kacak_iksir"), "Başka uzman kaçak mal satmaz")
 print("KİŞİSEL KARABORSA: GEÇTİ" if hata == 0 else "KİŞİSEL KARABORSA: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
