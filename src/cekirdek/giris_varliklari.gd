## Mevcut menü/kapı üreticilerinin kullandığı kaynak yolları; bulunmayan isteğe bağlı model atlanır.
class_name GirisVarliklari
extends RefCounted

static func menu() -> Array[String]:
	var yollar: Array[String] = [Tema.FONT_DIK, Tema.FONT_ITALIK, MenuSahnesi.GOKYUZU]
	for ad in ["kapi", "ev", "cadir", "gozetleme_kulesi"]:
		_model(yollar, ad, "yapi")
	for ad in ["kazik_cit", "agac", "kaya", "araba", "mesale"]:
		_model(yollar, ad)
	_model(yollar, "ciftci_kadin_yuru", "karakter")
	return yollar

static func kapi() -> Array[String]:
	var yollar: Array[String] = [Tema.FONT_DIK, Tema.FONT_ITALIK]
	_dosya(yollar, "res://src/dunya", ["gdshader"])
	for ad in ["kazik_cit", "okuz", "araba"]:
		_model(yollar, ad)
	for ad in ["brown_mud_rocks_01", "snow_02", "aerial_rocks_02", "snow_field_aerial", "muddy_tracks", "medieval_wood", "bark_willow", "castle_wall_varriation"]:
		_dosya(yollar, "res://assets/ph/doku/" + ad, ["jpg", "png"])
	_dosya(yollar, "res://assets/ph/gok", ["hdr"])
	_dosya(yollar, "res://assets/ph/impostor", ["png"])
	for ad in ["large_castle_door", "wooden_barrels_01", "wooden_crate_01", "boulder_01", "rock_moss_set_01", "dead_tree_trunk_02", "dry_branches_medium_01"]:
		var yol := "res://assets/ph/model/%s/%s.gltf" % [ad, ad]
		if ResourceLoader.exists(yol):
			yollar.append(yol)
	return yollar

static func karakterler(adlar: Array[String]) -> Array[String]:
	var yollar: Array[String] = []
	for ad in adlar:
		_model(yollar, ad + "_yuru", "karakter")
		for hareket in KarakterModel.HAREKETLER:
			_model(yollar, ad + "_" + hareket, "karakter")
	return yollar

static func _model(yollar: Array[String], ad: String, tur: String = "") -> void:
	var yol := Dunya3B._yol(ad, tur)
	if yol != "" and yol not in yollar:
		yollar.append(yol)

static func _dosya(yollar: Array[String], dizin: String, uzantilar: Array) -> void:
	if not DirAccess.dir_exists_absolute(dizin):
		return
	for ad in DirAccess.get_files_at(dizin):
		if ad.get_extension() in uzantilar:
			yollar.append(dizin.path_join(ad))
