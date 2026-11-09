extends SceneTree

## SAH-17..SAH-32: Hareket geçişi ve animasyon karıştırma birim testi

var hata_sayisi: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		push_error("HATA: %s" % mesaj)
		hata_sayisi += 1


func _init() -> void:
	print("--- TEST SAH-17..SAH-32: Hareket Geçişi Doğrulama Başlıyor ---")
	test_sah17_uc_hiz_bandi()
	test_sah18_karisik_gecis()
	test_sah19_kosu_kosullari()
	test_sah20_durus_cila_baglantisi()
	test_sah21_yokus_adim_kisalmasi()
	test_sah22_yorgun_yuruyus()
	test_sah23_kapi_bekleme()
	test_sah24_zorluk_gecis_suresi()
	test_sah25_karisim_agirliklari_toplami()
	test_sah26_ust_konus_alt_yuru()
	test_sah27_eksik_klip_idle_duser()
	test_sah28_geciste_ofset_korunur()
	test_sah29_tezgah_yuruyusle_karismaz()
	test_sah30_hava_katmani()
	test_sah31_kayit_klip_agirligi_tutmaz()
	test_sah32_uc_gecis_filtresi()

	if hata_sayisi > 0:
		push_error("--- TEST SAH-17..SAH-32: BAŞARISIZ (Toplam hata: %d) ---" % hata_sayisi)
		quit(1)
	else:
		print("--- TEST SAH-17..SAH-32: TÜM TESTLER BAŞARIYLA GEÇTİ (0 hata) ---")
		quit(0)


func test_sah17_uc_hiz_bandi() -> void:
	var hg := HareketGecisi.new()
	_kontrol(hg.hiz_bandi_bul(0.0) == "dur", "SAH-17: 0.0 hız 'dur' olmalı")
	_kontrol(hg.hiz_bandi_bul(1.2) == "yuru", "SAH-17: 1.2 hız 'yuru' olmalı")
	_kontrol(hg.hiz_bandi_bul(3.5) == "kos", "SAH-17: 3.5 hız 'kos' olmalı")
	_kontrol(hg.klip_adi_al("dur") == "bekle", "SAH-17: dur klibi bekle olmalı")
	_kontrol(hg.klip_adi_al("yuru") == "yuru", "SAH-17: yuru klibi yuru olmalı")
	_kontrol(hg.klip_adi_al("kos") == "kos", "SAH-17: kos klibi kos olmalı")
	hg.free()
	print("SAH-17: Üç hız bandı testi geçti.")


func test_sah18_karisik_gecis() -> void:
	var hg := HareketGecisi.new()
	var oran_ilk := hg.karisim_hesapla(0.02, 0.25)
	_kontrol(oran_ilk < 0.2, "SAH-18: Geçişin ilk karesinde dur klibine daha yakın olmalı")
	var oran_son := hg.karisim_hesapla(0.25, 0.25)
	_kontrol(oran_son == 1.0, "SAH-18: Geçiş sonunda tam yeni klibe geçmeli")
	hg.free()
	print("SAH-18: Karışık geçiş testi geçti.")


func test_sah19_kosu_kosullari() -> void:
	var hg := HareketGecisi.new()
	_kontrol(hg.kosu_acik_mi("kovalama"), "SAH-19: Kovalama durumunda koşu açılmalı")
	_kontrol(hg.kosu_acik_mi("kacis"), "SAH-19: Kaçış durumunda koşu açılmalı")
	_kontrol(not hg.kosu_acik_mi("devriye"), "SAH-19: Günlük devriyede koşu 0 olmalı")
	hg.free()
	print("SAH-19: Koşu koşulları testi geçti.")


func test_sah20_durus_cila_baglantisi() -> void:
	var hg := HareketGecisi.new()
	_kontrol(hg.durus_cila_etkin_mi("dur"), "SAH-20: Hız bandı dura düşünce ayak cilası aynı karede açılmalı")
	_kontrol(not hg.durus_cila_etkin_mi("yuru"), "SAH-20: Yürüyüşte duruş cilası kapalı olmalı")
	hg.free()
	print("SAH-20: Duruş cila bağlantısı testi geçti.")


