## TUC-05: ziyaret başına deterministik teklif ve kalıcı kabul defteri.
class_name SiparisSozlesmeleri
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/siparis_sozlesmeleri.json"))
var sozlesmeler: Dictionary = {}
## Mevcut ziyaretin değiştirilemeyen teklif kopyası; başka RNG veya takvim yok.
static func teklif(y: KoyYonetimi) -> Dictionary:
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 if not d.aktif or not AYAR.teklifler.has(d.tuccar.id): return {}
 var t: Dictionary = AYAR.teklifler[d.tuccar.id].duplicate(true)
 t.adet = int(t.adet)
 t.odul = int(t.odul)
 t.merge({"id": "%s:%d" % [d.tuccar.id, d.gelis_gunu], "tuccar": d.tuccar.id, "ad": d.tuccar.ad})
 return t
## Açık sipariş sayısı; zaman yalnız mevcut oyun gününden okunur.
func aktif_sayisi() -> int:
 var n := 0
 for s in sozlesmeler.values():
  if s.durum == "bekliyor": n += 1
 return n
## Bir ziyaretin teklifini iki konaklama gününde yalnız bir kez kabul edebilir.
func kabul_edilebilir(y: KoyYonetimi) -> bool:
 var t := teklif(y)
 return not t.is_empty() and not sozlesmeler.has(t.id) and aktif_sayisi() < int(AYAR.azami_aktif)
## Kabul stok/kasa harcamaz; taahhüdü ve yedi günlük vadeyi kalıcı kaydeder.
func kabul(y: KoyYonetimi) -> bool:
 if not kabul_edilebilir(y): return false
 var t := teklif(y)
 t.merge({"kabul_gunu": y.gun + 1, "vade": y.gun + 1 + int(AYAR.sure), "durum": "bekliyor"})
 sozlesmeler[t.id] = t
 return true
## Kullanıcı/snapshot işlemlerine bağımsız sözlük verir.
func kaydet() -> Dictionary:
 return sozlesmeler.duplicate(true)
## Optional eski alan yoksa boş defter; bozuk terimler ve tarihler reddedilir.
static func kayittan(v: Variant) -> SiparisSozlesmeleri:
 var s := SiparisSozlesmeleri.new()
 if not v is Dictionary: return s
 for key in v:
  var d: Variant = v[key]
  if not d is Dictionary or not d.get("id") is String or d.id != key or not AYAR.teklifler.has(d.get("tuccar", "")): continue
  if not d.get("urun") in Kaynaklar.TURLER or not d.get("ad") is String or d.get("durum") not in ["bekliyor", "teslim", "ihlal"]: continue
  var olur := true
  for a in ["adet", "odul", "kabul_gunu", "vade"]:
   var n: Variant = d.get(a)
   if not (n is int or n is float) or not is_finite(float(n)) or float(n) < 1 or float(n) > 1000000 or floor(float(n)) != float(n): olur = false
  if not olur or int(d.vade) < int(d.kabul_gunu): continue
  s.sozlesmeler[key] = {"id": d.id, "tuccar": d.tuccar, "ad": d.ad, "urun": d.urun, "adet": int(d.adet), "odul": int(d.odul), "kabul_gunu": int(d.kabul_gunu), "vade": int(d.vade), "durum": d.durum}
 return s
