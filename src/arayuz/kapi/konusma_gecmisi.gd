## AYR-11: Bu ziyaretin konuşma akışı kaydırılır. Fare tekeri RichTextLabel'ın kendisinde,
## gamepad sağ çubuk burada; ikisi de ilk satıra kadar gider.
class_name KonusmaGecmisi
extends RefCounted

const ESIK := 0.5
const ADIM := 48.0


static func kaydir(kayit: RichTextLabel, olay: InputEvent) -> bool:
	if kayit == null or not (olay is InputEventJoypadMotion):
		return false
	var hareket := olay as InputEventJoypadMotion
	if hareket.axis != JOY_AXIS_RIGHT_Y or absf(hareket.axis_value) <= ESIK:
		return false
	var cubuk := kayit.get_v_scroll_bar()
	cubuk.value = clampf(cubuk.value + signf(hareket.axis_value) * ADIM, 0.0, cubuk.max_value)
	kayit.scroll_following = sonda_mi(kayit)
	return true


static func sonda_mi(kayit: RichTextLabel) -> bool:
	var cubuk := kayit.get_v_scroll_bar()
	return cubuk.value + cubuk.page >= cubuk.max_value - 1.0


static func ilk_satirda_mi(kayit: RichTextLabel) -> bool:
	return kayit.get_v_scroll_bar().value <= 0.0


static func ziyaret_basi(kayit: RichTextLabel) -> void:
	kayit.scroll_following = true
