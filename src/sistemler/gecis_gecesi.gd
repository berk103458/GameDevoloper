# gdlint: disable=max-line-length
class_name GecisGecesi
extends RefCounted

## OMR-08: "Köy oturdu" geçiş gecesinde kapı kapalıdır.
## Oyuncu köyde ağalık kararını verir; o gece kapıya kimse gelmez.

static func gecis_gecesi_mi(y: Object) -> bool:
	if y == null:
		return false
	var agalik_val: Variant = y.get("agalik")
	if agalik_val == null and y.has_meta(&"agalik"):
		agalik_val = y.get_meta(&"agalik")
	if not agalik_val:
		return false
	var b := int(y.get_meta(&"perde2_baslangic", -1))
	var gun_val: Variant = y.get("gun")
	if gun_val == null and y.has_meta(&"gun"):
		gun_val = y.get_meta(&"gun")
	return b == int(gun_val)


static func gelen_sayisi_filtrele(y: Object, varsayilan_gelen: int) -> int:
	if gecis_gecesi_mi(y):
		return 0
	return varsayilan_gelen
