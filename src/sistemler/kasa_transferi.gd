## EKO-14: iki mevcut kasa arasında atomik kurtarma/zimmet; ikinci ekonomi yok.
class_name KasaTransferi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/kasa_transferi.json"))
## Optional transfer özeti ve aynı gün zimmet korumasını güvenle yükler.
static func oku(v: Variant) -> Dictionary:
 var s := {"son_zimmet": -1, "kurtarma_toplam": 0, "zimmet_toplam": 0}
 if not v is Dictionary: return s
 for alan in s:
  var n: Variant = v.get(alan)
  if (n is int or n is float) and is_finite(float(n)) and floor(float(n)) == float(n) and float(n) >= (-1 if alan == "son_zimmet" else 0) and float(n) <= 1000000000: s[alan] = int(n)
 return s
## Her çağrıda gerçek bakiye, açık, günlük sınır ve oyun sonunu yeniden denetler.
static func uygun(o: Oturum, tur: String, adet: int) -> bool:
 if adet <= 0 or adet > 1000000000 or o.yonetim.son != "": return false
 if tur == "kurtarma": return o.koy_akce < 0 and o.koy_akce + adet <= 0 and o.muhafiz_akce >= adet and int(o.kasa_transferleri.kurtarma_toplam) <= 1000000000 - adet
 if tur == "zimmet": return o.muhafiz_akce <= 9223372036854775807 - adet and o.koy_akce >= adet and adet <= int(AYAR.gunluk_zimmet_azami) and int(o.kasa_transferleri.son_zimmet) != o.gun and int(o.kasa_transferleri.zimmet_toplam) <= 1000000000 - adet
 return false
## Pazarın kurtarma miktarı; aşırı negatif kamu bakiyesinde de taşma üretmez.
static func kurtarma_adedi(o: Oturum) -> int:
 if o.koy_akce >= 0: return 0
 var acik: int = 1000000000 if o.koy_akce <= -1000000000 else -o.koy_akce
 return mini(acik, o.muhafiz_akce)
## İki tarafı birlikte günceller; başarısız çağrı durumu/sinyali değiştirmez.
static func uygula(o: Oturum, tur: String, adet: int) -> bool:
 if not uygun(o, tur, adet): return false
 if tur == "kurtarma":
  o.muhafiz_akce -= adet
  o.koy_akce += adet
  o.kasa_transferleri.kurtarma_toplam += adet
 else:
  o.koy_akce -= adet
  o.muhafiz_akce += adet
  o.kasa_transferleri.zimmet_toplam += adet
  o.kasa_transferleri.son_zimmet = o.gun
  o.yonetim.adalet = clampi(o.yonetim.adalet + int(AYAR.zimmet_adalet), 0, 100)
  o.yonetim.asayis_riski = clampi(o.yonetim.asayis_riski + int(AYAR.zimmet_asayis), 0, 100)
  for k in o.yonetim.koylular: k.moral = clampi(k.moral + int(AYAR.zimmet_moral), 0, 100)
 o.koy.degisti.emit()
 return true
## Oyuncuya para yönü ve sosyal bedeli işlem öncesinde açıklar.
static func tip(tur: String) -> String:
 if tur == "kurtarma": return "Kişisel keseden kamuya: yalnız mevcut açık kadar. Para ve moral ödülü yaratmaz; sonraki gece kamu bakiyesi iflas serisini değerlendirir."
 return "Kamudan kişisel keseye; günde bir kez, en çok %d akçe. Adalet %d, yaşayan köylülerin morali %d, asayiş riski +%d." % [int(AYAR.gunluk_zimmet_azami), int(AYAR.zimmet_adalet), int(AYAR.zimmet_moral), int(AYAR.zimmet_asayis)]
