## CAS-03: kaynak CHR gecikmeli zehir sonucu mevcut kuyu/sağlık/stok üzerinde bir kez.
class_name KuyuZehirleme
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/kuyu_zehirleme.json"))
const META := "kuyu_zehirleme"
## Optional kayıt: kapıdaki karar/sır ve gerçek uygulanmış gece makbuzu; JSON güvenli.
static func oku(v: Variant) -> Dictionary:
 var d := {"son_gece":-1,"tespit_gunu":-1,"icenen":0,"kisiler":{}}
 if not v is Dictionary: return d
 for a in ["son_gece","tespit_gunu"]: d[a] = KurtBaskini.oku(v.get(a,-1))
 d.icenen = maxi(0,KurtBaskini.oku(v.get("icenen",0)))
 if not v.get("kisiler") is Dictionary: return d
 for id in v.kisiler:
  var x: Variant = v.kisiler[id]
  if not id is String or not id.is_valid_int() or int(id) < 1 or not x is Dictionary or x.get("karar") not in ["kabul","rusvet","kisla"] or not x.get("cozuldu") is bool: continue
  d.kisiler[id] = {"karar":String(x.karar),"cozuldu":x.cozuldu,"uygulandi":KurtBaskini.oku(x.get("uygulandi",-1))}
  if x.has("bayraklar"): d.kisiler[id]["bayraklar"] = SabotajClueSozlesmesi.bayrak_oku(x.bayraklar)
  if d.kisiler.size() >= int(AYAR.azami_kayit): break
 return d
## Kopya sorgu; gizli kişilerin adları UI metnine taşınmaz.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META,{}))
## Gerçek kapı kararının CHR bayrakları; tam çözüm ve yol sırrı tohum/zehirin alınmasını sağlar.
static func kabul(y: KoyYonetimi,k: Koylu,g: Gelen,karar: StringName) -> void:
 if String(k.adli_id) not in AYAR.profiller: return
 var d := durum(y)
 d.kisiler[str(k.id)] = CasusGeceTakibi.kapi_bilgisi(g,karar)
 d.kisiler[str(k.id)]["bayraklar"] = SabotajClueSozlesmesi.kapidan(g)
 y.set_meta(META,d)
## Sadece bu maddenin kaynak kabul/rüşvet zehir olayı; genel gecikmeli olayları veya KAP-01'i yeniden yazmaz.
static func kaynak(k: Koylu,karar: String) -> Dictionary:
 return CasusGeceTakibi.gecikmeli(k,karar,"Saglik")
## Gerçek gece su raporu sonrası, sağlık/ölüm fazı öncesi; kaynak stat sınırı ve tek makbuz.
static func gece(y: KoyYonetimi,su: Dictionary,olaylar: Array[Dictionary]) -> void:
 var d := durum(y)
 if y.son != "" or d.son_gece == y.gun: return
 d.son_gece = y.gun
 y.set_meta(META,d)
 for k in y.koylular:
  if String(k.adli_id) not in AYAR.profiller: continue
  var x: Dictionary = d.kisiler.get(str(k.id),{"karar":"kabul","cozuldu":"sabotajci" in k.bayraklar or "casus" in k.bayraklar,"uygulandi":-1})
  if not SabotajClueSozlesmesi.kaynak_uygun(k,AYAR.clue_sozlesmesi): continue
  if SabotajClueSozlesmesi.guvene_alindi(x) or x.karar == "kisla" or int(x.uygulandi) >= 0: continue
  var e := kaynak(k,String(x.karar))
  if e.is_empty() or y.gun-k.giris_gunu+1 < int(e.tur_offset): continue
  if DivanHukmu.zindanda(k) or k.saglik <= 0 or k.ac or KisHastaligi.hasta(k) or "hasta" in k.bayraklar or "agir_yarali" in k.bayraklar+k.gizli_bayraklar or IsKazalari.uyuyor(k) or MuhafizMaasi.aday(k,y) or KervanKorumasi.disarida(y,k.id): continue
  # CHR002 eski gizli hasta etiketi banotu deri nişanıdır; kapıdaki fiziksel sır fırsatı kalıcı kapatmaz.
  var p := CasusGeceTakibi.hedef(y,k)
  if p.is_empty() or p.hedef != "kuyu": continue
  x.uygulandi = y.gun
  d.kisiler[str(k.id)] = x
  # Aynı gerçek kuyu akışını içenler; depoda önce ayrılmış su bu fiilden etkilenmez.
  var ihtiyac := maxi(1,SuDengesi.gerek(y)/maxi(1,y.nufus()))
  var sayi := mini(y.nufus(),ceili(float(su.get("taze",0))/ihtiyac))
  var stat := preload("res://src/sistemler/chr_runtime_sinirlari.gd").statlar(e.stat_etkisi)
  var saglik := absi(int(stat.get("Saglik",0)))
  var etkilenen := 0
  for hasta in y.koylular.slice(0,sayi):
   if hasta.saglik <= 0 or KervanKorumasi.disarida(y,hasta.id): continue
   hasta.saglik = maxi(0,hasta.saglik-saglik)
   etkilenen += 1
  for kisi in y.koylular:
   kisi.moral = clampi(kisi.moral+int(stat.get("Moral",0)),0,100)
  y.asayis_riski = clampi(y.asayis_riski-int(stat.get("Guvenlik",0)),0,100)
  y.kaynaklar.azalt("gida",absi(int(stat.get("Erzak",0))))
  CasusGeceTakibi.kaydet(y,k,"kuyu",int(p.bina),"zehirleme","saglik",saglik*etkilenen,false)
  d.tespit_gunu = y.gun+1
  d.icenen = etkilenen
  olaylar.append({"anahtar":"Sabah kuyuda zehirlenme/salgın şüphesi: %d kişide −%d sağlık. Kaynak suyu incele; fail henüz gözlenmedi.","deger":[etkilenen,saglik]})
 y.set_meta(META,d)
## Aynı su kartı: belirtiler halka açık, şüpheli kimliği yalnız suçüstü tutanağında.
static func tip(y: KoyYonetimi) -> String:
 var d := durum(y)
 var bilinen := 0
 for k in y.koylular:
  if SabotajClueSozlesmesi.bulunan_yuk(k,AYAR.clue_sozlesmesi): bilinen += 1
 var bilgi := "\nKapıda keşfedilmiş zehir malzemesi yük ipucu: %d. İpucu tek başına gece failinin gözlemi değildir." % bilinen if bilinen > 0 else ""
 return bilgi + ("\nSon kuyu zehirlenmesi tespiti: %d. gün · %d kişi. Sağlık raporu tek başına fail kanıtı değildir." % [int(d.tespit_gunu)+1,int(d.icenen)] if d.tespit_gunu >= 0 else "")
