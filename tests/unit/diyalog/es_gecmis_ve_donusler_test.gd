# ES-GECM-01 ve ANL-DON-01 doğrulama testi
extends SceneTree

func _init() -> void:
	print("--- ES-GECM-01 & ANL-DON-01 TESTI BASLADI ---")
	
	# 1. ES-GECM-01 Parley kontrolü
	var yollar_es := [
		"res://data/parley/koy/koylu_muhabbet_es.ds",
		"res://data/parley/en/koy/koylu_muhabbet_es.ds"
	]
	for yol in yollar_es:
		assert(FileAccess.file_exists(yol), "%s bulunamadi" % yol)
		var txt := FileAccess.get_file_as_string(yol)
		assert("node:opt_gecmis" in txt, "node:opt_gecmis eksik: %s" % yol)
		assert("node:opt_g_yangin" in txt, "node:opt_g_yangin eksik: %s" % yol)
		assert("node:opt_g_yetim" in txt, "node:opt_g_yetim eksik: %s" % yol)
		assert("node:opt_g_sifa" in txt, "node:opt_g_sifa eksik: %s" % yol)
		assert("node:act_g_yangin_mert" in txt, "node:act_g_yangin_mert eksik: %s" % yol)
	
	# 2. ES-GECM-01 Akşam Sohbeti kontrolü
	var yol_aksam := "res://data/soz/aksam_konulari.json"
	assert(FileAccess.file_exists(yol_aksam), "aksam_konulari.json bulunamadi")
	var j_ak: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol_aksam))
	assert(j_ak.has("konular"), "konular alani eksik")
	assert(j_ak["konular"].has("es_yangin_ve_goc"), "es_yangin_ve_goc eksik")
	assert(j_ak["konular"].has("es_yetim_ve_cocuk"), "es_yetim_ve_cocuk eksik")
	assert(j_ak["konular"].has("es_gece_sifasi"), "es_gece_sifasi eksik")
	
	# 3. ANL-DON-01 Dönüş Diyalogları kontrolü
	var yollar_donus := [
		"res://data/diyalog/diyalog_donusler.json",
		"res://data/diyalog/en/diyalog_donusler.json"
	]
	var beklenen_idler := [
		"donus_sungur_hasim",
		"donus_sungur_muttefik",
		"donus_dursun_turna",
		"donus_lokman_ihanet",
		"donus_banu_zafer",
		"donus_behram_vefa"
	]
	for yol in yollar_donus:
		assert(FileAccess.file_exists(yol), "%s bulunamadi" % yol)
		var j_d: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
		assert(j_d is Array, "Dizi olmali: %s" % yol)
		assert(j_d.size() == 6, "6 donus sekansi olmali: %s" % yol)
		var idler: Array = []
		for item in j_d:
			idler.append(item.get("id"))
			assert(item.has("sorular") and item["sorular"].size() >= 2, "Sorular eksik: %s" % item.get("id"))
			assert(item.has("yanitlar"), "Yanitlar eksik: %s" % item.get("id"))
			assert(item.has("sonuclar"), "Sonuclar eksik: %s" % item.get("id"))
		for b in beklenen_idler:
			assert(b in idler, "Beklenen id bulunamadi: %s in %s" % [b, yol])
			
	print("ES-GECM-01 & ANL-DON-01 TESTI: GECTI (0 hata)")
	quit(0)
