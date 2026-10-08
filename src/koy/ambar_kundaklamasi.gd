## CAS-04: CHR kaynak kundaklaması, mevcut tek yangın/su/bina kaybı akışında.
class_name AmbarKundaklamasi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ambar_kundaklamasi.json"))
const META := "ambar_kundaklamasi"
## Güvenli eski/JSON kayıt; kapı snapshotu ve kişi başına tek fiil makbuzu.
static func oku(v: Variant) -> Dictionary:
 var d := {"son_gece":-1,"kisiler":{}}
 if not v is Dictionary: return d
 d.son_gece = KurtBaskini.oku(v.get("son_gece",-1))
 # Zehir adaptörüyle aynı karar kaydı biçimi; yalnız doğrulayıcı, zehir etkisi uygulanmaz.
 d.kisiler = KuyuZehirleme.oku({"kisiler":v.get("kisiler",{})}).kisiler
 while d.kisiler.size() > int(AYAR.azami_kayit): d.kisiler.erase(d.kisiler.keys()[-1])
 return d
## Kopya durum; UI gizli kimliği açıklamaz.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Aynı gerçek kabulün bayrak snapshotu; kışla/önlenen zehir gibi korunur.
static func kabul(y: KoyYonetimi,k: Koylu,g: Gelen,karar: StringName) -> void:
 if String(k.adli_id) not in AYAR.profiller: return
 var d := durum(y)
 d.kisiler[str(k.id)] = CasusGeceTakibi.kapi_bilgisi(g,karar)
 y.set_meta(META,d)
## Gerçek kaynak yangın sonucu; CHR001 rüşvetindeki odun çürümesi yangın diye uydurulmaz.
static func kaynak(k: Koylu,karar: String) -> Dictionary:
 var e := CasusGeceTakibi.gecikmeli(k,karar,"Erzak")
 for s in AYAR.yangin_sozcukleri:
  if String(e.get("kaynak","")).contains(String(s)): return e
 return {}
## Üretim öncesi hazır kaynak binası; aynı rezervle söndürme, kaynak statlar yalnız söndürülmeyende.
static func gece(y: KoyYonetimi,olaylar: Array[Dictionary]) -> int:
 var d := durum(y)
 if y.son != "" or d.son_gece == y.gun: return 0
 d.son_gece = y.gun
 y.set_meta(META,d)
 var tuketim := 0
 for k in y.koylular:
  if String(k.adli_id) not in AYAR.profiller: continue
  var x: Dictionary = d.kisiler.get(str(k.id),{"karar":"kabul","cozuldu":"sabotajci" in k.bayraklar or "casus" in k.bayraklar,"uygulandi":-1})
  if x.cozuldu or x.karar == "kisla" or x.uygulandi >= 0 or not CirakEgitimi.saglam(k) or IsKazalari.uyuyor(k) or MuhafizMaasi.aday(k,y) or KervanKorumasi.disarida(y,k.id): continue
  var e := kaynak(k,String(x.karar))
  if e.is_empty() or y.gun-k.giris_gunu+1 < int(e.tur_offset): continue
  var hedefler := preload("res://src/koy/chr_bina_sozlugu.gd").turler(String(e.hedef_bina))
  var hedef: KoyBinasi = null
  for b in y.binalar:
   if b.hazir() and b.tur in hedefler and (hedef == null or b.id < hedef.id): hedef = b
  if hedef == null: continue
  x.uygulandi = y.gun
  d.kisiler[str(k.id)] = x
  var sonuc := YazYanginRiski.sondur(y,hedef,olaylar,"Kundaklama yangını")
  tuketim += int(sonuc.su)
  var kayip := 0
  if not sonuc.kurtuldu:
   var stat := preload("res://src/sistemler/chr_runtime_sinirlari.gd").statlar(e.stat_etkisi)
   kayip = y.kaynaklar.azalt("gida",absi(int(stat.get("Erzak",0))))
   y.asayis_riski = clampi(y.asayis_riski-int(stat.get("Guvenlik",0)),0,100)
   for kisi in y.koylular:
    kisi.moral = clampi(kisi.moral+int(stat.get("Moral",0)),0,100)
    kisi.refah = clampi(kisi.refah+int(stat.get("Refah",0)),0,100)
   olaylar.append({"anahtar":"Kundaklama sonrası %d erzak kaybedildi; kaynak stat kaybı uygulandı, fail henüz gözlenmedi.","deger":[kayip]})
  CasusGeceTakibi.kaydet(y,k,"ambar",hedef.id,"kundaklama","gida",kayip,false)
 y.set_meta(META,d)
 return tuketim
