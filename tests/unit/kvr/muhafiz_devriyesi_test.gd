extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 71).yonetim
 y.izgara.engeller.clear()
 var r := KoyRotasi.new()
 r.kur(y.izgara, 2.5)
 var bas := r.yakin(y.a.meydan.position)
 dene(MuhafizDevriyesi.duraklar(y).size() == 1, "Sur/kışla yoksa yalnız kapı")
 y.sur_seviye = 1
 dene(MuhafizDevriyesi.duraklar(y).size() == 5, "Surda dört kule ve kapı")
 var b := KoyBinasi.new()
 b.id = 900
 b.tur = "muhafiz_kislasi"
 b.hucre = Vector2i(3, 3)
 y.binalar.append(b)
 dene(MuhafizDevriyesi.duraklar(y).size() == 6, "Hazır kışla durağı")
 b.insa_kalan = 1
 dene(MuhafizDevriyesi.duraklar(y).size() == 5, "İnşa halindeki kışla hariç")
 b.insa_kalan = 0
 var once := y.kaydet()
 var rng := y._rng.state
 for i in 6:
  var d := MuhafizDevriyesi.hedef(y, r, bas, i)
  dene(not d.is_empty() and not r.yol(bas, d.son).is_empty(), "Her hedef erişilebilir")
 dene(y.kaydet() == once and y._rng.state == rng, "Devriye salt okunur")
 y.sur_hasar = 100
 dene(MuhafizDevriyesi.duraklar(y).size() == 2, "Yanmış kule devriye dışı")
 for x in y.a.izgara_boyut.x:
  y.izgara.engeller[Vector2i(x, y.a.izgara_boyut.y / 2)] = true
 r.kur(y.izgara, 2.5)
 var d := MuhafizDevriyesi.hedef(y, r, Vector2i.ZERO, 0)
 dene(d.is_empty() or not r.yol(Vector2i.ZERO, d.son).is_empty(), "Kopuk durak atlanır; sahte yol yok")
 print("MUHAFIZ DEVRİYESİ: GEÇTİ" if hata == 0 else "MUHAFIZ DEVRİYESİ: KALDI")
 quit(hata)
