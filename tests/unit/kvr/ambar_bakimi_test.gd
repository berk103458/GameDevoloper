extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _init() -> void:
 var k := Kaynaklar.new(200, {"gida": 100, "tas": 50})
 k.kapasite = 80
 dene(k.toplam() == 80 and k.miktar("gida") == 30 and k.miktar("tas") == 50, "Kapasite azalınca gıda önce gider")
 var bekleyen := Kaynaklar.kayittan(JSON.parse_string(JSON.stringify(k.kaydet())))
 dene(bekleyen.bakim.tasma.get("gida", 0) == 70 and bekleyen.toplam() == 80, "Raporlanmamış kapasite kaybı JSON ile korunur")
 var olaylar: Array[Dictionary] = []
 var z := AmbarBakimi.gece(k, 1, olaylar)
 dene(z.tasma.get("gida", 0) == 70 and k.toplam() <= k.kapasite, "Taşma raporu")
 dene(AmbarBakimi.gece(k, 1, olaylar).is_empty(), "Aynı gece yinelenmez")
 var tekrar := Kaynaklar.kayittan(k.kaydet())
 dene(tekrar.kaydet() == k.kaydet(), "Kesir ve gece JSON turu")
 AmbarBakimi.gece(tekrar, 2, olaylar)
 dene(tekrar.miktar("gida") == 29, "Kesir birikir; ikinci gece bir gıda bozulur")
 dene(tekrar.miktar("tas") == 50, "Taş bozulmaz")
 var eski := Kaynaklar.kayittan({"kapasite": 10, "stok": {"gida": 30, "tas": -1}})
 dene(eski.toplam() == 10 and eski.miktar("tas") == 0, "Eski ve aşırı stoklu kayıt güvenli")
 var bozuk := Kaynaklar.kayittan({"stok": {}, "bakim": {"artik": {"gida": "x"}, "tasma": {"gida": -8}, "son_gece": "x"}})
 dene(bozuk.bakim.son_gece == -1 and bozuk.bakim.artik.is_empty() and bozuk.bakim.tasma.is_empty(), "Bozuk optional geçmiş")
 k.kapasite = -1
 dene(k.kapasite == 0 and k.toplam() == 0, "Negatif kapasite")
 print("AMBAR BAKIMI TEST: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
 quit(hata)
