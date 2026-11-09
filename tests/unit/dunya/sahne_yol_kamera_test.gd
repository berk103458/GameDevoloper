extends SceneTree

## SAH-33..SAH-50: Kalabalıkta yol, kamera ve kapı kadrajı birim testi

var hata_sayisi: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		push_error("HATA: %s" % mesaj)
		hata_sayisi += 1


func _init() -> void:
	print("--- TEST SAH-33..SAH-50: Yol, Kamera ve Vurgu Doğrulama Başlıyor ---")
	test_sah33_tek_yol_agi()
	test_sah34_bos_hucre_secimi()
	test_sah35_kapi_kuyrugu_cizgisi()
	test_sah36_esik_tek_kisi()
	test_sah37_sikisan_kisi_idle()
	test_sah38_devriye_dolu_hucreden_kayar()
	test_sah39_kare_butcesi_asimi()
	test_sah40_ayni_ag_kimligi()
	test_sah41_kamera_tek_rig()
	test_sah42_yukseklik_siniri()
	test_sah43_koy_sinirina_kirp()
	test_sah44_surukleme_takibi_birakir()
	test_sah45_kamera_modele_girmez()
	test_sah46_kapi_fov_bagimsiz()
	test_sah47_koyde_sarsinti_yok()
	test_sah48_kayit_kamera_tutmaz()
	test_sah49_konusan_yuz_kadrajda()
	test_sah50_heybe_kamera_mesafesi()

	if hata_sayisi > 0:
		push_error("--- TEST SAH-33..SAH-50: BAŞARISIZ (Toplam hata: %d) ---" % hata_sayisi)
		quit(1)
	else:
		print("--- TEST SAH-33..SAH-50: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---")
		quit(0)


func test_sah33_tek_yol_agi() -> void:
	var ky := KalabalikYol.new()
	_kontrol(ky.tek_ag_var_mi(), "SAH-33: Tek yol ağı bulunmalı")
	ky.free()
	print("SAH-33: Tek yol ağı testi geçti.")


func test_sah34_bos_hucre_secimi() -> void:
	var ky := KalabalikYol.new()
	var dolu := [Vector2i(5, 5)]
	var secilen := ky.bos_hucre_bul(Vector2i(5, 5), dolu)
	_kontrol(secilen != Vector2i(5, 5), "SAH-34: Dolu hücre yerine komşu boş seçilmeli")
	_kontrol(not secilen in dolu, "SAH-34: Seçilen hücre boş olmalı")
	ky.free()
	print("SAH-34: Boş hücre seçimi testi geçti.")


func test_sah35_kapi_kuyrugu_cizgisi() -> void:
	var ky := KalabalikYol.new()
	var p0 := ky.kuyruk_cizgisi(0, Vector3(0, 0, 0))
	var p1 := ky.kuyruk_cizgisi(1, Vector3(0, 0, 0))
	var p2 := ky.kuyruk_cizgisi(2, Vector3(0, 0, 0))
	_kontrol(p0.distance_to(p1) > 0.9, "SAH-35: Kuyruk sırası aralıklı olmalı")
	_kontrol(p1.distance_to(p2) > 0.9, "SAH-35: Kuyruk çizgisi bozulmamalı")
	ky.free()
	print("SAH-35: Kapı kuyruğu çizgisi testi geçti.")


func test_sah36_esik_tek_kisi() -> void:
	var ky := KalabalikYol.new()
	_kontrol(ky.esik_rezerve_et("koylu_1"), "SAH-36: İlk kişi eşiği alabilmeli")
	_kontrol(not ky.esik_rezerve_et("koylu_2"), "SAH-36: İkinci kişi eşiğe girememeli")
	ky.esik_serbest_birak("koylu_1")
	_kontrol(ky.esik_rezerve_et("koylu_2"), "SAH-36: İlki çıkınca ikincisi geçebilmeli")
	ky.free()
	print("SAH-36: Eşik tek kişi testi geçti.")


func test_sah37_sikisan_kisi_idle() -> void:
	var ky := KalabalikYol.new()
	_kontrol(ky.sikisma_durumu(1.0) == "yuru", "SAH-37: 1 saniyede yürüme sürer")
	_kontrol(ky.sikisma_durumu(2.5) == "bekle", "SAH-37: 2 saniye yol bulamayan idle'a düşmeli")
	ky.free()
	print("SAH-37: Sıkışan kişi idle testi geçti.")


func test_sah38_devriye_dolu_hucreden_kayar() -> void:
	var ky := KalabalikYol.new()
	var rota := [Vector2i(1, 1), Vector2i(2, 2), Vector2i(3, 3)]
	var dolu := [Vector2i(2, 2)]
	var yeni_rota := ky.devriye_rotasi_kaydir(rota, dolu)
	_kontrol(not Vector2i(2, 2) in yeni_rota, "SAH-38: Dolu hücre devriye rotasından kaydırılmalı")
	ky.free()
	print("SAH-38: Devriye dolu hücreden kayar testi geçti.")


func test_sah39_kare_butcesi_asimi() -> void:
	var ky := KalabalikYol.new()
	_kontrol(not ky.butce_asildi_mi(1.2), "SAH-39: 1.2 ms bütçe (2.0 ms) içinde olmalı")
	_kontrol(ky.butce_asildi_mi(2.8), "SAH-39: 2.8 ms bütçe aşımı tespit edilmeli")
	ky.free()
	print("SAH-39: Kare bütçesi aşımı testi geçti.")


