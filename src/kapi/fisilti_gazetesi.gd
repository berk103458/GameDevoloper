## CAS-09: imzasız iddia gerçek gözlem değildir; mevcut sabah kartında tek pusula.
class_name FisiltiGazetesi
extends RefCounted
const HISTERI = preload("res://src/koy/batil_inanc_histerisi.gd")
const META := "fisilti_gazetesi"
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/fisilti_gazetesi.json"))
## Optional gün/kişi pusulası; kanıt ya da CHR gizli kimliği kopyalanmaz.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"son_gece":-1,"gun":-1,"kisi":-1,"metin":-1,"bekliyor":false,"secim":-1}
 if not v is Dictionary: return d
 for a in ["son_gece","gun","kisi","metin","secim"]: d[a]=KurtBaskini.oku(v.get(a,-1))
 d.bekliyor=v.get("bekliyor",false) is bool and bool(v.get("bekliyor",false)) and d.gun>=0 and d.kisi>0 and d.metin>=0 and d.metin<AYAR.pusulalar.size()
 return d
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Deterministik halka açık isim seçimi; gizli bayrak/Clue/fiil/persona/RNG okunmaz.
static func gece(y: KoyYonetimi,olaylar: Array[Dictionary]) -> void:
 HISTERI.gece(y,olaylar)
 var d:=durum(y)
 if y.son!="" or d.son_gece==y.gun: return
 d.son_gece=y.gun
 y.set_meta(META,d)
 if d.bekliyor or y.gun%maxi(1,int(AYAR.aralik_gece))!=0: return
 var adaylar: Array[Koylu]=[]
 for k in y.koylular:
  if k.saglik>0 and k.yas_grubu!=&"cocuk" and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y,k.id): adaylar.append(k)
 if adaylar.is_empty(): return
 adaylar.sort_custom(func(a: Koylu,b: Koylu) -> bool: return a.id<b.id)
 var s:=y.gun/maxi(1,int(AYAR.aralik_gece))
 d.kisi=adaylar[s%adaylar.size()].id
 d.gun=y.gun
 d.metin=s%AYAR.pusulalar.size()
 d.bekliyor=true
 d.secim=-1
 y.set_meta(META,d)
 olaylar.append({"anahtar":"Fısıltı gazetesi: kapıya imzasız bir şüphe pusulası bırakıldı. Söylenti suç kanıtı değildir."})
## Aynı mevcut olay kartı; gerçek suçüstü tutanağından sonra, genel rastgele olaydan önce.
static func olay(o: Oturum) -> OlayVerisi:
 var histeri: OlayVerisi=HISTERI.olay(o)
 if histeri!=null: return histeri
 var d:=durum(o.yonetim)
 if not d.bekliyor or o.yonetim.son!="": return null
 var k:=o.yonetim.koylu(int(d.kisi))
 var e:=OlayVerisi.new()
 e.id=StringName("cas09_pusula_%d_%d"%[int(d.gun),int(d.kisi)])
 e.baslik_anahtari="Fısıltı gazetesi · imzasız pusula"
 e.metin_anahtari="İmzasız iddia: “%s”\nBu bir söylentidir; suçüstü gözlemi veya divan kanıtı değildir." % (String(AYAR.pusulalar[int(d.metin)]) % (k.ad if k!=null else "köyden ayrılmış kişi"))
 e.secenek_anahtarlari=PackedStringArray(["Pusulayı arşivle · kanıt bekle","Söylentiyi reddet"])
 e.secenek_etkileri=[{},{}]
 return e
static func tanimli(e: OlayVerisi) -> bool:
 if HISTERI.tanimli(e): return true
 return e!=null and String(e.id).begins_with("cas09_pusula_")
## Eski/foreign kart, geçersiz seçim veya çift tıklama reddedilir.
static func uygun(o: Oturum,e: OlayVerisi,i: int) -> bool:
 if HISTERI.tanimli(e): return HISTERI.uygun(o,e,i)
 var g:=olay(o)
 return i in [0,1] and tanimli(e) and g!=null and e.id==g.id
## Arşiv yalnız söylenti makbuzudur; suç bayrağı, divan adayı, hasar, para ve zar yaratmaz.
static func uygula(o: Oturum,e: OlayVerisi,i: int) -> Dictionary:
 if HISTERI.tanimli(e): return HISTERI.uygula(o,e,i)
 var r: Dictionary={"ok":false,"kirilan":-1,"rusvet_harcandi":-1,"sonuc_anahtari":"Pusula güncel değil.","oyun_puan":-1}
 if not uygun(o,e,i): return r
 var d:=durum(o.yonetim)
 d.bekliyor=false
 d.secim=i
 o.yonetim.set_meta(META,d)
 r.ok=true
 r.sonuc_anahtari="Pusula arşivlendi; iddia henüz kanıt değildir." if i==0 else "İmzasız söylenti reddedildi; kimse suçlu ilan edilmedi."
 return r
