extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 22)
 var y := o.yonetim
 var son := 0.0
 for gun in range(21, 28):
  y.gun = gun
  var once := JSON.stringify(o.kaydet())
  var kar := MevsimKarOrtusu.oran(y)
  dene(kar > son and kar <= 0.85 and JSON.stringify(o.kaydet()) == once, "Günlük kademeli örtü salt okunur")
  son = kar
 y.gun = 21
 dene(is_equal_approx(MevsimKarOrtusu.oran(y), 0.15), "İlk kış günü ince örtü")
 y.gun = 28
 dene(is_zero_approx(MevsimKarOrtusu.oran(y)), "Bahar örtüyü kaldırır")
 IklimDeneyi.degistir(o, 1, "kar_firtinasi")
 dene(is_equal_approx(MevsimKarOrtusu.oran(y), 0.85), "Admin fırtına eski örtü yoğunluğunu korur")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(MevsimKarOrtusu.oran(geri.yonetim) == MevsimKarOrtusu.oran(y), "Kayıt dönüşü aynı örtü")
 print("MEVSİM KAR ÖRTÜSÜ: GEÇTİ" if hata == 0 else "MEVSİM KAR ÖRTÜSÜ: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
