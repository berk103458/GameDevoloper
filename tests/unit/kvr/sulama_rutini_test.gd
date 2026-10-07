extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 72).yonetim
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 var b := KoyBinasi.new()
 b.id = 999
 b.tur = "tarla"
 b.hucre = Vector2i(3, 3)
 y.binalar.append(b)
 k.is_yeri = b.id
 dene(SulamaRutini.aday(y, k, &"gunduz"), "Hazır tarla çalışanı")
 dene(not SulamaRutini.aday(y, k, &"gece"), "Gece sulama yok")
 b.insa_kalan = 1
 dene(not SulamaRutini.aday(y, k, &"gunduz"), "İnşaat sulanmaz")
 b.insa_kalan = 0
 var gun := y.gun
 while y.mevsim() != 3: y.gun += 1
 dene(not SulamaRutini.aday(y, k, &"gunduz"), "Kışın duran tarla sulanmaz")
 y.gun = gun
 b.tur = "bostan"
 dene(SulamaRutini.aday(y, k, &"gunduz"), "Bostancı aynı döngü")
 k.is_yeri = KoyYonetimi.MUHAFIZ
 dene(not SulamaRutini.aday(y, k, &"gunduz"), "Başka görev sulamaz")
 print("SULAMA RUTİNİ: GEÇTİ" if hata == 0 else "SULAMA RUTİNİ: KALDI")
 quit(hata)
