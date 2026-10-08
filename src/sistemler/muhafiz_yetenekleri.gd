## ODA-05: kalıcı yetenek seçimi, aynı kişisel rüşvet ve tek günlük esnaf haraç işlemi.
class_name MuhafizYetenekleri
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_yetenekleri.json"))
const YETENEKLER: Array[String]=["goz_yumma","harac_kesme"]
const AKCE_AZAMI:=9223372036854775807

## Eski/bozuk optional kaydı doğrular; ikinci yetenek önkoşulsuz yüklenmez.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"alinan":[],"son_harac_gece":-1,"harac_toplam":0}
 if not v is Dictionary: return d
 if v.get("alinan") is Array:
  for id in YETENEKLER:
   if id not in v.alinan: continue
   var on: String=AYAR[id].on_kosul
   if on.is_empty() or on in d.alinan: d.alinan.append(id)
 for key in ["son_harac_gece","harac_toplam"]:
  var n: Variant=v.get(key)
  if (n is int or n is float) and is_finite(float(n)) and floor(float(n))==float(n) and float(n)>=(-1 if key=="son_harac_gece" else 0) and float(n)<=1000000000: d[key]=int(n)
 return d

## Salt okunur sahiplik; bilinmeyen id yetenek değildir.
static func var_mi(o: Oturum,id: String) -> bool:
 return id in oku(o.muhafiz_yetenekleri).alinan

## Gerçek kişisel bakiye, tecrübe, yozlaşma ve önkoşul yeniden denetlenir.
static func alinabilir(o: Oturum,id: String) -> bool:
 if id not in YETENEKLER or o.yonetim.son!="" or var_mi(o,id): return false
 var a: Dictionary=AYAR[id]
 return o.muhafiz_akce>=int(a.bedel) and o.muhafiz_tecrubesi>=int(a.tecrube) and int(MuhafizTerazisi.durum(o).yozlasma)>=int(a.yozlasma) and (String(a.on_kosul).is_empty() or var_mi(o,String(a.on_kosul)))

## Tam kişisel bedel tek tahsilat; kamu/stok/RNG veya başka makbuz değişmez.
static func al(o: Oturum,id: String) -> bool:
 if not alinabilir(o,id): return false
 var d:=oku(o.muhafiz_yetenekleri)
 o.muhafiz_akce-=int(AYAR[id].bedel)
 d.alinan.append(id)
 o.muhafiz_yetenekleri=d
 return true

## Mevcut dağıtımın kopyasına yalnız akçe bonusu; eşya ve kaynak Resource readonly.
static func rusvet(o: Oturum,kisisel: Dictionary) -> Dictionary:
 var d:=kisisel.duplicate(true)
 if not var_mi(o,"goz_yumma"): return d
 var taban:=maxi(0,int(d.get("akce",0)))
 var bonus:=int(floor(taban*float(AYAR.rusvet_bonus_oran)))
 d.akce=mini(AKCE_AZAMI-o.muhafiz_akce,taban+bonus)
 return d

## Aynı gerçek gece bir kez; çocuk/tutsak/dışarıdaki/işsiz/ölü veya inşa işçisi esnaftan gelir yok.
static func harac(o: Oturum) -> Dictionary:
 var r: Dictionary={"akce":0,"kisi":0}
 if not var_mi(o,"harac_kesme") or o.yonetim.son!="": return r
 var d:=oku(o.muhafiz_yetenekleri)
 var y:=o.yonetim
 if int(d.son_harac_gece)>=y.gun: return r
 var kisiler: Array[Koylu]=[]
 for k in y.koylular:
  var b:=y.bina(k.is_yeri)
  if k.sinif==&"esnaf" and k.saglik>0 and k.yas_grubu!=&"cocuk" and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y,k.id) and b!=null and b.hazir(): kisiler.append(k)
 var tutar:=kisiler.size()*int(AYAR.harac_kisi_akce)
 if tutar>AKCE_AZAMI-o.muhafiz_akce or tutar>1000000000-int(d.harac_toplam): return r
 d.son_harac_gece=y.gun
 d.harac_toplam+=tutar
 o.muhafiz_yetenekleri=d
 if tutar==0: return r
 o.muhafiz_akce+=tutar
 for k in kisiler: k.moral=clampi(k.moral+int(AYAR.harac_moral),0,100)
 y.adalet=clampi(y.adalet+int(AYAR.harac_adalet),0,100)
 return {"akce":tutar,"kisi":kisiler.size()}

## Mevcut tek sabah raporuna açık gelir ve sosyal bedel notu; ayrı olay/HUD yok.
static func rapora_ekle(r: Dictionary,harac: Dictionary) -> void:
 if int(harac.akce)>0: r.olaylar.append({"anahtar":&"koy.olay.muhafiz_harac","deger":[],"muhafiz_harac":harac.duplicate(true)})

## Aynı olay kartında gerçek haraç sonucu; CSV veya mevcut diğer olaylara yazmaz.
static func olay_metin(harac: Dictionary) -> String:
 return "Haraç: %d çalışan esnaftan %d kişisel akçe; esnaf morali %d, adalet %d."%[harac.kisi,harac.akce,int(AYAR.harac_moral),int(AYAR.harac_adalet)]
