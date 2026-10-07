extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var y := Oturum.new(kat, 91).yonetim
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 k.gizli_egilim = {"tur": "haydut"}
 var once := JSON.stringify(y.kaydet())
 var rng := y._rng.state
 dene(SinsiGeceRutini.aday(y, k, &"gece"), "Gece mevcut gizli eğilim adayı")
 dene(not SinsiGeceRutini.aday(y, k, &"gunduz") and not SinsiGeceRutini.aday(y, k, &"aksam"), "Yalnız gece")
 dene(JSON.stringify(y.kaydet()) == once and y._rng.state == rng, "Aday gözlemi kayıt/RNG değiştirmez")
 k.is_yeri = KoyYonetimi.MUHAFIZ
 dene(not SinsiGeceRutini.aday(y, k, &"gece"), "Muhafız görevi öncelikli")
 k.is_yeri = KoyYonetimi.BOSTA
 k.saglik = 0
 dene(not SinsiGeceRutini.aday(y, k, &"gece"), "Sağlıksız köylü kaçışa zorlanmaz")
 k.saglik = 100
 k.gizli_egilim = {"tur": "yok"}
 dene(not SinsiGeceRutini.aday(y, k, &"gece"), "Normal köylüye gizli kimlik uydurulmaz")
 for cy in y.a.izgara_boyut.y:
  var bulundu := false
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if not y.yerlesim("tarla", h).olur: continue
   y.kaynaklar.kapasite = 10000
   for t in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(t, 100)
   var sonuc := y.bina_kur("tarla", h)
   if not sonuc.olur: continue
   var b := y.bina(sonuc.id)
   b.insa_kalan = 0
   k.is_yeri = b.id
   k.zanaat_turu = ZanaatTuru.Tur.ASKER
   dene(SinsiGeceRutini.aday(y, k, &"gece"), "Mevcut uyumsuz iş sabotaj riski de gece adayı")
   bulundu = true
   break
  if bulundu: break
 print("SİNSİ GECE: GEÇTİ" if hata == 0 else "SİNSİ GECE: KALDI")
 quit(hata)
