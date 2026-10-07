extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 79)
 var y := o.yonetim
 dene(KarakterHavaTepkisi.hiz(y) == 1.0 and KarakterHavaTepkisi.egim(y) == 0.0, "Normal yürüyüş korunur")
 dene(IklimDeneyi.degistir(o, 0, "yagmur").ok, "Mevcut iklim sözleşmesinde yağmur")
 dene(KarakterHavaTepkisi.yagmur(y) and not y.kis_mi(), "Yağmur kar değildir")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(IklimDeneyi.hava(geri.yonetim) == "yagmur", "Yağmur mevcut kayıt formatında korunur")
 IklimDeneyi.degistir(o, 0, "kar_firtinasi")
 var once := y.kaydet()
 var rng := y._rng.state
 dene(KarakterHavaTepkisi.hiz(y) < 1 and KarakterHavaTepkisi.hiz(y) > 0 and KarakterHavaTepkisi.egim(y) > 0, "Karda yavaş/büzülmüş yürüyüş")
 dene(y.kaydet() == once and y._rng.state == rng, "Görsel hava gözlemi kayıt/RNG değiştirmez")
 IklimDeneyi.degistir(o, 3, "normal")
 dene(KarakterHavaTepkisi.hiz(y) == 1.0, "Kar yağışı olmadan kış yürüyüşünü yavaşlatmaz")
 print("KARAKTER HAVA: GEÇTİ" if hata == 0 else "KARAKTER HAVA: KALDI")
 quit(hata)
