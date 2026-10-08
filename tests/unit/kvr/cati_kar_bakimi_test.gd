extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 22)
 var y := o.yonetim
 y.a = y.a.duplicate(true)
 y.a.ambar_taban_kapasite = 10000
 kat.koy_ayarlari = y.a
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "kereste", "gida"]: y.kaynaklar.ekle(t, 100)
 var b := kur(y, "kulube")
 var k := y.kabul({"ad":"Kürekçi", "sinif":"ciftci", "stat":5})
 y.gun = 27
 b.cati_kar.yuk = 2.0
 var once := JSON.stringify(o.kaydet())
 dene(CatiKarBakimi.gorevler(y).get(k.id) == b.id and JSON.stringify(o.kaydet()) == once, "Sağlıklı boş yetişkin ve salt okunur gerçek rota")
 var olaylar: Array[Dictionary] = []
 CatiKarBakimi.gece(y, olaylar)
 dene(b.cati_kar.yuk == 1.0 and olaylar.size() == 1 and y.bina(b.id) != null, "Kürekçi bir gecelik yükten fazla kar temizler")
 once = JSON.stringify(o.kaydet())
 CatiKarBakimi.gece(y, olaylar)
 dene(JSON.stringify(o.kaydet()) == once and olaylar.size() == 1, "Aynı gece tekrar temizlik/kar/olay yok")
 var geri := Oturum.kayittan(kat, JSON.parse_string(once))
 dene(geri.yonetim.bina(b.id).cati_kar == b.cati_kar, "Kar yükü/son gece aynı bina kaydında")
 var eski := b.kaydet()
 eski.erase("cati_kar")
 dene(KoyBinasi.kayittan(eski).cati_kar.yuk == 0.0 and CatiKarBakimi.oku({"yuk":"x","son_gece":2.5}).son_gece == -1, "Eski/bozuk optional çatı kaydı")
 k.is_yeri = KoyYonetimi.MUHAFIZ
 dene(CatiKarBakimi.gorevler(y).is_empty(), "Nöbet görevi çatıya çekilmez")
 y.gun = 28
 CatiKarBakimi.gece(y, [])
 dene(b.cati_kar.yuk == 0.0, "Bahar kar yükünü eritir")
 var risk: int = CatiKarBakimi.AYAR.cokme_yuzde
 CatiKarBakimi.AYAR.cokme_yuzde = 100
 y.gun = 27
 b.cati_kar.yuk = 2.0
 b.cati_kar.son_gece = -1
 k.ev = b.id
 var para := y.akce
 var stok := y.kaynaklar.kaydet()
 geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 var probe := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 CatiKarBakimi.gece(probe, [])
 dene(probe.akce == para and probe.kaynaklar.kaydet() == stok, "Çökme yıkım iadesi yaratmaz")
 var r := y.gece()
 dene(y.bina(b.id) == null and k.ev == -1 and y.nufus() == 1, "Çökme mevcut iadesiz kaldırma; ev boşaltılır, kişi öldürülmez")
 dene(geri.yonetim.gece() == r and geri.yonetim._rng.state == y._rng.state, "Gerçek gece çökme/RNG restore eşitliği")
 CatiKarBakimi.AYAR.cokme_yuzde = risk
 print("ÇATI KAR BAKIMI: GEÇTİ" if hata == 0 else "ÇATI KAR BAKIMI: KALDI")
 quit(hata)
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
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
