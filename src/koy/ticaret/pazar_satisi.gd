## TUC-10: aynı ambar satışını mevcut kamu veya kişisel kasaya yönlendirir.
class_name PazarSatisi
extends RefCounted
## Mevcut satış formülünün salt okunur teklifi; hiçbir stok/kasa/RNG değişmez.
static func onizle(y: KoyYonetimi, tur: String, adet: int, kervan: bool) -> Dictionary:
 var bos := {"satilan": 0, "akce": 0}
 if adet <= 0 or adet > 1000000000 or y.son != "" or (kervan and not y.kervan_gunu()): return bos
 var fiyat := TicaretFiyatlari.sat_birim(y, tur) * (1.0 if kervan else y.a.tezgah_orani)
 if fiyat <= 0: return bos
 var adet_ := mini(adet, y.kaynaklar.miktar(tur))
 var kazanc := int(adet_ * fiyat)
 if not kervan: kazanc = mini(kazanc, y.a.tezgah_gunluk_azami - y._tezgah_bugun)
 if kazanc <= 0: return bos
 return {"satilan": mini(adet_, ceili(kazanc / fiyat)), "akce": kazanc}
## Kişisel gelir mevcut zimmet gün/üst sınırı ve sosyal bedelinden kaçamaz.
static func uygun(o: Oturum, tur: String, adet: int, kervan: bool, kisisel: bool) -> bool:
 var r := onizle(o.yonetim, tur, adet, kervan)
 return r.akce > 0 and (not kisisel or KasaTransferi.gelir_uygun(o, int(r.akce)))
## Başarıda tek model satışı, ardından mevcut atomik zimmet işlemi; başarısızlık salt okunurdur.
static func uygula(o: Oturum, tur: String, adet: int, kervan: bool, kisisel: bool) -> Dictionary:
 if not uygun(o, tur, adet, kervan, kisisel): return {"satilan": 0, "akce": 0}
 var r := o.yonetim.kervana_sat(tur, adet) if kervan else o.yonetim.tezgah_sat(tur, adet)
 if kisisel: KasaTransferi.uygula(o, "zimmet", int(r.akce))
 o.koy.degisti.emit()
 return r
