## CAS-10: yalnız söylentiyle zindan haksızdır; gerçek hüküm ve kamu tazminat makbuzu.
class_name DivanHaksizligi
extends RefCounted
const META := "divan_haksizligi"
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/divan_haksizligi.json"))
## Haksızlık ve onarım makbuzu; ikinci suç/kanıt deposu değildir.
static func oku(v: Variant) -> Dictionary:
 var r: Dictionary={}
 if not v is Dictionary: return r
 for id in v:
  var x: Variant=v[id]
  if not id is String or not id.is_valid_int() or int(id)<1 or not x is Dictionary or not x.get("odendi") is bool: continue
  var g:=KurtBaskini.oku(x.get("gun",-1))
  if g>=0: r[id]={"gun":g,"odendi":bool(x.odendi)}
 return r
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Arşivlenmiş güncel imzasız iddia; kişi hayatta, hüküm yok. İddia fiile dönüştürülmez.
static func suphe(y: KoyYonetimi,id: int) -> bool:
 var d:=FisiltiGazetesi.durum(y)
 var k:=y.koylu(id)
 return y.son=="" and k!=null and k.saglik>0 and not KervanKorumasi.disarida(y,id) and not DivanHukmu.verildi(y,id) and not d.bekliyor and d.secim==0 and d.kisi==id and d.gun>=0
## Kaynak şecerede açık kardeş bağı; aynı ev veya fraksiyon aile sayılmaz.
static func aile(y: KoyYonetimi,k: Koylu) -> Array[Koylu]:
 var r: Array[Koylu]=[]
 for c in AYAR.aile_ciftleri:
  if String(k.adli_id) not in c: continue
  for a in y.koylular:
   if a.id!=k.id and a.saglik>0 and not DivanHukmu.zindanda(a) and String(a.adli_id) in c and not KervanKorumasi.disarida(y,a.id) and a not in r: r.append(a)
 return r
## Kanıtsız zindan kararı sonrası tek moral/adalet çöküşü ve gerçek mevcut aile ayrılışı.
static func uygula(o: Oturum,k: Koylu,haksiz: bool) -> void:
 if not haksiz: return
 var y:=o.yonetim
 var d:=durum(y)
 if d.has(str(k.id)): return
 d[str(k.id)]={"gun":y.gun,"odendi":false}
 y.set_meta(META,d)
 for a in aile(y,k):
  y.koylular.erase(a)
  if o.kadro.durumlar.has(a.adli_id): o.kadro.durumlar[a.adli_id]["durum"]=&"kalici_ayrildi"
 y._herkese_moral(int(AYAR.moral))
 y.adalet=clampi(y.adalet+int(AYAR.adalet),0,100)
## Borcu ödenmiş kişi kayıt dönüşünde yeniden hapse sokulmaz; asıl hüküm tarihi korunur.
static func odendi(y: KoyYonetimi,id: int) -> bool:
 return bool(durum(y).get(str(id),{}).get("odendi",false))
static func onarilabilir(o: Oturum,id: int) -> bool:
 var y:=o.yonetim
 var k:=y.koylu(id)
 return y.son=="" and k!=null and k.saglik>0 and DivanHukmu.zindanda(k) and durum(y).has(str(id)) and not odendi(y,id) and y.akce>=int(AYAR.tazminat)
## Tam kamu tazminatı ve tahliye bir kez; kişisel kese/RNG/stok veya ayrılan aile geri yaratılmaz.
static func tazmin(o: Oturum,id: int) -> bool:
 if not onarilabilir(o,id): return false
 var y:=o.yonetim
 var d:=durum(y)
 y.akce-=int(AYAR.tazminat)
 d[str(id)].odendi=true
 y.set_meta(META,d)
 y.koylu(id).bayraklar.erase(DivanHukmu.FLAG)
 y._herkese_moral(int(AYAR.onarim_moral))
 y.adalet=clampi(y.adalet+int(AYAR.onarim_adalet),0,100)
 o._koy_esitle()
 return true
## Aynı divanda yalnız onarılmamış canlı mağdur; kasa yetmese de borç görünür.
static func adaylar(y: KoyYonetimi) -> Array[int]:
 var r: Array[int]=[]
 if y.son!="": return r
 for k in y.koylular:
  if k.saglik>0 and DivanHukmu.zindanda(k) and durum(y).has(str(k.id)) and not odendi(y,k.id): r.append(k.id)
 var d:=FisiltiGazetesi.durum(y)
 if suphe(y,int(d.kisi)): r.append(int(d.kisi))
 return r
