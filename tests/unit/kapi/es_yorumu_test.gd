# tests/unit/kapi/es_yorumu_test.gd
# Görev 5 - Bölüm 1C: Kapı Ekranında Eşin Düşünceleri Doğrulama Testi
extends SceneTree

const EsYorumuAdaptoru = preload("res://src/kapi/es_yorumu_adaptoru.gd")

var hata_sayisi := 0

func dene(sart: bool, mesaj: String) -> void:
	if not sart:
		hata_sayisi += 1
		push_error("HATA: " + mesaj)
	else:
		print("  [OK] " + mesaj)


func _initialize() -> void:
	print("\n========================================================")
	print("--- [BÖLÜM 1C: EŞİN KAPIDAKİ DÜŞÜNCELERİ TESTİ] ---")
	print("========================================================\n")
	
	var yol := "res://data/diyalog/es_kapi_dusunceleri.json"
	dene(FileAccess.file_exists(yol), "es_kapi_dusunceleri.json mevcut")
	
	var metin := FileAccess.get_file_as_string(yol)
	var j: Variant = JSON.parse_string(metin)
	dene(j is Dictionary, "JSON verisi sözlük formatında")
	
	if j is Dictionary:
		var d: Dictionary = j
		for i in range(1, 21):
			var did := "diyalog_%02d" % i
			dene(d.has(did), "%s için eş düşüncesi mevcut" % did)
			if d.has(did):
				var icerik: Dictionary = d[did]
				dene(icerik.has("karar_oncesi") and not String(icerik.karar_oncesi).is_empty(), "%s: karar_oncesi mevcut ve dolu" % did)
				dene(icerik.has("kritik_soru") and not String(icerik.kritik_soru).is_empty(), "%s: kritik_soru mevcut ve dolu" % did)
				dene(icerik.has("karar_kabul") and not String(icerik.karar_kabul).is_empty(), "%s: karar_kabul mevcut ve dolu" % did)
				dene(icerik.has("karar_ret") and not String(icerik.karar_ret).is_empty(), "%s: karar_ret mevcut ve dolu" % did)
	
	# Mock Kapi test
	var mock_kapi := MockKapi.new()
	var gelen := Gelen.new()
	gelen.id = &"diyalog_01"
	gelen.sinif = &"ciftci"
	
	EsYorumuAdaptoru.soru_soruldu(mock_kapi, gelen, 1)
	dene(mock_kapi.yazilanlar.size() == 1, "Soru 2'de eşin uyarısı fısıldandı")
	
	EsYorumuAdaptoru.karar_gosterildi(mock_kapi, gelen)
	dene(mock_kapi.yazilanlar.size() == 2, "Karar ekranında eşin fısıltısı yazıldı")
	
	EsYorumuAdaptoru.karar_verildi(mock_kapi, gelen, &"kabul")
	dene(mock_kapi.yazilanlar.size() == 3, "Kabul kararında eşin kanaati yazıldı")
	
	print("\n========================================================")
	if hata_sayisi == 0:
		print("--- [EŞ DÜŞÜNCELERİ TEST SONUCU: BAŞARILI (0 HATA)] ---")
	else:
		print("--- [EŞ DÜŞÜNCELERİ TEST SONUCU: BAŞARISIZ (%d HATA)] ---" % hata_sayisi)
	print("========================================================\n")
	
	quit(hata_sayisi)


class MockKapi extends Control:
	var yazilanlar: Array[String] = []
	func _yaz(s: String) -> void:
		yazilanlar.append(s)
