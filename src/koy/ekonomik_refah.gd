## EKO-08: hazine bakiyesinden ayrı, köylülerin ekonomik yaşam standardı.
class_name EkonomikRefah
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/refah.json"))
## Yeni/eski kaydın dış denge başlangıç puanı.
static func baslangic() -> int:
	return int(AYAR.baslangic)
## Optional kişi alanını doğrular; bozuk değer varsayılanı kullanır.
static func yukle(v: Variant) -> int:
	if (v is int or v is float) and is_finite(float(v)) and floor(float(v)) == float(v) and float(v) >= int(AYAR.alt) and float(v) <= int(AYAR.ust): return int(v)
	return baslangic()
## Yaşayan köylülerin ekonomik puan ortalaması; boş köy ihtiyaç üretmez.
static func oku(y: KoyYonetimi) -> int:
	if y.koylular.is_empty(): return int(AYAR.ust)
	var toplam := 0
	for k in y.koylular: toplam += k.refah
	return toplam / y.koylular.size()
## Her yaşayan kişiye sınırlı delta uygular; hiçbir kasayı veya RNG'yi değiştirmez.
static func degistir(y: KoyYonetimi, fark: int) -> bool:
	if y.koylular.is_empty(): return false
	for k in y.koylular: k.refah = clampi(k.refah + fark, int(AYAR.alt), int(AYAR.ust))
	return true
