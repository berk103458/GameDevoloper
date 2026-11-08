extends SceneTree

## SAH-17..SAH-32: Hareket geçişi ve animasyon karıştırma birim testi

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
	test_sah25_ust_konus_alt_dur()
	test_sah26_kismi_karisim_agirliklari()
	test_sah27_agirlik_normalligi()
	test_sah28_bosta_kemik_idle()
	test_sah29_tezgah_yuruyusle_karismaz()
	test_sah30_hava_katmani()
	test_sah31_kayit_klip_agirligi_tutmaz()
	test_sah32_uc_gecis_filtresi()
	print("--- TEST SAH-17..SAH-32: TÜM TESTLER BAŞARIYLA GEÇTİ ---")
	quit(0)


func test_sah17_uc_hiz_bandi() -> void:
	var hg := HareketGecisi.new()
	assert(hg.hiz_bandi_bul(0.0) == "dur", "SAH-17: 0.0 hız 'dur' olmalı")
	assert(hg.hiz_bandi_bul(1.2) == "yuru", "SAH-17: 1.2 hız 'yuru' olmalı")
	assert(hg.hiz_bandi_bul(3.5) == "kos", "SAH-17: 3.5 hız 'kos' olmalı")
	assert(hg.klip_adi_al("dur") == "bekle", "SAH-17: dur klibi bekle olmalı")
	assert(hg.klip_adi_al("yuru") == "yuru", "SAH-17: yuru klibi yuru olmalı")
	assert(hg.klip_adi_al("kos") == "kos", "SAH-17: kos klibi kos olmalı")
	hg.free()
	print("SAH-17: Üç hız bandı testi geçti.")


func test_sah18_karisik_gecis() -> void:
	var hg := HareketGecisi.new()
	var oran_ilk := hg.karisim_hesapla(0.02, 0.25)
	assert(oran_ilk < 0.2, "SAH-18: Geçişin ilk karesinde dur klibine daha yakın olmalı")
	var oran_son := hg.karisim_hesapla(0.25, 0.25)
	assert(oran_son == 1.0, "SAH-18: Geçiş sonunda tam yeni klibe geçmeli")
	hg.free()
	print("SAH-18: Karışık geçiş testi geçti.")


func test_sah19_kosu_kosullari() -> void:
	var hg := HareketGecisi.new()
	assert(hg.kosu_acik_mi("kovalama"), "SAH-19: Kovalama durumunda koşu açılmalı")
	assert(hg.kosu_acik_mi("kacis"), "SAH-19: Kaçış durumunda koşu açılmalı")
	assert(not hg.kosu_acik_mi("devriye"), "SAH-19: Günlük devriyede koşu 0 olmalı")
	hg.free()
	print("SAH-19: Koşu koşulları testi geçti.")


func test_sah20_durus_cila_baglantisi() -> void:
	var hg := HareketGecisi.new()
	assert(hg.durus_cila_etkin_mi("dur"), "SAH-20: Hız bandı dura düşünce ayak cilası aynı karede açılmalı")
	assert(not hg.durus_cila_etkin_mi("yuru"), "SAH-20: Yürüyüşte duruş cilası kapalı olmalı")
	hg.free()
	print("SAH-20: Duruş cila bağlantısı testi geçti.")


func test_sah21_yokus_adim_kisalmasi() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.yokusta_hiz_uyarla(1.5, 15.0)
	assert(sonuc["band"] == "yuru", "SAH-21: Yokuşta hız bandı yürü kalmalı")
	assert(sonuc["hiz"] < 1.5, "SAH-21: Yokuşta hız/adım kısalmalı")
	assert(sonuc["klip"] == "yuru", "SAH-21: Klip yürü kalmalı")
	hg.free()
	print("SAH-21: Yokuş adım kısalması testi geçti.")


func test_sah22_yorgun_yuruyus() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.yorgun_hiz(1.8, true)
	assert(sonuc["hiz"] < 1.8, "SAH-22: Yorgunluk hızı düşürmeli")
	assert(sonuc["klip"] == "yuru", "SAH-22: Yeni klip üretilmemeli, yuru oynamalı")
	hg.free()
	print("SAH-22: Yorgun yürüyüş testi geçti.")


func test_sah23_kapi_bekleme() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.sorgu_hareketi(true)
	assert(sonuc["hiz"] == 0.0, "SAH-23: Sorgu sırasında kök hız 0 olmalı")
	assert(sonuc["klip"] == "bekle", "SAH-23: Sorgu sırasında bekle klibi olmalı")
	hg.free()
	print("SAH-23: Kapı bekleme testi geçti.")


