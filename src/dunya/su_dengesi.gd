class_name SuDengesi
extends RefCounted
const META := &"su_doldurma"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/yaz_su_yangin.json"))
## Su arzı mevcut meydan kuyusu; ambar yalnız oyuncunun ayırdığı rezervi tutar.
static func gerek(y: KoyYonetimi) -> int:
 return y.nufus() * int(AYAR.kisi_su) * (int(AYAR.yaz_carpani) if y.mevsim() == 1 or IklimDeneyi.hava(y) == "kuraklik" else 1)
## Günlük doldurma makbuzu güvenli optional kayıt.
static func oku(v: Variant) -> Dictionary:
 var r := {"gun":-1,"adet":0,"son_gece":-1,"yangin_gun":-1,"rapor":{}}
 if not v is Dictionary: return r
 for alan in ["gun", "adet", "son_gece", "yangin_gun"]:
  var n: Variant = v.get(alan)
  if (n is int or n is float) and is_finite(float(n)) and float(n)==floor(float(n)) and float(n)>=(-1 if alan!="adet" else 0) and float(n)<=(1000000000 if alan!="adet" else int(AYAR.kuyu_gunluk)): r[alan]=int(n)
 if v.get("rapor") is Dictionary:
  var rapor := {}
  for alan in ["ihtiyac","taze","depo","eksik"]:
   var n: Variant = v.rapor.get(alan)
   if (n is int or n is float) and is_finite(float(n)) and float(n)==floor(float(n)) and float(n)>=0 and float(n)<=1000000000: rapor[alan]=int(n)
  if rapor.size()==4 and rapor.ihtiyac==rapor.taze+rapor.depo+rapor.eksik: r.rapor=rapor
 if r.rapor.is_empty(): r.son_gece=-1
 return r
## Kayıt/önizleme canlı gün veya RNG değiştirmez.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META, {}))
## Eski kayıt varsayılan sıfır makbuzla açılır.
static func yukle(y: KoyYonetimi, v: Variant) -> void:
 y.set_meta(META, oku(v))
## Ayrılmış rezerv aynı gün kuyunun kalan akışından düşer; çift arz yoktur.
static func taze(y: KoyYonetimi) -> int:
 var r := durum(y)
 return maxi(0, int(AYAR.kuyu_gunluk) - (int(r.adet) if int(r.gun)==y.gun else 0))
## Mevcut ortak ambara tek parti; günlük kuyu sınırı, kamu akçesi ve kapasite ön kontrolü.
static func doldurabilir(y: KoyYonetimi) -> bool:
 return y.son == "" and not KuyuKirliligi.kirli(y) and y.nufus()>0 and taze(y)>=int(AYAR.doldurma_parti) and y.akce>=int(AYAR.doldurma_akce) and y.kaynaklar.bos_yer()>=int(AYAR.doldurma_parti)
## Başarı tek kamu tahsilatı ve tek ortak rezerv eklemesidir.
static func doldur(y: KoyYonetimi) -> bool:
 if not doldurabilir(y): return false
 var r := durum(y)
 if int(r.gun)!=y.gun:
  r.gun=y.gun
  r.adet=0
 r.adet = int(r.adet)+int(AYAR.doldurma_parti)
 y.akce -= int(AYAR.doldurma_akce)
 y.kaynaklar.ekle("su", int(AYAR.doldurma_parti))
 y.set_meta(META, r)
 return true
## Mevcut geceye günlük taze akış + aynı ambar rezervi; sağlığı mevcut faz çözer.
static func gece(y: KoyYonetimi, tuketim: Dictionary, olaylar: Array[Dictionary]) -> Dictionary:
 var makbuz := durum(y)
 if int(makbuz.son_gece)==y.gun: return makbuz.rapor.duplicate()
 var ihtiyac := gerek(y)
 var akan := mini(ihtiyac, taze(y))
 var depo := y.kaynaklar.azalt("su", maxi(0, ihtiyac-akan))
 tuketim["su"] = int(tuketim.get("su",0))+depo
 var eksik := maxi(0, ihtiyac-akan-depo)
 if eksik>0:
  var kisi := int(AYAR.kisi_su)*(int(AYAR.yaz_carpani) if y.mevsim()==1 or IklimDeneyi.hava(y)=="kuraklik" else 1)
  var sayi := ceili(float(eksik)/maxi(1,kisi))
  for k in y.koylular.slice(maxi(0,y.koylular.size()-sayi)): k.saglik=maxi(0,k.saglik-int(AYAR.susuz_saglik))
  olaylar.append({"anahtar":"Su ihtiyacı %d; kuyu %d, rezerv %d, eksik %d. Susuz kalanlarda −%d sağlık.","deger":[ihtiyac,akan,depo,eksik,int(AYAR.susuz_saglik)]})
 var rapor := {"ihtiyac":ihtiyac,"taze":akan,"depo":depo,"eksik":eksik}
 makbuz.son_gece=y.gun
 makbuz.rapor=rapor
 y.set_meta(META,makbuz)
 return rapor
## Aynı kaynak kartında arz/rezerv/ihtiyaç açıklaması.
static func tip(y: KoyYonetimi) -> String:
 return "Su rezervi · Gecelik ihtiyaç: %d · kalan kuyu akışı: %d. Yaz/kuraklık tüketimi ×%d. Pazarda kuyudan rezerv ayırabilirsin." % [gerek(y),taze(y),int(AYAR.yaz_carpani)] + "\n" + KuyuKirliligi.metin(y) + KuyuZehirleme.tip(y)


## ISG-02: işçi aynı meydan kuyusundan rezerv taşır; günlük akış makbuzu ortaktır.
## Elle doldurma bedeli yazılmaz: emek geçici iş ataması ve mevcut erzak payıdır.
static func isci_tasidi(y: KoyYonetimi, istenen: int) -> int:
 var miktar := mini(maxi(0,istenen),taze(y))
 var giren := y.kaynaklar.ekle("su",miktar)
 if giren <= 0: return 0
 var r := durum(y)
 if int(r.gun) != y.gun:
  r.gun = y.gun
  r.adet = 0
 r.adet = int(r.adet) + giren
 y.set_meta(META,r)
 return giren
