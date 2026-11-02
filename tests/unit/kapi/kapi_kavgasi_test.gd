## CAT-01: Geri cevrilen kavga cikarabilir birim testi.
## Kabul kriterleri:
## - Askersiz koyde kavga sahnesi 0'dir (kisi tehdit edip gider, tanik varsa dedikoduya yazilir).
## - Tip listesinde olmayan rette kavga bayragi 0'dir.
## - Asker 1 ve tip uygunken bayrak 1'dir.
## - Koy meydani, sifahane, divan ve heyet sirasinda kavga acilmaz; ayni kisi ayni gun ikinci istek uretmez;
##   asker ayrilirsa acilmamis istek tehdit_edip_gitti'ye, baslamis sahne kacti'ya doner.
extends SceneTree

const KapiKavgasiSinifi = preload("res://src/kapi/kapi_kavgasi.gd")
const DedikoduSinifi = preload("res://src/sistemler/dedikodu.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_test_askersiz_koyde_kavga_sifir_ve_dedikodu()
	_test_tip_listesinde_olmayan_rette_bayrak_sifir()
	_test_asker_bir_ve_tip_uygunken_bayrak_bir()
	_test_yasak_mekanlar_heyet_ve_ayni_gun_tek_istek()
	_test_asker_ayrilinca_acilmamis_ve_baslamis_sahne()

	await process_frame
	print("KAPI KAVGASI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_askersiz_koyde_kavga_sifir_ve_dedikodu() -> void:
	var kk := KapiKavgasiSinifi.new()
	var dedikodu := DedikoduSinifi.new()

	var sonuc: Dictionary = kk.ret_degerlendir({
		"kisi_id": "yolcu_01",
		"gun": 2,
		"mekan": "kapi",
		"neden": "yer_yoklugu",
		"tip": "genc_erkek",
		"asker_sayisi": 0,
		"tanik": "koylu_hasan",
	}, dedikodu)

	_kontrol(int(sonuc.get("kavga_bayragi", -1)) == 0 and not bool(sonuc.get("sahne_acildi", true)), "Askersiz köyde kavga sahnesi ve bayrağı 0 olmalı")
	_kontrol(String(sonuc.get("durum", "")) == "tehdit_edip_gitti", "Asker yokken durum tehdit_edip_gitti olmalı")
	_kontrol(bool(sonuc.get("dedikodu_yazildi", false)) and dedikodu.kayitlar().size() == 1, "Tanık varken tehdit edip gidiş dedikoduya yazılmalı")


func _test_tip_listesinde_olmayan_rette_bayrak_sifir() -> void:
	var kk := KapiKavgasiSinifi.new()
	var sonuc: Dictionary = kk.ret_degerlendir({
		"kisi_id": "yasli_hekim",
		"gun": 2,
		"mekan": "kapi",
		"neden": "sert_ret",
		"tip": "yasli_bilgin",
		"asker_sayisi": 2,
	})
	_kontrol(int(sonuc.get("kavga_bayragi", -1)) == 0, "Tip listesinde olmayan rette kavga bayrağı 0 olmalı")
	_kontrol(String(sonuc.get("durum", "")) == "siradan_ret", "Tip listesinde olmayan ret sıradan ret sayılmalı")


func _test_asker_bir_ve_tip_uygunken_bayrak_bir() -> void:
	var kk := KapiKavgasiSinifi.new()
	for tip in ["genc_erkek", "ac_aile_reisi", "asker_kacagi"]:
		var sonuc: Dictionary = kk.ret_degerlendir({
			"kisi_id": "kisi_" + tip,
			"gun": 3,
			"mekan": "kapi",
			"neden": "sert_ret",
			"tip": tip,
			"asker_sayisi": 1,
		})
		_kontrol(int(sonuc.get("kavga_bayragi", 0)) == 1 and bool(sonuc.get("sahne_acildi", false)), "Asker 1 ve tip '%s' uygunken bayrak 1 olmalı" % tip)


func _test_yasak_mekanlar_heyet_ve_ayni_gun_tek_istek() -> void:
	var kk := KapiKavgasiSinifi.new()
	for mekan in ["koy_meydani", "sifahane", "divan"]:
		var m_sonuc: Dictionary = kk.ret_degerlendir({
			"kisi_id": "kisi_" + mekan,
			"gun": 4,
			"mekan": mekan,
			"neden": "yer_yoklugu",
			"tip": "genc_erkek",
			"asker_sayisi": 2,
		})
		_kontrol(int(m_sonuc.get("kavga_bayragi", -1)) == 0, "%s mekanında kavga sahnesi 0 olmalı" % mekan)

	var heyet_sonuc: Dictionary = kk.ret_degerlendir({
		"kisi_id": "heyet_kisi",
		"gun": 4,
		"mekan": "kapi",
		"heyet_aktif": true,
		"neden": "sert_ret",
		"tip": "asker_kacagi",
		"asker_sayisi": 2,
	})
	_kontrol(int(heyet_sonuc.get("kavga_bayragi", -1)) == 0, "Heyet sırasında kavga açılmamalı")

	# Ayni kisi ayni gun ikinci kavga istegi uretmez
	var ilk: Dictionary = kk.ret_degerlendir({
		"kisi_id": "tekrar_eden",
		"gun": 5,
		"mekan": "kapi",
		"neden": "yer_yoklugu",
		"tip": "ac_aile_reisi",
		"asker_sayisi": 1,
	})
	var ikinci: Dictionary = kk.ret_degerlendir({
		"kisi_id": "tekrar_eden",
		"gun": 5,
		"mekan": "kapi",
		"neden": "sert_ret",
		"tip": "ac_aile_reisi",
		"asker_sayisi": 1,
	})
	_kontrol(int(ilk.get("kavga_bayragi", 0)) == 1 and int(ikinci.get("kavga_bayragi", -1)) == 0, "Aynı kişi aynı gün ikinci kavga isteği üretmemeli")


func _test_asker_ayrilinca_acilmamis_ve_baslamis_sahne() -> void:
	var kk := KapiKavgasiSinifi.new()
	var dedikodu := DedikoduSinifi.new()

	# 1) Henuz sahne baslamamisken asker ayrilirsa "tehdit_edip_gitti"ye doner
	kk.ret_degerlendir({
		"kisi_id": "bekleyen_kisi",
		"gun": 6,
		"mekan": "kapi",
		"neden": "yer_yoklugu",
		"tip": "genc_erkek",
		"asker_sayisi": 1,
		"tanik": "koylu_veli",
		"sahne_baslat": false,
	}, dedikodu)
	var ayrilis_1: Dictionary = kk.asker_ayrildi(dedikodu)
	_kontrol(String(ayrilis_1.get("sonuc", "")) == "tehdit_edip_gitti" and bool(ayrilis_1.get("dedikodu_yazildi", false)), "Açılmamış istekte asker ayrılırsa tehdit_edip_gitti olmalı")

	# 2) Sahne baslamisken asker ayrilirsa secenekler kapanir ve sonuc "kacti" sayilir
	kk.ret_degerlendir({
		"kisi_id": "aktif_kisi",
		"gun": 6,
		"mekan": "kapi",
		"neden": "sert_ret",
		"tip": "asker_kacagi",
		"asker_sayisi": 1,
		"sahne_baslat": true,
	}, dedikodu)
	var ayrilis_2: Dictionary = kk.asker_ayrildi(dedikodu)
	_kontrol(not bool(ayrilis_2.get("secenekler_acik", true)) and String(ayrilis_2.get("sonuc", "")) == "kacti", "Sahne başlamışken asker ayrılırsa seçenekler kapanmalı ve sonuç kaçtı olmalı")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