func test_sah21_yokus_adim_kisalmasi() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.yokusta_hiz_uyarla(1.5, 15.0)
	_kontrol(sonuc["band"] == "yuru", "SAH-21: Yokuşta hız bandı yürü kalmalı")
	_kontrol(sonuc["hiz"] < 1.5, "SAH-21: Yokuşta hız/adım kısalmalı")
	_kontrol(sonuc["klip"] == "yuru", "SAH-21: Klip yürü kalmalı")
	hg.free()
	print("SAH-21: Yokuş adım kısalması testi geçti.")


func test_sah22_yorgun_yuruyus() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.yorgun_hiz(1.8, true)
	_kontrol(sonuc["hiz"] < 1.8, "SAH-22: Yorgunluk hızı düşürmeli")
	_kontrol(sonuc["klip"] == "yuru", "SAH-22: Yeni klip üretilmemeli, yuru oynamalı")
	hg.free()
	print("SAH-22: Yorgun yürüyüş testi geçti.")


func test_sah23_kapi_bekleme() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.sorgu_hareketi(true)
	_kontrol(sonuc["hiz"] == 0.0, "SAH-23: Sorgu sırasında kök hız 0 olmalı")
	_kontrol(sonuc["klip"] == "bekle", "SAH-23: Sorgu sırasında bekle klibi olmalı")
	hg.free()
	print("SAH-23: Kapı bekleme testi geçti.")


func test_sah24_zorluk_gecis_suresi() -> void:
	var hg := HareketGecisi.new()
	var kolay := hg.gecis_suresi("kolay")
	var siki := hg.gecis_suresi("siki")
	_kontrol(kolay == siki and kolay == 0.25, "SAH-24: Geçiş süresi zorluğa göre değişmemeli")
	hg.free()
	print("SAH-24: Zorluk geçiş süresi testi geçti.")


func test_sah25_karisim_agirliklari_toplami() -> void:
	var hg := HareketGecisi.new()
	var ara := hg.karisim_agirliklari(0.125, 0.25)
	_kontrol(is_equal_approx(ara["kaynak_agirlik"] + ara["hedef_agirlik"], 1.0), "SAH-25: Ara karede ağırlıklar toplamı 1.0 olmalı")
	_kontrol(hg.agirlik_gecerli_mi([0.5, 0.5]), "SAH-25: 0.5+0.5 geçerli olmalı")
	_kontrol(not hg.agirlik_gecerli_mi([0.8, 0.8]), "SAH-25: 1.6 ağırlık toplamı reddedilmeli")
	hg.free()
	print("SAH-25: Karışım ağırlıkları toplamı testi geçti.")


func test_sah26_ust_konus_alt_yuru() -> void:
	var hg := HareketGecisi.new()
	# Köyde üst gövde konuşurken alt gövde yürür
	var koy_sonuc := hg.ust_konus_alt_yuru(true, false, true)
	_kontrol(koy_sonuc["ust_klip"] == "konus", "SAH-26: Köyde üst gövde konuş klibi olmalı")
	_kontrol(koy_sonuc["alt_klip"] == "yuru", "SAH-26: Köyde alt gövde yürümeli")
	_kontrol(koy_sonuc["yuruyus_agirlik"] == 1.0, "SAH-26: Köyde yürüyüş ağırlığı 1 olmalı")

	# Kapı sorgusunda alt gövde durur (SAH-23)
	var kapi_sonuc := hg.ust_konus_alt_yuru(true, true, false)
	_kontrol(kapi_sonuc["ust_klip"] == "konus", "SAH-26: Kapı sorgusunda üst konuşur")
	_kontrol(kapi_sonuc["alt_klip"] == "bekle", "SAH-26: Kapı sorgusunda alt gövde durur")
	_kontrol(kapi_sonuc["yuruyus_agirlik"] == 0.0, "SAH-26: Kapı sorgusunda yürüyüş ağırlığı 0 olmalı")
	hg.free()
	print("SAH-26: Üst konuş alt yürü testi geçti.")


