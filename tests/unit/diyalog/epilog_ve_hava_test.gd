extends SceneTree

var _hata := 0

const EpilogMetinVerisi := preload("res://src/sistemler/epilog_metin_verisi.gd")
const HavaReplikAdaptoru := preload("res://src/soz/hava_replik_adaptoru.gd")

func _init() -> void:
	print("--- epilog_ve_hava_test basladi ---")
	test_epilog_metin_verisi()
	test_hava_replik_adaptoru()
	print("--- epilog_ve_hava_test TAMAMLANDI: %d HATA ---" % _hata)
	quit(1 if _hata > 0 else 0)

func test_epilog_metin_verisi() -> void:
	_dene(EpilogMetinVerisi.KARTLAR.size() == 6, "Kart sayisi 6 olmali")
	
	# Varsayilan (bos bayrak) testi
	var bos_kartlar := EpilogMetinVerisi.tum_kartlar({})
	_dene(bos_kartlar.size() == 6, "Bos kart listesi 6 eleman donmeli")
	
	# Dursun & Turna olumlu / olumsuz
	var k_ret := EpilogMetinVerisi.kart_verisi_al(&"dursun_turna", {})
	_dene(k_ret.metin_anahtari == "epilog.dursun_turna.ret", "Varsayilan ret olmali")
	_dene(not k_ret.olumlu, "Ret olumsuz olmali")
	
	var k_kabul := EpilogMetinVerisi.kart_verisi_al(&"dursun_turna", {"dursun_turna_kabul": true})
	_dene(k_kabul.metin_anahtari == "epilog.dursun_turna.kabul", "Kabul anahtari gelmeli")
	_dene(k_kabul.olumlu, "Kabul olumlu olmali")
	
	# Banu Hatun ittifak
	var b_ret := EpilogMetinVerisi.kart_verisi_al(&"banu", {})
	_dene(b_ret.metin_anahtari == "epilog.banu.ret", "Banu varsayilan ret olmali")
	var b_ittifak := EpilogMetinVerisi.kart_verisi_al(&"banu", {"banu_ittifak_kabul": true})
	_dene(b_ittifak.metin_anahtari == "epilog.banu.ittifak", "Banu ittifak anahtari gelmeli")
	_dene(b_ittifak.olumlu, "Banu ittifak olumlu olmali")
	
	# Lokman
	var l_kov := EpilogMetinVerisi.kart_verisi_al(&"lokman", {"lokman_kovuldu": true})
	_dene(l_kov.metin_anahtari == "epilog.lokman.kovuldu", "Lokman kovuldu anahtari gelmeli")
	var l_iyi := EpilogMetinVerisi.kart_verisi_al(&"lokman", {"lokman_iyilesti": true})
	_dene(l_iyi.metin_anahtari == "epilog.lokman.iyilesti", "Lokman iyilesti anahtari gelmeli")
	
	# Sungur
	var s_hasim := EpilogMetinVerisi.kart_verisi_al(&"sungur", {})
	_dene(s_hasim.metin_anahtari == "epilog.sungur.hasim", "Sungur varsayilan hasim olmali")
	var s_ittifak := EpilogMetinVerisi.kart_verisi_al(&"sungur", {"sungur_ittifak": true})
	_dene(s_ittifak.metin_anahtari == "epilog.sungur.ittifak", "Sungur ittifak olmali")
	
	# Vebalı Ana
	var v_kayip := EpilogMetinVerisi.kart_verisi_al(&"vebali_ana", {})
	_dene(v_kayip.metin_anahtari == "epilog.vebali_ana.kayip", "Vebali varsayilan kayip olmali")
	var v_sifa := EpilogMetinVerisi.kart_verisi_al(&"vebali_ana", {"veba_kirec_karantina_basarili": true})
	_dene(v_sifa.metin_anahtari == "epilog.vebali_ana.sifa", "Vebali sifa anahtari gelmeli")
	
	# Hane
	var h_sadakat := EpilogMetinVerisi.kart_verisi_al(&"hane", {"hane_sadakat": true})
	_dene(h_sadakat.metin_anahtari == "epilog.hane.sadakat", "Hane sadakat anahtari gelmeli")
	var h_yabanci := EpilogMetinVerisi.kart_verisi_al(&"hane", {"hane_yabanci": true})
	_dene(h_yabanci.metin_anahtari == "epilog.hane.yabanci", "Hane yabanci anahtari gelmeli")
	
	print("EpilogMetinVerisi kontrolleri basarili.")

func test_hava_replik_adaptoru() -> void:
	_dene(HavaReplikAdaptoru.hava_destekleniyor_mu(&"firtina"), "Firtina desteklenmeli")
	_dene(HavaReplikAdaptoru.hava_destekleniyor_mu(&"kar"), "Kar desteklenmeli")
	_dene(HavaReplikAdaptoru.hava_destekleniyor_mu(&"yagmur"), "Yagmur desteklenmeli")
	_dene(HavaReplikAdaptoru.hava_destekleniyor_mu(&"ayaz"), "Ayaz desteklenmeli")
	_dene(HavaReplikAdaptoru.hava_destekleniyor_mu(&"sis"), "Sis desteklenmeli")
	_dene(not HavaReplikAdaptoru.hava_destekleniyor_mu(&"gunesli"), "Gunesli ozel replik istemez")
	
	# Ziyaretçi ön ekleri
	var f1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"firtina", 0)
	var f2 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"firtina", 1)
	_dene(f1 == "kapi.hava.firtina.ziyaretci.1", "Firtina 1 anahtari eslesmeli")
	_dene(f2 == "kapi.hava.firtina.ziyaretci.2", "Firtina 2 anahtari eslesmeli")
	
	var y1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"yagmur", 0)
	_dene(y1 == "kapi.hava.yagmur.ziyaretci.1", "Yagmur 1 anahtari eslesmeli")
	
	var a1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"ayaz", 0)
	_dene(a1 == "kapi.hava.ayaz.ziyaretci.1", "Ayaz 1 anahtari eslesmeli")
	
	var s1 := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(&"sis", 0)
	_dene(s1 == "kapi.hava.sis.ziyaretci.1", "Sis 1 anahtari eslesmeli")
	
	# Muhafız karşılamaları
	var mf := HavaReplikAdaptoru.muhafiz_karsilama_anahtari(&"firtina")
	_dene(mf == "kapi.hava.firtina.muhafiz", "Muhafiz firtina karsilamasi eslesmeli")
	
	# Replik birlestirme
	var birlesik := HavaReplikAdaptoru.replik_birlestir("Ön ek replik.", "Asıl konuşma metni.")
	_dene(birlesik.contains("Ön ek replik.") and birlesik.contains("Asıl konuşma metni."), "Replikler birlestirilmeli")
	
	print("HavaReplikAdaptoru kontrolleri basarili.")


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
