extends SceneTree
var hata := 0
func _initialize() -> void:
 dene(AtolyeParcaciklari.katsayi(0, 1) == 1, "Yakın tam bütçe")
 dene(AtolyeParcaciklari.katsayi(40, 1) == 0.5, "Orta uzaklık yarım bütçe")
 dene(AtolyeParcaciklari.katsayi(30, 1) == 1, "Yakın eşik tam bütçe")
 dene(AtolyeParcaciklari.katsayi(65, 1) == 0, "Uzak eşikte kapalı")
 dene(AtolyeParcaciklari.katsayi(100, 1) == 0, "Uzakta emisyon kapalı")
 dene(AtolyeParcaciklari.katsayi(0, 0) == 0, "Düşük profil katmanı kapalıysa emisyon yok")
 print("ATÖLYE PARÇACIKLARI: GEÇTİ" if hata == 0 else "ATÖLYE PARÇACIKLARI: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
