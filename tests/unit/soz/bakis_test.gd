# gdlint: disable=max-line-length
extends SceneTree

const Bakis = preload("res://src/soz/bakis.gd")
const SozMotoru = preload("res://src/soz/soz_motoru.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var bakis_sistemi := Bakis.new()
	var motor := SozMotoru.new()
	motor.sabir = 10

	var yusuf_bakis := {
		"eller": {
			"satirlar": ["Nasırlı, çatlak parmaklar."],
			"ipucu": "clue_yusuf_eller",
			"tepki": ["Ne bakarsın elime muhafız?"]
		},
		"carik": {
			"satirlar": ["Yırtık, yamalı dağ çarığı."],
			"ipucu": "clue_yusuf_carik",
			"tepki": ["Ayazda yol yürüyenin çarığı eskir."]
		},
		"kese": {
			"satirlar": ["Kuşağında şişkin bir deri kese."],
			"ipucu": "clue_yusuf_kese",
			"tepki": ["Kesemde bakır akçem var ancak."]
		},
		"yuz": {
			"satirlar": ["Güneşten yanmış, solgun bir sima."],
			"ipucu": "clue_yusuf_yuz",
			"tepki": ["Yüzümde bir şey mi var beyim?"]
		}
	}

	# 1. Yusuf'ta eller, çarık, kese ve yüzde bakış vardır (Kabul)
	for b in ["eller", "carik", "kese", "yuz"]:
		if not yusuf_bakis.has(b):
			hatalar.append("Yusuf bakış verisinde '%s' bölgesi eksik!" % b)

	# 2. Her bölge sabırdan 1 düşer (Kabul)
	var onceki_sabir := motor.sabir
	var sonuc_el := bakis_sistemi.bak("eller", yusuf_bakis, {"isik": true}, motor)
	if motor.sabir != onceki_sabir - 1:
		hatalar.append("Bakış sabırdan 1 düşürmedi! (Eski: %d, Yeni: %d)" % [onceki_sabir, motor.sabir])
	if sonuc_el.get("ipucu") != "clue_yusuf_eller":
		hatalar.append("İlk bakışta ipucu üretilmedi!")

	# 3. Tekrar bakış yeni ipucu üretmez (Kabul)
	var tekrar_sonuc := bakis_sistemi.bak("eller", yusuf_bakis, {"isik": true}, motor)
	if not str(tekrar_sonuc.get("ipucu", "")).is_empty():
		hatalar.append("Tekrar bakış yeni ipucu üretti! (Beklenen: boş)")

	# 4. Işıksız yüzde ipucu 0'dır (Kabul)
	var isiksiz_sonuc := bakis_sistemi.bak("yuz", yusuf_bakis, {"isik": false}, motor)
	if not str(isiksiz_sonuc.get("ipucu", "")).is_empty():
		hatalar.append("Işıksız bakışta ipucu üretildi! (Beklenen: 0 ipucu)")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: bakis_test.gd")
	quit(0)
