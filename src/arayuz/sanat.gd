## Sanat dosyalarını adla yükler; dosya yoksa null döner (yer tutucu çizilir).
class_name Sanat
extends RefCounted

const KOK := "res://assets/art/"
static var _onbellek: Dictionary = {}


## `alt` klasör ve dosya kökü ile doku (ör. `char`, `char_miraen_neutral_card`).
static func doku(alt: String, ad: String) -> Texture2D:
	var yol := "%s%s/%s.png" % [KOK, alt, ad]
	if _onbellek.has(yol):
		return _onbellek[yol]
	var t: Texture2D = null
	if ResourceLoader.exists(yol):
		t = load(yol) as Texture2D
	_onbellek[yol] = t
	return t


static func is_ikonu(is_id: String) -> Texture2D:
	return doku("ui", "icon_job_%s_48" % is_id)


## Portre: adlı karakter ya da figür kökü.
static func portre(kok: String) -> Texture2D:
	return doku("char", "char_%s_neutral_card" % kok)


## Köy figürü: adlı kimlik ya da sınıf.
static func koy_figuru(adli_id: StringName, sinif: StringName) -> Texture2D:
	if adli_id != &"":
		var t := doku("char", "char_%s_idle_village" % adli_id)
		if t != null:
			return t
	var sinif_kok := {&"asker": "soldier_01", &"esnaf": "craftsman_01", &"ciftci": "farmer_01"}
	return doku("char", "char_%s_idle_village" % sinif_kok.get(sinif, "farmer_01"))
