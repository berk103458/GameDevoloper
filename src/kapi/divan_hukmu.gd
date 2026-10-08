## CAS-07: aynı divanın tek hüküm makbuzu; zindan çalışmaz, sürgün/infaz gerçek nüfustan çıkar.
class_name DivanHukmu
extends RefCounted
const META := "divan_hukumleri"
const FLAG := "zindanda"
const KARARLAR := ["zindan","surgun","infaz"]
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/divan_hukmu.json"))
## Optional karar makbuzları; valid kişi/gün/karar, eksik eski kayıt boş.
static func oku(v: Variant) -> Dictionary:
 var d := {}
 if not v is Dictionary: return d
 for id in v:
  var x: Variant=v[id]
  if not id is String or not id.is_valid_int() or int(id)<1 or not x is Dictionary or x.get("karar") not in KARARLAR or not x.get("adli_id") is String: continue
  var g:=KurtBaskini.oku(x.get("gun",-1))
  if g<0: continue
  d[id]={"gun":g,"karar":String(x.karar),"adli_id":String(x.adli_id)}
 return d
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Nüfustaki tutuklu sağlık/tüketim döngüsünde kalır; iş ve suç için uygun değildir.
static func zindanda(k: Koylu) -> bool:
 return k!=null and FLAG in k.bayraklar
static func verildi(y: KoyYonetimi,id: int) -> bool:
 return durum(y).has(str(id))
## Kapının mevcut hücresinin soyut iki kişilik kontenjanı; ikinci bina/üretim slotu yok.
static func kalan(y: KoyYonetimi) -> int:
 var n:=0
 for k in y.koylular:
  if zindanda(k): n+=1
 return maxi(0,int(AYAR.zindan_kapasite)-n)
## Canlı kişi, gerçek açık fiil, bir hüküm; dış görev ve dolu hücre güvenli reddedilir.
static func uygun(o: Oturum,id: int,karar: String) -> bool:
 var y:=o.yonetim
 return karar in KARARLAR and y.son=="" and not verildi(y,id) and y.koylu(id)!=null and y.koylu(id).saglik>0 and not KervanKorumasi.disarida(y,id) and not DivanOturumu.izler(y,id).is_empty() and (karar!="zindan" or kalan(y)>0)
## Gerçek tek karar; kamu/kişisel para ve kaynak RNG değişmez. Tek sosyal denge delta.
static func uygula(o: Oturum,id: int,karar: String) -> bool:
 if not uygun(o,id,karar): return false
 var y:=o.yonetim
 var k:=y.koylu(id)
 var d:=durum(y)
 d[str(id)]={"gun":y.gun,"karar":karar,"adli_id":String(k.adli_id)}
 y.set_meta(META,d)
 match karar:
  "zindan":
   k.bayrak_ekle(FLAG)
   k.is_yeri=KoyYonetimi.BOSTA
   k.kis_oncesi_is=-1
   k.ev=-1
  "surgun": y.surgun(id)
  "infaz":
   k.saglik=0
   y.koylular.erase(k)
 if karar!="zindan" and o.kadro.durumlar.has(k.adli_id): o.kadro.durumlar[k.adli_id]["durum"]=&"kalici_ayrildi"
 y.asayis_riski=clampi(y.asayis_riski+int(AYAR[karar].asayis),0,100)
 y._herkese_moral(int(AYAR[karar].moral))
 var pending:=CasusDevriyesi.durum(y)
 if int(pending.kisi)==id:
  pending.bekliyor=false
  y.set_meta(CasusDevriyesi.META,pending)
 o._koy_esitle()
 return true
## Restore'da tutsak bayrağı tek hüküm kaydından türetilir; sahte/eksik bayrak aktif hücre yaratmaz.
static func kayit_esitle(y: KoyYonetimi) -> void:
 var d:=durum(y)
 for k in y.koylular:
  if d.get(str(k.id),{}).get("karar","")=="zindan":
   k.bayrak_ekle(FLAG)
   k.is_yeri=KoyYonetimi.BOSTA
   k.kis_oncesi_is=-1
   k.ev=-1
  else: k.bayraklar.erase(FLAG)
