extends SceneTree

## SAH-01..SAH-16: Ayak zemini ve El eşyası birim testi

func _init() -> void:
	print("--- TEST SAH-01..SAH-16: Ayak ve El Eşyası Doğrulama Başlıyor ---")
	test_sah01_ayak_zemin_hizalama()
	test_sah02_egik_zemin()
	test_sah03_ayak_kayma_esigi()
	test_sah04_durus_kayma_kapanisi()
	test_sah05_esik_ag_hucresi()
	test_sah06_comelme_taban_zeminde()
	test_sah07_kok_carpik_payi()
	test_sah08_muayene_ayak_yuksekligi()
	test_sah09_esya_kesisim_denetimi()
	test_sah10_esya_yurume_gecikmesi()
	test_sah11_egilme_zemin_kesisimi()
	test_sah12_cift_soket_omurga_kesisimi()
	test_sah13_konusma_esya_dusmez()
	test_sah14_ayni_soket_tanimi()
	test_sah15_cocuk_model_olcegi()
	test_sah16_muayene_kesisen_esya_raporu()
	print("--- TEST SAH-01..SAH-16: TÜM TESTLER BAŞARIYLA GEÇTİ ---")
	quit(0)


func test_sah01_ayak_zemin_hizalama() -> void:
	var az := AyakZemini.new()
	# Gömülme testi: ayak zemin altındaysa zemin seviyesine çıkarılır
	var duzeltilmis := az.zemin_hizala(-0.12, 0.0)
	assert(duzeltilmis >= 0.0, "SAH-01: Topuk zemin altından geçmemeli")
	var normal := az.zemin_hizala(0.05, 0.0)
	assert(normal == 0.05, "SAH-01: Zemin üstündeki ayak korunmalı")
	az.free()
	print("SAH-01: Ayak zemin hizalama testi geçti.")


func test_sah02_egik_zemin() -> void:
	var az := AyakZemini.new()
	# Yokuşta iki ayak farklı yüksekliktedir
	var sonuc := az.egik_zemin_hizala(0.25, 0.40)
	assert(sonuc["sol"] == 0.25 and sonuc["sag"] == 0.40, "SAH-02: Ayaklar kendi değdiği noktada olmalı")
	assert(sonuc["fark"] > 0.1, "SAH-02: Eğimli hücrede iki ayak farklı yükseklikte olmalı")
	az.free()
	print("SAH-02: Eğik zemin testi geçti.")


func test_sah03_ayak_kayma_esigi() -> void:
	var az := AyakZemini.new()
	assert(az.kayma_esigi == 0.15, "SAH-03: sahne.json'dan 0.15 okunmalı")
	assert(az.kayma_esik_altinda_mi(0.50, 0.45), "SAH-03: 0.05 fark eşik altında olmalı")
	assert(not az.kayma_esik_altinda_mi(0.50, 0.20), "SAH-03: 0.30 fark eşiği aşmalı")
	az.free()
	print("SAH-03: Ayak kayma eşiği testi geçti.")


func test_sah04_durus_kayma_kapanisi() -> void:
	var az := AyakZemini.new()
	assert(az.durus_kayma_esik_alti_mi(0.0, Vector3(0.005, 0, 0.005)), "SAH-04: Dururken delta eşik altı olmalı")
	assert(not az.durus_kayma_esik_alti_mi(0.0, Vector3(0.05, 0, 0.05)), "SAH-04: Dururken büyük kayma birikmemeli")
	az.free()
	print("SAH-04: Duruş kayma kapanışı testi geçti.")


func test_sah05_esik_ag_hucresi() -> void:
	var az := AyakZemini.new()
	var ag := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1)]
	assert(az.esik_hucrede_mi(Vector2i(0, 1), ag), "SAH-05: Kapı eşiği ağın bir hücresi olmalı")
	assert(not az.esik_hucrede_mi(Vector2i(5, 5), ag), "SAH-05: Ağ dışı hücreye basılmamalı")
	az.free()
	print("SAH-05: Kapı eşiği ağ hücresi testi geçti.")


func test_sah06_comelme_taban_zeminde() -> void:
	var az := AyakZemini.new()
	assert(az.taban_zeminde_mi("diz_cokme", 0.0, 0.0), "SAH-06: Diz çökmede taban zeminde kalmalı")
	assert(az.taban_zeminde_mi("sukran", -0.02, 0.0), "SAH-06: Şükran pozunda taban hizalanmalı")
	az.free()
	print("SAH-06: Çömelme taban zeminde testi geçti.")


func test_sah07_kok_carpik_payi() -> void:
	var az := AyakZemini.new()
	var a := Vector3(0, 0, 0)
	var b := Vector3(0.7, 0, 0)
	var c := Vector3(0.3, 0, 0)
	assert(az.aralik_guvenli_mi(a, b, 0.6), "SAH-07: 0.7m pay üstü güvenli olmalı")
	assert(not az.aralik_guvenli_mi(a, c, 0.6), "SAH-07: 0.3m pay altı güvenli olmamalı")
	az.free()
	print("SAH-07: Kök çarpışma payı testi geçti.")