func test_sah24_zorluk_gecis_suresi() -> void:
	var hg := HareketGecisi.new()
	var kolay := hg.gecis_suresi("kolay")
	var siki := hg.gecis_suresi("siki")
	assert(kolay == siki and kolay == 0.25, "SAH-24: Geçiş süresi zorluğa göre değişmemeli")
	hg.free()
	print("SAH-24: Zorluk geçiş süresi testi geçti.")


func test_sah25_ust_konus_alt_dur() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.ust_konus_alt_dur(true)
	assert(sonuc["ust_klip"] == "konus", "SAH-25: Üst gövde konuş klibi olmalı")
	assert(sonuc["alt_klip"] == "bekle", "SAH-25: Alt gövde bekle klibi olmalı")
	assert(sonuc["yuruyus_agirlik"] == 0.0, "SAH-25: Yürüyüş ağırlığı 0 olmalı")
	hg.free()
	print("SAH-25: Üst konuş alt dur testi geçti.")


func test_sah26_kismi_karisim_agirliklari() -> void:
	var hg := HareketGecisi.new()
	var agirliklar := hg.kismi_karisim_agirliklari()
	assert(agirliklar["bacak"] == 1.0, "SAH-26: Bacak tam ağırlık almalı")
	assert(agirliklar["kol"] < 1.0 and agirliklar["bas"] < 1.0, "SAH-26: Kol ve baş kısmi karışmalı")
	hg.free()
	print("SAH-26: Kısmi karışım ağırlıkları testi geçti.")


func test_sah27_agirlik_normalligi() -> void:
	var hg := HareketGecisi.new()
	assert(hg.agirlik_gecerli_mi([0.5, 0.5]), "SAH-27: Toplam 1.0 geçerli olmalı")
	assert(not hg.agirlik_gecerli_mi([0.8, 0.8]), "SAH-27: 1.6 ağırlık kemik bükülmesini önlemek için reddedilmeli")
	hg.free()
	print("SAH-27: Ağırlık normalliği testi geçti.")


func test_sah28_bosta_kemik_idle() -> void:
	var hg := HareketGecisi.new()
	assert(hg.bosta_kemik_klibi("yuru") == "bekle", "SAH-28: Boşta kalan kemik bekle/idle'a dönmeli")
	hg.free()
	print("SAH-28: Boşta kemik idle testi geçti.")


func test_sah29_tezgah_yuruyusle_karismaz() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.tezgah_klibi_agirlik(true)
	assert(sonuc["kok_hiz"] == 0.0, "SAH-29: Tezgâh başında kök hız 0 olmalı")
	assert(sonuc["yuruyus_agirlik"] == 0.0, "SAH-29: Yürüyüş ağırlığı 0 olmalı")
	hg.free()
	print("SAH-29: Tezgâh yürüyüşle karışmaz testi geçti.")


func test_sah30_hava_katmani() -> void:
	var hg := HareketGecisi.new()
	var sonuc := hg.hava_katmani_ekle("yuru", true)
	assert(sonuc["temel_klip"] == "yuru", "SAH-30: Temel yürüyüş korunmalı")
	assert(sonuc["omuz_katmani"] == "usume", "SAH-30: Soğukta omuz katmanı eklenmeli")
	assert(sonuc["ayri_katman"], "SAH-30: Ayrı katman olarak üst üste binmeli")
	hg.free()
	print("SAH-30: Hava katmanı testi geçti.")


func test_sah31_kayit_klip_agirligi_tutmaz() -> void:
	var hg := HareketGecisi.new()
	var kayit_temiz := {"nufus": 10, "akce": 50}
	var kayit_hatali := {"nufus": 10, "klip_agirligi": 0.5}
	assert(hg.kayit_klip_agirligi_icermez(kayit_temiz), "SAH-31: Temiz kayıtta klip ağırlığı olmamalı")
	assert(not hg.kayit_klip_agirligi_icermez(kayit_hatali), "SAH-31: Klip ağırlığı içeren kayıt yakalanmalı")
	hg.free()
	print("SAH-31: Kayıt klip ağırlığı tutmaz testi geçti.")


func test_sah32_uc_gecis_filtresi() -> void:
	var hg := HareketGecisi.new()
	var filtrelenmis := hg.gecis_filtrele(["dur", "yuru", "kos"])
	assert(filtrelenmis.size() == 2, "SAH-32: Aynı karede 3 geçişte ortadaki atlanmalı")
	assert(filtrelenmis[0] == "dur" and filtrelenmis[1] == "kos", "SAH-32: İlk ve son korunmalı")
	hg.free()
	print("SAH-32: Üç geçiş filtresi testi geçti.")
