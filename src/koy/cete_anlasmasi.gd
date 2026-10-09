## HAR-08: mevcut çete ganimetine süreli kamu ödemesi; yeni saldırı sistemi yok.
class_name CeteAnlasmasi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/cete_anlasmasi.json"))
const META:=&"cete_anlasmasi"
## Optional makbuzda yalnız geçerli sabit süre kabul edilir; sınırsız koruma elenir.
static func oku(v: Variant) -> Dictionary:
 var d:={"gun":-1,"bitis":-1}
 if not v is Dictionary: return d
 var gun:=KurtBaskini.oku(v.get("gun"))
 var bitis:=KurtBaskini.oku(v.get("bitis"))
 if gun>=0 and bitis==gun+int(AYAR.sure): return {"gun":gun,"bitis":bitis}
 return d
## Tek gerçek köy metadata makbuzu; kayda normalleştirilmiş kopya verilir.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Başlangıç dahil, bitiş hariç; terminal veya gelecekte başlayan makbuz aktif değildir.
static func aktif(y: KoyYonetimi) -> bool:
 var d:=durum(y)
 return y.son=="" and int(d.gun)>=0 and int(d.gun)<=y.gun and y.gun<int(d.bitis)
## Yalnız kamu kasası; aktif süre yeniden satın alınmaz, otomatik ödeme yok.
static func odenebilir(y: KoyYonetimi) -> bool:
 return y.son=="" and not aktif(y) and y.akce>=int(AYAR.bedel)
## Atomik ödeme mevcut kasadan; RNG/kişisel kese/husumet silinmez.
static func ode(y: KoyYonetimi) -> bool:
 if not odenebilir(y): return false
 y.akce-=int(AYAR.bedel)
 y.set_meta(META,{"gun":y.gun,"bitis":y.gun+int(AYAR.sure)})
 return true
## Aynı baskının yalnız stok ganimeti; diğer yaralanma/sosyal sonuçlar mevcut akıştadır.
static func baskin(y: KoyYonetimi,olaylar: Array[Dictionary]) -> Array[int]:
 if aktif(y):
  olaylar.append({"anahtar":String(AYAR.koruma_notu)})
  return [0,0]
 return [y.kaynaklar.azalt("gida",int(y.kaynaklar.miktar("gida")*3/10)),y.kaynaklar.azalt("odun",int(y.kaynaklar.miktar("odun")/5))]
## Aynı sızmanın yalnız ambar kaybı; zar ve husumet mekanikleri değişmez.
static func sizma(y: KoyYonetimi,olaylar: Array[Dictionary]) -> Array[int]:
 if aktif(y):
  olaylar.append({"anahtar":String(AYAR.koruma_notu)})
  return [0,0]
 return [y.kaynaklar.azalt("gida",maxi(3,int(y.kaynaklar.miktar("gida")/6))),y.kaynaklar.azalt("alet",1)]
## Saf kamu bedeli ve kalan gün; ikinci HUD veya gizli suç çıkarımı yok.
static func tip(y: KoyYonetimi) -> String:
 return "%s\n%s\n%s"%[String(AYAR.baslik),String(AYAR.aciklama),"Koruma: %d gün kaldı"%maxi(0,int(durum(y).bitis)-y.gun) if aktif(y) else "Geçerli anlaşma yok"]
