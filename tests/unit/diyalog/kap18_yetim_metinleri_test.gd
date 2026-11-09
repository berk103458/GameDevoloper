extends SceneTree

const SozSemasi := preload("res://src/soz/soz_semasi.gd")
const SozMotoru := preload("res://src/soz/soz_motoru.gd")

var hata_sayisi: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		push_error("HATA: %s" % mesaj)
		hata_sayisi += 1


func _init() -> void:
	for yol in ["res://data/soz/yetim_kafilesi.json", "res://data/soz/en/yetim_kafilesi.json"]:
		var veri := _json_oku(yol)
		var sonuc := SozSemasi.dogrula(veri)
		_kontrol(sonuc.is_empty(), "KAP-18 sema hatasi (%s): %s" % [yol, str(sonuc)])
		var uyeler: Variant = veri.get("kafile_uyeleri", [])
		_kontrol(uyeler is Array and (uyeler as Array).size() == 3, "KAP-18 kafile_uyeleri 3 cocuk icermeli: %s" % yol)
		if uyeler is Array:
			for u in uyeler:
				_kontrol(u is Dictionary and String((u as Dictionary).get("yas_grubu", "")) == "cocuk", "KAP-18 her uye cocuk yas grubunda olmali: %s" % yol)
				_kontrol(not bool((u as Dictionary).get("calisir_mi", true)), "KAP-18 cocuk calismamali: %s" % yol)
				_kontrol(int((u as Dictionary).get("gence_gecis_gunu", 0)) == 28, "KAP-18 gence gecis gunu 28 olmali: %s" % yol)

	var tr_veri := _json_oku("res://data/soz/yetim_kafilesi.json")
	var motor := SozMotoru.new()
	var baglam: Dictionary = {"tansiyon": 0, "bayraklar": ["mogol_ilerleyisi_etki"]}
	var yukle_sonuc := motor.yukle(tr_veri, baglam)
	_kontrol(not yukle_sonuc.is_empty(), "KAP-18 SozMotoru yukle basarisiz.")
	var secim := motor.sec("sec_yetim_emanet", baglam)
	_kontrol(not secim.is_empty() and String(secim.get("hedef", "")) == "konu_hane_emaneti", "KAP-18 SozMotoru secim hatasi: %s" % str(secim))
	var secim2 := motor.sec("sec_emanet_kabul_hane", baglam)
	_kontrol(not secim2.is_empty() and String(secim2.get("hedef", "")) == "kabul_sonuc", "KAP-18 SozMotoru kabul secim hatasi: %s" % str(secim2))

	var csv_metin := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	for anahtar in [
		"kap18.yetim.kafile_baslik",
		"kap18.yetim.kafile_acilis",
		"kap18.yetim.kabul_hane",
		"kap18.yetim.kabul_es",
		"kap18.yetim.kabul_acikta",
		"kap18.yetim.ret_sonuc",
		"kap18.yetim.genc_oldu",
		"kap18.yetim.uye.elif_not",
		"kap18.yetim.uye.sungurcuk_not",
		"kap18.yetim.uye.bala_not"
	]:
		_kontrol(csv_metin.contains(anahtar + ","), "KAP-18 eksik CSV anahtari: %s" % anahtar)

	if hata_sayisi > 0:
		push_error("KAP-18 testi BASARISIZ (Toplam hata: %d)" % hata_sayisi)
		quit(1)
	else:
		print("KAP-18 yetim metinleri ve diyalog agaci testi gecti (0 hata).")
		quit(0)


func _json_oku(yol: String) -> Dictionary:
	var ham := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(ham)
	return parsed if parsed is Dictionary else {}
