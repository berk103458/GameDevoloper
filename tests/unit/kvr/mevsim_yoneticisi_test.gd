extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 dene(y.a.mevsim_gun == 7, "Festive denge yedi gün")
 for gun in [0, 6, 7, 13, 14, 20, 21, 27, 28, 55, 56]:
  y.gun = gun
  var once := JSON.stringify(o.kaydet())
  var d := MevsimYoneticisi.durum(y)
  dene(d.mevsim == (gun / 7) % 4 and d.mevsim_gunu == gun % 7 + 1 and d.yil_gunu == gun % 28 + 1 and d.yil == gun / 28 + 1 and d.yil_uzunlugu == 28, "Mevsim/yıl sınırı: " + str(gun))
  dene(Takvim.mevsim(gun, 7) == d.mevsim and Takvim.yil_gunu(gun, 7) == d.yil_gunu and JSON.stringify(o.kaydet()) == once, "Eski API ve salt okunur durum")
 y.gun = 28
 IklimDeneyi.degistir(o, 3, "kar_firtinasi")
 var d := MevsimYoneticisi.durum(y)
 dene(d.yil == 2 and d.yil_gunu == 1 and d.mevsim == 3 and d.takvim_mevsimi == 0 and d.zorlanmis and d.hava == "kar_firtinasi", "Admin iklimi takvim saatini ezmez")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(MevsimYoneticisi.durum(geri.yonetim) == d, "Takvim ve iklim kayıt dönüşünde aynı")
 dene(Takvim.hafta_basi(7, 7) and not Takvim.hafta_basi(0, 7) and not Takvim.hafta_basi(6, 7), "Vergi hafta API'si korunur")
 dene(Takvim.mevsim(-1, 0) == 0 and Takvim.mevsim_gunu(-1, 0) == 1 and Takvim.yil_gunu(-1, -7) == 1, "Bozuk süre/gün güvenli başlangıç")
 dene(Takvim.mevsim(5, 5) == 1 and Takvim.yil_gunu(20, 5) == 1, "Özel denge süresi geriye uyumlu")
 print("MEVSİM YÖNETİCİSİ: GEÇTİ" if hata == 0 else "MEVSİM YÖNETİCİSİ: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
