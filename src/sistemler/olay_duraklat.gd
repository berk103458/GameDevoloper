## AYR-25: Olay paneli açılınca hız durur, kapanınca eski hız döner.
extends RefCounted

const META := &"olay_duraklat_eski"


static func ac(ekran: Node) -> bool:
	if ekran == null:
		return false
	var a: Variant = ekran.get("ayarlar")
	if not (a is Ayarlar) or not bool((a as Ayarlar).degerler.get(&"olayda_duraklat", false)):
		return false
	var agac := ekran.get_tree()
	if agac == null:
		return false
	ekran.set_meta(META, 0 if agac.paused else int(Engine.time_scale))
	agac.paused = true
	return agac.paused


static func kapat(ekran: Node) -> void:
	if ekran == null or not ekran.has_meta(META):
		return
	var eski := int(ekran.get_meta(META))
	ekran.remove_meta(META)
	var agac := ekran.get_tree()
	if agac == null:
		return
	agac.paused = eski == 0
	if eski > 0:
		Engine.time_scale = float(eski)
