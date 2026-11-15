## TUC-09: mevcut gün/mevsimden türeyen saf ortak fiyat hesabı.
class_name TicaretFiyatlari
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ticaret_fiyatlari.json"))
static var DENGE: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
## SOY-36: "kervan gelmeyecek" kamuoyu çarpanı bir gün uygulanır (sayı denge.json'dan).
static func soylenti_carpani(y: KoyYonetimi) -> float:
 if y == null or not y.has_meta(SoylentiKoprusu.META): return 1.0
 var ag: Variant = y.get_meta(SoylentiKoprusu.META)
 if ag == null or not ag.has_method("pazar_soylenti_aktif_mi") or not bool(ag.pazar_soylenti_aktif_mi(y.gun)): return 1.0
 return float(DENGE["pazar_soylenti_carpani"])
## Kış kıtlığı/yaz bolluğu yalnız yakacak ve erzak türlerine uygulanır; dış kervan söylentisi pazar çarpanını artırır.
static func carpan(y: KoyYonetimi, tur: String) -> float:
 var temel: float = float(AYAR.mevsim_carpani[y.mevsim()]) if tur in AYAR.urunler else 1.0
 return temel * soylenti_carpani(y)
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
