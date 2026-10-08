extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "gida"]: y.kaynaklar.ekle(t, 100)
 var ahir := _kur(y, "ahir")
 var agil := _kur(y, "agil")
 y.gun = 3
 dene(CelepHamdullah.geldi(y), "Dördüncü oyuncu gününde Celep var")
 dene(y.lojistik.al(y, "beygir") and y.lojistik.al(y, "inek"), "Beygir ve inek aynı ahıra alınır")
 var once := JSON.stringify(y.kaydet())
 dene(not y.lojistik.al(y, "okuz") and JSON.stringify(y.kaydet()) == once, "Dolu ahır işlemi kasayı/kaydı değiştirmez")
 dene(y.lojistik.sayi() == 2 and y.lojistik.sefer(y).kapasite == 9, "Beygir mevcut çeki seferine katılır")
 y.gun = 4
 dene(y.lojistik.al(y, "koc") and y.lojistik.al(y, "koc"), "İkinci konaklama gününde ağıla iki koç")
 dene(y.lojistik.sayi() == 2 and not y.lojistik.al(y, "koc"), "Koç çeki bonusuna katılmaz; ek ağıl yeri sınırlı")
 dene(CelepHamdullah.barindir(y, ahir.id).size() == 2 and CelepHamdullah.barindir(y, agil.id) == ["koc", "koc"], "Türler doğru barınağa atanır")
 var v := JSON.parse_string(JSON.stringify(y.kaydet())) as Dictionary
 var yuklenen := KoyYonetimi.kayittan(y.a, y.katalog, v)
 dene(yuklenen.lojistik.hayvanlar == y.lojistik.hayvanlar, "Dört tür mevcut lojistik kayıt alanında korunur")
 dene(CekiLojistigi.kayittan({"hayvanlar": {"okuz": 1}}).hayvanlar == {"okuz": 1, "inek": 0, "beygir": 0, "koc": 0}, "Eski iki tür kayıt yeni türleri sıfır varsayar")
 y.gun = 7
 dene(y.kervan_gunu() and not CelepHamdullah.geldi(y), "Nalbur genel pazarı açar ama hayvan satmaz")
 y.lojistik = CekiLojistigi.new()
 once = JSON.stringify(y.kaydet())
 dene(not y.lojistik.al(y, "beygir") and JSON.stringify(y.kaydet()) == once, "Yanlış uzman işlem yapamaz")
 y.gun = 3
 agil.insa_kalan = 1
 dene(not y.lojistik.al(y, "koc"), "Bitmemiş ağıl barındırmaz")
 agil.insa_kalan = 0
 y.akce = 0
 dene(not y.lojistik.al(y, "koc"), "Yetersiz kasa engeli")
 print("CELEP HAMDULLAH: GEÇTİ" if hata == 0 else "CELEP HAMDULLAH: KALDI")
 quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 return null
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
