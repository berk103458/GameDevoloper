## Kalıcı debug önayarı; gün/RNG veya paylaşılan denge Resource'u değişmez.
class_name IklimDeneyi
extends RefCounted
const META := &"debug_iklim_deneyi"
const HAVALAR := ["normal", "kar_firtinasi", "kuraklik"]

static func ayar(y: KoyYonetimi) -> Dictionary:
	return y.get_meta(META).duplicate(true) if y.has_meta(META) else {}

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	if not v is Dictionary: return
	var m: Variant = v.get("mevsim")
	if (not m is int and not m is float) or not is_finite(float(m)) or float(m) != floor(float(m)) or int(m) < -1 or int(m) > 3 or v.get("hava") not in HAVALAR: return
	if int(m) == -1 and v["hava"] == "normal":
		if y.has_meta(META): y.remove_meta(META)
	else: y.set_meta(META, {"mevsim": int(m), "hava": v["hava"]})

static func mevsim(y: KoyYonetimi, normal: int) -> int:
	var m := int(ayar(y).get("mevsim", -1))
	return normal if m == -1 else m

static func hava(y: KoyYonetimi) -> String:
	return String(ayar(y).get("hava", "normal"))

static func gida_carpani(y: KoyYonetimi) -> float:
	return 1.5 if hava(y) == "kuraklik" else 1.0

static func odun_carpani(y: KoyYonetimi) -> float:
	return 2.0 if hava(y) == "kar_firtinasi" else 1.0

static func degistir(o: Oturum, m: int, h: String) -> Dictionary:
	if o == null or o.yonetim.son != "" or m < -1 or m > 3 or h not in HAVALAR:
		return {"ok": false, "neden": "Canlı oturum, otomatik/0–3 mevsimi ve tanımlı hava gerekli."}
	yukle(o.yonetim, {"mevsim": m, "hava": h})
	return {"ok": true, "mevsim": o.yonetim.mevsim(), "hava": h, "gida": gida_carpani(o.yonetim), "odun": odun_carpani(o.yonetim)}

static func uygula(ana: Node, m: int, h: String) -> Dictionary:
	if not ZamanMakinesi.uygun(ana) or ana.get("_ust") != null:
		return {"ok": false, "neden": "Kararlı köy gerekli; rapor/olay önce tamamlanmalı."}
	var r := degistir(ana.get("oturum"), m, h)
	if r["ok"]:
		ana.get("_ekran").call("_yenile")
		r["kaydedildi"] = ana.get("kayit").yaz(ana.get("oturum").kaydet())
	return r
