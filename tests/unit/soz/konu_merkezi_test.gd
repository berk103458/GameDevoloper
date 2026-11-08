# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")
const KonuMerkezi = preload("res://src/soz/konu_merkezi.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_006",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam muhafız bey.",
				"secenekler": [
					{ "id": "sec_nereden", "hedef": "d_nereden", "metin": "Nereden gelirsin?" },
					{ "id": "sec_neden", "hedef": "d_neden", "metin": "Neden yola düştün?" },
					{ "id": "sec_is", "hedef": "d_is", "metin": "Ne iş bilirsin?" },
					{ "id": "sec_veda", "hedef": "veda", "metin": "Güle güle." }
				]
			},
			"d_nereden": {
				"id": "d_nereden",
				"konu": "nereden",
				"satir": "Kayseri sancağından gelirim.",
				"secenekler": [
					{ "id": "sec_don", "hedef": "giris", "metin": "Başka sorum var." }
				]
			},
			"d_neden": {
				"id": "d_neden",
				"konu": "neden_yola_dustun",
				"gece_min": 0,
				"satir": "Yurdumuzu terk eyledik.",
				"secenekler": [
					{ "id": "sec_neden_don", "hedef": "giris", "metin": "Anladım." }
				]
			},
			"d_is": {
				"id": "d_is",
				"konu": "ne_is_bilirsin",
				"gece_min": 1,
				"satir": "Nalbantım.",
				"secenekler": [
					{ "id": "sec_is_bitti", "hedef": "veda", "metin": "Yeterli." }
				]
			},
			"veda": {
				"id": "veda",
				"satir": "Sağ olasın.",
				"secenekler": []
			}
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)
	var km := KonuMerkezi.new(motor)

	# 1. Selam öncesi konu listesi 0 düğümdür (Kabul)
	var oncesi_konular := km.mevcut_konular()
	if not oncesi_konular.is_empty():
		hatalar.append("Selam öncesi konu listesi dolu döndü! (Beklenen: 0)")

	# 2. Selam okunduktan sonra konular gelir
	var selam := km.selam_oku()
	if selam != "Selam muhafız bey.":
		hatalar.append("Selam satırı doğru okunmadı: '%s'" % selam)

	# OGR-13: Gece 0 ilk ailede açık konu 2'dir (nereden ve neden_yola_dustun); gece_min=1 olan ne_is_bilirsin kapalıdır
	var gece0_konulari := km.mevcut_konular(0)
	if gece0_konulari.size() != 2:
		hatalar.append("OGR-13: gece 0 açık konu 2 olmalı! Bulunan: %d" % gece0_konulari.size())
	for k in gece0_konulari:
		if k.get("konu_id") not in ["nereden", "neden_yola_dustun"]:
			hatalar.append("OGR-13: gece 0 konusu beklenmeyen: %s" % str(k.get("konu_id")))

	var sonrasi_konular := km.mevcut_konular() # parametresiz veya gece >= 1: tüm konular
	if sonrasi_konular.size() != 3: # nereden, neden_yola_dustun ve ne_is_bilirsin
		hatalar.append("Selam sonrası tüm konular eksik veya hatalı: %d konu bulundu" % sonrasi_konular.size())

	# 3. Konu düğümünde karar çubuğu 0 kez etkindir (Kabul)
	if km.karar_cubugu_etkin:
		hatalar.append("Selam sonrası karar çubuğu açık görünüyor! (Beklenen: kapalı)")

	var secim_sonucu := km.konu_sec("sec_nereden")
	if km.karar_cubugu_etkin:
		hatalar.append("Konu düğümünde karar çubuğu etkinleşti! (Beklenen: 0 kez etkin)")

	# 4. Veda düğümüne geçilince karar çubuğu etkinleşmeli
	km.konu_sec("sec_don")
	km.konu_sec("sec_is")
	km.konu_sec("sec_is_bitti")
	if not km.karar_cubugu_etkin:
		hatalar.append("Veda sonrası karar çubuğu etkinleşmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: konu_merkezi_test.gd")
	quit(0)
