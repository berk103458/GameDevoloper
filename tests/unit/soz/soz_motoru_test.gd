# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var motor := SozMotoru.new()

	# 1. Şema hatası olan dosya 0 satır oynatır
	var dosya_hatali := FileAccess.open("res://data/soz/ornek_hatali.json", FileAccess.READ)
	var parsed_hatali = JSON.parse_string(dosya_hatali.get_as_text())
	var basarili := motor.yukle(parsed_hatali)
	if basarili:
		hatalar.append("Şema hatası olan dosya başarıyla yüklendi! (Beklenen: false)")
	if not motor.sustu or not motor.mevcut_satir().is_empty():
		hatalar.append("Şema hatası olan dosya satır oynattı! (Beklenen: 0 satır)")

	# 2. Altı kilit türünün testi
	var kilit_dosyasi := {
		"konusmaci": "chr_003",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Kilit test başlangıcı",
				"secenekler": [
					{ "id": "sec_tansiyon", "metin": "Tansiyon Seçeneği", "hedef": "d_tansiyon", "kosul": { "tansiyon_max": 2 } },
					{ "id": "sec_ipucu", "metin": "İpucu Seçeneği", "hedef": "d_ipucu", "kosul": { "gerekli_ipucu": "clue_01" } },
					{ "id": "sec_bayrak", "metin": "Bayrak Seçeneği", "hedef": "d_bayrak", "kosul": { "gerekli_bayrak": "tanidik_yuz" } },
					{ "id": "sec_panik_ikna", "metin": "İkna Seçeneği", "hedef": "d_ikna", "kosul": { "eylem_turu": "ikna" } },
					{ "id": "sec_panik_ret", "metin": "Final Ret", "hedef": "veda", "kosul": { "final_ret": true } },
					{ "id": "sec_karar_kisiti", "metin": "Karar Kısıt Seçeneği", "hedef": "d_kisit", "kosul": { "karar_kisiti": "kabul_izni" } }
				]
			},
			"d_tansiyon": { "id": "d_tansiyon", "satir": "Tansiyon", "secenekler": [] },
			"d_ipucu": { "id": "d_ipucu", "satir": "İpucu", "secenekler": [] },
			"d_bayrak": { "id": "d_bayrak", "satir": "Bayrak", "secenekler": [] },
			"d_ikna": { "id": "d_ikna", "satir": "İkna", "secenekler": [] },
			"d_kisit": { "id": "d_kisit", "satir": "Kısıt", "secenekler": [] },
			"veda": { "id": "veda", "satir": "Veda", "secenekler": [] }
		}
	}

	motor = SozMotoru.new()
	motor.yukle(kilit_dosyasi)

	# Bağlam 1: Tansiyon 5 iken tansiyon seçeneği görünmemeli (tansiyon_max: 2)
	var sec_t5 := motor.mevcut_secenekler({"tansiyon": 5})
	var t5_ids := sec_t5.map(func(s): return s.get("id"))
	if "sec_tansiyon" in t5_ids:
		hatalar.append("Tansiyon kilidi çalışmadı: tansiyon 5 iken max 2 seçeneği göründü!")

	# Bağlam 2: İpucu var iken ipucu seçeneği görünmeli
	var sec_clue := motor.mevcut_secenekler({"ipuclari": ["clue_01"]})
	var clue_ids := sec_clue.map(func(s): return s.get("id"))
	if not ("sec_ipucu" in clue_ids):
		hatalar.append("İpucu kilidi çalışmadı: gerekli ipucu varken seçenek görünmedi!")

	# Bağlam 3: Bayrak var iken bayrak seçeneği görünmeli
	var sec_flag := motor.mevcut_secenekler({"bayraklar": {"tanidik_yuz": true}})
	var flag_ids := sec_flag.map(func(s): return s.get("id"))
	if not ("sec_bayrak" in flag_ids):
		hatalar.append("Bayrak kilidi çalışmadı: bayrak varken seçenek görünmedi!")

	# Bağlam 4: Panik durumunda ikna seçeneği kapanmalı, Final Ret açık kalmalı
	var sec_panik := motor.mevcut_secenekler({"panik": true, "final_ret_uygun": true})
	var panik_ids := sec_panik.map(func(s): return s.get("id"))
	if "sec_panik_ikna" in panik_ids:
		hatalar.append("Panik kilidi çalışmadı: panikte ikna seçeneği açık kaldı!")
	if not ("sec_panik_ret" in panik_ids):
		hatalar.append("Panik kilidi hatası: Final Ret yolu kapandı!")

	# Bağlam 5: Karar kısıtı
	var sec_kisit := motor.mevcut_secenekler({"kabul_izni": true})
	var kisit_ids := sec_kisit.map(func(s): return s.get("id"))
	if not ("sec_karar_kisiti" in kisit_ids):
		hatalar.append("Karar kısıtı kilidi çalışmadı!")

	# 3. İkinci sonuç çağrısı etkiyi ikinci kez uygulamaz
	var etki_dosyasi := {
		"konusmaci": "chr_004",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Etki denemesi",
				"secenekler": [
					{ "id": "sec_etki", "metin": "Akçe Al", "hedef": "d_hedef", "etkiler": { "akce": 5 } }
				]
			},
			"d_hedef": { "id": "d_hedef", "satir": "Tamam", "secenekler": [] }
		}
	}
	motor = SozMotoru.new()
	motor.yukle(etki_dosyasi)
	var ilk_sec := motor.sec("sec_etki")
	var ilk_etki: Dictionary = ilk_sec.get("uygulanan_etkiler", {})
	if int(ilk_etki.get("akce", 0)) != 5:
		hatalar.append("İlk etki doğru uygulanmadı!")

	# Tekrar çağrılırsa boş veya önceden uygulandığı için sıfır etki dönmeli
	var ikinci_sec := motor._etkileri_uygula("sec_etki", {"akce": 5}, {})
	if not ikinci_sec.is_empty():
		hatalar.append("Aynı seçimin ikinci etki çağrısı etkiyi tekrar uyguladı!")

	# 4. 'altin' etki anahtarı ve boş metin anahtarı 1'er hata verir
	var hatali_anahtar_dosyasi := {
		"konusmaci": "chr_005",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "", # Boş metin anahtarı
				"secenekler": [
					{ "id": "sec_altin", "metin": "Altın", "hedef": "veda", "etkiler": { "altin": 10 } } # altin yasak
				]
			},
			"veda": { "id": "veda", "satir": "Bitti", "secenekler": [] }
		}
	}
	motor = SozMotoru.new()
	motor.yukle(hatali_anahtar_dosyasi)
	var altin_hatasi := false
	var bos_metin_hatasi := false
	for h in motor.hatalar:
		if "gecersiz_etki_anahtari_altin" in h:
			altin_hatasi = true
		if "bos_metin_anahtari_giris" in h:
			bos_metin_hatasi = true

	if not altin_hatasi:
		hatalar.append("'altin' etki anahtarı hata vermedi!")
	if not bos_metin_hatasi:
		hatalar.append("Boş metin anahtarı hata vermedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: soz_motoru_test.gd")
	quit(0)
