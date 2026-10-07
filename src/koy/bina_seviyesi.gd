## Ahmet denge kuralı: N'de üretim +%25, yatak/depo tabanı +%20/ek seviye.
class_name BinaSeviyesi
extends RefCounted

static func uretim_carpani(seviye: int) -> float:
	return 1.0 + 0.25 * (maxi(1, seviye) - 1)

static func kapasite(taban: int, seviye: int) -> int:
	# Taban tam sayı kalır; yalnız ek kapasite yukarı yuvarlanır.
	return maxi(0, taban) + ceili(maxi(0, taban) * (maxi(1, seviye) - 1) / 5.0)

static func sur_gucu(seviye: int, hasar: int) -> int:
	return floori(maxi(0, seviye) * 2.0 * (1.0 - clampi(hasar, 0, 100) / 100.0))
