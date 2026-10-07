## EKO-12: ortak ambar sınırı, gecelik bekleyen stok ziyanı ve kayıt adaptörü.
class_name AmbarBakimi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/ambar_bakimi.json"))
## Eski/bozuk optional geçmişi güvenli varsayılanla açar.
static func oku(v: Variant) -> Dictionary:
 var s := {"artik": {}, "tasma": {}, "son_gece": -1}
 if not v is Dictionary: return s
 for alan in ["artik", "tasma"]:
  if not v.get(alan) is Dictionary: continue
  for tur in Kaynaklar.TURLER:
   var n: Variant = v[alan].get(tur)
   if not (n is int or n is float) or not is_finite(float(n)): continue
   if alan == "artik" and AYAR.gecelik_bozulma.has(tur) and float(n) >= 0 and float(n) < 1: s[alan][tur] = float(n)
   if alan == "tasma" and float(n) > 0 and float(n) <= 1000000000 and floor(float(n)) == float(n): s[alan][tur] = int(n)
 var gun: Variant = v.get("son_gece")
 if (gun is int or gun is float) and is_finite(float(gun)) and float(gun) >= -1 and float(gun) <= 1000000000 and floor(float(gun)) == float(gun): s.son_gece = int(gun)
 return s
## Kapasite düşüşünde fazlayı sıralı çıkarır; raporlanacak kaybı saklar.
static func sinirla(k: RefCounted) -> void:
 var fazla: int = maxi(0, k.toplam() - k.kapasite)
 for tur in AYAR.tasma_sirasi:
  if fazla == 0: break
  var kayip: int = k.azalt(tur, fazla)
  if kayip > 0: k.bakim.tasma[tur] = int(k.bakim.tasma.get(tur, 0)) + kayip
  fazla -= kayip
## Tüketimden sonra kalan stoktan günde bir kez bozulma; kasalara/RNG'ye dokunmaz.
static func gece(k: RefCounted, gun: int, olaylar: Array[Dictionary]) -> Dictionary:
 if k.bakim.son_gece == gun: return {}
 sinirla(k)
 k.bakim.son_gece = gun
 var z := {"tasma": k.bakim.tasma.duplicate(), "bozulma": {}}
 k.bakim.tasma.clear()
 for tur in AYAR.gecelik_bozulma:
  if k.miktar(tur) <= 0:
   k.bakim.artik.erase(tur)
   continue
  var ham: float = k.miktar(tur) * float(AYAR.gecelik_bozulma[tur]) + float(k.bakim.artik.get(tur, 0.0))
  var kayip: int = k.azalt(tur, floori(ham))
  k.bakim.artik[tur] = ham - floor(ham) if k.miktar(tur) > 0 else 0.0
  if kayip > 0: z.bozulma[tur] = kayip
 for neden in ["tasma", "bozulma"]:
  for tur in z[neden]:
   olaylar.append({"anahtar": "koy.olay.ambar_ziyan", "deger": [neden, tur, int(z[neden][tur])]})
 return z
## CSV kilidini koruyarak gece raporunun yeni olayını açıklar.
static func olay_metin(e: Dictionary) -> String:
 var d: Array = e.deger
 return "Ambar %s: %d %s ziyan oldu." % ["kapasite aşımı" if d[0] == "tasma" else "bozulması", int(d[2]), DemirZinciri.ad("koy.kaynak." + String(d[1]))]
## Mevcut ambar göstergesi için oyuncuya kapasite ve bozulma kuralını açıklar.
static func tip() -> String:
 return "Kapasite azalırsa fazla stok ziyan olur (önce gıda). Tüketimden sonra kalan gıda gecede %%%s bozulur; kesirler sonraki geceye taşınır." % String.num(100.0 * float(AYAR.gecelik_bozulma.gida), 2)