func test_sah08_muayene_ayak_yuksekligi() -> void:
	var km := preload("res://tests/oto/karakter_muayene.gd")
	var normal := km.ayak_muayenesi_yap(0.02, 0.08)
	assert(not normal["hata"], "SAH-08: Normal ayak yüksekliği hatasız olmalı")
	var gomulu := km.ayak_muayenesi_yap(-0.15, 0.08)
	assert(gomulu["hata"], "SAH-08: Gömülü ayak hata satırı üretmeli")
	print("SAH-08: Muayene ayak yüksekliği testi geçti.")


func test_sah09_esya_kesisim_denetimi() -> void:
	var ee := preload("res://src/dunya/el_esyasi.gd")
	var esya := Vector3(0.4, 0.8, 0.1)
	var kemik_uzak := Vector3(0.0, 1.2, 0.0)
	var kemik_yakin := Vector3(0.42, 0.81, 0.11)
	assert(not ee.kesisiyor_mu(esya, kemik_uzak, 0.08), "SAH-09: Uzak kemikle kesişim olmamalı")
	assert(ee.kesisiyor_mu(esya, kemik_yakin, 0.08), "SAH-09: Yakın kemikle kesişim tespit edilmeli")
	print("SAH-09: Eşya kesişim testi geçti.")


func test_sah10_esya_yurume_gecikmesi() -> void:
	var ee := preload("res://src/dunya/el_esyasi.gd")
	assert(ee.gecikme_uygun_mu(0.015), "SAH-10: 1.5 cm gecikme uygun olmalı")
	assert(not ee.gecikme_uygun_mu(0.035), "SAH-10: 3.5 cm gecikme eşiği aşmalı")
	print("SAH-10: Eşya yürüme gecikmesi testi geçti.")


func test_sah11_egilme_zemin_kesisimi() -> void:
	var ee := preload("res://src/dunya/el_esyasi.gd")
	var taban := ee.zemin_altina_inmez(-0.08, 0.0)
	assert(taban >= 0.0, "SAH-11: Eğilince asılı eşya zemin altına inmemeli")
	print("SAH-11: Eğilme zemin kesişimi testi geçti.")


func test_sah12_cift_soket_omurga_kesisimi() -> void:
	var ee := preload("res://src/dunya/el_esyasi.gd")
	var sol := Vector3(-0.35, 0.8, 0)
	var sag := Vector3(0.35, 0.8, 0)
	var govde := Vector3(0.0, 0.8, 0)
	assert(not ee.cift_soket_kesisimi_var_mi(sol, sag, govde, 0.08), "SAH-12: İki el birbirinden ve gövdeden ayrı olmalı")
	var cakisan_sag := Vector3(-0.32, 0.8, 0)
	assert(ee.cift_soket_kesisimi_var_mi(sol, cakisan_sag, govde, 0.08), "SAH-12: Çakışan soketler tespit edilmeli")
	print("SAH-12: Çift soket kesişim testi geçti.")


func test_sah13_konusma_esya_dusmez() -> void:
	var e := ElEsyasi.olustur("torba")
	assert(e != null, "SAH-13: Eşya oluşturulmalı")
	var dummy := Node3D.new()
	dummy.add_child(e)
	assert(e.soket_dolu_mu(), "SAH-13: Konuşma süresince soket dolu kalmalı")
	dummy.free()
	print("SAH-13: Konuşma eşya düşmez testi geçti.")


func test_sah14_ayni_soket_tanimi() -> void:
	var ee := preload("res://src/dunya/el_esyasi.gd")
	var soketler := ee.soket_tanimi("chr_001")
	assert(soketler.size() > 0, "SAH-14: chr_001 için el_esyalari.json'da tek soket tanımı olmalı")
	assert(soketler[0][0] == "odun", "SAH-14: chr_001 eşyası odun olmalı")
	print("SAH-14: Aynı soket tanımı testi geçti.")


func test_sah15_cocuk_model_olcegi() -> void:
	var ee := preload("res://src/dunya/el_esyasi.gd")
	var cocuk_olcek := ee.cocuk_olcekle(0.7)
	assert(cocuk_olcek == 0.7, "SAH-15: Çocuk modelinde eşya ölçeği küçülmeli")
	var yetiskin_olcek := ee.cocuk_olcekle(1.0)
	assert(yetiskin_olcek == 1.0, "SAH-15: Yetişkin ölçeği 1.0 kalmalı")
	print("SAH-15: Çocuk model ölçeği testi geçti.")


func test_sah16_muayene_kesisen_esya_raporu() -> void:
	var km := preload("res://tests/oto/karakter_muayene.gd")
	var temiz := km.esya_kesisim_muayenesi_yap("torba", Vector3(0.4, 0.8, 0), [Vector3(0, 1.2, 0)])
	assert(not temiz["kesisim_var"], "SAH-16: Temiz eşya kesişmemeli")
	var kesisen := km.esya_kesisim_muayenesi_yap("cuval", Vector3(0.05, 1.2, 0), [Vector3(0, 1.2, 0)])
	assert(kesisen["kesisim_var"], "SAH-16: Çakışan eşya muayenede raporlanmalı")
	assert("SAH-EL-CAKISMA" in kesisen["mesaj"], "SAH-16: Çakışma mesajı formatı doğru olmalı")
	print("SAH-16: Muayene kesişen eşya raporu testi geçti.")
