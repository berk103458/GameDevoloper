extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 dene(GezginTuccarStogu.ad("koy.kaynak.kece") == "Keçe" and GezginTuccarStogu.ad("koy.kaynak.sargi") == "Sargı" and GezginTuccarStogu.ad("koy.kaynak.civi") == "Çivi", "UTF-8 ürün adları korunur")
 y.a = y.a.duplicate(true)
 y.a.ambar_taban_kapasite = 10000
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 y.kaynaklar.ekle("odun", 100)
 y.kaynaklar.ekle("tas", 100)
 y.kaynaklar.ekle("kereste", 100)
 var sif := _kur(y, "sifahane")
 var cerrah := y.kabul({"sinif": "ciftci", "stat": 5})
 cerrah.zanaat_turu = ZanaatTuru.Tur.CERRAH
 cerrah.moral = 50
 dene(y.ata(cerrah.id, sif.id), "Gerçek şifahane cerrahı")
 var hasta := y.kabul({"sinif": "ciftci", "stat": 5})
 hasta.saglik = 40
 hasta.zanaat_kazasi = {"tur": "yanik", "kalan": 1, "son_gece": 0, "tedavi": true}
 y.gun = 11
 for t in ["afyon", "sargi", "kece", "kumas"]: dene(y.gezgin_ticaret.al(y, t, 1), "Aktar gerçek uzman malzemesi satar")
 y.kaynaklar.ekle("gida", 100)
 var olaylar: Array[Dictionary] = []
 var rng := y._rng.state
 ZanaatKazalari.gece(y, olaylar)
 dene(hasta.saglik == 65 and hasta.zanaat_kazasi.is_empty(), "Mevcut gerçek tedavi +20 ve çift malzeme +5")
 dene(y.kaynaklar.miktar("afyon") == 0 and y.kaynaklar.miktar("sargi") == 0 and olaylar.any(func(d: Dictionary) -> bool: return d.anahtar.contains("afyon")), "İki malzeme tek sefer tüketilir ve raporlanır")
 dene(y._rng.state == rng, "Tedavi ek RNG tüketmez")
 y.kaynaklar.ekle("afyon", 1)
 dene(not KumasAktarDestegi.tedavi(y, hasta, olaylar) and y.kaynaklar.miktar("afyon") == 1, "Eksik çift malzemede kısmi tüketim yok")
 cerrah.refah = 70
 hasta.refah = 40
 var para := y.akce
 dene(KumasAktarDestegi.dagit(y, "kece") == 1 and hasta.refah == 43 and cerrah.refah == 70, "Sınırlı lüks düşük Refah kişisine gider")
 dene(KumasAktarDestegi.dagit(y, "kumas") == 1 and hasta.refah == 48 and y.akce == para and y._rng.state == rng, "Kumaş gerçek Refah statını artırır; kasa/RNG değişmez")
 hasta.refah = 100
 cerrah.refah = 100
 y.kaynaklar.ekle("kumas", 1)
 dene(KumasAktarDestegi.dagit(y, "kumas") == 0 and y.kaynaklar.miktar("kumas") == 1, "Tam Refah boşuna ürün tüketmez")
 dene(KumasAktarDestegi.dagit(y, "bilinmeyen") == 0, "Bilinmeyen dağıtım reddedilir")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(JSON.parse_string(JSON.stringify(geri.kaydet())) == JSON.parse_string(JSON.stringify(y.kaydet())), "Malzeme, uzman stoğu, sağlık ve Refah birebir kayıt dönüşü")
 print("KUMAŞ AKTAR: GEÇTİ" if hata == 0 else "KUMAŞ AKTAR: KALDI")
 quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 return null
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
