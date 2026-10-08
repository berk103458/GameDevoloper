## Şifahane tek gecelik çalışan kontenjanını yanık ve kış hastası paylaşır.
class_name SifahaneKontenjani
extends RefCounted
const META := &"sifahane_kontenjani"
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	for alan in ["gun", "kullanilan"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < 0 or float(n) > 1000000000: return {}
	return {"gun": int(v.gun), "kullanilan": int(v.kullanilan)}
static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))
static func kalan(y: KoyYonetimi, toplam: int) -> int:
	var d := durum(y)
	return maxi(0, toplam - int(d.get("kullanilan", 0))) if int(d.get("gun", -1)) == y.gun else toplam
static func kullan(y: KoyYonetimi) -> void:
	var d := durum(y)
	var n := int(d.get("kullanilan", 0)) if int(d.get("gun", -1)) == y.gun else 0
	y.set_meta(META, {"gun": y.gun, "kullanilan": n + 1})
