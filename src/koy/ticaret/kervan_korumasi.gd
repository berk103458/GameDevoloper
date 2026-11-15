## TUC-15: aynı köylü/kışla kaydının süreli kervan görevi.
class_name KervanKorumasi
extends RefCounted
const SAVUNMA_GUVENLIGI = preload("res://src/koy/savunma_guvenligi.gd")
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/kervan_korumasi.json"))
## Gün mevcut oyun saatinden; süresi dolunca atama değiştirmeden köye döner.
static func disarida(y: KoyYonetimi, id: int) -> bool:
 var s: Dictionary = y.kervan_koruma.get(str(id), {})
 return y.koylu(id) != null and not s.is_empty() and y.gun >= int(s.baslangic) and y.gun < int(s.donus)
## Mevcut nüfustaki etkin görevler; ölü/silinmiş kişi güvenlik düşürmez.
static func sayi(y: KoyYonetimi) -> int:
 var n := 0
 for k in y.koylular:
  if disarida(y, k.id): n += 1
 return n
## Tek Güvenlik hesabı: temel asayiş + HAR-15 hazırlık − geçici dış görev kaybı.
static func guvenlik(y: KoyYonetimi) -> int:
 var taban := float(100 - y.asayis_riski + SAVUNMA_GUVENLIGI.katkisi(y) - sayi(y) * int(AYAR.guvenlik_kaybi))
 var c := OzelEsyalar.carpan(y, "guvenlik")
 return clampi(roundi(taban) if is_equal_approx(c, 1.0) else ceili(taban * c), 0, 100)
## Kışlanın gerçekten etkin, borçsuz ve boşta kiralanabilir yetişkin nöbetçisi.
static func aday(y: KoyYonetimi, id: int) -> bool:
 var k := y.koylu(id)
 if KarantinaYoneticisi.aktif(k) or not HaneEsi.izinli_mi(k, "kervan"): return false
 if k == null or disarida(y, id) or k.yas_grubu != &"yetiskin": return false
 var b := y.bina(k.is_yeri)
 return b != null and b.hazir() and b.tur == "muhafiz_kislasi" and MuhafizMaasi.aday(k, y) and not MuhafizMaasi.borclu(k, y) and not IsKazalari.uyuyor(k) and not IsMemnuniyeti.isyanci(k, y)
## Mevcut ziyaret ve kapı/borç kısıtları; aynı ziyarette birden çok peşinat yoktur.
static func uygun(y: KoyYonetimi, id: int) -> bool:
 if y.son != "" or not y.kervan_gunu() or not aday(y, id) or y.akce > 9223372036854775807 - int(AYAR.pesin_akce): return false
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 var n := 0
 for s in y.kervan_koruma.values():
  if s.varis == d.gelis_gunu: n += 1
 return n < int(AYAR.ziyaret_azami)
## Peşinat yalnız kamuya; kişi/atama/bordro korunur, yerel nöbet katkısı dışarıda kalır.
static func kirala(y: KoyYonetimi, id: int) -> bool:
 if not uygun(y, id): return false
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 y.kervan_koruma[str(id)] = {"baslangic": y.gun, "donus": y.gun + int(AYAR.sure_gun), "varis": int(d.gelis_gunu), "tuccar": String(d.tuccar.id), "alinan": int(AYAR.pesin_akce)}
 y.akce += int(AYAR.pesin_akce)
 return true
## Eski boş alan güvenli; bozuk süre/id/ücret veya uzman makbuzu yüklenmez.
static func oku(v: Variant) -> Dictionary:
 var r := {}
 if not v is Dictionary: return r
 for key in v:
  if not key is String or not key.is_valid_int() or key.to_int() < 0 or key.to_int() > 1000000: continue
  var s: Variant = v[key]
  if not s is Dictionary: continue
  var valid := true
  for alan in ["baslangic", "donus", "varis", "alinan"]:
   var n: Variant = s.get(alan)
   if not (n is int or n is float) or not is_finite(float(n)) or floor(float(n)) != float(n) or float(n) < 0 or float(n) > 1000000: valid = false
  if not valid or int(s.donus) <= int(s.baslangic) or int(s.varis) < 1: continue
  var uzman := false
  for u in GezginTuccarTakvimi.AYAR.uzmanlar:
   if u.id == s.get("tuccar"): uzman = true
  if not uzman: continue
  r[str(key.to_int())] = {"baslangic": int(s.baslangic), "donus": int(s.donus), "varis": int(s.varis), "alinan": int(s.alinan), "tuccar": String(s.tuccar)}
 return r
