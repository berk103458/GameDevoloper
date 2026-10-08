extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 76).yonetim
 y.gun = 3
 var rng := y._rng.state
 dene(TicaretFiyatlari.al_birim(y, "gida") == 0.5, "İlkbahar taban gıda")
 y.gun = 7
 dene(TicaretFiyatlari.al_birim(y, "gida") == 0.375 and TicaretFiyatlari.carpan(y, "odun") == 0.75, "Yaz yüzde 25 ucuzluk")
 y.gun = 23
 dene(TicaretFiyatlari.al_birim(y, "gida") == 1.5 and TicaretFiyatlari.al_birim(y, "odun") == 1.5, "Kış yakacak/erzak tam üç kat")
 dene(TicaretFiyatlari.al_birim(y, "balta") == 5.0, "Mevsim alet fiyatını etkilemez")
 y.akce = 100
 var miktar := y.kaynaklar.miktar("gida")
 dene(y.kervandan_al("gida", 10) and y.akce == 85 and y.kaynaklar.miktar("gida") == miktar + 10, "Gerçek kamu tahsilatı 10 gıda 15")
 dene(y.kervandan_al("odun", 10) and y.akce == 70, "Kış yakacağı mevcut genel satın alma yolu")
 var para := y.akce
 var sat := y.kervana_sat("odun", 20)
 dene(sat.akce == 15 and y.akce == para + 15, "Kervan satışına aynı mevsim çarpanı")
 para = y.akce
 var tezgah := y.tezgah_sat("gida", 20)
 dene(tezgah.akce == y.a.tezgah_gunluk_azami and y.akce == para + tezgah.akce, "Tezgâh fiyatı mevsimli, günlük limit korunur")
 y.gun = 7
 para = y.akce
 dene(y.kervandan_al("gida", 10) and y.akce == para - 4, "Yaz parti bedeli yukarı yuvarlanır")
 var once := JSON.stringify(y.kaydet())
 dene(not y.kervandan_al("gida", -10) and not y.kervandan_al("gida", 0) and JSON.stringify(y.kaydet()) == once, "Negatif/sıfır alım para yaratmaz")
 for i in 3: TicaretFiyatlari.al_birim(y, "gida")
 dene(JSON.stringify(y.kaydet()) == once and y._rng.state == rng, "Fiyat sorgusu kayıt/RNG değiştirmez")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(TicaretFiyatlari.al_birim(geri, "gida") == TicaretFiyatlari.al_birim(y, "gida"), "Fiyat mevcut gün kaydından korunur")
 IklimDeneyi.yukle(y, {"mevsim": 3, "hava": "normal"})
 dene(TicaretFiyatlari.al_birim(y, "gida") == 1.5, "Mevcut admin mevsim önayarı ortak fiyat yoluna yansır")
 y.husumet.tekfura_gecenler.append("demirci")
 dene(TicaretFiyatlari.al_birim(y, "alet") == 7.5, "Mevcut Tekfur alet ek fiyatı korunur")
 print("TİCARET FİYATLARI: GEÇTİ" if hata == 0 else "TİCARET FİYATLARI: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
