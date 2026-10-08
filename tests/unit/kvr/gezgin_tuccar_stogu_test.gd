extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 dene(GezginTuccarStogu.kayittan(y.gezgin_ticaret.kaydet()).kaydet() == y.gezgin_ticaret.kaydet(), "Boş stok geçmişi kayıt sonrası tam eşleşir")
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 y.gun = 7
 for t in ["demir", "civi", "tirpan", "balta"]:
  var para := y.akce
  dene(y.gezgin_ticaret.al(y, t, 1), "Nalbur her tanımlı ürünü satar")
  dene(y.kaynaklar.miktar(t) >= 1 and y.akce == para - int(GezginTuccarStogu.AYAR.nalbur[t].fiyat), "Tek ambar ve kamu kasası kullanılır")
 var once := JSON.stringify(y.kaydet())
 for i in 3: y.gezgin_ticaret.kalan(y, "balta")
 dene(JSON.stringify(y.kaydet()) == once, "Stok sorgusu kayıt/RNG değiştirmez")
 dene(y.kervandan_al("demir", 19) and not y.kervandan_al("demir", 1), "Eski demir API'si sınırlı uzman stoğunu aşamaz")
 y.gun = 8
 dene(y.gezgin_ticaret.kalan(y, "demir") == 0, "İkinci konaklama günü stok yenilenmez")
 var yeni := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(yeni.gezgin_ticaret.kalan(yeni, "demir") == 0 and yeni.kaynaklar.miktar("balta") == y.kaynaklar.miktar("balta"), "Stok ve üç yeni kaynak kayıttan döner")
 y.gun = 11
 dene(not y.gezgin_ticaret.al(y, "balta", 1), "Başka uzman Nalbur ürünü satmaz")
 y.gun = 23
 once = JSON.stringify(y.kaydet())
 dene(y.gezgin_ticaret.kalan(y, "demir") == 20 and JSON.stringify(y.kaydet()) == once, "Sonraki Nalbur ziyaretinde saf stok yenilenmesi")
 y.akce = 0
 dene(not y.gezgin_ticaret.al(y, "civi", 1), "Yetersiz kasa")
 y.akce = 1000
 y.kaynaklar.kapasite = y.kaynaklar.toplam()
 dene(not y.gezgin_ticaret.al(y, "civi", 1), "Dolu ambar")
 dene(not y.gezgin_ticaret.al(y, "civi", -1) and not y.gezgin_ticaret.al(y, "civi", 0) and not y.gezgin_ticaret.al(y, "bilinmeyen", 1), "Geçersiz sipariş")
 y.kaynaklar.kapasite = 0
 dene(y.kaynaklar.toplam() == 0, "Yeni türler kapasite düşüşünde taşma bakımına dahildir")
 var bozuk := GezginTuccarStogu.kayittan({"varis": "bozuk", "alinan": {"demir": -1, "balta": 1e100}})
 dene(bozuk.varis == -1 and bozuk.alinan.get("demir", 0) == 0 and bozuk.alinan.balta == 6, "Bozuk alanlar ve büyük sayılar güvenle sınırlandırılır")
 var eski := y.kaydet()
 eski.erase("gezgin_ticaret")
 dene(KoyYonetimi.kayittan(y.a, y.katalog, eski).gezgin_ticaret.varis == -1, "Eski kayıt boş uzman geçmişiyle açılır")
 print("GEZGİN TÜCCAR STOĞU: GEÇTİ" if hata == 0 else "GEZGİN TÜCCAR STOĞU: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
