# KVR-SES-01: Hava ve mevsim replikleri doğrulama birim testi
extends SceneTree

const HavaReplikAdaptoru = preload("res://src/koy/hava_replik_adaptoru.gd")


func _initialize() -> void:
	print("--- [KVR-SES-01 HAVA REPLIKLERI TESTI BASLADI] ---")
	
	# 1. JSON dosyalarının varlığı ve yapısı
	var tr_yol := "res://data/koy/hava_replikleri.json"
	var en_yol := "res://data/koy/en/hava_replikleri.json"
	assert(FileAccess.file_exists(tr_yol), "TR hava_replikleri.json bulunamadı")
	assert(FileAccess.file_exists(en_yol), "EN hava_replikleri.json bulunamadı")
	
	var tr_txt := FileAccess.get_file_as_string(tr_yol)
	var en_txt := FileAccess.get_file_as_string(en_yol)
	var tr_j: Variant = JSON.parse_string(tr_txt)
	var en_j: Variant = JSON.parse_string(en_txt)
	assert(tr_j is Dictionary, "TR JSON geçerli bir sözlük değil")
	assert(en_j is Dictionary, "EN JSON geçerli bir sözlük değil")
	
	var karakterler := [
		"karaca_usta", "ayse_baci", "es", "saruca_hatun", "hasan_celebi",
		"yusuf", "miraen", "thessra", "sorhan", "aydogdu", "nogay", "genel"
	]
	var havalar := ["yagmur", "kar", "ayaz", "sicak", "sis"]
	
	for c in karakterler:
		assert(tr_j.has(c), "TR JSON karakter eksik: %s" % c)
		assert(en_j.has(c), "EN JSON karakter eksik: %s" % c)
		for h in havalar:
			assert(tr_j[c].has(h), "TR JSON hava eksik: %s -> %s" % [c, h])
			assert(en_j[c].has(h), "EN JSON hava eksik: %s -> %s" % [c, h])
			var tr_arr: Array = tr_j[c][h]
			var en_arr: Array = en_j[c][h]
			assert(tr_arr.size() >= 2, "TR replik sayısı yetersiz: %s -> %s" % [c, h])
			assert(en_arr.size() >= 2, "EN replik sayısı yetersiz: %s -> %s" % [c, h])
			assert(not tr_arr[0].is_empty(), "TR replik 1 boş: %s -> %s" % [c, h])
			assert(not tr_arr[1].is_empty(), "TR replik 2 boş: %s -> %s" % [c, h])
			assert(not en_arr[0].is_empty(), "EN replik 1 boş: %s -> %s" % [c, h])
			assert(not en_arr[1].is_empty(), "EN replik 2 boş: %s -> %s" % [c, h])

	print("  [OK] JSON veri dosyaları ve 12 karakter/5 hava durumu yapısı doğrulandı.")

	# 2. HavaReplikAdaptoru fonksiyon testleri
	assert(HavaReplikAdaptoru.normalize_hava("kar_firtinasi") == "kar", "kar_firtinasi normalizasyon hatası")
	assert(HavaReplikAdaptoru.normalize_hava("kuraklik") == "sicak", "kuraklik normalizasyon hatası")
	assert(HavaReplikAdaptoru.normalize_hava("saganak") == "yagmur", "saganak normalizasyon hatası")
	assert(HavaReplikAdaptoru.normalize_hava("acik") == "normal", "acik normalizasyon hatası")

	# Kapı replikleri testi
	var kapi_kar := HavaReplikAdaptoru.kapi_on_ek_al("kar", 1)
	assert(not kapi_kar.is_empty(), "kapi_on_ek_al kar boş döndü")
	var kapi_yagmur := HavaReplikAdaptoru.kapi_on_ek_al("yagmur", 1)
	assert(not kapi_yagmur.is_empty(), "kapi_on_ek_al yagmur boş döndü")
	var kapi_muhafiz := HavaReplikAdaptoru.muhafiz_karsilama_al("firtina")
	assert(not kapi_muhafiz.is_empty(), "muhafiz_karsilama_al firtina boş döndü")

	# Köylü replikleri testi
	for c in karakterler:
		for h in havalar:
			var r1 := HavaReplikAdaptoru.koylu_replik_al(c, h, 1)
			assert(not r1.is_empty(), "koylu_replik_al boş döndü: %s -> %s (v1)" % [c, h])
			var r2 := HavaReplikAdaptoru.koylu_replik_al(c, h, 2)
			assert(not r2.is_empty(), "koylu_replik_al boş döndü: %s -> %s (v2)" % [c, h])

	print("  [OK] HavaReplikAdaptoru sorguları ve metin dönüşleri doğrulandı.")

	print("\n========================================================")
	print("--- [KVR-SES-01 TEST SONUCU: BASARILI (0 HATA)] ---")
	print("========================================================\n")
	quit(0)
