## CAS-12: mevcut CHR Clue/Flag adlarını koruyan dar sabotaj kaynak sözleşmesi.
class_name SabotajClueSozlesmesi
extends RefCounted
## Yalnız kaynak sözleşmedeki dört bool; string true veya yeni isim uydurulmaz.
static func bayrak_oku(v: Variant) -> Dictionary:
 var d: Dictionary={}
 for a in ChrSozlesmesi.BAYRAKLAR: d[String(a)]=v.get(String(a),false) is bool and bool(v.get(String(a),false)) if v is Dictionary else false
 return d
static func kapidan(g: Gelen) -> Dictionary:
 var s: ChrSorgusu=g.chr_sorgusu()
 return bayrak_oku(s.bayraklar if s!=null else {})
## Gerçek kaynak nişan/yük/görsel Clue; keşif başka, malzemenin kaynakta var olması başkadır.
static func kaynak_uygun(k: Koylu,tablo: Dictionary) -> bool:
 var x: Variant=tablo.get(String(k.adli_id))
 var v:=DivanKanit.kaynak(k)
 if v==null or not x is Dictionary: return false
 return x.get("nisan")==String(v.obje_ipucu(1)) and x.get("yuk")==String(v.obje_ipucu(2)) and x.get("gorsel")==String(v.gorsel_hata_ipucu)
## Eski cozuldu kararını korur; raw kaynak bayrak varsa tam/yol çözümü de tehlikeyi kapatır.
static func guvene_alindi(x: Dictionary) -> bool:
 if bool(x.get("cozuldu",false)): return true
 if not x.has("bayraklar"): return false
 var b:=bayrak_oku(x.bayraklar)
 return bool(b.Flag_Sir_Tamamen_Cozuldu) or bool(b.Flag_Yol_Sirri_Acik)
## Bilinen yük kimliği aynı DivanKanit kaydından; yeni Clue listesi saklanmaz.
static func bulunan_yuk(k: Koylu,tablo: Dictionary) -> bool:
 return kaynak_uygun(k,tablo) and String(tablo[String(k.adli_id)].yuk) in DivanKanit.durum(k).ipuclar
