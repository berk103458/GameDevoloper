## HAR-11: mevcut uygun kadro ve adsız sınıf seçiminin Güvenlik ağırlıkları.
class_name GuvenlikKafileDengesi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/guvenlik_kafile_dengesi.json"))
## Gerçek CAS profil kümesi; seçim riski oyuncuya suç kanıtı/kimlik açıklaması değildir.
static func adli_agirliklar(o: Oturum,ids: Array[StringName]) -> Array[float]:
 var w: Array[float]=[]
 var guvenlik:=o.gosterge(3)
 for id in ids:
  var n:=1.0
  if guvenlik<int(AYAR.dusuk_esik) and String(id) in AYAR.risk_profilleri: n=float(AYAR.risk_agirlik)
  elif guvenlik>int(AYAR.yuksek_esik) and o.katalog.karakter(id).sinif==StringName(AYAR.ticaret_sinifi): n=float(AYAR.ticaret_agirlik)
  w.append(n)
 return w
## KAP01 hazır diyalog sırası korunur; yalnız eski rastgele şablon sınıfları.
static func sinif_agirliklar(o: Oturum) -> Array[float]:
 var w: Array[float]=[]
 for s in Katalog.SINIFLAR:
  w.append(float(AYAR.ticaret_agirlik) if o.gosterge(3)>int(AYAR.yuksek_esik) and s==StringName(AYAR.ticaret_sinifi) else 1.0)
 return w
## Ağırlıklı olasılık aralığı; oyun state/RNG değiştirmez. Son sınıf üst sınırı karşılar.
static func aralik(w: Array[float],zar: float) -> int:
 var toplam:=0.0
 for n in w: toplam+=n
 var kalan:=clampf(zar,0.0,1.0)*toplam
 for i in w.size():
  if kalan<w[i]: return i
  kalan-=w[i]
 return w.size()-1
## Tümü eşitse eski tek randi_range aynen; ağırlıklı seçim aynı kayıtlı RNG'den tek zar.
static func sec(rng: RandomNumberGenerator,w: Array[float]) -> int:
 if w.is_empty(): return -1
 var esit:=true
 for n in w:
  if n!=w[0]: esit=false
 return rng.randi_range(0,w.size()-1) if esit else aralik(w,rng.randf())
## Çağıran aynı uygunlar listesinden pop/iste yapar; dönüş veya erken gece atlanmaz.
static func adli_indeks(o: Oturum,ids: Array[StringName]) -> int:
 return sec(o._rng,adli_agirliklar(o,ids))
## Eski üç normal sınıftan birini seçer; NPC/takvim/ticaret makbuzu yaratmaz.
static func sinif_sec(o: Oturum) -> StringName:
 return Katalog.SINIFLAR[sec(o._rng,sinif_agirliklar(o))]