func test_sah27_eksik_klip_idle_duser() -> void:
	var hg := HareketGecisi.new()
	var sonuc_eksik := hg.eksik_klip_coz("olmayan_klip_xyz", ["bekle", "yuru", "kos"])
	_kontrol(sonuc_eksik["klip"] == "bekle", "SAH-27: Eksik klip BUG-09 idle/bekle klibine düşmeli")
	_kontrol(sonuc_eksik["agirlik"] == 1.0, "SAH-27: Idle ağırlığı 1 olmalı")
	_kontrol(sonuc_eksik["eksik_dususu"] == true, "SAH-27: Eksik düşüşü işaretlenmeli")

	var sonuc_var := hg.eksik_klip_coz("yuru", ["bekle", "yuru", "kos"])
	_kontrol(sonuc_var["klip"] == "yuru", "SAH-27: Mevcut klip aynen dönmeli")
	hg.free()
	print("SAH-27: Eksik klip idle'a düşer testi geçti.")


func test_sah28_geciste_ofset_korunur() -> void:
	var hg := HareketGecisi.new()
	var ofset_sonuc := hg.geciste_ofset_koru(0.42, 0.5)
	_kontrol(ofset_sonuc["ofset"] == 0.42, "SAH-28: ANI-12 animasyon ofseti geçiş ortasında korunmalı")
	_kontrol(ofset_sonuc["sifirlandi"] == false, "SAH-28: Ofset sıfırlanmamalı")
	hg.free()
	print("SAH-28: Geçişte ofset korunur testi geçti.")


func test_sah29_tezgah_yuruyusle_karismaz() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.tezgah_klibi_agirlik(true)
	_kontrol(sonuc["kok_hiz"] == 0.0, "SAH-29: Tezgâh başında kök hız 0 olmalı")
	_kontrol(sonuc["yuruyus_agirlik"] == 0.0, "SAH-29: Yürüyüş ağırlığı 0 olmalı")
	hg.free()
	print("SAH-29: Tezgâh yürüyüşle karışmaz testi geçti.")


func test_sah30_hava_katmani() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.hava_katmani_ekle("yuru", true)
	_kontrol(sonuc["temel_klip"] == "yuru", "SAH-30: Temel yürüyüş korunmalı")
	_kontrol(sonuc["omuz_katmani"] == "usume", "SAH-30: Soğukta omuz katmanı eklenmeli")
	_kontrol(sonuc["ayri_katman"], "SAH-30: Ayrı katman olarak üst üste binmeli")
	hg.free()
	print("SAH-30: Hava katmanı testi geçti.")


func test_sah31_kayit_klip_agirligi_tutmaz() -> void:
	var hg := HareketGecisi.new()
	var kayit_temiz := {"nufus": 10, "akce": 50}
	var kayit_hatali := {"nufus": 10, "klip_agirligi": 0.5}
	_kontrol(hg.kayit_klip_agirligi_icermez(kayit_temiz), "SAH-31: Temiz kayıtta klip ağırlığı olmamalı")
	_kontrol(not hg.kayit_klip_agirligi_icermez(kayit_hatali), "SAH-31: Klip ağırlığı içeren kayıt yakalanmalı")
	hg.free()
	print("SAH-31: Kayıt klip ağırlığı tutmaz testi geçti.")


func test_sah32_uc_gecis_filtresi() -> void:
	var hg := HareketGecisi.new()
	var filtrelenmis := hg.gecis_filtrele(["dur", "yuru", "kos"])
	_kontrol(filtrelenmis.size() == 2, "SAH-32: Aynı karede 3 geçişte ortadaki atlanmalı")
	_kontrol(filtrelenmis[0] == "dur" and filtrelenmis[1] == "kos", "SAH-32: İlk ve son korunmalı")
	hg.free()
	print("SAH-32: Üç geçiş filtresi testi geçti.")
