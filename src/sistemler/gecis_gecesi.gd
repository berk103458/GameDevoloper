# gdlint: disable=max-line-length
class_name GecisGecesi
extends RefCounted

## OMR-08: "Köy oturdu" geçiş gecesinde kapı kapalıdır.
## Oyuncu köyde ağalık kararını verir; o gece kapıya kimse gelmez.

static func gecis_gecesi_mi(y: KoyYonetimi) -> bool:
	if y == null or not y.agalik:
		return false
	var b := int(y.get_meta(&"perde2_baslangic", -1))
	return b == y.gun

static func gelen_sayisi_filtrele(y: KoyYonetimi, varsayilan_gelen: int) -> int:
	if gecis_gecesi_mi(y):
		return 0
	return varsayilan_gelen
