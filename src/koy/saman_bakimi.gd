## MEV-14: tek ambar ve gerçek mevcut sürü/lojistik sayaçlarıyla kış yemi.
class_name SamanBakimi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/saman_bakimi.json"))
const META := "saman_son_gece"
## Optional başlangıç koyunu alanı; eski kayıtta dört, gerçek sıfırda sıfır kalır.
static func oku(v: Variant) -> int:
 if (v is int or v is float) and is_finite(float(v)) and float(v) == floorf(float(v)):
  return clampi(int(v), 0, int(CobanSurusu.AYAR.koyun_sayisi))
 return int(CobanSurusu.AYAR.koyun_sayisi)
## Yalnız hazır ağılın kurulum sürüsü; lojistikteki satın alınmış koçlar ayrı mevcut sayacı kullanır.
static func taban(b: KoyBinasi) -> int:
 return b.agil_koyun if CobanSurusu.hazir(b) else 0
## Sabit bina kimliği/tür sırası; barınağı kaldırmak satın alınmış hayvanın yemini gizlemez.
static func hayvanlar(y: KoyYonetimi) -> Array[Dictionary]:
 var s: Array[Dictionary] = []
 var binalar := y.binalar.duplicate()
 binalar.sort_custom(func(a: KoyBinasi, b: KoyBinasi) -> bool: return a.id < b.id)
 for b in binalar:
  for i in taban(b): s.append({"tur":"koyun", "bina":b.id})
 for t in CelepHamdullah.AYAR.hayvanlar:
  for i in int(y.lojistik.hayvanlar.get(t, 0)): s.append({"tur":t, "bina":-1})
 return s
## Kış/tipi gecesinde bir makbuz; önce beslenenler, eksikte en çok bir gerçek ölüm.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> int:
 if y.son != "" or not y.kis_mi() or KurtBaskini.oku(y.get_meta(META, -1)) == y.gun: return 0
 y.set_meta(META, y.gun)
 var s := hayvanlar(y)
 var birim := maxi(1, int(AYAR.gecelik_yem))
 var beslenen := mini(s.size(), floori(float(y.kaynaklar.miktar("saman")) / birim))
 var yenen := y.kaynaklar.azalt("saman", beslenen * birim)
 if beslenen == s.size(): return yenen
 var kayip := mini(s.size() - beslenen, int(AYAR.gecelik_azami_kayip))
 for i in range(beslenen, beslenen + kayip):
  var x := s[i]
  if x.tur == "koyun": y.bina(int(x.bina)).agil_koyun -= 1
  else: y.lojistik.hayvanlar[x.tur] = maxi(0, int(y.lojistik.hayvanlar[x.tur]) - 1)
  olaylar.append({"anahtar":"Saman yetersiz: %s yem bulamadı ve öldü. Ambarda %d saman kaldı.", "deger":["koyun" if x.tur == "koyun" else CelepHamdullah.AYAR.hayvanlar[x.tur].ad, y.kaynaklar.miktar("saman")]})
 return yenen
## Yalnız gerçekten ambara giren buğdayın yan ürünü; aynı kapasite, sıcak hasat, ikinci üretim yok.
static func hasat(y: KoyYonetimi, rapor: Dictionary) -> void:
 var miktar := floori(int(rapor.uretim.get("bugday", 0)) * float(AYAR.hasat_orani))
 if miktar <= 0: return
 rapor.uretim["saman"] = y.kaynaklar.ekle("saman", miktar)
## Eksik temel sürü mevcut ağıl üretimini oransal azaltır; satın alınmış bonus ek olarak korunur.
static func uretim(b: KoyBinasi) -> float:
 return float(taban(b)) / maxi(1, int(CobanSurusu.AYAR.koyun_sayisi))
## Mevcut kervan kapı/ziyaret ve kamu kasası; başarısız alış atomiktir.
static func al(y: KoyYonetimi) -> bool:
 var adet := int(AYAR.alis_partisi)
 var fiyat := ceili(adet * float(AYAR.alis_fiyat))
 if y.son != "" or not y.kervan_gunu() or y.akce < fiyat or y.kaynaklar.bos_yer() < adet: return false
 y.akce -= fiyat
 y.kaynaklar.ekle("saman", adet)
 return true
## Aynı stok kartı ve bina bilgisi için canlı ihtiyacın okunur açıklaması.
static func tip(y: KoyYonetimi) -> String:
 var gerek := hayvanlar(y).size() * int(AYAR.gecelik_yem)
 return "Saman: %d · kışlık yem %d/gece · yaklaşık %d gece. Buğday hasadının yan ürünü; kervandan alınabilir. Eksikte gecede en çok %d hayvan ölür." % [y.kaynaklar.miktar("saman"), gerek, y.kaynaklar.miktar("saman") / maxi(1, gerek), int(AYAR.gecelik_azami_kayip)]
