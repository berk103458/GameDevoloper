extends SceneTree

const SozSemasi := preload("res://src/soz/soz_semasi.gd")
const SozMotoru := preload("res://src/soz/soz_motoru.gd")
const BaglamSorgusu := preload("res://src/soz/baglam_sorgusu.gd")


func _init() -> void:
	for yol in ["res://data/soz/yetim_kafilesi.json", "res://data/soz/en/yetim_kafilesi.json"]:
		var veri := _json_oku(yol)
		var sonuc := SozSemasi.dogrula(veri)
		if not bool(sonuc.get("gecerli", false)):
			push_error("KAP-18 sema hatasi (%s): %s" % [yol, str(sonuc.get("hatalar", []))])
			quit(1)
			return
		var uyeler: Variant = veri.get("kafile_uyeleri", [])
		if not (uyeler is Array) or (uyeler as Array).size() != 3:
			push_error("KAP-18 kafile_uyeleri 3 cocuk icermeli: %s" % yol)
			quit(1)
			return
		for u in uyeler:
			if not (u is Dictionary) or String((u as Dictionary).get("yas_grubu", "")) != "cocuk":
				push_error("KAP-18 her uye cocuk yas grubunda olmali: %s" % yol)
				quit(1)
				return
			if bool((u as Dictionary).get("calisir_mi", true)):
				push_error("KAP-18 cocuk calismamali: %s" % yol)
				quit(1)
				return
			if int((u as Dictionary).get("gence_gecis_gunu", 0)) != 28:
				push_error("KAP-18 gence gecis gunu 28 olmali: %s" % yol)
				quit(1)
				return

	var tr_veri := _json_oku("res://data/soz/yetim_kafilesi.json")
	var motor := SozMotoru.new()
	var baglam := BaglamSorgusu.olustur({"tansiyon": 0, "bayraklar": ["mogol_ilerleyisi_etki"]})
	if not motor.yukle(tr_veri, baglam):
		push_error("KAP-18 SozMotoru yukle basarisiz.")
		quit(1)
		return
	var secim := motor.secenek_sec("kimsesiz_sorgu")
	if not bool(secim.get("basarili", false)) or String(secim.get("hedef", "")) != "emanet_sozu":
		push_error("KAP-18 SozMotoru secim hatasi: %s" % str(secim))
		quit(1)
		return

	var csv_metin := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	for anahtar in [
		"kap18.yetim.kafile_baslik",
		"kap18.yetim.kafile_acilis",
		"kap18.yetim.kabul_hane",
		"kap18.yetim.kabul_es",
		"kap18.yetim.kabul_acikta",
		"kap18.yetim.ret_sonuc",
		"kap18.yetim.genc_oldu",
		"kap18.yetim.uye.elif_not",
		"kap18.yetim.uye.sungurcuk_not",
		"kap18.yetim.uye.bala_not"
	]:
		if not csv_metin.contains(anahtar + ","):
			push_error("KAP-18 eksik CSV anahtari: %s" % anahtar)
			quit(1)
			return

	print("KAP-18 yetim metinleri ve diyalog agaci testi gecti.")
	quit(0)


func _json_oku(yol: String) -> Dictionary:
	var ham := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(ham)
	return parsed if parsed is Dictionary else {}
