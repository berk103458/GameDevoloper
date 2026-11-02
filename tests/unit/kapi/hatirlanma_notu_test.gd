## DIY-14: "Bu hatirlanacak" bildirimi birim testi.
## Kabul kriterleri:
## - Ayar kapaliyken not 0 kez gorunur, kayit 1 kez yazilir.
## - Tek secimde (hem hafiza hem dedikodu olsa bile) not sayisi 1'dir.
## - Metinde ozel ad, grup ve gece sayisi 0'dir ("Bu hatırlanacak").
## - Not 2 saniye sonra veya tiklaninca kapanir; ikinci not birincinin ustune binmez.
extends SceneTree

const HatirlanmaNotuSinifi = preload("res://src/arayuz/kapi/hatirlanma_notu.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_test_ayar_kapaliyken_not_sifir_kayit_bir()
	_test_tek_secimde_hem_hafiza_hem_dedikodu_bir_not()
	_test_metinde_ozel_ad_ve_gece_yok()
	_test_iki_saniye_kapanis_tiklama_ve_ust_uste_binmeme()

	await process_frame
	print("HATIRLANMA NOTU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_ayar_kapaliyken_not_sifir_kayit_bir() -> void:
	var not_ui := HatirlanmaNotuSinifi.new()
	not_ui.bildirim_acik = false
	var yazilan := {"sayac": 0}
	var sonuc: Dictionary = not_ui.secim_bildir(
		{"hafiza": true, "isim": "Yusuf", "gece": 4},
		func() -> void: yazilan["sayac"] = int(yazilan["sayac"]) + 1
	)
	_kontrol(not_ui.gorunme_sayisi() == 0 and not not_ui.visible, "Ayar kapalıyken not 0 kez görünmeli")
	_kontrol(int(yazilan["sayac"]) == 1 and not_ui.kayit_yazim_sayisi() == 1, "Ayar kapalıyken kayıt 1 kez yazılmalı")
	_kontrol(bool(sonuc.get("kayit_yazildi", false)) and int(sonuc.get("not_sayisi", -1)) == 0, "Sonuç sözlüğü kayıt=true, not_sayisi=0 dönmeli")
	not_ui.free()


func _test_tek_secimde_hem_hafiza_hem_dedikodu_bir_not() -> void:
	var not_ui := HatirlanmaNotuSinifi.new()
	var sonuc: Dictionary = not_ui.secim_bildir({"hafiza": true, "dedikodu": true})
	_kontrol(int(sonuc.get("not_sayisi", 0)) == 1, "Hem hafıza hem dedikodu olan tek seçimde not sayısı 1 olmalı")
	_kontrol(not_ui.gorunme_sayisi() == 1 and not_ui.aktif_not_sayisi() == 1, "Ekranda yalnız 1 not açılmalı")
	not_ui.free()


func _test_metinde_ozel_ad_ve_gece_yok() -> void:
	var not_ui := HatirlanmaNotuSinifi.new()
	var sonuc: Dictionary = not_ui.secim_bildir({
		"hafiza": true,
		"dedikodu": true,
		"isim": "Yusuf",
		"grup": "Türkmen",
		"gece": 3,
	})
	var metin := String(sonuc.get("metin", ""))
	_kontrol(metin == "Bu hatırlanacak", "Not metni tam olarak 'Bu hatırlanacak' olmalı (alınan='%s')" % metin)
	_kontrol(not metin.contains("Yusuf") and not metin.contains("Türkmen") and not metin.contains("3"), "Metinde özel ad, grup ve gece sayısı 0 olmalı")
	not_ui.free()


func _test_iki_saniye_kapanis_tiklama_ve_ust_uste_binmeme() -> void:
	var not_ui := HatirlanmaNotuSinifi.new()
	# Hafiza veya dedikodu yoksa not cikmamali
	var bos_sonuc: Dictionary = not_ui.secim_bildir({"hafiza": false, "dedikodu": false})
	_kontrol(not bool(bos_sonuc.get("not_gorundu", true)) and not not_ui.visible, "Hafıza ve dedikodu yoksa not çıkmamalı")

	# ZAR-03 kacis hafizaya yaziyorsa not cikar
	not_ui.secim_bildir({"kacis_hafiza": true})
	_kontrol(not_ui.visible and is_equal_approx(not_ui.kalan_sure(), 2.0), "Kaçış hafızaya yazıyorsa 2 saniyelik not açılmalı")

	# Ikinci not birincinin ustune binmez; birincisi kapanir, kuyruk birikmez
	not_ui.ilerlet(1.0)
	not_ui.secim_bildir({"dedikodu": true})
	_kontrol(not_ui.aktif_not_sayisi() == 1 and is_equal_approx(not_ui.kalan_sure(), 2.0), "İkinci not birincinin üstüne binmemeli, süre yenilenip tek not kalmalı")

	# 2 saniye sonra kapanir
	not_ui.ilerlet(2.0)
	_kontrol(not not_ui.visible and not_ui.aktif_not_sayisi() == 0, "2 saniye sonunda not kendiliğinden kapanmalı")

	# Tiklaninca da kapanir
	not_ui.secim_bildir({"hafiza": true})
	_kontrol(not_ui.visible, "Not yeniden açılmalı")
	not_ui.tikla()
	_kontrol(not not_ui.visible and not_ui.aktif_not_sayisi() == 0, "Tıklanınca not hemen kapanmalı")
	not_ui.free()


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
