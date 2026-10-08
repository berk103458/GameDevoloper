## CAS-05: tek CAS gözlem kaydını okuyan duruşma seçimi; ikinci kanıt deposu yok.
class_name DivanOturumu
extends RefCounted
const META := "divan_oturumu"
## Optional seçim/duruşma makbuzu; eski/bozuk kayıt güvenli.
static func oku(v: Variant) -> Dictionary:
 var d := {"kisi":-1,"inceleme_gunu":-1}
 if v is Dictionary:
  d.kisi = KurtBaskini.oku(v.get("kisi",-1))
  d.inceleme_gunu = KurtBaskini.oku(v.get("inceleme_gunu",-1))
 return d
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Niyet değil, aynı açık gerçek fiil; eksik/dead kişi yeni duruşma adayı değildir.
static func adaylar(y: KoyYonetimi) -> Array[int]:
 var ids: Array[int] = []
 if y.son != "": return ids
 for x in CasusGeceTakibi.acik_izler(y):
  var k := y.koylu(int(x.kisi))
  if k != null and k.saglik > 0 and not DivanHukmu.verildi(y,k.id) and not k.id in ids: ids.append(k.id)
 ids.sort()
 return ids
## Aynı yaşayan kişinin açık kayıtları kopya; gizli hedefler bu ekrana girmez.
static func izler(y: KoyYonetimi,id: int) -> Array:
 return CasusGeceTakibi.acik_izler(y).filter(func(x: Dictionary) -> bool: return int(x.kisi)==id) if id in adaylar(y) else []
## Duruşma başlatma yalnız seçim makbuzu; stok/kasa/RNG/ceza değişmez.
static func sec(y: KoyYonetimi,id: int) -> bool:
 if not id in adaylar(y): return false
 y.set_meta(META,{"kisi":id,"inceleme_gunu":y.gun})
 return true
