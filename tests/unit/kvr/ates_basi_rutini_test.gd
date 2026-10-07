extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 77).yonetim
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 var once := y.kaydet()
 var rng := y._rng.state
 dene(AtesBasiRutini.aday(y, k, &"aksam") and AtesBasiRutini.aday(y, k, &"gece"), "Boşta köylü akşam/gece ısınır")
 dene(not AtesBasiRutini.aday(y, k, &"gunduz"), "Gündüz günlük rutin korunur")
 k.is_yeri = KoyYonetimi.MUHAFIZ
 dene(not AtesBasiRutini.aday(y, k, &"gece"), "Nöbetçi ateş ritüeline alınmaz")
 k.is_yeri = 900
 dene(not AtesBasiRutini.aday(y, k, &"gece"), "Atanmış işçi gece ev rutininde kalır")
 k.is_yeri = KoyYonetimi.BOSTA
 dene(y.kaydet() == once and y._rng.state == rng, "Görsel adaylık kayıt ve RNG değiştirmez")
 var a := AtesBasiRutini.kol(1, 0)
 var b := AtesBasiRutini.kol(-1, 1)
 dene(a[1].z > 0.5 and b[1].z > 0.5 and a[0].x > 0 and b[0].x < 0, "İki el önde, kollar doğal yanlarında")
 print("ATEŞ BAŞI: GEÇTİ" if hata == 0 else "ATEŞ BAŞI: KALDI")
 quit(hata)
