## CAS-06/11: kapıdaki gerçekten bulunan Clue kimliklerinin tek kalıcı devamı; ikinci kart/kanıt deposu yok.
class_name DivanKanit
extends RefCounted
const META := "divan_kanit"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/divan_sorgusu.json"))
## Geçerli kaynak CHR; sahte/eksik kimlik yükleme hatası üretmez.
static func kaynak(k: Koylu) -> KarakterVerisi:
 var id := String(k.adli_id)
 if id.length()!=7 or not id.begins_with("chr_") or not id.right(3).is_valid_int(): return null
 var yol := "res://data/chr_runtime/%s.tres" % id.to_upper()
 return load(yol) as KarakterVerisi if ResourceLoader.exists(yol) else null
## Aynı üç kaynak ipucu; açıklama/isim kaynak Resource'tan, yeni CSV anahtarı yok.
static func ipuclari(k: Koylu) -> Dictionary:
 var v := kaynak(k)
 if v == null: return {}
 var d := {}
 for i in [1,2]:
  var id := String(v.obje_ipucu(i))
  if id.begins_with("Clue_"): d[id] = {"baslik":"Nişan kanıtı" if i==1 else "Yük kanıtı","aciklama":String((v.obje_1 if i==1 else v.obje_2).get("aciklama",""))}
 if String(v.gorsel_hata_ipucu).begins_with("Clue_"): d[String(v.gorsel_hata_ipucu)]={"baslik":"Fiziksel iz kanıtı","aciklama":v.gorsel_hata}
 return d
## Optional kalıcı devam: yalnız kaynakta tanımlı gerçek bulunan kimlik; sunulan altküme ve geçerli itiraf makbuzu.
static func oku(k: Koylu,v: Variant) -> Dictionary:
 var d := {"ipuclar":[],"sunulan":[],"itiraf":false}
 if not v is Dictionary: return d
 var izin := ipuclari(k)
 if v.get("ipuclar") is Array:
  for a in v.ipuclar:
   if a is String and izin.has(a) and not a in d.ipuclar: d.ipuclar.append(a)
 if v.get("sunulan") is Array:
  for a in v.sunulan:
   if a is String and a in d.ipuclar and not a in d.sunulan: d.sunulan.append(a)
 d.itiraf = v.get("itiraf",false) is bool and bool(v.get("itiraf",false)) and yeterli(k,d)
 return d
## Kopya sorgu; eski kayıt ipucu keşfetmiş sayılmaz.
static func durum(k: Koylu) -> Dictionary:
 return oku(k,k.get_meta(META,{}))
## Ziyaret bitince mevcut IpucuYoneticisi kimlikleri köylü kaydında devam eder; kaynak/kapı sorgusu değiştirilmez.
static func devral(k: Koylu,g: Gelen) -> void:
 var s := g.chr_sorgusu()
 if s == null: return
 var ids: Array = []
 for id in s.ipuclari:
  if s.ipuclari[id] == true: ids.append(String(id))
 k.set_meta(META,oku(k,{"ipuclar":ids}))
## Kapıda bulunan gerçek kanıt yalnız mevcut duruşmada sunulur; tekrar tek kimliktir.
static func sun(y: KoyYonetimi,id: int,clue: String) -> bool:
 if not id in DivanOturumu.adaylar(y): return false
 var k := y.koylu(id)
 var d := durum(k)
 if not clue in d.ipuclar or clue in d.sunulan or d.itiraf: return false
 d.sunulan.append(clue)
 k.set_meta(META,d)
 return true
## Denge: en az iki bağımsız kaynak Clue ve bulunan yük/suç aleti gerekir; yalnız kaynak CAS şüphelileri.
static func yeterli(k: Koylu,d: Dictionary) -> bool:
 var v := kaynak(k)
 return v != null and String(k.adli_id) in CasusGeceTakibi.AYAR.profiller and d.sunulan.size()>=int(AYAR.gerekli_ipucu) and String(v.obje_ipucu(2)) in d.sunulan
## Gözlenmiş gerçek fiil + eşleşen bulunan/sunulan kaynak kanıt; otomatik niyet itirafı veya RNG yok.
static func sorgula(y: KoyYonetimi,id: int) -> bool:
 if not id in DivanOturumu.adaylar(y): return false
 var k := y.koylu(id)
 var d := durum(k)
 if d.itiraf or not yeterli(k,d): return false
 d.itiraf = true
 k.set_meta(META,d)
 return true
