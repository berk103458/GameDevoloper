## CAS-01: gece hedef/fiil takip kaydı; hasar/zehir/ikinci suç RNG'si değildir.
class_name CasusGeceTakibi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/casus_gece_takibi.json"))
const META := "casus_gece_takibi"
## Hazır hedef ve gerçek yaşayan köylü: meslek görevi/CHR metni ezilmez; sağlıklı nöbetçi hariç.
static func plan(y: KoyYonetimi, k: Koylu) -> Dictionary:
 if y.son != "" or k == null or not CirakEgitimi.saglam(k) or IsKazalari.uyuyor(k) or MuhafizMaasi.aday(k, y) or KervanKorumasi.disarida(y, k.id): return {}
 return hedef(y,k)
## Aynı gerçek hedef seçimi; çağıran fiil motoru kendi kaynak/sağlık koşulunu doğrular.
static func hedef(y: KoyYonetimi,k: Koylu) -> Dictionary:
 var tur := String(AYAR.profiller.get(String(k.adli_id), ""))
 if tur.is_empty(): return {}
 var binalar := y.binalar.duplicate()
 binalar.sort_custom(func(a: KoyBinasi, b: KoyBinasi) -> bool: return a.id < b.id)
 for b in binalar:
  if b.hazir() and b.tur in AYAR.hedefler[tur]: return {"hedef":tur,"bina":b.id}
 if tur == "kuyu" and bool(AYAR.meydan_kuyusu): return {"hedef":tur,"bina":-1}
 return {}
## Optional bounded takip kaydı; bozuk satırlar/negatif miktar/eski kayıt güvenli biçimde elenir.
static func oku(v: Variant) -> Dictionary:
 var d := {"son_gece":-1,"izler":[]}
 if not v is Dictionary: return d
 d.son_gece = KurtBaskini.oku(v.get("son_gece", -1))
 if not v.get("izler") is Array: return d
 for x in v.izler:
  if not x is Dictionary or x.get("hedef") not in AYAR.hedefler or x.get("durum") not in ["hedef", "hirsizlik", "sabotaj", "zehirleme", "kundaklama"] or not x.get("goruldu") is bool: continue
  var g := KurtBaskini.oku(x.get("gun", -1))
  var k := KurtBaskini.oku(x.get("kisi", -1))
  var b := KurtBaskini.oku(x.get("bina", -1))
  var kayip := KurtBaskini.oku(x.get("kayip", -1))
  if g < 0 or k < 1 or kayip < 0 or b < -1 or not x.get("kaynak") is String: continue
  d.izler.append({"gun":g,"kisi":k,"bina":b,"hedef":String(x.hedef),"durum":String(x.durum),"kaynak":String(x.kaynak),"kayip":kayip,"goruldu":x.goruldu})
  if d.izler.size() >= int(AYAR.iz_azami): break
 return d
## Kayıt/query kendi kopyasını döndürür; oyuncunun açık bayraklarına gizli niyet sızmaz.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META, {}))
## Gecede tek plan kaydı; yalnız hazır hedefler, yeni maliyet/hasar/zar yok.
static func gece(y: KoyYonetimi) -> void:
 var d := durum(y)
 if y.son != "" or d.son_gece == y.gun: return
 d.son_gece = y.gun
 d.izler = d.izler.filter(func(x: Dictionary) -> bool: return int(x.gun) >= y.gun - int(AYAR.gecmis_gece) + 1)
 y.set_meta(META, d)
 for k in y.koylular:
  var p := plan(y, k)
  if not p.is_empty(): kaydet(y, k, String(p.hedef), int(p.bina), "hedef", "", 0, false)
## Var olan hırsızlık/sabotaj sonucunu kaydeder; suçun kendisi ve RNG mevcut motorlarda kalır.
static func kaydet(y: KoyYonetimi, k: Koylu, hedef: String, bina: int, fiil: String, kaynak: String, kayip: int, goruldu: bool) -> void:
 if k == null or hedef not in AYAR.hedefler or fiil not in ["hedef", "hirsizlik", "sabotaj", "zehirleme", "kundaklama"]: return
 var d := durum(y)
 var satir := {"gun":y.gun,"kisi":k.id,"bina":bina,"hedef":hedef,"durum":fiil,"kaynak":kaynak,"kayip":maxi(0,kayip),"goruldu":goruldu}
 for i in d.izler.size():
  var x: Dictionary = d.izler[i]
  if x.gun == y.gun and x.kisi == k.id and x.hedef == hedef:
   if x.durum == "hedef" or fiil != "hedef": d.izler[i] = satir
   y.set_meta(META, d)
   return
 if d.izler.size() >= int(AYAR.iz_azami): d.izler.pop_front()
 d.izler.append(satir)
 y.set_meta(META, d)
## CAS/Divan yalnız gözlenen gerçek fiilleri kanıt sayabilir; niyet tek başına suç kanıtı değildir.
static func acik_izler(y: KoyYonetimi) -> Array:
 return durum(y).izler.filter(func(x: Dictionary) -> bool: return x.goruldu and x.durum != "hedef")

## Kapı kararının aynı CHR bayrak snapshotu; kaynak verisi değişmez.
static func kapi_bilgisi(g: Gelen,karar: StringName) -> Dictionary:
 var s := g.chr_sorgusu()
 var cozuldu: bool = s != null and (bool(s.bayraklar.get("Flag_Sir_Tamamen_Cozuldu",false)) or bool(s.bayraklar.get("Flag_Yol_Sirri_Acik",false)))
 return {"karar":"kabul" if karar == &"harc" else String(karar),"cozuldu":cozuldu,"uygulandi":-1}
## Dar fiil adaptörleri sözleşmenin karar/tur/stat alanını aynı değişmez kaynakta bulur.
static func gecikmeli(k: Koylu,karar: String,stat: String) -> Dictionary:
 var v := load("res://data/chr_runtime/%s.tres" % String(k.adli_id).to_upper()) as KarakterVerisi
 if v == null: return {}
 for e in v.gecikmeli_etkiler:
  if e.get("karar","") == karar and int(e.get("stat_etkisi",{}).get(stat,0)) < 0: return e.duplicate(true)
 return {}
