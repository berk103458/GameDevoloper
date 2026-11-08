## OGR-19: İlk köylü kartı sürüklenebilir olduğunda tek satır ipucu ve kartın kulpunda bir kez yanıp sönen vurgu.
## İlk atama sonrası vurgu kalkar; ikinci köylüde vurgu 0.
class_name IlkAtamaVurgusu
extends ColorRect

const META_BITTI := &"ilk_atama_vurgusu_bitti"
const VURGU_ADI := "IlkAtamaVurgusu"


static func suruklenebilir_mi(k: Koylu) -> bool:
	return k != null and k.yas_grubu == &"yetiskin" and not k.bayrak_var("acl01_es")


static func vurgu_gerekli_mi(y: KoyYonetimi, k: Koylu = null) -> bool:
	if y == null or not IlkSaat.koy_acik(y):
		return false
	if bool(y.get_meta(META_BITTI, false)):
		return false
	for mevcut in y.koylular:
		if suruklenebilir_mi(mevcut) and mevcut.is_yeri != KoyYonetimi.BOSTA:
			y.set_meta(META_BITTI, true)
			return false
	if k != null and not suruklenebilir_mi(k):
		return false
	return true


static func atama_kaydet(y: KoyYonetimi) -> void:
	if y != null:
		y.set_meta(META_BITTI, true)


static func uygula(kulp: Control, y: KoyYonetimi, k: Koylu = null) -> Dictionary:
	if kulp != null:
		var eski := kulp.get_node_or_null(VURGU_ADI)
		if eski != null:
			kulp.remove_child(eski)
			eski.free()
	if not vurgu_gerekli_mi(y, k):
		return {"vurgu": 0, "ipucu": ""}
	if kulp != null:
		var vurgu := (load("res://src/arayuz/koy_hud/ilk_atama_vurgusu.gd") as GDScript).new() as ColorRect
		vurgu.name = VURGU_ADI
		vurgu.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vurgu.color = Color(0.95, 0.78, 0.25, 0.35)
		vurgu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		kulp.add_child(vurgu)
	return {
		"vurgu": 1,
		"ipucu": IlkSaat.ipucu_metni("ogretici.koy.atama"),
	}
