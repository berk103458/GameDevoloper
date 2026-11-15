## HAR-12: gerçek harita talebinin aynı Gelen kuyruğunda zorunlu bildirisi.
class_name DiplomatikHeyet
extends RefCounted
const META := "diplomatik_heyet"
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/diplomatik_heyet.json"))
## Optional iki kaynak makbuzu; Moğol yalnız gerçek izinli üç uyarı.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"tekfur_gun":-1,"mogol":[]}
 if not v is Dictionary: return d
 d.tekfur_gun=KurtBaskini.oku(v.get("tekfur_gun",-1))
 if v.get("mogol") is Array:
  for n in v.mogol:
   if (n is int or n is float) and is_finite(float(n)) and floor(float(n))==float(n) and int(n) in MogolOncusu._esikler() and not int(n) in d.mogol: d.mogol.append(int(n))
 return d
## Kayıt makbuzunu kopyalar; eksik legacy hiçbir ziyaret dinlendi demek değildir.
static func durum(o: Oturum) -> Dictionary:
 return oku(o.get_meta(META,{}))
## Kapı snapshot için sınırlı veri; script/Resource yüklemez.
static func bilet_oku(v: Variant) -> Dictionary:
 if not v is Dictionary or not v.get("tur") is String or not AYAR.heyetler.has(v.tur): return {}
 var n: Variant=v.get("kalan")
 if (not n is int and not n is float) or not is_finite(float(n)) or floor(float(n))!=float(n) or float(n)<-1 or float(n)>1000000000: return {}
 var gun:=KurtBaskini.oku(v.get("gun",-1))
 var kalan:=KurtBaskini.oku(v.get("kalan",-1))
 if gun<0 or (v.tur=="mogol" and not kalan in MogolOncusu._esikler()) or (v.tur=="tekfur" and kalan!=-1): return {}
 return {"tur":String(v.tur),"gun":gun,"kalan":kalan}
## Yalnız bu heyetin adsız gerçek kapı ziyaretçisi; CHR kimliği yerine geçmez.
static func bilet(g: Gelen) -> Dictionary:
 return bilet_oku(g.get_meta(META,{})) if g!=null else {}
## Metası bozuk olsa bile generic köylü kabulüne düşürülmez.
static func ilgilenir(g: Gelen) -> bool:
 return g!=null and g.has_meta(META)
## Canlı gün/kaynak ve tamamlanmamış makbuz birlikte gerekir.
static func gecerli(o: Oturum,g: Gelen) -> bool:
 var b:=bilet(g)
 if b.is_empty() or o.yonetim.son!=&"" or b.gun!=o.gun or g.adli or g.id!=&"" or g.ad_anahtari!=String(AYAR.heyetler[b.tur].ad): return false
 var d:=durum(o)
 if b.tur=="tekfur": return o.yonetim.agalik and o.yonetim.harac_bekliyor and d.tekfur_gun!=o.gun
 return b.kalan==int(MogolOncusu.durum(o).kalan) and b.kalan in MogolOncusu.oku(o.mogol_oncusu).uyarilar and not b.kalan in d.mogol
## Mevcut listenin başına kararlı heyet sırası; normal/tüccar nesneleri silinmez, RNG çekilmez.
static func ekle(o: Oturum,liste: Array[Gelen]) -> void:
 if o.yonetim.son!=&"": return
 var d:=durum(o)
 var kalan:=int(MogolOncusu.durum(o).kalan)
 var sira: Array=AYAR.oncelik.duplicate()
 sira.reverse()
 var dis_hat = preload("res://src/sistemler/dis_hat_kapisi.gd")
 for tur in sira:
  if tur=="mogol" and not dis_hat.izin(o.yonetim, dis_hat.TALEP): continue
  if tur=="tekfur" and (not o.yonetim.agalik or not o.yonetim.harac_bekliyor or d.tekfur_gun==o.gun): continue
  if tur=="mogol" and (not kalan in MogolOncusu._esikler() or not kalan in MogolOncusu.oku(o.mogol_oncusu).uyarilar or kalan in d.mogol): continue
  var var_mi:=false
  for g in liste:
   var b:=bilet(g)
   if not b.is_empty() and b.tur==tur and b.gun==o.gun: var_mi=true
  if var_mi: continue
  var g:=Gelen.new()
  g.ad_anahtari=String(AYAR.heyetler[tur].ad);g.sinif=&"asker";g.portre=String(AYAR.portre)
  g.giris_anahtari=String(AYAR.heyetler[tur].giris)
  g.acilis=MogolOncusu.metin(o) if tur=="mogol" else TekfurHaracHeyeti.metin({"akce":o.yonetim.a.harac_akce,"bugday":o.yonetim.a.harac_gida})
  g.secenekler=PackedStringArray(["kabul","harc"] if tur=="tekfur" else ["kabul"])
  g.set_meta(META,{"tur":String(tur),"gun":o.gun,"kalan":kalan if tur=="mogol" else -1})
  liste.push_front(g)
## Dinleme zorunlu, ödeme tercihli; eksik kaynakla geçerli dinleme her zaman mümkündür.
static func karar_olur(o: Oturum,g: Gelen,k: StringName) -> bool:
 if not gecerli(o,g): return false
 if k==&"kabul": return true
 return k==&"harc" and bilet(g).tur=="tekfur" and o.yonetim.akce>=o.yonetim.a.harac_akce and o.yonetim.kaynaklar.miktar("bugday")>=o.yonetim.a.harac_gida
## Aynı karar API: yalnız gerçek Tekfur ödemesi; nüfus/kadro/tecrübe/RNG veya savaş değişmez.
static func karar(o: Oturum,g: Gelen,k: StringName) -> Dictionary:
 var s: Dictionary={"engellendi":true,"kaldi":false,"kirilan":-1,"koylu_id":-1,"heyet":true,"odendi":false}
 if not karar_olur(o,g,k): return s
 if k==&"harc" and not TekfurHaracHeyeti.ode(o.yonetim): return s
 var b:=bilet(g)
 var d:=durum(o)
 if b.tur=="tekfur":
  d.tekfur_gun=o.gun
  if k==&"harc":
   DunyaZamani.karar_kaydet(o, "tekfur_haraci", "kabul")
 else:
  d.mogol.append(int(b.kalan))
  DunyaZamani.karar_kaydet(o, "mogol_elcisi", "ret" if k==&"ret" else "kabul")
 o.set_meta(META,d)
 s.engellendi=false;s.odendi=k==&"harc"
 return s
## Karar verilmeden doğrudan sıradaki/klavye/API çağrısı heyeti atlayamaz.
static func gecis_engeli(o: Oturum,g: Gelen) -> bool:
 return ilgilenir(g) and gecerli(o,g)
## Bekleyen canlı heyet varsa öne geçme/sıra olayı oluşmaz; normal kuyruk değişmez.
static func kilitli(o: Oturum,liste: Array[Gelen]) -> bool:
 for g in liste:
  if gecis_engeli(o,g): return true
 return false
