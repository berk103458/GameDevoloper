## OGR-33: Ilk saat icinde oyun bitmez.
## Ilk alti gecede (`ilk_saat.json` `son_kilidi_gece`) bes sondan (SYS-20) hicbiri tetiklenemez.
class_name SonKilidi
extends RefCounted

const VERI_YOLU := "res://data/ogretici/ilk_saat.json"
const VARSAYILAN_KILIT_GECESI := 6


static func kilit_gecesi(yol: String = VERI_YOLU) -> int:
	if FileAccess.file_exists(yol):
		var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
		if parsed is Dictionary and (parsed as Dictionary).has("son_kilidi_gece"):
			return maxi(0, int((parsed as Dictionary)["son_kilidi_gece"]))
	return VARSAYILAN_KILIT_GECESI


static func kilitli_mi(kaynak: Variant, yol: String = VERI_YOLU) -> bool:
	var gece := _gece_coz(kaynak)
	return gece < kilit_gecesi(yol)


static func _gece_coz(kaynak: Variant) -> int:
	if kaynak == null:
		return 0
	if kaynak is int or kaynak is float:
		return int(kaynak)
	if kaynak is Dictionary:
		var d := kaynak as Dictionary
		return int(d.get("gece", d.get("gun", 0)))
	if kaynak is Oturum:
		return int((kaynak as Oturum).gun)
	if kaynak is KoyYonetimi:
		return int((kaynak as KoyYonetimi).gun)
	if kaynak is Object and "gun" in (kaynak as Object):
		return int((kaynak as Object).get("gun"))
	return 0
