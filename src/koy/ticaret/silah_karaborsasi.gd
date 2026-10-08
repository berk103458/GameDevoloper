## TUC-08: tek ziyaret geçmişinde kaçak tutsak teklifi; mevcut köylü kabul yolu.
class_name SilahKaraborsasi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/silah_karaborsasi.json"))
## Teklif yalnız Silah tüccarı konaklamasında ve ambargo yokken açıktır.
static func geldi(y: KoyYonetimi) -> bool:
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 return d.aktif and d.tuccar.id == "silah_tuccari" and not SiparisIhlali.terk(y, "silah_tuccari")
## Barınak, kamu kasası ve aynı konaklamanın tek kişi stoğu doğrulanır.
static func alinabilir(y: KoyYonetimi) -> bool:
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 return geldi(y) and y.akce >= int(AYAR.fiyat) and y.yatak_kapasitesi() > y.nufus() and (y.gezgin_ticaret.varis != d.gelis_gunu or int(y.gezgin_ticaret.alinan.get("tutsak", 0)) < int(AYAR.stok))
## Başarıda mevcut deftere tek makbuz, kamu ödemesi ve tek normal köylü yazılır.
static func al(y: KoyYonetimi) -> Koylu:
 if not alinabilir(y): return null
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 if y.gezgin_ticaret.varis != d.gelis_gunu:
  y.gezgin_ticaret.varis = int(d.gelis_gunu)
  y.gezgin_ticaret.alinan.clear()
 y.gezgin_ticaret.alinan["tutsak"] = int(y.gezgin_ticaret.alinan.get("tutsak", 0)) + 1
 y.akce -= int(AYAR.fiyat)
 var k := y.kabul(AYAR.kisi.duplicate(true))
 y._barindir()
 y.adalet = maxi(0, y.adalet - int(AYAR.adalet_kaybi))
 y.asayis_riski = mini(100, y.asayis_riski + int(AYAR.asayis_artis))
 return k
## Mevcut stok loaderı yalnız güvenli pozitif ziyaret makbuzunu genişletir.
static func makbuz(v: Variant, s: GezginTuccarStogu) -> void:
 if not v is Dictionary: return
 var n: Variant = v.get("tutsak", 0)
 if (n is int or n is float) and is_finite(float(n)) and float(n) > 0 and floor(float(n)) == float(n): s.alinan["tutsak"] = int(minf(float(n), float(AYAR.stok)))
