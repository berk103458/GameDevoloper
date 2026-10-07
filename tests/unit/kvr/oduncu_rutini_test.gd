extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 73).yonetim
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 var b := KoyBinasi.new()
 b.id = 900
 b.tur = "odunluk"
 y.binalar.append(b)
 k.is_yeri = b.id
 dene(not OduncuRutini.aday(y, k, &"gunduz"), "Hızarsız sahte teslim yok")
 var hz := KoyBinasi.new()
 hz.id = 901
 hz.tur = "hizarhane"
 y.binalar.append(hz)
 dene(OduncuRutini.aday(y, k, &"gunduz"), "Hazır orman kampı ve hızar")
 dene(not OduncuRutini.aday(y, k, &"gece"), "Gece tomruk döngüsü durur")
 hz.insa_kalan = 1
 dene(not OduncuRutini.aday(y, k, &"gunduz"), "İnşaat halindeki hızara teslim yok")
 hz.insa_kalan = 0
 dene(not OduncuRutini.okuz_ver(y, k.id), "Sahip olunmayan öküz gösterilmez")
 y.lojistik.hayvanlar.okuz = 1
 dene(not OduncuRutini.okuz_ver(y, k.id), "Ahırsız öküz görevlendirilmez")
 var a := KoyBinasi.new()
 a.id = 902
 a.tur = "ahir"
 y.binalar.append(a)
 dene(OduncuRutini.okuz_ver(y, k.id), "Kayıtlı öküz ve hazır ahır")
 var k2 := y.kabul({"sinif": "ciftci", "stat": 5})
 k2.is_yeri = b.id
 dene(not OduncuRutini.okuz_ver(y, k2.id), "Tek öküz iki çalışana çoğaltılmaz")
 var once := y.kaydet()
 var rng := y._rng.state
 OduncuRutini.okuz_ver(y, k.id)
 dene(y.kaydet() == once and y._rng.state == rng, "Görsel sahiplik salt okunur")
 print("ODUNCU RUTİNİ: GEÇTİ" if hata == 0 else "ODUNCU RUTİNİ: KALDI")
 quit(hata)
