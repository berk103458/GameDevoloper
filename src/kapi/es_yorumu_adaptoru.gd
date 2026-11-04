# Kapı ekranında eşin düşünce ve fısıltılarını yöneten ince adaptör (Görev 5 - Bölüm 1C)
class_name EsYorumuAdaptoru
extends RefCounted

static var _veriler: Dictionary = {}
static var _yuklendi := false

static func _veri_yukle() -> void:
	if _yuklendi:
		return
	_yuklendi = true
	var yol := "res://data/diyalog/en/es_kapi_dusunceleri.json" if (TranslationServer.get_locale() == "en" and FileAccess.file_exists("res://data/diyalog/en/es_kapi_dusunceleri.json")) else "res://data/diyalog/es_kapi_dusunceleri.json"
	if FileAccess.file_exists(yol):
		var txt := FileAccess.get_file_as_string(yol)
		var j: Variant = JSON.parse_string(txt)
		if j is Dictionary:
			_veriler = j


static func karar_gosterildi(kapi: Control, gelen: Gelen) -> void:
	if kapi == null or gelen == null:
		return
	_veri_yukle()
	var d_id := _gelen_diyalog_id(kapi, gelen)
	var yorum := ""
	
	if _veriler.has(d_id) and _veriler[d_id] is Dictionary:
		yorum = String(_veriler[d_id].get("karar_oncesi", ""))
	elif _veriler.has("genel") and _veriler["genel"] is Dictionary:
		var sinif_str := String(gelen.sinif)
		if _veriler["genel"].has(sinif_str) and _veriler["genel"][sinif_str] is Dictionary:
			yorum = String(_veriler["genel"][sinif_str].get("karar_oncesi", ""))
			
	if not yorum.is_empty() and kapi.has_method("_yaz"):
		kapi._yaz("[color=#c8a477][i]Eşin fısıltısı:[/i] \"%s\"[/color]" % yorum)


static func soru_soruldu(kapi: Control, gelen: Gelen, soru_index: int) -> void:
	if kapi == null or gelen == null or soru_index != 1:
		return # 2. soruda (kritik sorgu aşamasında) tek bir fısıltı
	_veri_yukle()
	var d_id := _gelen_diyalog_id(kapi, gelen)
	var yorum := ""
	
	if _veriler.has(d_id) and _veriler[d_id] is Dictionary:
		yorum = String(_veriler[d_id].get("kritik_soru", ""))
		
	if not yorum.is_empty() and kapi.has_method("_yaz"):
		kapi._yaz("[color=#c8a477][i]Eşin uyarısı:[/i] \"%s\"[/color]" % yorum)


static func karar_verildi(kapi: Control, gelen: Gelen, karar: StringName) -> void:
	if kapi == null or gelen == null:
		return
	_veri_yukle()
	var d_id := _gelen_diyalog_id(kapi, gelen)
	var yorum := ""
	
	if _veriler.has(d_id) and _veriler[d_id] is Dictionary:
		var anahtar := "karar_kabul" if (karar == &"kabul" or karar == &"harc") else "karar_ret"
		if d_id == "diyalog_24" and (karar == &"kabul" or karar == &"harc"):
			if gelen.acik_bayraklar.has("veba_kirec_karantina_basarili"):
				anahtar = "karar_kabul_sifa"
				if gelen.yanitlar.has("kabul_sifa"):
					gelen.yanitlar["kabul"] = gelen.yanitlar["kabul_sifa"]
			elif gelen.acik_bayraklar.has("sabi_vefati_kis_matemi"):
				anahtar = "karar_kabul_kayip"
				if gelen.yanitlar.has("kabul_kayip"):
					gelen.yanitlar["kabul"] = gelen.yanitlar["kabul_kayip"]
		yorum = String(_veriler[d_id].get(anahtar, ""))
		if yorum.is_empty() and (karar == &"kabul" or karar == &"harc"):
			yorum = String(_veriler[d_id].get("karar_kabul", ""))
		
	if not yorum.is_empty() and kapi.has_method("_yaz"):
		kapi._yaz("[color=#c8a477][i]Eşin kanaati:[/i] \"%s\"[/color]" % yorum)


static func _gelen_diyalog_id(kapi: Control, gelen: Gelen) -> String:
	# Önce gelene ait açık id veya oturum sırasından diyalog_XX tespiti
	if not gelen.id.is_empty():
		var id_str := String(gelen.id).to_lower()
		if id_str.begins_with("diyalog_"):
			return id_str
	var o: Oturum = kapi.get("oturum")
	if o and o._gemini_sira > 0:
		return "diyalog_%02d" % o._gemini_sira
	return "diyalog_01"
