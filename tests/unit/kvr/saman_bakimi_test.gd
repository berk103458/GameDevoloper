extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.a = y.a.duplicate(true)
 y.a.ambar_taban_kapasite = 10000
 kat.koy_ayarlari = y.a
 y.kaynaklar.kapasite = 10000
 y.akce = 1000
 for t in ["odun", "tas", "gida", "kereste"]: y.kaynaklar.ekle(t, 100)
 var b := kur(y, "agil")
 var ahir := kur(y, "ahir")
 var k := y.kabul({"ad":"Çoban", "sinif":"ciftci", "stat":5})
 dene(y.ata(k.id, b.id), "Gerçek çoban ataması")
 dene(SamanBakimi.taban(b) == 4 and SamanBakimi.hayvanlar(y).size() == 4, "Eski temel dört koyun")
 dene(SamanBakimi.oku(0) == 0 and SamanBakimi.oku(-1) == 0 and SamanBakimi.oku("4") == 4 and SamanBakimi.oku(1.5) == 4, "Optional doğrulama")
 y.gun = 3
 var para := y.akce
 dene(SamanBakimi.al(y) and y.kaynaklar.miktar("saman") == 10 and y.akce == para - 5, "Kamu kasası/gerçek ziyaret saman alış")
 y.gun = 0
 var once := JSON.stringify(o.kaydet())
 dene(not SamanBakimi.al(y) and JSON.stringify(o.kaydet()) == once, "Ziyaret dışı atomik ret")
 y.gun = 21
 y.lojistik.hayvanlar.okuz = 1
 y.lojistik.hayvanlar.koc = 1
 var olaylar: Array[Dictionary] = []
 dene(SamanBakimi.gece(y, olaylar) == 6 and SamanBakimi.hayvanlar(y).size() == 6 and olaylar.is_empty(), "Kış tek ortak stokla bütün hayvanları besler")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 once = JSON.stringify(o.kaydet())
 dene(SamanBakimi.gece(geri.yonetim, []) == 0 and JSON.stringify(geri.kaydet()) == once, "Makbuz restore/çift tüketim yok")
 dene(SamanBakimi.gece(y, olaylar) == 0 and JSON.stringify(o.kaydet()) == once, "Aynı gece tek çözüm")
 y.gun += 1
 dene(SamanBakimi.gece(y, olaylar) == 4 and b.agil_koyun == 4 and y.lojistik.hayvanlar.okuz == 0 and y.lojistik.hayvanlar.koc == 1 and olaylar.size() == 1, "Kısmi yem: gerçek ilk aç satın alınmış öküz ölür")
 dene(not y.lojistik.etkin(y), "Ölen çeki hayvanı taşıma bonusu vermez")
 y.gun += 1
 dene(SamanBakimi.gece(y, olaylar) == 0 and b.agil_koyun == 3 and y.lojistik.hayvanlar.koc == 1, "Yemsiz gece en çok bir başlangıç koyunu ölür")
 dene(is_equal_approx(CanliHayvanTakasi.carpan(y, b, "gida"), 0.85), "Azalan sürü üretimi azaltır; mevcut koç katkısı kalır")
 dene(not CanliHayvanTakasi.satilabilir(y, "okuz"), "Ölü hayvan geri satılamaz")
 b.agil_koyun = 0
 y.gun += 1
 SamanBakimi.gece(y, olaylar)
 dene(y.lojistik.hayvanlar.koc == 0 and is_zero_approx(CanliHayvanTakasi.carpan(y, b, "gida")), "Son satın alınmış ölüm, boş sürü sıfır üretim")
 geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(geri.yonetim.bina(b.id).agil_koyun == 0 and SamanBakimi.hayvanlar(geri.yonetim).is_empty(), "Kayıt sıfır sürüyü canlandırmaz")
 var eski := b.kaydet()
 eski.erase("agil_koyun")
 dene(KoyBinasi.kayittan(eski).agil_koyun == 4, "Eski ağıl kaydı dört koyunla açılır")
 y.lojistik.hayvanlar.inek = 1
 y.bina_el_koy(ahir.id)
 dene(SamanBakimi.hayvanlar(y).size() == 1, "Yıkılan ahır yem ihtiyacını gizlemez")
 y.gun = 0
 var rng := y._rng.state
 SamanBakimi.gece(y, olaylar)
 dene(y.lojistik.hayvanlar.inek == 1 and y._rng.state == rng, "Sıcak mevsim yem/ölüm/RNG yok")
 var rapor := {"uretim":{"bugday":5}}
 SamanBakimi.hasat(y, rapor)
 dene(rapor.uretim.saman == 5 and y.kaynaklar.miktar("saman") == 5, "Gerçek buğday miktarı kadar yan ürün")
 y.kaynaklar.kapasite = y.kaynaklar.toplam()
 SamanBakimi.hasat(y, rapor)
 dene(rapor.uretim.saman == 0 and y.kaynaklar.toplam() <= y.kaynaklar.kapasite, "Ambar doluyken saman taşmaz")
 once = JSON.stringify(o.kaydet())
 dene(not SamanBakimi.al(y) and JSON.stringify(o.kaydet()) == once, "Ambar dolu atomik ret")
 y.kaynaklar.kapasite = 10000
 y.gun = 21
 y.lojistik.hayvanlar.inek = 0
 b.agil_koyun = 4
 y.kaynaklar.azalt("saman", 9999)
 y.set_meta(SamanBakimi.META, -1)
 geri = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 var gercek := y.gece()
 dene(geri.yonetim.gece() == gercek and geri.yonetim.kaydet() == y.kaydet(), "Gerçek gece tam restore eşitliği")
 dene(b.agil_koyun == 3 and int(gercek.tuketim.saman) == 0 and gercek.olaylar.any(func(x: Dictionary) -> bool: return String(x.anahtar).begins_with("Saman yetersiz")), "Gerçek gece rapor/sürü kaybı")
 y.gun = 0
 var tarla := kur(y, "tarla")
 var ciftci := y.kabul({"ad":"Hasatçı", "sinif":"ciftci", "stat":5})
 dene(y.ata(ciftci.id, tarla.id) and y.recete_sec(tarla.id, "bugday"), "Buğday tarifi/gerçek tarla")
 var saman_once := y.kaynaklar.miktar("saman")
 var hasat := y.gece()
 dene(int(hasat.uretim.get("bugday", 0)) > 0 and int(hasat.uretim.get("saman", 0)) == int(hasat.uretim.bugday) and y.kaynaklar.miktar("saman") == saman_once + int(hasat.uretim.saman), "Gerçek sıcak gece buğday ve saman yan ürünü")
 y.gun = 2
 IklimDeneyi.yukle(y, {"mevsim":-1,"hava":"kar_firtinasi"})
 y.kaynaklar.azalt("saman", 9999)
 var adet := SamanBakimi.hayvanlar(y).size()
 SamanBakimi.gece(y, [])
 dene(SamanBakimi.hayvanlar(y).size() == adet - 1, "Zorlanmış tipi doğal kış dışında da yem gerektirir")
 var stok := Kaynaklar.new(100, {"saman":50,"gida":40})
 stok.kapasite = 10
 dene(stok.toplam() <= 10, "Saman aynı taşma sırasıyla sınırlandırılır")
 print("SAMAN BAKIMI: GEÇTİ" if hata == 0 else "SAMAN BAKIMI: KALDI")
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
