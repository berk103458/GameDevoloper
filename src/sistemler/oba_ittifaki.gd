## HAR-07: buğday ittifakı; aynı lojistik ve gerçek köylü kaydı, ayrı ekonomi yok.
class_name ObaIttifaki
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/oba_ittifaki.json"))
## Optional günlük makbuz; sınırsız bayrak veya ayrı hayvan/nüfus kayıtları yok.
static func oku(v: Variant) -> Dictionary:
 var d:={"son_gun":-1,"takas":""}
 if v is Dictionary:
  d.son_gun=KurtBaskini.oku(v.get("son_gun",-1))
  if v.get("takas") in ["at","alp"]: d.takas=String(v.takas)
 return d
## İttifak mevcut kalıcı oturum bayrağıdır; anlaşma veya başarılı takasla kurulur.
static func muttefik(o: Oturum) -> bool:
 return o.bayraklar.has(StringName(AYAR.ittifak_bayragi))
static func ittifak_kur(o: Oturum) -> void:
 o.bayraklar[StringName(AYAR.ittifak_bayragi)]=true
## Günlük sınır, gerçek kaynaklar ve tamamlanmış ortak barınak/yatak kapasitesi.
static func uygun(o: Oturum,tur: String) -> bool:
 var y:=o.yonetim
 if y.son!="" or tur not in ["at","alp"] or int(oku(o.oba_ittifaki).son_gun)>=o.gun: return false
 var dis_hat = preload("res://src/sistemler/dis_hat_kapisi.gd")
 if not dis_hat.izin(y, dis_hat.TALEP): return false
 var bedel:=int(AYAR.at_bugday if tur=="at" else AYAR.alp_bugday)
 if y.kaynaklar.miktar("bugday")<bedel: return false
 if tur=="at": return CelepHamdullah.sayi(y.lojistik,"beygir")<CelepHamdullah.kapasite(y,"beygir")
 return y.yatak_kapasitesi()>y.nufus()
## Tek atomik eylem; para ve RNG tüketmez, mevcut kabul/köprü API'sini kullanır.
static func takas(o: Oturum,tur: String) -> Dictionary:
 if not uygun(o,tur): return {"ok":false}
 var y:=o.yonetim
 var bedel:=int(AYAR.at_bugday if tur=="at" else AYAR.alp_bugday)
 if not y.kaynaklar.harca({"bugday":bedel}): return {"ok":false}
 if tur=="at": y.lojistik.hayvanlar.beygir=int(y.lojistik.hayvanlar.beygir)+1
 else:
  y.kabul({"ad":String(AYAR.alp_ad),"sinif":"asker","stat":int(AYAR.alp_stat)})
  o._koy_esitle()
 o.oba_ittifaki={"son_gun":o.gun,"takas":tur}
 ittifak_kur(o)
 return {"ok":true}
## Saf pazar durum metni; yalnız açık kaynak ve gün bilgisi, gizli CHR bilgisi yok.
static func tip(o: Oturum) -> String:
 var y:=o.yonetim
 var d:=oku(o.oba_ittifaki)
 var s:="İttifak kuruldu" if muttefik(o) else "İttifak kurulmadı"
 return "%s\n%s\n%s · buğday %d · ortak ahır %d/%d · nüfus/yatak %d/%d%s"%[String(AYAR.baslik),String(AYAR.aciklama),s,y.kaynaklar.miktar("bugday"),CelepHamdullah.sayi(y.lojistik,"beygir"),CelepHamdullah.kapasite(y,"beygir"),y.nufus(),y.yatak_kapasitesi()," · bugün takas yapıldı" if int(d.son_gun)>=o.gun else ""]
