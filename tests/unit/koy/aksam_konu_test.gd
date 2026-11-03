# gdlint: disable=max-line-length
extends SceneTree

const AksamSohbeti = preload("res://src/koy/aksam_sohbeti.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	AksamSohbeti.sifirla()

	# 1. Yusuf kararı sonrası ağırlığı en yüksek olay konusu seçilir
	# Yusuf kararı: aileyi_bolmek (ağırlık 5) ve kacak_yetimi_almak (ağırlık 3)
	var kararlar := [
		{"konu_id": "kacak_yetimi_almak", "ziyaret_sirasi": 1},
		{"konu_id": "aileyi_bolmek", "ziyaret_sirasi": 2}
	]
	var secilen := AksamSohbeti.konu_sec(kararlar, 1, {"es_meslegi": "dokumaci", "es_hayatta": true})
	if secilen.is_empty():
		hatalar.append("AksamSohbeti konu seçemedi!")
	elif secilen.get("konu_id") != "aileyi_bolmek":
		hatalar.append("Ağırlığı en yüksek 'aileyi_bolmek' yerine '%s' seçildi!" % secilen.get("konu_id"))

	# 2. Eşit ağırlıkta ziyaret sırası büyük olan konu gelir
	AksamSohbeti.sifirla()
	var esit_kararlar := [
		{"konu_id": "aileyi_bolmek", "ziyaret_sirasi": 1}, # Ağırlık 5
		{"konu_id": "rusvet_almak", "ziyaret_sirasi": 4}   # Ağırlık 5, daha yeni
	]
	var esit_secim := AksamSohbeti.konu_sec(esit_kararlar, 1, {"es_meslegi": "firinci", "es_hayatta": true})
	if esit_secim.get("konu_id") != "rusvet_almak":
		hatalar.append("Eşit ağırlıkta ziyaret sırası büyük olan seçilmedi; seçilen: %s" % esit_secim.get("konu_id"))

	# 3. Atlama barı değiştirmez
	var atlama := AksamSohbeti.atla()
	if not atlama.get("atlandi", false) or atlama.get("moral_etkisi") != 0:
		hatalar.append("Atlama bar veya durum değiştirdi!")

	# 4. Ağırlığı 0 olan olay konu olmaz
	AksamSohbeti.sifirla()
	var sifir_karar := [
		{"konu_id": "olmayan_konu", "ziyaret_sirasi": 1}
	]
	var sifir_secim := AksamSohbeti.konu_sec(sifir_karar, 1, {"es_hayatta": true})
	if not sifir_secim.is_empty():
		hatalar.append("Ağırlığı 0 / tanınmayan olay konu olarak seçildi!")

	# 5. Cevap işleme ve eş hafızası kontrolü
	var cevap_sonucu := AksamSohbeti.cevap_ver("rusvet_almak", "savunmak", {"gun": 2})
	if cevap_sonucu.get("terazi") != "savundu":
		hatalar.append("Cevap teraziye 'savundu' olarak işlenmedi!")
	var hafiza := AksamSohbeti.hafiza_al()
	if hafiza.get("son_konu") != "rusvet_almak" or hafiza.get("son_cevap") != "savunmak":
		hatalar.append("Eş hafızası güncellenmedi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: aksam_konu_test.gd")
	quit(0)
