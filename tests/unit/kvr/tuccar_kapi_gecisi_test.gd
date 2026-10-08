extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 o.yonetim.gun = 3
 var liste: Array[Gelen] = []
 var kisi := Gelen.new()
 liste.append(kisi)
 TuccarKapiGecisi.ekle(o, liste)
 dene(liste.size() == 2 and liste[1] == kisi and TuccarKapiGecisi.ilgilenir(liste[0]), "Kuyruk kalan ziyaretçiyi korur")
 var g := liste[0]
 TuccarKapiGecisi.ekle(o, liste)
 dene(liste.size() == 2, "Aynı kuyruk adaptörü tüccarı çoğaltmaz")
 dene(not o.yonetim.kervan_gunu() and not CelepHamdullah.geldi(o.yonetim), "Kapı beklerken aynı ziyaret pazar kapalı")
 var para := o.koy_akce
 var kisi_sayisi := o.yonetim.nufus()
 var rng := o.yonetim._rng.state
 var s := o.karar_ver(g, &"harc")
 dene(s.kaldi and o.koy_akce == para + int(TuccarKapiGecisi.AYAR.bac) and o.muhafiz_akce == 0, "Resmi bac kamuya")
 dene(o.yonetim.nufus() == kisi_sayisi and o.yonetim._rng.state == rng and o.yonetim.kervan_gunu(), "Tüccar nüfus/RNG yaratmadan pazara geçer")
 var once := JSON.stringify(o.kaydet())
 dene(o.karar_ver(g, &"rusvet").engellendi and JSON.stringify(o.kaydet()) == once, "Çift karar tahsilatı yok")
 var geri := Oturum.kayittan(kat, JSON.parse_string(once))
 liste.clear()
 TuccarKapiGecisi.ekle(geri, liste)
 dene(liste.is_empty() and geri.yonetim.kervan_gunu(), "Resmi kayıt ikinci konaklama ve yüklemede korunur")
 o = Oturum.new(kat, 76)
 o.yonetim.gun = 7
 liste.clear()
 TuccarKapiGecisi.ekle(o, liste)
 g = liste[0]
 para = o.koy_akce
 s = o.karar_ver(g, &"rusvet")
 dene(o.koy_akce == para and o.muhafiz_akce == int(TuccarKapiGecisi.AYAR.rusvet) and s.kaldi and o.yonetim.kervan_gunu(), "Hızlı giriş yalnız kişisel gelir ve anında uzman pazarı")
 dene(o.yonetim.adalet == 65 and o.yonetim.asayis_riski == 15, "Rüşvet toplumsal bedeli")
 o = Oturum.new(kat, 76)
 o.yonetim.gun = 15
 liste.clear()
 TuccarKapiGecisi.ekle(o, liste)
 s = o.karar_ver(liste[0], &"ret")
 dene(not s.kaldi and GezginTuccarStogu.urunler(o.yonetim).is_empty() and not KaraborsaAdaptoru.geldi(o), "Ret genel/uzman/kişisel ticareti kapatır")
 o.yonetim.gun = 16
 liste.clear()
 TuccarKapiGecisi.ekle(o, liste)
 dene(liste.is_empty() and not o.yonetim.kervan_gunu(), "İkinci konaklamada ret geri alınmaz")
 o.yonetim.gun = 31
 TuccarKapiGecisi.ekle(o, liste)
 dene(liste.size() == 1, "Sonraki ziyaret yeni kapı kararı")
 var bekleyen := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 liste.clear()
 TuccarKapiGecisi.ekle(bekleyen, liste)
 dene(liste.size() == 1 and bekleyen.karar_ver(liste[0], &"harc").kaldi, "Bekleyen kayıt kapı ziyaretini tekrar kurabilir")
 var gercek := Oturum.new(kat, 76)
 gercek.yonetim.gun = 3
 var kuyruk := gercek.gece_kuyrugu()
 dene(kuyruk.size() > 1 and TuccarKapiGecisi.ilgilenir(kuyruk[0]), "Gerçek kapı kuyruğu ince adaptörü çağırır")
 dene(SiparisSozlesmeleri.teklif(gercek.yonetim).is_empty(), "Bekleyen kapıda sözleşme kapalı")
 var sahte := Gelen.new()
 sahte.set_meta(&"gezgin_kapi_varis", -1)
 sahte.set_meta(&"gezgin_kapi_id", "nalbur")
 var ham := JSON.stringify(gercek.kaydet())
 dene(gercek.karar_ver(sahte, &"harc").engellendi and JSON.stringify(gercek.kaydet()) == ham, "Eski/sahte ziyaret değişiklik yapamaz")
 dene(TuccarKapiGecisi.oku({}).is_empty(), "Eski kayıtta alan isteğe bağlı")
 print("TÜCCAR KAPI GEÇİŞİ: GEÇTİ" if hata == 0 else "TÜCCAR KAPI GEÇİŞİ: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
