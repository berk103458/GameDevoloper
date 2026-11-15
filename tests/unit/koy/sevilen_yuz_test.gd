# gdlint: disable=max-line-length
extends SceneTree

const SevilenYuz = preload("res://src/koy/sevilen_yuz.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	var sy := SevilenYuz.new()

	# 1. SEV-01: Boş gün kontrolü
	if not sy.bos_gun_mu([]):
		hatalar.append("Ziyaretçi yokken boş gün olarak tespit edilmedi!")
	if sy.bos_gun_mu([{"id": "chr_001"}]):
		hatalar.append("Ziyaretçi varken boş gün olarak kabul edildi!")

	# 2. SEV-02: Tanıdık yüz ateşe gelir
	var koy_kaydi := [
		{"id": "chr_004", "ad": "Yusuf", "durum": "koyde", "son_karar": "kabul"}
	]
	var ates_kisi := sy.ates_ziyaretcisi_sec(koy_kaydi)
	if ates_kisi.get("ad") != "Yusuf" or not ates_kisi.has("ates_sozu"):
		hatalar.append("Tanıdık yüz Yusuf ateşe gelmedi!")

	# 3. SEV-03: Kişisel iz
	sy.kisisel_iz_birak("chr_004", "ahsap_oyuncak")
	if sy.kisisel_izler.get("chr_004") != "ahsap_oyuncak":
		hatalar.append("Kişisel iz köyde kalmadı!")

	# 4. SEV-04: Tek istek
	var istek := sy.istek_uret("chr_004")
	if istek.get("istek") != "bir_cuval_tohum":
		hatalar.append("Tek istek üretilemedi!")

	# 5. SEV-05: Köylü bağları
	sy.bag_kur("chr_004", "chr_005", "dostluk")
	if sy.koylu_baglari.is_empty():
		hatalar.append("Köylüler arası bağ kurulmadı!")

	# 6. SEV-06: İsim ancak sorulunca kartta durur
	var ilk_kart_adi := sy.kart_gorunum_adi("chr_004", "Yusuf", "Çoban")
	if ilk_kart_adi != "Çoban":
		hatalar.append("İsim sorulmadan kartta gerçek ad göründü! (Beklenen: Çoban)")
	sy.isim_sor("chr_004")
	var sonraki_kart_adi := sy.kart_gorunum_adi("chr_004", "Yusuf", "Çoban")
	if sonraki_kart_adi != "Yusuf":
		hatalar.append("İsim sorulduktan sonra kartta gerçek ad görünmedi!")

	# 7. SEV-07: Veda o kişiyi götürür
	var veda := sy.veda_et("chr_004")
	if not veda.get("ayrildi"):
		hatalar.append("Veda edilen kişi ayrılmadı!")
	if not sy.ates_ziyaretcisi_sec(koy_kaydi).is_empty():
		hatalar.append("Ayrılan kişi tekrar ateşe geldi!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: sevilen_yuz_test.gd")
	quit(0)
