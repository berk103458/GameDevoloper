## CAS-02: etkin gece meşaleli devriye yalnız gerçek fiili görür; niyet yakalanma değildir.
class_name CasusDevriyesi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/casus_devriyesi.json"))
const META := "casus_devriyesi"
## Eski/bozuk kayıt güvenli, tek pending tutanak; kalıcı kişinin kimliği korunur.
static func oku(v: Variant) -> Dictionary:
 var d := {"son_gece":-1,"kisi":-1,"gun":-1,"bekliyor":false,"secim":-1}
 if not v is Dictionary: return d
 for a in ["son_gece","kisi","gun","secim"]: d[a] = KurtBaskini.oku(v.get(a,-1))
 d.bekliyor = v.get("bekliyor",false) is bool and bool(v.get("bekliyor",false)) and d.kisi > 0 and d.gun >= 0
 return d
## Kayıt/önizleme salt kopyadır.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Mevcut etkin nöbet: borç/uyku/isyan/uzaktaki koruma mevcut API'de hariç. ANI gece meşalesi bu görevin donanımıdır.
static func sans(y: KoyYonetimi) -> float:
 var n := 0
 for k in y.koylular:
  if CirakEgitimi.saglam(k) and MuhafizMaasi.aday(k,y) and not MuhafizMaasi.borclu(k,y) and k.yas_grubu == &"yetiskin" and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k,y) and not KervanKorumasi.disarida(y,k.id): n += 1
 return 0.0 if n == 0 else clampf(float(AYAR.fener_taban) + n * float(AYAR.muhafiz_katkisi),0.0,float(AYAR.yakalama_ust))
## Gece sonu gerçek hırsızlık/sabotaj izlerinde tek suçüstü; mevcut kayıp ikinci kez uygulanmaz.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
 var d := durum(y)
 if y.son != "" or d.son_gece == y.gun: return
 d.son_gece = y.gun
 y.set_meta(META,d)
 if d.bekliyor or sans(y) == 0.0: return
 for x in CasusGeceTakibi.durum(y).izler:
  if int(x.gun) != y.gun or x.durum == "hedef": continue
  var k := y.koylu(int(x.kisi))
  if k == null or k.saglik <= 0: continue
  if not x.goruldu and y._rng.randf() >= sans(y): continue
  CasusGeceTakibi.kaydet(y,k,String(x.hedef),int(x.bina),String(x.durum),String(x.kaynak),int(x.kayip),true)
  if x.durum == "hirsizlik": k.bayrak_ac("hirsiz")
  d.kisi = k.id
  d.gun = y.gun
  d.bekliyor = true
  d.secim = -1
  y.set_meta(META,d)
  olaylar.append({"anahtar":"Meşaleli devriye %s kişisini suçüstü gördü; %s tutanağı hazır.","deger":[k.ad,"hırsızlık" if x.durum == "hirsizlik" else "sabotaj"]})
  return
## Aynı mevcut olay kartı; tutanak çözülene kadar yenisi üretilmez.
static func olay(o: Oturum) -> OlayVerisi:
 var d := durum(o.yonetim)
 if not d.bekliyor or o.yonetim.son != "": return null
 var k := o.yonetim.koylu(int(d.kisi))
 var e := OlayVerisi.new()
 e.id = StringName("cas02_tutanak_%d_%d" % [int(d.gun),int(d.kisi)])
 e.baslik_anahtari = "Gece devriyesi · suçüstü tutanağı"
 e.metin_anahtari = "Meşaleli devriye %s kişisini gerçek bir gece fiilinde gördü. Niyet değil gözlem kayda geçti; divan için tutanağı sakla veya bu gece uyarı ver." % (k.ad if k != null else "köyden ayrılmış")
 e.secenek_anahtarlari = PackedStringArray(["Tutanağı sakla · divana hazırlık", "Bu gece uyar · tutanakta şerh"])
 e.secenek_etkileri = [{},{}]
 return e
## Yalnız bu adaptörün gün/kişi kimliği.
static func tanimli(e: OlayVerisi) -> bool:
 return e != null and String(e.id).begins_with("cas02_tutanak_")
## Eski kart/çift tıklama/terminal oturum etkisizdir.
static func uygun(o: Oturum,e: OlayVerisi,i: int) -> bool:
 var gecerli := olay(o)
 return i in [0,1] and tanimli(e) and gecerli != null and e.id == gecerli.id
## Hukuki ceza burada verilmez; mevcut gözlem kaydı korunur, para/zar/hasar tekrarlanmaz.
static func uygula(o: Oturum,e: OlayVerisi,i: int) -> Dictionary:
 var r := {"ok":false,"kirilan":-1,"rusvet_harcandi":-1,"sonuc_anahtari":"Tutanak güncel değil.","oyun_puan":-1}
 if not uygun(o,e,i): return r
 var d := durum(o.yonetim)
 d.bekliyor = false
 d.secim = i
 o.yonetim.set_meta(META,d)
 r.ok = true
 r.sonuc_anahtari = "Gözlenen fiil tutanağı divan için saklandı." if i == 0 else "Uyarı şerhi tutanağa işlendi; gerçek fiil gözlemi korunur."
 return r
