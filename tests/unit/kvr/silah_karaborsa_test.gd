extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 76).yonetim
 y.akce = 1000
 y.gun = 15
 for t in ["zirh", "yay", "kalkan"]:
  var para := y.akce
  dene(y.gezgin_ticaret.al(y, t, 1), "Silah uzmanından ürün alınır")
  dene(y.kaynaklar.miktar(t) == 1 and y.akce == para - int(GezginTuccarStogu.AYAR.silah_tuccari[t].fiyat), "Tek ambar/kamu kasası")
 var once := JSON.stringify(y.kaydet())
 dene(not SilahKaraborsasi.alinabilir(y) and SilahKaraborsasi.al(y) == null and JSON.stringify(y.kaydet()) == once, "Yataksız teklif atomik reddedilir")
 var b := _kur(y)
 dene(b != null, "Mevcut barınak kurulur")
 var stok := y.kaynaklar.kaydet()
 var para := y.akce
 var rng := y._rng.state
 var k := SilahKaraborsasi.al(y)
 dene(k != null and y.nufus() == 1 and k.ev == b.id and k.bayrak_var("eski_tutsak"), "Tek mevcut kabul ve barındırma yolu")
 dene(y.akce == para - int(SilahKaraborsasi.AYAR.fiyat) and y.kaynaklar.kaydet() == stok and y._rng.state == rng, "Kamu ödeme; kişi ambar ürünü veya RNG değildir")
 once = JSON.stringify(y.kaydet())
 dene(SilahKaraborsasi.al(y) == null and JSON.stringify(y.kaydet()) == once, "Aynı ziyaret teklifinin çift tahsilatı yok")
 y.gun = 16
 dene(not SilahKaraborsasi.alinabilir(y), "İkinci gün aynı teklif tüketilmiştir")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(not SilahKaraborsasi.alinabilir(geri) and geri.koylular[0].bayrak_var("eski_tutsak") and geri.kaynaklar.miktar("zirh") == 1, "Kayıt satın alma ve kişi/ürün geçmişini korur")
 y.gun = 31
 dene(SilahKaraborsasi.alinabilir(y), "Sonraki Silah ziyareti yeni teklif")
 y.akce = 0
 once = JSON.stringify(y.kaydet())
 dene(SilahKaraborsasi.al(y) == null and JSON.stringify(y.kaydet()) == once, "Yetersiz para atomik")
 y.akce = 1000
 y.tuccar_cezasi.silah_tuccari = {"borc": 1, "donus": 0, "son_faiz": 32}
 dene(not SilahKaraborsasi.alinabilir(y) and not y.gezgin_ticaret.al(y, "yay", 1), "İhlal ambargo teklif/silahı kapatır")
 y.gun = 7
 dene(not SilahKaraborsasi.alinabilir(y), "Başka uzman tutsak teklifi sunmaz")
 y.kaynaklar.kapasite = 0
 dene(y.kaynaklar.toplam() == 0, "Üç yeni stok taşma bakımında")
 print("SİLAH KARABORSASI: GEÇTİ" if hata == 0 else "SİLAH KARABORSASI: KALDI")
 quit(hata)
func _kur(y: KoyYonetimi) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim("cadir", h).olur:
    var b := y.bina(y.bina_kur("cadir", h).id)
    b.insa_kalan = 0
    return b
 return null
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
