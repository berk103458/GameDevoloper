extends SceneTree

const EpilogMetinVerisi := preload("res://src/sistemler/epilog_metin_verisi.gd")
const HavaReplikAdaptoru := preload("res://src/soz/hava_replik_adaptoru.gd")

func _init() -> void:
	print("--- epilog_ve_hava_test basladi ---")
	test_epilog_metin_verisi()
	test_hava_replik_adaptoru()
	print("--- epilog_ve_hava_test TAMAMLANDI: 0 HATA ---")
	quit(0)

func test_epilog_metin_verisi() -> void:
	assert(EpilogMetinVerisi.KARTLAR.size() == 6, "Kart sayisi 6 olmali")
	
	# Varsayilan (bos bayrak) testi
	var bos_kartlar := EpilogMetinVerisi.tum_kartlar({})
	assert(bos_kartlar.size() == 6, "Bos kart listesi 6 eleman donmeli")
	
	# Dursun & Turna olumlu / olumsuz
	var k_ret := EpilogMetinVerisi.kart_verisi_al(&"dursun_turna", {})
	assert(k_ret.metin_anahtari == "epilog.dursun_turna.ret", "Varsayilan ret olmali")
	assert(not k_ret.olumlu, "Ret olumsuz olmali")
	
	var k_kabul := EpilogMetinVerisi.kart_verisi_al(&"dursun_turna", {"dursun_turna_kabul": true})
	assert(k_kabul.metin_anahtari == "epilog.dursun_turna.kabul", "Kabul anahtari gelmeli")
	assert(k_kabul.olumlu, "Kabul olumlu olmali")
	
	# Banu Hatun ittifak
	var b_ret := EpilogMetinVerisi.kart_verisi_al(&"banu", {})
	assert(b_ret.metin_anahtari == "epilog.banu.ret", "Banu varsayilan ret olmali")
	var b_ittifak := EpilogMetinVerisi.kart_verisi_al(&"banu", {"banu_ittifak_kabul": true})
	assert(b_ittifak.metin_anahtari == "epilog.banu.ittifak", "Banu ittifak anahtari gelmeli")
	assert(b_ittifak.olumlu, "Banu ittifak olumlu olmali")
	
	# Lokman
	var l_kov := EpilogMetinVerisi.kart_verisi_al(&"lokman", {"lokman_kovuldu": true})
	assert(l_kov.metin_anahtari == "epilog.lokman.kovuldu", "Lokman kovuldu anahtari gelmeli")
	var l_iyi := EpilogMetinVerisi.kart_verisi_al(&"lokman", {"lokman_iyilesti": true})
	assert(l_iyi.metin_anahtari == "epilog.lokman.iyilesti", "Lokman iyilesti anahtari gelmeli")
	
	# Sungur
	var s_hasim := EpilogMetinVerisi.kart_verisi_al(&"sungur", {})
	assert(s_hasim.metin_anahtari == "epilog.sungur.hasim", "Sungur varsayilan hasim olmali")
	var s_ittifak := EpilogMetinVerisi.kart_verisi_al(&"sungur", {"sungur_ittifak": true})
	assert(s_ittifak.metin_anahtari == "epilog.sungur.ittifak", "Sungur ittifak olmali")
	
	# Vebalı Ana
	var v_kayip := EpilogMetinVerisi.kart_verisi_al(&"vebali_ana", {})
	assert(v_kayip.metin_anahtari == "epilog.vebali_ana.kayip", "Vebali varsayilan kayip olmali")
	var v_sifa := EpilogMetinVerisi.kart_verisi_al(&"vebali_ana", {"veba_kirec_karantina_basarili": true})
	assert(v_sifa.metin_anahtari == "epilog.vebali_ana.sifa", "Vebali sifa anahtari gelmeli")
	
	# Hane
	var h_sadakat := EpilogMetinVerisi.kart_verisi_al(&"hane", {"hane_sadakat": true})
	assert(h_sadakat.metin_anahtari == "epilog.hane.sadakat", "Hane sadakat anahtari gelmeli")
	var h_yabanci := EpilogMetinVerisi.kart_verisi_al(&"hane", {"hane_yabanci": true})
	assert(h_yabanci.metin_anahtari == "epilog.hane.yabanci", "Hane yabanci anahtari gelmeli")
	
	print("EpilogMetinVerisi kontrolleri basarili.")

func test_hava_replik_adaptoru() -> void:
	assert(HavaReplikAdaptoru.hava_destekleniyor_mu(&"firtina"), "Firtina desteklenmeli")
	assert(HavaReplikAdaptoru.hava_destekleniyor_mu(&"kar"), "Kar desteklenmeli")
	assert(HavaReplikAdaptoru.hava_destekleniyor_mu(&"yagmur"), "Yagmur desteklenmeli")
	assert(HavaReplikAdaptoru.hava_destekleniyor_mu(&"ayaz"), "Ayaz desteklenmeli")
	assert(HavaReplikAdaptoru.hava_destekleniyor_mu(&"sis"), "Sis desteklenmeli")
	assert(not HavaReplikAdaptoru.hava_destekleniyor_mu(&"gunesli"), "Gunesli ozel replik istemez")
	
	# Ziyaretçi ön ekleri
	var f1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"firtina", 0)
	var f2 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"firtina", 1)
	assert(f1 == "kapi.hava.firtina.ziyaretci.1", "Firtina 1 anahtari eslesmeli")
	assert(f2 == "kapi.hava.firtina.ziyaretci.2", "Firtina 2 anahtari eslesmeli")
	
	var y1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"yagmur", 0)
	assert(y1 == "kapi.hava.yagmur.ziyaretci.1", "Yagmur 1 anahtari eslesmeli")
	
	var a1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"ayaz", 0)
	assert(a1 == "kapi.hava.ayaz.ziyaretci.1", "Ayaz 1 anahtari eslesmeli")
	
	var s1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"sis", 0)
	assert(s1 == "kapi.hava.sis.ziyaretci.1", "Sis 1 anahtari eslesmeli")
	
	# Muhafız karşılamaları
	var mf := HavaReplikAdaptoru.muhafiz_karsilama_anahtari(&"firtina")
	assert(mf == "kapi.hava.firtina.muhafiz", "Muhafiz firtina karsilamasi eslesmeli")
	
	# Replik birlestirme
	var birlesik := HavaReplikAdaptoru.replik_birlestir("Ön ek replik.", "Asıl konuşma metni.")
	assert(birlesik.contains("Ön ek replik.") and birlesik.contains("Asıl konuşma metni."), "Replikler birlestirilmeli")
	
	print("HavaReplikAdaptoru kontrolleri basarili.")
