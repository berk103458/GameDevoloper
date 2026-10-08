extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 y.gun = 3
 dene(y.siparisler.kabul(y), "Gerçek ilk sipariş")
 var id := String(y.siparisler.sozlesmeler.keys()[0])
 var once := JSON.stringify(y.kaydet())
 dene(not SiparisTeslimati.teslim(y, id) and JSON.stringify(y.kaydet()) == once, "Eksik ürün işlem yapmaz")
 y.kaynaklar.ekle("un", 12)
 var para := y.akce
 var rng := y._rng.state
 dene(SiparisTeslimati.teslim(y, id), "Erken teslim kabul edilir")
 dene(y.akce == para + 24 and y.kaynaklar.miktar("un") == 0 and y._rng.state == rng, "Tek kamu ödemesi/tam stok düşümü; RNG korunur")
 dene(y.tuccar_itibari.celep_hamdullah.puan == 10 and y.siparisler.aktif_sayisi() == 0, "İtibar tüccara özgü, açık slot serbest")
 once = JSON.stringify(y.kaydet())
 dene(not SiparisTeslimati.teslim(y, id) and JSON.stringify(y.kaydet()) == once, "İkinci ödül yok")
 dene(not GezginTuccarStogu.urunler(y).has("bugday"), "Aynı ziyarette sadakat ürünü erken açılmaz")
 y.gun = 19
 dene(GezginTuccarStogu.urunler(y).has("bugday"), "Sonraki Celep ziyareti sadakat stoğunu açar")
 y.akce = 100
 dene(y.gezgin_ticaret.al(y, "bugday", 2) and not y.gezgin_ticaret.al(y, "bugday", 1), "Nadir ürün mevcut sınırlı stoktan alınır")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(geri.kaydet() == y.kaydet() and geri.gezgin_ticaret.kalan(geri, "bugday") == 0, "Teslim tarihi/itibar/sadakat alımı ana kayıtta korunur")
 dene(y.siparisler.kabul(y), "Yeni ziyaret yeni sipariş verir")
 id = String(SiparisSozlesmeleri.teklif(y).id)
 y.kaynaklar.ekle("un", 24)
 y.gun = 26
 dene(SiparisTeslimati.teslim(y, id), "Vade günü dahil kabul")
 y.gun = 35
 dene(y.siparisler.kabul(y), "Üçüncü teklif")
 id = String(SiparisSozlesmeleri.teklif(y).id)
 y.gun = 43
 once = JSON.stringify(y.kaydet())
 dene(not SiparisTeslimati.teslim(y, id) and JSON.stringify(y.kaydet()) == once, "Vade sonrası teslim reddedilir; ihlal ayrı paket")
 dene(SiparisTeslimati.oku({"nalbur": {"puan": 1e100, "acilis": 8}}).nalbur.puan == 100, "Bozuk yüksek itibar sınırlanır")
 print("SİPARİŞ TESLİMATI: GEÇTİ" if hata == 0 else "SİPARİŞ TESLİMATI: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
