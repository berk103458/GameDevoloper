## HAR-02: gerçek gün üzerinden öncü tehdidi ve tek gece uyarı makbuzu.
class_name MogolOncusu
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/mogol_oncusu.json"))
## Optional defter yalnız izinli uyarı eşiklerini tutar; eski kayıt geçmiş uyarı uydurmaz.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"son_gece":-1,"uyarilar":[]}
 if not v is Dictionary: return d
 var n: Variant=v.get("son_gece")
 if (n is int or n is float) and is_finite(float(n)) and floor(float(n))==float(n) and float(n)>=-1 and float(n)<=1000000000: d.son_gece=int(n)
 var a: Variant=v.get("uyarilar")
 if a is Array:
  for x in a:
   if (x is int or x is float) and is_finite(float(x)) and floor(float(x))==float(x) and int(x) in _esikler() and not int(x) in d.uyarilar: d.uyarilar.append(int(x))
 return d
## Geri sayım salt okunur, bakiye veya ikinci gün sayacı değildir.
static func durum(o: Oturum) -> Dictionary:
 var kalan:=maxi(0,int(AYAR.varis_gunu)-maxi(0,o.gun))
 return {"ad":String(AYAR.ad),"kalan":kalan,"sinirda":kalan==0}
## Aynı harita bilgi alanına insan metni verir; geliş tarihi dış JSON varsayımıdır.
static func metin(o: Oturum) -> String:
 return olay_metin(durum(o))
## Tamamlanan gerçek gece eşiği bir kez aynı rapora eklenir; savaş/para/zar eklenmez.
static func gece(o: Oturum,r: Dictionary) -> void:
 var no:=int(r.gun)+1
 var d:=oku(o.mogol_oncusu)
 if o.yonetim.son!="" or no<=int(d.son_gece): return
 d.son_gece=no
 var kalan:=maxi(0,int(AYAR.varis_gunu)-no)
 if kalan in _esikler() and not kalan in d.uyarilar:
  d.uyarilar.append(kalan)
  var dis_hat = preload("res://src/sistemler/dis_hat_kapisi.gd")
  if dis_hat.izin(o.yonetim, dis_hat.SONUC if kalan == 0 else dis_hat.HABER, -1):
   r.olaylar.append({"anahtar":&"koy.olay.mogol_oncusu","deger":[],"mogol_oncusu":{"ad":String(AYAR.ad),"kalan":kalan,"sinirda":kalan==0}})
 o.mogol_oncusu=d
## Aynı sabah raporu ve harita tek uyarı dilini kullanır; CSV anahtarı sızmaz.
static func olay_metin(d: Dictionary) -> String:
 return String(AYAR.varis_metin) if int(d.kalan)==0 else String(AYAR.yaklasma_metin)%int(d.kalan)

static func _esikler() -> Array[int]:
 var a: Array[int]=[]
 for n in AYAR.uyari_kalan: a.append(int(n))
 return a
