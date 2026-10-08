## TUC-03: uzman satıcının sınırlı ziyaret stoğu; tek köy ambarına teslim.
class_name GezginTuccarStogu
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/gezgin_tuccar_stogu.json"))
var varis := -1
var alinan: Dictionary = {}
## Geçerli uzman ürünleri; panel okumaları kaydı değiştirmez.
static func urunler(y: KoyYonetimi) -> Dictionary:
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 if d.aktif and SiparisIhlali.terk(y, d.tuccar.id): return {}
 var urun: Dictionary = AYAR.get(d.tuccar.id, {}).duplicate(true) if d.aktif else {}
 urun.merge(SiparisTeslimati.nadir(y, d), false)
 for tur in urun: urun[tur].fiyat = ceili(float(urun[tur].fiyat) * TicaretFiyatlari.carpan(y, tur))
 return urun
## Aynı ziyaretin iki gününde ortak stok; yeni varışta taban stok.
func kalan(y: KoyYonetimi, tur: String) -> int:
 var urun: Dictionary = urunler(y).get(tur, {})
 if urun.is_empty(): return 0
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 return maxi(0, int(urun.stok) - (int(alinan.get(tur, 0)) if varis == d.gelis_gunu else 0))
## Tam sipariş tek kamu kasası/ambar işlemiyle kabul edilir; kısmi tahsilat yok.
func alinabilir(y: KoyYonetimi, tur: String, adet: int) -> bool:
 var urun: Dictionary = urunler(y).get(tur, {})
 return adet > 0 and not urun.is_empty() and kalan(y, tur) >= adet and y.kaynaklar.bos_yer() >= adet and y.akce >= int(urun.fiyat) * adet
## Başarı koşulu tekrar doğrulanır; eski ziyaret ancak başarılı işlemde yenilenir.
func al(y: KoyYonetimi, tur: String, adet: int) -> bool:
 if not alinabilir(y, tur, adet): return false
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 if varis != d.gelis_gunu:
  varis = int(d.gelis_gunu)
  alinan.clear()
 y.akce -= int(urunler(y)[tur].fiyat) * adet
 y.kaynaklar.ekle(tur, adet)
 alinan[tur] = int(alinan.get(tur, 0)) + adet
 return true
## Optional alan; önceki kayıtlar sınırsız veya yinelenmiş yeni ziyaret yaratmaz.
func kaydet() -> Dictionary:
 return {"varis": varis, "alinan": alinan.duplicate()}
## Eski/bozuk optional geçmişi güvenli varsayılanlarla bağımsız nesneye yükler.
static func kayittan(v: Variant) -> GezginTuccarStogu:
 var s := GezginTuccarStogu.new()
 if not v is Dictionary: return s
 var g: Variant = v.get("varis", -1)
 if (g is int or g is float) and is_finite(float(g)) and float(g) >= -1 and float(g) <= 1000000000 and floor(float(g)) == float(g): s.varis = int(g)
 if v.get("alinan") is Dictionary:
  for uzman in AYAR.values() + SiparisTeslimati.AYAR.nadir.values():
   for tur in uzman:
    var n: Variant = v.alinan.get(tur, 0)
    if (n is int or n is float) and is_finite(float(n)) and float(n) > 0 and floor(float(n)) == float(n): s.alinan[tur] = int(minf(float(n), float(uzman[tur].stok)))
 SilahKaraborsasi.makbuz(v.get("alinan"), s)
 return s
## Mevcut kaynak adı adaptöründeki yeni stok etiketleri.
static func ad(anahtar: String) -> String:
 for uzman in AYAR.values() + SiparisTeslimati.AYAR.nadir.values():
  for tur in uzman:
   if anahtar == "koy.kaynak." + tur: return String(uzman[tur].ad)
 return HarcZinciri.ad(anahtar)
