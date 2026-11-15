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
 # SOY-36: "kervan_gelmeyecek" kamuoyu olunca pazar fiyat çarpanı bir gün +%10; ertesi gün düzelir.
 var so := Oturum.new(kat, 9136)
 var sy := so.yonetim
 sy.kaynaklar = Kaynaklar.new(10000, {"gida": 2000, "odun": 200})
 sy.gun = 1
 so.gun = 1
 for i in 6:
  sy.kabul({"sinif": "ciftci"})
 var s_ag := SoylentiKoprusu.ag(so) as SoylentiAgi
 var s_ek := s_ag.soylenti_ekle("kervan_9136", "kervan_gelmeyecek", str(sy.koylular[0].id), false, {"gece": sy.gun})
 dene(bool(s_ek.get("olur", false)), "Kervan söylentisi ağa girer")
 so.gece_sonu()
 dene(bool(s_ag.ag_kayitlari["kervan_9136"].get("kamuoyu_oldu", false)), "Kervan söylentisi gerçek gece_sonu ile kamuoyu olur")
 dene(is_equal_approx(TicaretFiyatlari.carpan(sy, "gida"), 1.1) and is_equal_approx(TicaretFiyatlari.al_birim(sy, "gida"), 0.55), "SOY-36: kamuoyu gününde pazar çarpanı +10%")
 var so_geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(so.kaydet())))
 dene(is_equal_approx(TicaretFiyatlari.carpan(so_geri.yonetim, "gida"), 1.1), "SOY-36: pazar çarpanı kayıttan korunur")
 so.gece_sonu()
 dene(is_equal_approx(TicaretFiyatlari.carpan(sy, "gida"), 1.0) and is_equal_approx(TicaretFiyatlari.al_birim(sy, "gida"), 0.5), "SOY-36: yanlış söylenti ertesi gün düzelir")
 print("TİCARET FİYATLARI: GEÇTİ" if hata == 0 else "TİCARET FİYATLARI: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
