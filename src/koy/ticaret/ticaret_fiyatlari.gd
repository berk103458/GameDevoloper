## TUC-09: mevcut gün/mevsimden türeyen saf ortak fiyat hesabı.
class_name TicaretFiyatlari
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ticaret_fiyatlari.json"))
## Kış kıtlığı/yaz bolluğu yalnız yakacak ve erzak türlerine uygulanır.
static func carpan(y: KoyYonetimi, tur: String) -> float:
 return float(AYAR.mevsim_carpani[y.mevsim()]) if tur in AYAR.urunler else 1.0
## Genel veya uzman alışın aynı birim bedeli; mevcut Tekfur farkı korunur.
static func al_birim(y: KoyYonetimi, tur: String) -> float:
 var u: Dictionary = GezginTuccarStogu.urunler(y).get(tur, {})
 if not u.is_empty(): return float(u.fiyat)
 var fiyat := float(y.a.kervan_satis.get(tur, 0.0))
 if tur == "alet" and "demirci" in y.husumet.tekfura_gecenler: fiyat *= 1.5
 return fiyat * carpan(y, tur)
## Alış parti bedeli yukarı yuvarlanır; gösterim ve tahsilat aynı hesabı kullanır.
static func bedel(y: KoyYonetimi, tur: String, adet: int) -> int:
 return ceili(al_birim(y, tur) * maxi(0, adet))
## Mevcut kervan/tezgâh satış birim fiyatı; tezgâhın limiti modelde korunur.
static func sat_birim(y: KoyYonetimi, tur: String) -> float:
 return float(y.a.kervan_fiyat.get(tur, 0.0)) * carpan(y, tur)
