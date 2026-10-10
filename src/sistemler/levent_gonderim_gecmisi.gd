## BUG-0014: geçici ferman seçimi yenilense de başarı izi makbuzda kalır.
## Legacy kayıtta yalnız geçerli son gönderim ve tam kişi makbuzu kanıttır.
extends RefCounted

static func oku(ham: Dictionary, makbuz: Dictionary, adet: int, ilk_gece: int) -> bool:
	if ham.has("levent_gonderildi"):
		return ham.levent_gonderildi is bool and ham.levent_gonderildi
	return not makbuz.bekliyor and int(makbuz.secim) in [0, 1] and int(makbuz.gun) >= ilk_gece and int(makbuz.son_gece) >= int(makbuz.gun) and makbuz.gonderilen.size() == adet
