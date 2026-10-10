## BUG-0012: mevcut KRI-06 kayıt makbuzunda gün kilidi, olayda JSON replay izi.
## Nöbetsiz/terminal çağrı buraya gelmez; ertesi gün yeni olaya izin verilir.
extends RefCounted

static func al(y: KoyYonetimi, olay: Dictionary = {}) -> bool:
	var d := KitlikIsyani.durum(y)
	if int(d.nobet_son_gece) == y.gun: return false
	if not olay.is_empty() and olay.kitlik_isyani.get("nobet_islendi", false) == true: return false
	d.nobet_son_gece = y.gun
	y.set_meta(KitlikIsyani.META, d)
	if not olay.is_empty(): olay.kitlik_isyani["nobet_islendi"] = true
	return true
