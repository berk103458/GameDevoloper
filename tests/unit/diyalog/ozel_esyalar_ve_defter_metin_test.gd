extends SceneTree


func _init() -> void:
	var csv_metin := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	if csv_metin.to_lower().contains("şematik") or csv_metin.to_lower().contains("sematik"):
		push_error("YAP-04 oyuncu metninde 'şematik' gecemez!")
		quit(1)
		return

	var defter_veri := _json_oku("res://data/usta_defterleri.json")
	var defter_metinleri: Variant = defter_veri.get("defter_metinleri", {})
	if not (defter_metinleri is Dictionary) or (defter_metinleri as Dictionary).size() < 5:
		push_error("YAP-04 defter_metinleri en az 5 kayit icermeli.")
		quit(1)
		return
	for d_id in (defter_metinleri as Dictionary).keys():
		var kayit: Dictionary = (defter_metinleri as Dictionary)[d_id]
		var tur := String(kayit.get("tur", ""))
		if tur not in ["usta_defteri", "yapi_resmi"]:
			push_error("YAP-04 tur usta_defteri ya da yapi_resmi olmali: %s" % str(d_id))
			quit(1)
			return
		for alan in ["ad_anahtari", "aciklama_anahtari", "kaynak_notu_anahtari", "cozum_bildirimi_anahtari"]:
			var anahtar := String(kayit.get(alan, ""))
			if notanahtar_gecerli(anahtar) or not csv_metin.contains(anahtar + ","):
				push_error("YAP-04/YAP-51 gecersiz veya eksik defter anahtari (%s): %s" % [alan, anahtar])
				quit(1)
				return

	var ozel_veri := _json_oku("res://data/ozel_esyalar.json")
	var gecerli_hedefler: Array = ozel_veri.get("gecerli_hedefler", [])
	var esyalar: Variant = ozel_veri.get("esyalar", [])
	if not (esyalar is Array) or (esyalar as Array).size() < 8:
		push_error("YAP-06 data/ozel_esyalar.json en az 8 esya icermeli.")
		quit(1)
		return

	for e in esyalar:
		if not (e is Dictionary):
			push_error("YAP-06 esya kaydi Dictionary olmali.")
			quit(1)
			return
		var kayit := e as Dictionary
		if kayit.has("ikinci_hedef") or not gecerli_hedefler.has(String(kayit.get("hedef_sistem", ""))):
			push_error("YAP-06 tek gecerli hedef_sistem zorunlu: %s" % str(kayit))
			quit(1)
			return
		for alan in ["ad_anahtari", "aciklama_anahtari", "kaynak_notu_anahtari"]:
			var anahtar := String(kayit.get(alan, ""))
			if notanahtar_gecerli(anahtar) or not csv_metin.contains(anahtar + ","):
				push_error("YAP-51 esya aciklamasi duz cumle olamaz, CSV anahtari olmali (%s): %s" % [alan, anahtar])
				quit(1)
				return

	for donus_anahtar in ["yap37.donus.defter_kabul", "yap37.donus.defter_ret"]:
		if not csv_metin.contains(donus_anahtar + ","):
			push_error("YAP-37 eksik CSV anahtari: %s" % donus_anahtar)
			quit(1)
			return

	print("YAP-04, YAP-37, YAP-51 defter, donus ve ozel esya metin testi gecti.")
	quit(0)


func notanahtar_gecerli(a: String) -> bool:
	return a.is_empty() or a.contains(" ") or a.split(".").size() < 3


func _json_oku(yol: String) -> Dictionary:
	var ham := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(ham)
	return parsed if parsed is Dictionary else {}
