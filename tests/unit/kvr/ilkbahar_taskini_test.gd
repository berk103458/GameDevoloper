extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 22)
 var y := o.yonetim
 var k := y.kabul({"ad":"Su köylüsü", "sinif":"ciftci", "stat":5})
 k.moral = 50
 IlkbaharTaskini.gece(y, [])
 dene(not IlkbaharTaskini.durum(y).hasar and IlkbaharTaskini.olay(o) == null, "Başlangıç ilkbaharı kar erimesi üretmez")
 y.gun = 28
 var rng := y._rng.state
 var olaylar: Array[Dictionary] = []
 IlkbaharTaskini.gece(y, olaylar)
 dene(IlkbaharTaskini.durum(y).hasar and k.saglik == 97 and y._rng.state == rng, "İkinci yıl ilk bahar gecesi bendin kırılması ve sağlık etkisi")
 var once := JSON.stringify(o.kaydet())
 IlkbaharTaskini.gece(y, olaylar)
 dene(JSON.stringify(o.kaydet()) == once and olaylar.size() == 2, "Aynı gece ikinci taşkın/sağlık/RNG yok")
 var e := o.olay_sec()
 dene(IlkbaharTaskini.tanimli(e) and not o.secenek_olur(e, 0) and o.secenek_olur(e, 1), "Mevcut olay seçim/uygunluk API ve eksik kaynak")
 dene(not o.olay_uygula(e, 0).ok and JSON.stringify(o.kaydet()) == once, "Eksik onarım atomik ret")
 y.kaynaklar.ekle("tas", 4)
 y.kaynaklar.ekle("kirec", 2)
 var tas := y.kaynaklar.miktar("tas")
 var kirec := y.kaynaklar.miktar("kirec")
 var para := y.akce
 dene(o.secenek_olur(e, 0) and o.olay_uygula(e, 0).ok and not IlkbaharTaskini.durum(y).hasar, "Taş/kireçle gerçek bent/kuyu onarımı")
 dene(y.kaynaklar.miktar("tas") == tas-4 and y.kaynaklar.miktar("kirec") == kirec-2 and y.akce == para, "Yalnız ortak onarım kaynağı bir kez")
 once = JSON.stringify(o.kaydet())
 dene(not o.olay_uygula(e, 0).ok and JSON.stringify(o.kaydet()) == once, "Çift/stale seçim tekrar harcamaz")
 y.gun = 29
 IlkbaharTaskini.gece(y, [])
 dene(k.saglik == 97, "Onarım sağlık kaybını durdurur")
 IlkbaharTaskini.yukle(y, {"yil":2,"hasar":true,"son_gece":28,"secim_gunu":-1})
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 e = o.olay_sec()
 dene(o.olay_uygula(e, 1).ok and k.moral == 48 and IlkbaharTaskini.olay(o) == null, "Erteleme tek moral bedeli ve aynı gün tekrar kart yok")
 y.gun = 30
 dene(IlkbaharTaskini.olay(o) != null and not o.olay_uygula(e, 1).ok, "Sonraki gece onarım yeniden; eski kart ret")
 y.gun = 29
 geri.olay_uygula(geri.olay_sec(), 1)
 var r := y.gece()
 dene(geri.yonetim.gece() == r and geri.yonetim.kaydet() == y.kaydet(), "Restore mevcut gece sağlık/taşkın eşitliği")
 dene(not IlkbaharTaskini.oku({"yil":"x","hasar":true}).hasar, "Bozuk/eski yıl güvenli durum")
 print("İLKBAHAR TAŞKINI: GEÇTİ" if hata == 0 else "İLKBAHAR TAŞKINI: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
