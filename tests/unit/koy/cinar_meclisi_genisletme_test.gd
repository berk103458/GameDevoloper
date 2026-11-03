# gdlint: disable=max-line-length
extends SceneTree

const MeclisSesi = preload("res://src/koy/meclis_sesi.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	# 1. MCL-02: Şikayet kararın adını taşır
	var sikayet := MeclisSesi.sikayet_metni("aileyi_bolme", "Rençber Ali")
	if not ("aileyi_bolme" in sikayet) or not ("Rençber Ali" in sikayet):
		hatalar.append("Şikayet metni kararın veya konuşmacının adını taşımıyor: '%s'" % sikayet)

	# 2. MCL-03: Eş veya usta sözü
	var usta_soz := MeclisSesi.usta_veya_es_sozu("usta", "Demirci Karaca")
	if usta_soz.get("rol") != "usta" or not ("Demirci Karaca" in usta_soz.get("satir")):
		hatalar.append("Usta sözü doğru oluşturulamadı!")

	# 3. MCL-04: Oy duran değere yazar
	var barlar := { "adalet": 50, "moral": 50, "asayis": 50 }
	MeclisSesi.oyu_uygula(barlar, "kabul")
	if barlar["adalet"] != 53:
		hatalar.append("Kabul oyu adaleti artırmadı!")

	# 4. MCL-05: Meclis her gece açılmaz
	if MeclisSesi.meclis_acik_mi(2, true): # Çift gün, açılmamalı
		hatalar.append("Meclis çift günde de açık göründü! (Beklenen: her gece açılmaz)")
	if not MeclisSesi.meclis_acik_mi(3, true):
		hatalar.append("Meclis krizli günde açılamadı!")

	# 5. MCL-06: Karar metni konuşulan adı söyler
	var k_metin := MeclisSesi.karar_metni(true, "Çoban Yusuf")
	if not ("Çoban Yusuf" in k_metin):
		hatalar.append("Karar metni konuşulan kişinin adını taşımıyor!")

	# 6. MCL-07: En ağır kararın sahibi önce konuşur
	var kararlar := [
		{ "ad": "az_onemli", "agirlik": 2 },
		{ "ad": "cok_agir", "agirlik": 5 }
	]
	var sirali := MeclisSesi.agirlik_sirala(kararlar)
	if sirali[0].get("ad") != "cok_agir":
		hatalar.append("En ağır karar ilk sıraya yerleşmedi!")

	# 7. MCL-09: Meclis savaş, bina ve son açamaz
	if not MeclisSesi.eylem_yasak_mi("savas") or not MeclisSesi.eylem_yasak_mi("bina") or not MeclisSesi.eylem_yasak_mi("son"):
		hatalar.append("Savaş, bina ve son eylemleri meclise kapalı sayılmadı!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: cinar_meclisi_genisletme_test.gd")
	quit(0)