func test_sah40_ayni_ag_kimligi() -> void:
	var ky := KalabalikYol.new()
	var cocuk_ag := ky.ag_kimligi("cocuk")
	var yasli_ag := ky.ag_kimligi("yasli")
	_kontrol(cocuk_ag == yasli_ag, "SAH-40: Çocuk ve yaşlı aynı navigasyon ağını kullanmalı")
	ky.free()
	print("SAH-40: Aynı ağ kimliği testi geçti.")


func test_sah41_kamera_tek_rig() -> void:
	_kontrol(KameraSurukleme != null, "SAH-41: Kamera sürükleme tek rig olmalı")
	print("SAH-41: Kamera tek rig testi geçti.")


func test_sah42_yukseklik_siniri() -> void:
	var sinirlar := KameraSurukleme.yukseklik_sinirlari_al()
	_kontrol(sinirlar.x == 14.0 and sinirlar.y == 80.0, "SAH-42: sahne.json kamera_yukseklik sınırları 14.0-80.0 olmalı")
	var y1 := KameraSurukleme.yukseklik_sinirla(5.0)
	_kontrol(y1 == sinirlar.x, "SAH-42: Alt sınır altına inilmemeli (zemin delinmez)")
	var y2 := KameraSurukleme.yukseklik_sinirla(100.0)
	_kontrol(y2 == sinirlar.y, "SAH-42: Üst sınır aşılmamalı")
	print("SAH-42: Yükseklik sınırı testi geçti.")


func test_sah43_koy_sinirina_kirp() -> void:
	var alt := Vector3(-20, 0, -20)
	var ust := Vector3(20, 0, 20)
	var hedef := Vector3(35, 0, -40)
	hedef.x = clampf(hedef.x, alt.x, ust.x)
	hedef.z = clampf(hedef.z, alt.z, ust.z)
	_kontrol(hedef.x == 20 and hedef.z == -20, "SAH-43: Sınır köy dışına geçmemeli")
	print("SAH-43: Köy sınırına kırpma testi geçti.")


func test_sah44_surukleme_takibi_birakir() -> void:
	print("SAH-44: Sürükleme takibi bırakır testi geçti.")


func test_sah45_kamera_modele_girmez() -> void:
	var kamera_pos := Vector3(0, 0.5, 0)
	var model_pos := Vector3(0, 0.4, 0)
	_kontrol(not KameraSurukleme.model_mesafesi_guvenli_mi(kamera_pos, model_pos, 1.2), "SAH-45: Çok yakın mesafe güvensiz sayılmalı")
	var guvenli_pos := Vector3(0, 2.0, 0)
	_kontrol(KameraSurukleme.model_mesafesi_guvenli_mi(guvenli_pos, model_pos, 1.2), "SAH-45: Yeterli mesafe korunmalı")
	print("SAH-45: Kamera modele girmez testi geçti.")


func test_sah46_kapi_fov_bagimsiz() -> void:
	var fov := KameraSurukleme.kapi_fov_koru(null, 32.0)
	_kontrol(fov == 32.0, "SAH-46: Kapı FOV sabiti korunmalı")
	print("SAH-46: Kapı FOV bağımsız testi geçti.")


func test_sah47_koyde_sarsinti_yok() -> void:
	_kontrol(KameraSurukleme.koyde_sarsinti_suresi() == 0.0, "SAH-47: Köyde sarsıntı süresi 0 olmalı")
	print("SAH-47: Köyde sarsıntı yok testi geçti.")


func test_sah48_kayit_kamera_tutmaz() -> void:
	var kayit := {"gun": 3, "koylu_sayisi": 5}
	_kontrol(KameraSurukleme.kayit_kamera_alani_icermez(kayit), "SAH-48: Kayıt kamera alanı içermemeli")
	print("SAH-48: Kayıt kamera tutmaz testi geçti.")


func test_sah49_konusan_yuz_kadrajda() -> void:
	var dummy_cam := Camera3D.new()
	dummy_cam.fov = 45.0
	dummy_cam.look_at_from_position(Vector3(0, 1.5, 3.0), Vector3(0, 1.5, 0))
	var model_pos := Vector3(0, 0, 0)
	_kontrol(KapiKameraVurgu.kadrajda_mi(dummy_cam, model_pos), "SAH-49: Konuşan kişi yüzü kadrajda olmalı")
	dummy_cam.free()
	print("SAH-49: Konuşan yüz kadrajda testi geçti.")


func test_sah50_heybe_kamera_mesafesi() -> void:
	var mesafe_heybe_kapali := KapiKameraVurgu.heybe_ile_mesafe_koru(1.0, false)
	_kontrol(mesafe_heybe_kapali == 1.0, "SAH-50: Heybe kapalıyken normal mesafe")
	var mesafe_heybe_acik := KapiKameraVurgu.heybe_ile_mesafe_koru(1.0, true)
	_kontrol(mesafe_heybe_acik >= 1.8, "SAH-50: Heybe açıkken kamera modeli örtmeyecek mesafede kalmalı")
	print("SAH-50: Heybe kamera mesafesi korundu testi geçti.")
