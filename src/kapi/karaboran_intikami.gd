## CAS-08: gerçek CHR004 zindan hükmünün üçüncü gecesi; aynı husumet baskınına tek tetik.
class_name KaraboranIntikami
extends RefCounted
const META := "karaboran_intikami"
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/karaboran_intikami.json"))
## Eski kayıt boş; geçerli kişi kimlikleri tek teslim makbuzudur.
static func oku(v: Variant) -> Array[int]:
 var r: Array[int]=[]
 if not v is Array: return r
 for x in v:
  var id:=KurtBaskini.oku(x)
  if id>0 and id not in r: r.append(id)
  if r.size()>=int(AYAR.makbuz_siniri): break
 return r
static func durum(y: KoyYonetimi) -> Array[int]:
 return oku(y.get_meta(META,[]))
## Hüküm gecesi ilk gece; yaşayan gerçek tutuklu yoksa tetik yok. Zar/stok burada değişmez.
static func tetikle(y: KoyYonetimi,olaylar: Array[Dictionary]) -> String:
 if y.son!="": return ""
 var makbuz:=durum(y)
 for k in y.koylular:
  if k.adli_id!=StringName(AYAR.adli_id) or k.saglik<=0 or not DivanHukmu.zindanda(k) or k.id in makbuz: continue
  var h: Dictionary=DivanHukmu.durum(y).get(str(k.id),{})
  if h.get("karar","")!="zindan" or h.get("adli_id","")!=String(AYAR.adli_id) or y.gun-int(h.get("gun",y.gun))+1<int(AYAR.gece_sayisi): continue
  if makbuz.size()>=int(AYAR.makbuz_siniri): return ""
  makbuz.append(k.id)
  y.set_meta(META,makbuz)
  olaylar.append({"anahtar":"Karaboran çetesi, zindandaki reisinin intikamı için kapıya baskın yaptı."})
  return "baskin"
 return ""
