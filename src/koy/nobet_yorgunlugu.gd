## UZM-14: son gerçek uyanık gece nöbeti, ertesi gün risk ×1.40.
class_name NobetYorgunlugu
extends RefCounted
const RISK_CARPANI := 1.40
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	var n: Variant = v.get("son_gece")
	if (not n is int and not n is float) or not is_finite(float(n)) or floor(float(n)) != float(n) or float(n) < 0 or float(n) > 1000000000: return {}
	return {"son_gece": int(n)}
static func aktif(k: Koylu, y: KoyYonetimi) -> bool:
	return int(k.yorgunluk.get("son_gece", -2)) == y.gun - 1
static func carpan(k: Koylu, y: KoyYonetimi) -> float:
	return RISK_CARPANI if aktif(k, y) else 1.0
static func nobetciler(y: KoyYonetimi) -> Array[int]:
	var sonuc: Array[int] = []
	for k in y.koylular:
		if k.yas_grubu != &"yetiskin" or MuhafizMaasi.borclu(k, y) or not IsKazalari.nobet(k, y) or IsKazalari.uyuyor(k) or not CirakEgitimi.saglam(k) or IsMemnuniyeti.isyanci(k, y) or ZanaatKazalari.durur(k): continue
		sonuc.append(k.id)
	return sonuc
static func gece(y: KoyYonetimi, uyanik: Array[int]) -> void:
	for id in uyanik:
		var k := y.koylu(id)
		if k == null or IsKazalari.uyuyor(k) or not CirakEgitimi.saglam(k): continue
		k.yorgunluk = {"son_gece": y.gun}
static func metin(k: Koylu, y: KoyYonetimi) -> String:
	return "Gece vardiyasından yorgun · kaza/uyuklama riski ×1.40 · bir gece dinlenin." if aktif(k, y) else "Gece vardiyası yorgunluğu yok"
