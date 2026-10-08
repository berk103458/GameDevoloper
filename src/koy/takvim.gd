## Mevsim takvimi (design/gdd/koy-yonetimi.md, 4.3): her mevsim `mevsim_gun` gün; dördüncüsü kış.
## Gün 0'dan sayılır (oyunun ilk günü 0).
class_name Takvim
extends RefCounted


## Günün mevsim indeksi (0 = ilkbahar … 3 = kış).
static func mevsim(gun: int, mevsim_gun: int) -> int:
	return MevsimYoneticisi.mevsim(gun, mevsim_gun)


static func kis_mi(gun: int, mevsim_gun: int) -> bool:
	return mevsim(gun, mevsim_gun) == 3


## Mevsimin kaçıncı günü (1'den).
static func mevsim_gunu(gun: int, mevsim_gun: int) -> int:
	return MevsimYoneticisi.mevsim_gunu(gun, mevsim_gun)


## Yılın kaçıncı günü (1'den; 28 günlük yıl).
static func yil_gunu(gun: int, mevsim_gun: int) -> int:
	return MevsimYoneticisi.yil_gunu(gun, mevsim_gun)


## Hafta başı mı (vergi günü). İlk gün sayılmaz.
static func hafta_basi(gun: int, mevsim_gun: int) -> bool:
	return MevsimYoneticisi.hafta_basi(gun, mevsim_gun)
