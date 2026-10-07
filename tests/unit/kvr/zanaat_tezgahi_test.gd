extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 78).yonetim
 var b := KoyBinasi.new()
 b.id = 901
 b.tur = "demirhane"
 b.recete = "alet"
 y.binalar.append(b)
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 k.is_yeri = b.id
 k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
 dene(ZanaatTezgahi.aday(y, k, &"gunduz"), "Hazır demirhane çalışanı")
 dene(not ZanaatTezgahi.aktif(y, k), "Girdisiz örs hareketi kapalı")
 y.kaynaklar.ekle("demir", 4)
 y.kaynaklar.ekle("kereste", 4)
 var once := y.kaydet()
 var rng := y._rng.state
 dene(ZanaatTezgahi.aktif(y, k), "Gerçek alet girdileri")
 dene(not ZanaatTezgahi.aday(y, k, &"gece"), "Gece zanaat durur")
 dene(y.kaydet() == once and y._rng.state == rng, "Görsel zanaat üretim/RNG değiştirmez")
 k.yas_grubu = &"yasli"
 dene(not ZanaatTezgahi.aday(y, k, &"gunduz"), "Fiziksel çalışmayan danışman çekiç sallamaz")
 k.yas_grubu = &"yetiskin"
 b.insa_kalan = 1
 dene(not ZanaatTezgahi.aday(y, k, &"gunduz"), "İnşaatta tezgâh yok")
 dene(ZanaatTezgahi.kol(-1, 0, &"dov")[0] != ZanaatTezgahi.kol(-1, 1, &"dov")[0], "Çekiç döngü hareketi")
 print("ZANAAT TEZGÂHI: GEÇTİ" if hata == 0 else "ZANAAT TEZGÂHI: KALDI")
 quit(hata)
