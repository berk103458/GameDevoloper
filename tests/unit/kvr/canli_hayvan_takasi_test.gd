extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.a = y.a.duplicate(true)
 y.a.ambar_taban_kapasite = 10000
 y.kaynaklar.kapasite = 10000
 y.akce = 1000
 for t in ["odun", "tas", "gida", "alet"]: y.kaynaklar.ekle(t, 100)
 var ahir := kur(y, "ahir")
 var agil := kur(y, "agil")
 var tarla := kur(y, "tarla")
 y.gun = 3
 dene(y.lojistik.al(y, "okuz") and y.lojistik.al(y, "inek") and y.lojistik.al(y, "koc"), "Mevcut kamu alımı ve iki barınak")
 dene(CanliHayvanTakasi.barinan(y, "okuz") == 1 and CanliHayvanTakasi.barinan(y, "inek") == 1, "Ortak ahırda gerçek barınan türler")
 dene(is_equal_approx(CanliHayvanTakasi.carpan(y, tarla, "gida"), 1.25) and is_equal_approx(CanliHayvanTakasi.carpan(y, agil, "gida"), 1.3), "Öküz tarla ve inek/koç ağıl çarpanı")
 dene(CanliHayvanTakasi.carpan(y, tarla, "alet") == 1.0, "İlgisiz ürün etkilenmez")
 for b in [tarla, agil]:
  var k := y.kabul({"ad": "Hayvan bakıcısı", "sinif": "ciftci" if b == tarla else "coban", "stat": 10})
  k.moral = 50
  y.ata(k.id, b.id)
 var normal := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 normal.lojistik.hayvanlar = {"okuz": 0, "inek": 0, "beygir": 0, "koc": 0}
 var u := {}
 var u0 := {}
 var olaylar: Array[Dictionary] = []
 y._uret(u, olaylar)
 normal._uret(u0, olaylar)
 dene(int(u.get("gida", 0)) > int(u0.get("gida", 0)), "Gerçek tek üretim hattında katkı")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(geri.lojistik.hayvanlar == y.lojistik.hayvanlar and is_equal_approx(CanliHayvanTakasi.carpan(geri, geri.bina(tarla.id), "gida"), 1.25), "Mevcut hayvan kaydı çarpanı yeniden üretir")
 var para := y.akce
 dene(CanliHayvanTakasi.sat(y, "okuz") and y.akce == para + 20 and o.muhafiz_akce == 0, "Geri satış yarım fiyatla yalnız kamuya")
 dene(CanliHayvanTakasi.carpan(y, tarla, "gida") == 1.0 and y.lojistik.alinabilir(y, "okuz"), "Hayvan katkısı biter ve ahır yeri açılır")
 var once := JSON.stringify(y.kaydet())
 dene(not CanliHayvanTakasi.sat(y, "okuz") and JSON.stringify(y.kaydet()) == once, "İkinci satış stok/kasa yaratmaz")
 dene(y.lojistik.al(y, "okuz") and y.akce == para - 20, "Al-sat turu kâr üretmez")
 ahir.insa_kalan = 1
 dene(CanliHayvanTakasi.barinan(y, "okuz") == 0 and CanliHayvanTakasi.carpan(y, tarla, "gida") == 1.0, "Bitmemiş barınak üretim desteği vermez")
 ahir.insa_kalan = 0
 y.gun = 7
 once = JSON.stringify(y.kaydet())
 dene(not CanliHayvanTakasi.sat(y, "inek") and JSON.stringify(y.kaydet()) == once, "Yanlış uzman atomik ret")
 y.gun = 3
 y.akce = 9223372036854775807
 once = JSON.stringify(y.kaydet())
 dene(not CanliHayvanTakasi.sat(y, "inek") and JSON.stringify(y.kaydet()) == once, "Kasa taşması atomik ret")
 y.akce = 100
 y.son = "iflas"
 dene(not CanliHayvanTakasi.satilabilir(y, "inek"), "Bitmiş oyun geri satış yok")
 y.lojistik.hayvanlar.inek = 0
 once = JSON.stringify(y.kaydet())
 dene(not y.lojistik.al(y, "inek") and JSON.stringify(y.kaydet()) == once, "Bitmiş oyun boş ahırda alımı da kapatır")
 print("CANLI HAYVAN TAKASI: GEÇTİ" if hata == 0 else "CANLI HAYVAN TAKASI: KALDI")
 quit(hata)
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 assert(false, "Barınak yeri bulunamadı")
 return null
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
