extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kayit := {}
 for id in range(1, 10):
  var p := KarakterBeklemeCesitliligi.profil(id)
  dene(p.ofset >= 0.1 and p.ofset <= 1.5, "Idle faz farkı 0.1–1.5 saniye")
  dene(p.varyant == posmod(id, 3) and p == KarakterBeklemeCesitliligi.profil(id), "Üç kararlı varyant")
  kayit[p.ofset] = true
 dene(kayit.size() == 9, "İlk dokuz kişinin fazı aynı değil")
 var a := KarakterBeklemeCesitliligi.acilar(1.0, 1.0, 0)
 var b := KarakterBeklemeCesitliligi.acilar(1.0, 1.0, 1)
 var c := KarakterBeklemeCesitliligi.acilar(1.0, 1.0, 2)
 dene(a != b and b != c and a != c, "Üç varyant farklı gövde/kalça/baş hareketi")
 dene(KarakterBeklemeCesitliligi.acilar(1.0, 0.0, 2) == Vector3.ZERO, "Yürüyüşte idle etkisi kapanır")
 var normal := KarakterBeklemeCesitliligi.acilar(1.0, 1.0, -1)
 dene(is_equal_approx(normal.x, sin(TAU / 3.6) * deg_to_rad(1.6)), "Atanmayan kapı modeli eski idle profilini korur")
 var f := KarakterModel.new()
 KarakterBeklemeCesitliligi.uygula(f, 1)
 dene(f.duzeltici() == null, "İskeletsiz fallback'a modifier uydurulmaz")
 f.free()
 print("BEKLEME ÇEŞİTLİLİĞİ: GEÇTİ" if hata == 0 else "BEKLEME ÇEŞİTLİLİĞİ: KALDI")
 quit(hata)
