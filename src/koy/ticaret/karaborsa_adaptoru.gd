## TUC-11: yalnız kişisel keseden mevcut muhafız eşya envanterine kaçak alım.
class_name KaraborsaAdaptoru
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/kisisel_karaborsa.json"))
## Aynı Silah uzmanı ziyareti; mevcut borç ambargosu ve oyun sonu korunur.
static func geldi(o: Oturum) -> bool:
 return o.yonetim.son == "" and SilahKaraborsasi.geldi(o.yonetim)
## Aynı kayıtlı eşya satırının bu ziyaret makbuzuna göre kalan stok; saf sorgu.
static func kalan(o: Oturum, id: String) -> int:
 if not geldi(o) or not AYAR.has(id): return 0
 var d := GezginTuccarTakvimi.durum(o.yonetim.gun, o.yonetim.a.kervan_araligi)
 for e in o.muhafiz_esyalari:
  if e.get("id") == "karaborsa_" + id and _sayi(e.get("son_varis", -1)) == d.gelis_gunu:
   return maxi(0, int(AYAR[id].stok) - _sayi(e.get("ziyaret_adet", 0)))
 return int(AYAR[id].stok)
## Kamu kasası veya ambar bu koşula finansman olamaz.
static func alinabilir(o: Oturum, id: String) -> bool:
 if kalan(o, id) <= 0 or o.muhafiz_akce < int(AYAR[id].fiyat): return false
 for e in o.muhafiz_esyalari:
  if e.get("id") == "karaborsa_" + id and _sayi(e.get("adet", 0)) >= 1000000000: return false
 return true
## Başarıda tek kişisel tahsilat/eşya satırı; ziyaret makbuzu aynı envanterde kalır.
static func al(o: Oturum, id: String) -> bool:
 if not alinabilir(o, id): return false
 var d := GezginTuccarTakvimi.durum(o.yonetim.gun, o.yonetim.a.kervan_araligi)
 var e: Dictionary = {}
 for kayit in o.muhafiz_esyalari:
  if kayit.get("id") == "karaborsa_" + id: e = kayit; break
 if e.is_empty():
  e = {"id": "karaborsa_" + id, "tur": "kacak", "ad": AYAR[id].ad, "adet": 0, "deger": int(AYAR[id].fiyat), "son_varis": -1, "ziyaret_adet": 0}
  o.muhafiz_esyalari.append(e)
 if _sayi(e.get("son_varis", -1)) != d.gelis_gunu: e.ziyaret_adet = 0
 e.son_varis = int(d.gelis_gunu)
 e.ziyaret_adet = _sayi(e.ziyaret_adet) + 1
 e.adet = _sayi(e.adet) + 1
 o.muhafiz_akce -= int(AYAR[id].fiyat)
 o.koy.degisti.emit()
 return true
## Mevcut kişisel eşya loaderına isteğe bağlı güvenli ziyaret makbuzu ekler.
static func kayit(e: Dictionary) -> void:
 for id in AYAR:
  if e.get("id") != "karaborsa_" + id: continue
  e.adet = _sayi(e.get("adet", 0))
  e.son_varis = _sayi(e.get("son_varis", 0))
  e.ziyaret_adet = mini(int(AYAR[id].stok), _sayi(e.get("ziyaret_adet", 0)))
static func _sayi(v: Variant) -> int:
 return int(v) if (v is int or v is float) and is_finite(float(v)) and float(v) >= 0 and float(v) <= 1000000000 and floor(float(v)) == float(v) else 0
