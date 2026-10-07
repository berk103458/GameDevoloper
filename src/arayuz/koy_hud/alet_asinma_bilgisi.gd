## EKO-13: mevcut alet stok göstergesi için salt okunur aşınma açıklaması.
class_name AletAsinmaBilgisi
extends RefCounted
## Gerçek stok ve ortak dengeyi gösterir; süre/üretim tahmini veya ikinci aşınma sistemi kurmaz.
static func tip(y: KoyYonetimi) -> String:
 var oran := String.num(100.0 * float(DemirZinciri.AYAR.aletsiz_carpan), 2)
 var asinan := String.num(100.0 * y.alet_asinma, 1)
 var adim := String.num(100.0 * float(DemirZinciri.AYAR.asinma_calisma), 1)
 return "Alet: %d · birikmiş aşınma: %%%s\nAlet kullanan fiili çalışan başına %%%s aşınma; %%100'de bir alet tüketilir. Alet yokken ilgili üretim normalin %%%s'uyla çalışır. Girdisiz, duran veya ambarı dolu iş aşındırmaz." % [y.kaynaklar.miktar("alet"), asinan, adim, oran]
