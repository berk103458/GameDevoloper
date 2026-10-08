## ODA-08: tek optional kişisel oda/yorgunluk kaydı; köylü nöbet sistemi ayrıdır.
class_name MuhafizOdaGelisimi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/oda_gelisimi.json"))
const GELISTIRMELER: Array[String]=["yatak","askilik","kutuphane"]

## Eski/bozuk kayıt ve önkoşulsuz geliştirmeler güvenli normalize edilir.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"alinan":[],"yorgunluk":0,"son_gece":-1,"son_dinlenme":-1}
 if not v is Dictionary: return d
 if v.get("alinan") is Array:
  for id in GELISTIRMELER:
   if id in v.alinan and (String(AYAR[id].on_kosul).is_empty() or AYAR[id].on_kosul in d.alinan): d.alinan.append(id)
 for key in ["yorgunluk","son_gece","son_dinlenme"]:
  var n: Variant=v.get(key)
  if (n is int or n is float) and is_finite(float(n)) and floor(float(n))==float(n) and float(n)>=(-1 if key!="yorgunluk" else 0) and float(n)<= (int(AYAR.yorgunluk_azami) if key=="yorgunluk" else 1000000000): d[key]=int(n)
 return d

## Gerçek seçim sahipliği; ikinci oda envanteri değil.
static func var_mi(o: Oturum,id: String) -> bool:
 return id in oku(o.oda_gelisimi).alinan

## Kamu/ambar dokunulmadan kişisel bedel, önkoşul ve terminal kontrolü.
static func alinabilir(o: Oturum,id: String) -> bool:
 return id in GELISTIRMELER and o.yonetim.son=="" and not var_mi(o,id) and o.muhafiz_akce>=int(AYAR[id].bedel) and (String(AYAR[id].on_kosul).is_empty() or var_mi(o,String(AYAR[id].on_kosul)))

## Tek alım kişisel bedeli tahsil eder, yorgunluğu sıfırlar; tecrübe/skor silinmez.
static func al(o: Oturum,id: String) -> bool:
 if not alinabilir(o,id): return false
 var d:=oku(o.oda_gelisimi)
 d.alinan.append(id)
 d.yorgunluk=0
 o.muhafiz_akce-=int(AYAR[id].bedel)
 o.oda_gelisimi=d
 return true

## Pozitif kişisel yorgunluk ekler; kabus aynı alanı kullanır, ikinci yorgunluk yok.
static func yor(o: Oturum,miktar: int) -> void:
 if o.yonetim.son!="": return
 var d:=oku(o.oda_gelisimi)
 d.yorgunluk=clampi(int(d.yorgunluk)+maxi(0,miktar),0,int(AYAR.yorgunluk_azami))
 o.oda_gelisimi=d

## Kabul edilen gerçek muhafız kararı, sınırlı kişisel yorgunluk ekler.
static func karar(o: Oturum) -> void:
 if o.yonetim.son!="": return
 var d:=oku(o.oda_gelisimi)
 d.yorgunluk=mini(int(AYAR.yorgunluk_azami),int(d.yorgunluk)+int(AYAR.karar_yorgunluk))
 o.oda_gelisimi=d

## Aynı gerçek gece yalnız bir kez; geliştirmelerin pasif dinlenmesi uygulanır.
static func gece(o: Oturum) -> void:
 var d:=oku(o.oda_gelisimi)
 if o.yonetim.son!="" or int(d.son_gece)>=o.gun: return
 var dinlenme:=0
 for id in d.alinan: dinlenme+=int(AYAR[id].dinlenme)
 d.yorgunluk=clampi(int(d.yorgunluk)+int(AYAR.gece_yorgunluk)-dinlenme,0,int(AYAR.yorgunluk_azami))
 d.son_gece=o.gun
 o.oda_gelisimi=d

## Yatakta aynı gün bir kez ücretsiz dinlenme; zaman/RNG/köylü yorgunluğu değişmez.
static func dinlen(o: Oturum) -> bool:
 var d:=oku(o.oda_gelisimi)
 if o.yonetim.son!="" or not var_mi(o,"yatak") or int(d.yorgunluk)<=0 or int(d.son_dinlenme)>=o.gun: return false
 d.yorgunluk=0
 d.son_dinlenme=o.gun
 o.oda_gelisimi=d
 return true

## Sorgunun mevcut ikna hesabı için etkin tecrübe; kazanılmış tecrübe kayıtta korunur.
static func etkin_tecrube(o: Oturum) -> int:
 return maxi(0,o.muhafiz_tecrubesi-floori(float(oku(o.oda_gelisimi).yorgunluk)/int(AYAR.tecrube_ceza_aralik)))
