## TUC-14: tek hayvan kaydı, kamu takası ve mevcut üretime sınırlı katkı.
class_name CanliHayvanTakasi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/canli_hayvan_takasi.json"))
## Yıkılan/bitmemiş barınaktaki fazla hayvan kaybolmaz ama üretim desteği vermez.
static func barinan(y: KoyYonetimi, tur: String) -> int:
 if int(y.lojistik.hayvanlar.get(tur, 0)) <= 0: return 0
 var yer := CelepHamdullah.kapasite(y, tur)
 for t in CelepHamdullah.AYAR.hayvanlar:
  if CelepHamdullah.barinak(t) != CelepHamdullah.barinak(tur): continue
  var adet := mini(yer, int(y.lojistik.hayvanlar.get(t, 0)))
  if t == tur: return adet
  yer -= adet
 return 0
## Yalnız mevcut çalışan/ürün üretimine uygulanır; pasif ikinci üretim yoktur.
static func carpan(y: KoyYonetimi, b: KoyBinasi, urun: String) -> float:
 if not b.hazir(): return 1.0
 var bonus := 0.0
 if b.tur in ["tarla", "bostan"] and urun in ["gida", "bugday"]:
  bonus = barinan(y, "okuz") * float(AYAR.tarla_okuz_bonus)
 if b.tur == "agil" and urun == "gida":
  bonus = barinan(y, "inek") * float(AYAR.agil_inek_bonus) + CelepHamdullah.barindir(y, b.id).count("koc") * float(AYAR.agil_koc_bonus)
 return clampf(1.0 + bonus, 1.0, float(AYAR.carpan_ust))
## Canlı hayvan geri satışı yalnız mevcut Celep ziyareti ve kamu kasasıdır.
static func fiyat(tur: String) -> int:
 return floori(float(CekiLojistigi.FIYAT.get(tur, 0)) * float(AYAR.geri_satis_orani))
static func satilabilir(y: KoyYonetimi, tur: String) -> bool:
 return y.son == "" and CelepHamdullah.geldi(y) and fiyat(tur) > 0 and int(y.lojistik.hayvanlar.get(tur, 0)) > 0 and y.akce <= 9223372036854775807 - fiyat(tur)
## Aynı kayıt ve barınak yeri serbest kalır; başarısızlık hiçbir değer değiştirmez.
static func sat(y: KoyYonetimi, tur: String) -> bool:
 if not satilabilir(y, tur): return false
 y.lojistik.hayvanlar[tur] = int(y.lojistik.hayvanlar[tur]) - 1
 y.akce += fiyat(tur)
 return true
