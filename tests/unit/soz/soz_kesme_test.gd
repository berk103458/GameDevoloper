# gdlint: disable=max-line-length
extends SceneTree

const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var dosya := {
		"konusmaci": "chr_013",
		"cekirdek": "durust",
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Eski zamanlarda uzun bir yolculuk vardı",
				"secenekler": [
					{ "id": "sec_kes", "hedef": "d_uzun_hikaye", "metin": "Sadede gel! [Söz Kes]", "kesme": true },
					{ "id": "sec_soru", "hedef": "d_soru", "metin": "Soru sor", "muhafiz_cevabi": "cevabi_verdim" }
				]
			},
			"d_uzun_hikaye": {
				"id": "d_uzun_hikaye",
				"satir": "Masal gibi devam ederdi...",
				"secenekler": []
			},
			"d_soru": {
				"id": "d_soru",
				"satir": "Muhafız bey ne dersin?",
				"secenekler": [
					{ "id": "sec_kosullu", "hedef": "veda", "metin": "Cevaba göre seçenek", "kosul": { "gerekli_soylenen": "cevabi_verdim" } },
					{ "id": "sec_olmayan_kosullu", "hedef": "veda", "metin": "Olmayan cevaba göre", "kosul": { "gerekli_soylenen": "baska_cevap" } }
				]
			},
			"veda": { "id": "veda", "satir": "Son", "secenekler": [] }
		}
	}

	var motor := SozMotoru.new()
	motor.yukle(dosya)

	# 1. Söz kesme: cümle "—" ile biter, sabır +1, güven -1
	var baslangic_sabir := motor.sabir
	var baslangic_guven := motor.guven
	var kesme_sonuc := motor.sec("sec_kes")

	if not motor.son_satir.ends_with("—"):
		hatalar.append("Kesilen cümle '—' ile bitmedi: '%s'" % motor.son_satir)
	if motor.sabir != baslangic_sabir + 1:
		hatalar.append("Söz kesme sabrı 1 artırmadı! (Eski: %d, Yeni: %d)" % [baslangic_sabir, motor.sabir])
	if motor.guven != baslangic_guven - 1:
		hatalar.append("Söz kesme güveni 1 düşürmedi! (Eski: %d, Yeni: %d)" % [baslangic_guven, motor.guven])

	# Kesilen anlatının devam düğümüne erişim 0'dır (Kabul)
	var secenekler := motor.mevcut_secenekler()
	var sec_ids := secenekler.map(func(s): return s.get("id"))
	if "sec_kes" in sec_ids:
		hatalar.append("Kesilen düğüme giden seçenek listede açık kaldı!")

	# 2. Karşı soru ve muhafız cevabı testi
	motor = SozMotoru.new()
	motor.yukle(dosya)
	baslangic_sabir = motor.sabir

	motor.sec("sec_soru")
	# Karşı soru kalan sabrı 1 düşürür (Kabul)
	if motor.sabir != baslangic_sabir - 1:
		hatalar.append("Karşı soru sabrı 1 düşürmedi! (Eski: %d, Yeni: %d)" % [baslangic_sabir, motor.sabir])

	# 3. 'soylenen' yokken koşullu varyant 0 kez seçilir (Kabul)
	var soru_secenekleri := motor.mevcut_secenekler()
	var soru_sec_ids := soru_secenekleri.map(func(s): return s.get("id"))
	if not ("sec_kosullu" in soru_sec_ids):
		hatalar.append("Verilen cevaba ait koşullu seçenek görünmedi!")
	if "sec_olmayan_kosullu" in soru_sec_ids:
		hatalar.append("Verilmeyen cevaba ait ('baska_cevap') seçenek listede göründü! (Beklenen: 0)")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: soz_kesme_test.gd")
	quit(0)
