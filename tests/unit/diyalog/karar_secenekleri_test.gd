# Karar 1 (Banu Hatun), Karar 2 (Molla Şükrü) ve Karar 3 (Vebalı Sabi) seçeneklerinin doğrulanması
extends SceneTree

var _hata := 0

func _init() -> void:
	print("--- KARAR SECENEKLERI TESTI BASLADI ---")
	
	# 1. Banu Hatun (diyalog_28) ve Molla Şükrü (diyalog_27) ve Vebalı Sabi (diyalog_24) kontrolü
	var yol_d := "res://data/diyalog/diyalog_01_20.json"
	_dene(FileAccess.file_exists(yol_d), "diyalog_01_20.json bulunamadi")
	var txt_d := FileAccess.get_file_as_string(yol_d)
	var j_d: Variant = JSON.parse_string(txt_d)
	_dene(j_d is Array, "JSON dizi olmali")
	
	var d28: Dictionary = {}
	var d27: Dictionary = {}
	var d24: Dictionary = {}
	for item in j_d:
		if item.get("id") == "diyalog_28":
			d28 = item
		elif item.get("id") == "diyalog_27":
			d27 = item
		elif item.get("id") == "diyalog_24":
			d24 = item
			
	_dene(not d28.is_empty(), "diyalog_28 bulunamadi")
	_dene(not d27.is_empty(), "diyalog_27 bulunamadi")
	_dene(not d24.is_empty(), "diyalog_24 bulunamadi")
	
	# Banu Hatun bayrak kontrolü (Karar 1)
	var banu_flag_bulundu := false
	for q in d28.get("sorular", []):
		if q.size() > 2 and q[2] is Array:
			for sub in q[2]:
				if sub.size() > 3 and sub[3] == "banu_ittifak_kabul":
					banu_flag_bulundu = true
	_dene(banu_flag_bulundu, "Banu Hatun ittifak bayragi bulunamadi")
	_dene("50 pusat" in String(d28.get("yanitlar", {}).get("kabul", "")), "Banu Hatun kabul yaniti ittifaka uygun degil")
	
	# Molla Şükrü bayrak ve yanıt kontrolü (Karar 2 - Seçenek 2.1 Aleni Mahkeme)
	var sukru_flag_bulundu := false
	for q in d27.get("sorular", []):
		if q.size() > 2 and q[2] is Array:
			for sub in q[2]:
				if sub.size() > 3 and sub[3] == "meclis_sukru_mahkeme_edildi":
					sukru_flag_bulundu = true
	_dene(sukru_flag_bulundu, "Molla Sukru meclis_sukru_mahkeme_edildi bayragi bulunamadi")
	_dene("körük çekip" in String(d27.get("yanitlar", {}).get("kabul", "")), "Molla Sukru kabul yaniti aleni mahkemeye uygun degil")
	
	# 2. Vebalı Sabi (diyalog_24) çift dal kontrolü (Karar 3)
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
	_dene(sifa_flag, "diyalog_24 icinde veba_kirec_karantina_basarili bulunamadi")
	_dene(kayip_flag, "diyalog_24 icinde sabi_vefati_kis_matemi bulunamadi")
	_dene(d24.get("yanitlar", {}).has("kabul_sifa"), "diyalog_24 kabul_sifa yaniti eksik")
	_dene(d24.get("yanitlar", {}).has("kabul_kayip"), "diyalog_24 kabul_kayip yaniti eksik")
	
	# 3. Eş Kapı Düşünceleri kontrolü
	var yol_es := "res://data/diyalog/es_kapi_dusunceleri.json"
	_dene(FileAccess.file_exists(yol_es), "es_kapi_dusunceleri.json bulunamadi")
	var j_es: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol_es))
	_dene(j_es.get("diyalog_28", {}).has("karar_kabul"), "es diyalog_28 karar_kabul eksik")
	_dene("Hasan Çelebi" in String(j_es.get("diyalog_27", {}).get("karar_kabul", "")), "es diyalog_27 karar_kabul eksik")
	_dene("Çınar Meclisi" in String(j_es.get("diyalog_27", {}).get("karar_oncesi", "")), "es diyalog_27 karar_oncesi eksik")
	_dene(j_es.get("diyalog_24", {}).has("karar_kabul_sifa"), "es diyalog_24 karar_kabul_sifa eksik")
	_dene(j_es.get("diyalog_24", {}).has("karar_kabul_kayip"), "es diyalog_24 karar_kabul_kayip eksik")
	
	# 4. Parley Dosyaları kontrolü
	var txt_karaca := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_karaca_usta.ds")
	_dene("node:opt_banu" in txt_karaca, "Karaca Usta Banu dugumu eksik")
	
	var txt_hasan := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_hasan_celebi.ds")
	_dene("node:opt_sukru" in txt_hasan, "Hasan Celebi Sukru dugumu eksik")
	
	var txt_miraen := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_miraen.ds")
	_dene("node:opt_veba_sifa" in txt_miraen, "Miraen sifa dugumu eksik")
	_dene("node:opt_veba_kayip" in txt_miraen, "Miraen kayip dugumu eksik")
	
	var txt_es_koy := FileAccess.get_file_as_string("res://data/parley/koy/koylu_muhabbet_es.ds")
	_dene("node:opt_z_banu" in txt_es_koy, "Es Banu dugumu eksik")
	_dene("Molla Şükrü" in txt_es_koy, "Es Sukru dugumu eksik")
	_dene("node:opt_z_veba_sifa" in txt_es_koy, "Es sifa dugumu eksik")
	_dene("node:opt_z_veba_kayip" in txt_es_koy, "Es kayip dugumu eksik")
	
	print("KARAR SECENEKLERI TESTI: GECTI (0 hata)" if _hata == 0 else "KARAR SECENEKLERI TESTI: KALDI (%d hata)" % _hata)
	quit(1 if _hata > 0 else 0)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
