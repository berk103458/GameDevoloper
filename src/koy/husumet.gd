## Ret havuzu ve husumet (design/gdd/koy-yonetimi.md, 3): reddedilenler kayda geçer; gerekçesiz ret husumeti
## daha çok artırır. Husumet her gece söner; eşikleri geçince sızma ve baskın zarı atılır.
class_name Husumet
extends RefCounted

var puan: int = 0
## Reddedilenler: {ad, gun, haksiz, usta}.
var reddedilenler: Array[Dictionary] = []
## Haksız reddedilip Tekfur'un hizmetine geçen ustalar (uzmanlık adları).
var tekfura_gecenler: PackedStringArray = []


## Bir ret kaydeder. `haksiz`: masum köylü ya da usta reddedildi.
func ret(ad: String, gun: int, haksiz: bool, usta_uzmanlik: String, a: KoyAyarlari) -> void:
	puan += a.husumet_haksiz if haksiz else a.husumet_gerekceli
	reddedilenler.append({"ad": ad, "gun": gun, "haksiz": haksiz, "usta": usta_uzmanlik})
	if haksiz and usta_uzmanlik != "" and not usta_uzmanlik in tekfura_gecenler:
		tekfura_gecenler.append(usta_uzmanlik)


## Gece: önce söner, sonra eşik zarları. Döner: `baskin`, `sizma` ya da boş.
func gece(a: KoyAyarlari, muhafiz: int, rng: RandomNumberGenerator) -> String:
	puan = maxi(0, puan - a.husumet_sonum)
	var indirim := muhafiz * a.muhafiz_zar_indirimi
	if puan >= a.baskin_esigi:
		if rng.randf() < maxf(0.0, a.baskin_zar - indirim):
			return "baskin"
	elif puan >= a.sizma_esigi:
		if rng.randf() < maxf(0.0, a.sizma_zar - indirim):
			return "sizma"
	return ""


func kaydet() -> Dictionary:
	return {"puan": puan, "reddedilenler": reddedilenler.duplicate(true), "tekfur": Array(tekfura_gecenler)}


static func kayittan(v: Dictionary) -> Husumet:
	var h := Husumet.new()
	h.puan = int(v.get("puan", 0))
	for r in v.get("reddedilenler", []):
		h.reddedilenler.append(r)
	h.tekfura_gecenler = PackedStringArray(v.get("tekfur", []))
	return h
