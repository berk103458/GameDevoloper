## MEV-02: mevcut soğuk hasarı ve sağlık/ölüm çözümü; ikinci tüketim yoktur.
class_name DonmaYoneticisi
extends RefCounted
## Soğukta ölüm eşiğine yaklaşanlar sağlık/id sırasıyla; RNG değiştirilmez.
static func adaylar(y: KoyYonetimi) -> Array[Koylu]:
 var s: Array[Koylu] = []
 for k in y.koylular:
  if k.saglik > 0 and k.saglik <= y.a.soguk_saglik: s.append(k)
 s.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.saglik < b.saglik if a.saglik != b.saglik else a.id < b.id)
 return s.slice(0, clampi(int(MevsimTuketimAdaptoru.AYAR.get("donma_azami", 3)), 1, 3))
## Ödeme öncesi salt okunur yakacak/sağlık uyarısı; sağlık fazı yine gerçek ölümü belirler.
static func risk(y: KoyYonetimi) -> PackedInt64Array:
 var ids := PackedInt64Array()
 if not y.kis_mi() or y.kaynaklar.miktar("odun") >= MevsimTuketimAdaptoru.odun(y): return ids
 for k in adaylar(y): ids.append(k.id)
 return ids
## Aynı odun kartında önlenebilir soğuk riski; ikinci panel veya sayaç yoktur.
static func tip(y: KoyYonetimi, tur: String) -> String:
 if tur != "odun" or not y.kis_mi() or y.kaynaklar.miktar("odun") >= MevsimTuketimAdaptoru.odun(y): return ""
 return "\nYakacak eksik: soğuk sağlık kaybı %d; donma eşiğinde %d kişi. Yakacak sağla veya sağlığı iyileştir." % [y.a.soguk_saglik, risk(y).size()]
## Yalnız karşılanmayan soğuk ihtiyacında çağrılır; diğer nedenlerin ölümü sınırlanmaz.
static func soguk(y: KoyYonetimi) -> void:
 if not y.kis_mi(): return
 var secilen := adaylar(y)
 for k in y.koylular:
  if k.saglik <= 0:
   k.saglik -= maxi(0, y.a.soguk_saglik)
   continue
  var sonra := k.saglik - maxi(0, y.a.soguk_saglik)
  k.saglik = sonra if k in secilen else maxi(1, sonra)
