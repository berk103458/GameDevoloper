extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.akce = 1000
 y.kaynaklar.kapasite = 10000
 for t in ["odun", "tas", "kereste", "gida", "alet"]: y.kaynaklar.ekle(t, 100)
 # YAP: fixture önce gerçek K1 ve bilgi sahibiyle K2 kışlayı kurar.
 var bilgili := y.kabul({"ad":"Kurulum bilgisi","sinif":"asker","stat":8,"yapi_bilgisi":["kulube"]})
 kur(y,"kulube")
 var kisla := kur(y)
 y.koylular.erase(bilgili)
 var k := y.kabul({"ad": "Kervan nöbetçisi", "sinif": "asker", "stat": 5})
 var k2 := y.kabul({"ad": "Köy nöbetçisi", "sinif": "asker", "stat": 5})
 dene(y.ata(k.id, kisla.id) and y.ata(k2.id, kisla.id), "İki mevcut kışla nöbetçisi")
 y.gun = 3
 var para := y.akce
 var guvenlik := StatEnjektoru.oku(o, "Guvenlik")
 var savunma := y.savunma_gucu()
 var nufus := y.nufus()
 var rng := y._rng.state
 dene(KervanKorumasi.kirala(y, k.id), "Mevcut uzman kervanı kiralar")
 dene(y.akce == para + 12 and o.muhafiz_akce == 0 and y.nufus() == nufus and y._rng.state == rng, "Tek kamu peşinatı, nüfus ve RNG korunur")
 dene(y.etkin_muhafiz_sayisi() == 1 and y.savunma_gucu() == savunma - 1 and StatEnjektoru.oku(o, "Guvenlik") == guvenlik - 5, "Savunma ve geçici Güvenlik gerçek modele bağlı")
 var once := JSON.stringify(o.kaydet())
 dene(not KervanKorumasi.kirala(y, k.id) and not KervanKorumasi.kirala(y, k2.id) and JSON.stringify(o.kaydet()) == once, "Aynı ziyaret ikinci peşinat vermez")
 dene(not y.muhafiz_ata(k.id) and not y.ata(k.id, kisla.id), "Görevde yeniden atama yok")
 y.bosalt(k.id)
 dene(k.is_yeri == kisla.id and y.muhafiz_sayisi() == 2, "Kışla yeri ve mevcut bordro adayı korunur")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(KervanKorumasi.disarida(geri.yonetim, k.id) and geri.yonetim.etkin_muhafiz_sayisi() == 1, "Görev makbuzu kayıt dönüşünde korunur")
 y.gun = 5
 dene(KervanKorumasi.disarida(y, k.id), "Üçüncü görev gününde dışarıda")
 y.gun = 6
 dene(not KervanKorumasi.disarida(y, k.id) and y.etkin_muhafiz_sayisi() == 2 and StatEnjektoru.oku(o, "Guvenlik") == guvenlik and k.is_yeri == kisla.id, "Dönüş günü geçici kayıp kalkar; eski atama kalır")
 y.gun = 7
 dene(KervanKorumasi.kirala(y, k.id), "Yeni uzman ziyaretinde yeniden görev")
 y.son = "iflas"
 dene(not KervanKorumasi.uygun(y, k2.id), "Bitmiş oyun kiralama yok")
 y.son = ""
 y.gun = 11
 y.akce = 9223372036854775807
 once = JSON.stringify(y.kaydet())
 dene(not KervanKorumasi.kirala(y, k2.id) and JSON.stringify(y.kaydet()) == once, "Kasa taşması atomik ret")
 y.akce = 100
 y.maas_durumu[str(k2.id)] = {"borc": 1}
 once = JSON.stringify(y.kaydet())
 dene(not KervanKorumasi.kirala(y, k2.id) and JSON.stringify(y.kaydet()) == once, "Borçlu nöbetçi kiralanmaz")
 dene(not KervanKorumasi.kirala(y, -1), "Yanlış kişi güvenli ret")
 dene(KervanKorumasi.oku({"0": {"baslangic": 3, "donus": 2, "varis": 4, "tuccar": "nalbur", "alinan": 12}}).is_empty(), "Bozuk süre yüklenmez")
 dene(KervanKorumasi.oku({}).is_empty(), "Eski kayıt ek alan gerektirmez")
 print("KERVAN KORUMASI: GEÇTİ" if hata == 0 else "KERVAN KORUMASI: KALDI")
 quit(hata)
func kur(y: KoyYonetimi, tur: String = "muhafiz_kislasi") -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 assert(false)
 return null
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
