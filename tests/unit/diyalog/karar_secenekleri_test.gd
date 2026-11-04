# Karar 1 (Banu Hatun) ve Karar 3 (Vebalı Sabi) seçeneklerinin doğrulanması
extends SceneTree

func _init() -> void:
	print("--- KARAR SECENEKLERI TESTI BASLADI ---")
	
	# 1. Banu Hatun (diyalog_28) kontrolü
	var yol_d28 := "res://data/diyalog/diyalog_01_20.json"
	assert(FileAccess.file_exists(yol_d28), "diyalog_01_20.json bulunamadi")
	var txt_d := FileAccess.get_file_as_string(yol_d28)
	var j_d: Variant = JSON.parse_string(txt_d)
	assert(j_d is Array, "JSON dizi olmali")
	
	var d28: Dictionary = {}
	var d24: Dictionary = {}
	for item in j_d:
		if item.get("id") == "diyalog_28":
			d28 = item
		elif item.get("id") == "diyalog_24":
			d24 = item
			
	assert(not d28.is_empty(), "diyalog_28 bulunamadi")
	assert(not d24.is_empty(), "diyalog_24 bulunamadi")
	
	# Banu Hatun bayrak kontrolü
	var banu_flag_bulundu := false
	for q in d28.get("sorular", []):
		if q.size() > 2 and q[2] is Array:
			for sub in q[2]:
				if sub.size() > 3 and sub[3] == "banu_ittifak_kabul":
					banu_flag_bulundu = true
	assert(banu_flag_bulundu, "Banu Hatun ittifak bayragi bulunamadi")
	assert("50 pusat" in String(d28.get("yanitlar", {}).get("kabul", "")), "Banu Hatun kabul yaniti ittifaka uygun degil")
	
	# 2. Vebalı Sabi (diyalog_24) çift dal kontrolü
	var sifa_flag := false
	var kayip_flag := false
	for q in d24.get("sorular", []):
		if q.size() > 2 and q[2] is Array:
			for sub in q[2]:
				if sub.size() > 2 and sub[2] is Array:
					for sub_in in sub[2]:
						if sub_in.size() > 3:
							if sub_in[3] == "veba_kirec_karantina_basarili":
								sifa_flag = true
							elif sub_in[3] == "sabi_vefati_kis_matemi":
								kayip_flag = true
	assert(sifa_flag, "diyalog_24 icinde veba_kirec_karantina_basarili bulunamadi")
	assert(kayip_flag, "diyalog_24 icinde sabi_vefati_kis_matemi bulunamadi")
	assert(d24.get("yanitlar", {}).has("kabul_sifa"), "diyalog_24 kabul_sifa yaniti eksik")
	assert(d24.get("yanitlar", {}).has("kabul_kayip"), "diyalog_24 kabul_kayip yaniti eksik")
	
	# 3. Eş Kapı Düşünceleri kontrolü
	var yol_es := "res://data/diyalog/es_kapi_dusunceleri.json"
	assert(FileAccess.file_exists(yol_es), "es_kapi_dusunceleri.json bulunamadi")
	var j_es: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol_es))
	assert(j_es.get("diyalog_28", {}).has("karar_kabul"), "es diyalog_28 karar_kabul eksik")
	assert(j_es.get("diyalog_24", {}).has("karar_kabul_sifa"), "es diyalog_24 karar_kabul_sifa eksik")
	assert(j_es.get("diyalog_24", {}).has("karar_kabul_kayip"), "es diyalog_24 karar_kabul_kayip eksik")
	
	# 4. Parley Dosyaları kontrolü
	var txt_karaca := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_karaca_usta.ds")
	assert("node:opt_banu" in txt_karaca, "Karaca Usta Banu dugumu eksik")
	
	var txt_miraen := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_miraen.ds")
	assert("node:opt_veba_sifa" in txt_miraen, "Miraen sifa dugumu eksik")
	assert("node:opt_veba_kayip" in txt_miraen, "Miraen kayip dugumu eksik")
	
	var txt_es_koy := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_es.ds")
	assert("node:opt_z_banu" in txt_es_koy, "Es Banu dugumu eksik")
	assert("node:opt_z_veba_sifa" in txt_es_koy, "Es sifa dugumu eksik")
	assert("node:opt_z_veba_kayip" in txt_es_koy, "Es kayip dugumu eksik")
	
	print("KARAR SECENEKLERI TESTI: GECTI (0 hata)")
	quit(0)
