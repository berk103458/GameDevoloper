## HAR-09: gerçek gece raporunu mevcut OlayVerisi yazılı haberine bağlar.
class_name HaberciAgi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/haberci_agi.json"))
## Sınırlı optional defter: her açık kaynak için yalnız en yeni bekleyen haber.
static func oku(v: Variant) -> Dictionary:
 var d:={"son_gece":-1,"ilk_haber_gunu":-1,"bekleyen":[]}
 if not v is Dictionary: return d
 d.son_gece=KurtBaskini.oku(v.get("son_gece"))
 var ilk := KurtBaskini.oku(v.get("ilk_haber_gunu"))
 if ilk > 0 and ilk <= int(d.son_gece): d.ilk_haber_gunu=ilk
 if v.get("bekleyen") is Array:
  for x in v.bekleyen:
   if not x is Dictionary or not AYAR.kaynaklar.has(x.get("kaynak")) or not x.get("metin") is String: continue
   var gun:=KurtBaskini.oku(x.get("gun"))
   if gun<1 or String(x.metin).is_empty() or String(x.metin).length()>int(AYAR.azami_metin): continue
   var h:={"kaynak":String(x.kaynak),"gun":gun,"metin":String(x.metin)}
   _ekle(d.bekleyen,h)
   if int(d.ilk_haber_gunu) < 0 or gun < int(d.ilk_haber_gunu): d.ilk_haber_gunu=gun
 return d
## Aynı gece yalnız açık Moğol/Tekfur/çete raporları; gizli bayrak/kanıt okumaz.
static func gece(o: Oturum,r: Dictionary) -> void:
 var d:=oku(o.haberci_agi)
 var gun:=int(r.gun)+1
 if o.yonetim.son!="" or gun<=int(d.son_gece): return
 d.son_gece=gun
 for x in r.olaylar:
  if not x is Dictionary: continue
  var kaynak:=""
  var metin:=""
  if x.get("mogol_oncusu") is Dictionary:
   kaynak="mogol";metin=MogolOncusu.olay_metin(x.mogol_oncusu)
  elif x.get("tekfur_harac") is Dictionary:
   kaynak="tekfur";metin=TekfurHaracHeyeti.metin(x.tekfur_harac)
  elif String(x.get("anahtar","")) in ["koy.olay.baskin","koy.olay.sizma"]:
   kaynak="cete"
   var a: Array=x.get("deger",[])
   if a.size()>=2: metin=String(AYAR.cete_metin)%[int(a[0]),int(a[1])]
  if not metin.is_empty():
   _ekle(d.bekleyen,{"kaynak":kaynak,"gun":gun,"metin":metin})
   if int(d.ilk_haber_gunu) < 0: d.ilk_haber_gunu=gun
 o.haberci_agi=d
## Aynı bekleyen kartın salt okunur görünümü; okumak teslim/para işlemi değildir.
static func olay(o: Oturum) -> OlayVerisi:
 var d:=oku(o.haberci_agi)
 if o.yonetim.son!="" or d.bekleyen.is_empty(): return null
 var h: Dictionary=d.bekleyen[0]
 var kanal:=String(AYAR.kaynaklar[h.kaynak])
 var e:=OlayVerisi.new()
 e.id=StringName("har09_haber_%s_%d"%[h.kaynak,int(h.gun)])
 e.baslik_anahtari=String(AYAR.baslik)%String(AYAR.kanallar[kanal].ad)
 e.metin_anahtari=String(AYAR.giris[kanal])+"\n\n"+String(h.metin)
 e.secenek_anahtarlari=PackedStringArray([String(AYAR.secenek)])
 e.secenek_etkileri=[{}]
 return e
## Foreign olaylar mevcut çekirdekte kalır; yalnız haber kimliği yönlendirilir.
static func tanimli(e: OlayVerisi) -> bool:
 return e!=null and String(e.id).begins_with("har09_haber_")
## Canlı ilk haber kimliği ve tek okuma seçeneği; stale/terminal kartlar reddedilir.
static func uygun(o: Oturum,e: OlayVerisi,i: int) -> bool:
 var g:=olay(o)
 return i==0 and tanimli(e) and g!=null and e.id==g.id
## Gerçek okuma makbuzu: yalnız bekleyen ilk haber kaldırılır; kasa/RNG/karar etkisi yok.
static func uygula(o: Oturum,e: OlayVerisi,i: int) -> Dictionary:
 var r:={"ok":false,"kirilan":-1,"rusvet_harcandi":-1,"oyun_puan":-1,"sonuc_anahtari":"Bu haber artık güncel değil."}
 if not uygun(o,e,i): return r
 var d:=oku(o.haberci_agi)
 d.bekleyen.pop_front()
 o.haberci_agi=d
 r.ok=true;r.sonuc_anahtari=String(AYAR.sonuc)
 return r
## Aynı canlı kartın dış JSON kanal adı; UI yalnız kısa yer tutucuyu çizer.
static func kanal(o: Oturum) -> String:
 var d:=oku(o.haberci_agi)
 return "" if d.bekleyen.is_empty() else String(AYAR.kaynaklar[d.bekleyen[0].kaynak])
static func _ekle(a: Array,h: Dictionary) -> void:
 for i in a.size():
  if a[i].kaynak==h.kaynak:
   if int(h.gun)>=int(a[i].gun): a[i]=h.duplicate(true)
   return
 a.append(h.duplicate(true))
