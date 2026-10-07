extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 74).yonetim
 var b := KoyBinasi.new()
 b.id = 900
 b.tur = "degirmen"
 b.recete = "un"
 y.binalar.append(b)
 dene(not DegirmenHareketi.aktif(y, b.id, &"gunduz"), "Çalışansız çark durur")
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 k.zanaat_turu = ZanaatTuru.Tur.DEGIRMENCI
 k.is_yeri = b.id
 dene(not DegirmenHareketi.aktif(y, b.id, &"gunduz"), "Buğdaysız çark durur")
 y.kaynaklar.ekle("bugday", 2)
 var once := y.kaydet()
 var rng := y._rng.state
 dene(DegirmenHareketi.aktif(y, b.id, &"gunduz"), "Gerçek un girdisi ve değirmenci")
 dene(not DegirmenHareketi.aktif(y, b.id, &"gece"), "Gece çark durur")
 dene(y.kaydet() == once and y._rng.state == rng, "Görsel aktiflik üretim yapmaz")
 k.yas_grubu = &"yasli"
 dene(not DegirmenHareketi.aday(y, k, &"gunduz") and not DegirmenHareketi.aktif(y, b.id, &"gunduz"), "Yaşlı danışman çuval taşımaz/çarkı tek başına işletmez")
 k.yas_grubu = &"yetiskin"
 b.insa_kalan = 1
 dene(not DegirmenHareketi.aktif(y, b.id, &"gunduz"), "İnşaat dönmez")
 print("DEĞİRMEN HAREKETİ: GEÇTİ" if hata == 0 else "DEĞİRMEN HAREKETİ: KALDI")
 quit(hata)
