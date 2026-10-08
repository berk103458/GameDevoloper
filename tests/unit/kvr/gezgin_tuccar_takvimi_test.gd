extends SceneTree
var hata := 0
func _initialize() -> void:
 var a := load("res://data/ayarlar/koy.tres") as KoyAyarlari
 dene(a.kervan_araligi == 4, "Ana oyun ayarında dört günlük varış")
 for gun in 32:
  var d := GezginTuccarTakvimi.durum(gun, a.kervan_araligi)
  var aktif := gun >= 3 and posmod(gun - 3, 4) < 2
  dene(d.aktif == aktif, "Dört gün / iki gün konaklama sınırları")
  dene(d.sonraki_gun > gun + 1, "Sonraki varış her zaman ileride")
  if d.aktif: dene(d.kalan in [1, 2], "Konaklamada kalan süre 1–2 gün")
 var ids := {}
 for gun in [3, 7, 11, 15]: ids[GezginTuccarTakvimi.durum(gun, 4).tuccar.id] = true
 dene(ids.size() == 4, "Dört uzman sırayla gelir")
 dene(GezginTuccarTakvimi.durum(19, 4).tuccar.id == GezginTuccarTakvimi.durum(3, 4).tuccar.id, "Uzman döngüsü tekrar eder")
 var d := GezginTuccarTakvimi.durum(3, 4)
 d.tuccar.ad = "Değiştirilmiş çıktı"
 dene(GezginTuccarTakvimi.durum(3, 4).tuccar.ad != d.tuccar.ad, "Çıktı kaynak denge sözlüğünü değiştiremez")
 dene(not GezginTuccarTakvimi.durum(5, 4).aktif, "Altıncı oyuncu gününde tüccar ayrılmıştır")
 dene(GezginTuccarTakvimi.durum(0, 4).sonraki_gun == 4, "İlk gün tüccar yok, ilk varış dördüncü gün")
 print("GEZGİN TÜCCAR TAKVİMİ: GEÇTİ" if hata == 0 else "GEZGİN TÜCCAR TAKVİMİ: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
