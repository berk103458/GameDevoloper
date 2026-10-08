extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 76)
 var y := o.yonetim
 var k := y.kabul({"sinif": "ciftci", "stat": 5})
 k.refah = 50
 y.gun = 3
 dene(y.siparisler.kabul(y), "Gerçek taahhüt")
 var id := String(y.siparisler.sozlesmeler.keys()[0])
 y.gun = 10
 var olaylar: Array[Dictionary] = []
 SiparisIhlali.gece(y, olaylar)
 dene(y.siparisler.sozlesmeler[id].durum == "bekliyor" and k.refah == 50, "Vade günü ihlal değildir")
 y.gun = 11
 var rng := y._rng.state
 SiparisIhlali.gece(y, olaylar)
 dene(y.siparisler.sozlesmeler[id].durum == "ihlal" and k.refah == 47 and y.tuccar_cezasi.celep_hamdullah.borc == 6, "İlk geç gün tek ihlal/Refah/ödülün dörtte biri ceza")
 var once := JSON.stringify(y.kaydet())
 SiparisIhlali.gece(y, olaylar)
 dene(JSON.stringify(y.kaydet()) == once and y._rng.state == rng, "Aynı gün yeniden denetim faiz/ceza çoğaltmaz")
 y.gun = 12
 SiparisIhlali.gece(y, olaylar)
 dene(y.tuccar_cezasi.celep_hamdullah.borc == 7 and k.refah == 47, "Ertesi gün yüzde on yukarı yuvarlanmış faiz; Refah tekrar düşmez")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 dene(geri.tuccar_cezasi == y.tuccar_cezasi and geri.siparisler.kaydet() == y.siparisler.kaydet(), "Borç/faiz günü/ihlal kayıttan korunur")
 y.gun = 19
 dene(not y.kervan_gunu() and not CelepHamdullah.geldi(y) and SiparisSozlesmeleri.teklif(y).is_empty(), "Sonraki ziyarette ödenmemiş borç tüm ticareti kapatır")
 y.akce = 3
 dene(SiparisIhlali.ode(y, "celep_hamdullah") == 3 and y.akce == 0 and SiparisIhlali.terk(y, "celep_hamdullah"), "Kısmi kamu ödemesi; borç kalanında terk sürer")
 y.akce = 100
 dene(SiparisIhlali.ode(y, "celep_hamdullah") == 4 and y.kervan_gunu(), "Tam ödeme ve asgari süre bitişi ticareti açar")
 y.gun = 18
 dene(SiparisIhlali.terk(y, "celep_hamdullah"), "Ödeme asgari terk süresini atlatmaz")
 var bozuk := SiparisIhlali.oku({"nalbur": {"borc": -1, "donus": 1, "son_faiz": 1}})
 dene(bozuk.is_empty(), "Bozuk ceza kaydı reddedilir")
 # Önceden kalan borcun faizi yeni cezanın oluşturulmasından önce işler.
 var ikinci := Oturum.new(kat, 76).yonetim
 ikinci.gun = 3
 ikinci.siparisler.kabul(ikinci)
 ikinci.tuccar_cezasi.celep_hamdullah = {"borc": 10, "donus": 0, "son_faiz": 10}
 ikinci.gun = 11
 SiparisIhlali.gece(ikinci, olaylar)
 dene(ikinci.tuccar_cezasi.celep_hamdullah.borc == 19, "Eski borç 10→11→13; bugünkü yeni ceza 6 geçmişe faizlenmez")
 var ayni := JSON.stringify(ikinci.kaydet())
 SiparisIhlali.gece(ikinci, olaylar)
 dene(JSON.stringify(ikinci.kaydet()) == ayni, "Eski ve yeni borç birleşimi aynı gün tekrar güvenli")
 ikinci.gun = 1000000
 SiparisIhlali.gece(ikinci, olaylar)
 dene(ikinci.tuccar_cezasi.celep_hamdullah.borc == int(SiparisIhlali.AYAR.borc_ust), "Uzun tarih sıçraması faiz üst sınırında durur")
 # Gerçek gece entegrasyonu: geçiş sonunda bir kez çalışır.
 var yeni := Oturum.new(kat, 76).yonetim
 yeni.gun = 3
 yeni.siparisler.kabul(yeni)
 yeni.gun = 10
 yeni.gece()
 dene(yeni.siparisler.sozlesmeler.values()[0].durum == "ihlal", "Gerçek gece vade sonrası gününde ihlali tetikler")
 print("SİPARİŞ İHLALİ: GEÇTİ" if hata == 0 else "SİPARİŞ İHLALİ: KALDI")
 quit(hata)
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
