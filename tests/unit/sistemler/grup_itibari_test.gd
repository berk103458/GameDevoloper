## DIY-12: Grup itibari — Turkmen, Rum, Ahi, koylu, tuccar, asker birim testi.
## Kabul kriterleri:
## - Turkmen reti Turkmen itibarini dusurur, Rum deltasi 0 kalir.
## - Eksi ondayken bir ret daha eksi on birakir ve kayitta "kesildi" diye durur.
## - Bir ziyarette yazilan grup sayisi 1'dir.
## - Grupsuz karakter koylu sayilir; yedinci grup ve kalp/romans anahtari reddedilir.
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_test_veri_dosyasi_ve_alti_grup()
	_test_turkmen_reti_ve_rum_deltasi_sifir()
	_test_eksi_on_ve_arti_on_sinir_kesilmesi()
	_test_cift_gruplu_ve_ziyaret_basina_tek_yazim()
	_test_grupsuz_varsayilan_koylu()
	_test_yedinci_grup_ve_kalp_romans_reddi()
	_test_diy09_ve_zar04_entegrasyonu()

	await process_frame
	print("GRUP ITIBARI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_veri_dosyasi_ve_alti_grup() -> void:
	var hatalar: Array[String] = GrupItibari.veri_dogrula()
	_kontrol(hatalar.is_empty(), "data/gruplar.json hatasız doğrulanmalı: %s" % str(hatalar))
	var gi := GrupItibari.new()
	_kontrol(gi.oda_ozeti().size() == 6, "Muhafız odası özetinde 6 grup bulunmalı")


func _test_turkmen_reti_ve_rum_deltasi_sifir() -> void:
	var gi := GrupItibari.new()
	var rum_once := gi.deger("rum")
	gi.ziyaret_baslat()
	var sonuc: Dictionary = gi.karar_uygula("Türkmen", "ret")
	_kontrol(bool(sonuc.get("olur", false)), "Türkmen reti uygulanmalı")
	_kontrol(gi.deger("turkmen") == -1, "Türkmen reti Türkmen itibarını -1 yapmalı")
	var rum_sonra := gi.deger("rum")
	_kontrol(rum_sonra - rum_once == 0, "Türkmen retinde Rum deltası 0 kalmalı")
	_kontrol(int(sonuc.get("yazilan_grup_sayisi", 0)) == 1, "Bir ziyarette yazılan grup sayısı 1 olmalı")


func _test_eksi_on_ve_arti_on_sinir_kesilmesi() -> void:
	var gi := GrupItibari.new()
	for _i in range(10):
		gi.ziyaret_baslat()
		gi.karar_uygula("turkmen", "ret")
	_kontrol(gi.deger("turkmen") == -10, "10 ret sonunda Türkmen itibarı -10 olmalı")
	_kontrol(gi.deger("rum") == 0, "Türkmen ret dizisi Rum değerini değiştirmemeli")

	# -10'dayken yeni ret degeri degistirmez, yazim denemesi kayitta "kesildi" diye durur
	gi.ziyaret_baslat()
	var kesilen: Dictionary = gi.karar_uygula("turkmen", "ret")
	_kontrol(gi.deger("turkmen") == -10, "Eksi ondayken bir ret daha eksi on bırakmalı")
	_kontrol(bool(kesilen.get("kesildi", false)) == true, "Sınır dışı yazım kesildi=true dönmeli")
	_kontrol(String(kesilen.get("durum", "")) == "kesildi", "Yazım denemesi kayıtta 'kesildi' diye durmalı")

	var son_kayit: Dictionary = gi.yazim_kayitlari().back()
	_kontrol(String(son_kayit.get("durum", "")) == "kesildi", "Kayıt listesinde son deneme 'kesildi' olmalı")

	# +10 siniri kontrolu
	gi.ziyaret_baslat()
	var tavan: Dictionary = gi.uygula("ahi", 25, true)
	_kontrol(gi.deger("ahi") == 10 and bool(tavan.get("kesildi", false)), "Artı on üstüne taşan yazım +10'da kesilmeli")


func _test_cift_gruplu_ve_ziyaret_basina_tek_yazim() -> void:
	var gi := GrupItibari.new()
	gi.ziyaret_baslat()
	var cift_gruplu := {
		"birincil_grup": "tuccar",
		"ikincil_grup": "rum",
		"gruplar": ["tuccar", "rum"],
	}
	var s1: Dictionary = gi.karar_uygula(cift_gruplu, "kabul", true)
	_kontrol(bool(s1.get("olur", false)) and int(s1.get("yazilan_grup_sayisi", 0)) == 1, "Çift gruplu kişide birincil gruba 1 kez yazılmalı")
	_kontrol(gi.deger("tuccar") == 1 and gi.deger("rum") == 0, "Yalnız birincil grup (tüccar) değişmeli, ikinci gruba (rum) yazılmamalı")

	# Ayni ziyarette ikinci yazim denemesi reddedilmeli
	var s2: Dictionary = gi.karar_uygula("rum", "kabul", true)
	_kontrol(not bool(s2.get("olur", true)), "Aynı ziyarette ikinci gruba yazım engellenmeli")
	_kontrol(gi.deger("rum") == 0, "İkinci grup puanı değişmemeli")


func _test_grupsuz_varsayilan_koylu() -> void:
	var gi := GrupItibari.new()
	gi.ziyaret_baslat()
	var sonuc: Dictionary = gi.karar_uygula("", "kabul", true)
	_kontrol(bool(sonuc.get("olur", false)) and String(sonuc.get("grup", "")) == "koylu", "Grupsuz karakter varsayılan olarak köylü sayılmalı")
	_kontrol(gi.deger("koylu") == 1, "Grupsuz kabulü köylü itibarını +1 artırmalı")


func _test_yedinci_grup_ve_kalp_romans_reddi() -> void:
	var gi := GrupItibari.new()
	gi.ziyaret_baslat()
	var yedinci: Dictionary = gi.uygula("korsan", 1, false)
	_kontrol(not bool(yedinci.get("olur", true)), "Yedinci grup adı reddedilmeli")

	var kalp_deneme: Dictionary = gi.uygula("kalp", 1, false)
	var romans_deneme: Dictionary = gi.uygula("romans", 1, false)
	_kontrol(not bool(kalp_deneme.get("olur", true)) and not bool(romans_deneme.get("olur", true)), "kalp ve romans grup adı reddedilmeli")
	_kontrol(not gi.yukle({"kalp": 5}), "Kayıt anahtarı kalp olamaz")
	_kontrol(not gi.yukle({"puanlar": {"romans": 3}}), "Kayıt anahtarı romans olamaz")
	_kontrol(not gi.yukle({"puanlar": {"yedinci_grup": 2}}), "Kayıtta yedinci grup adı reddedilmeli")


func _test_diy09_ve_zar04_entegrasyonu() -> void:
	var gi := GrupItibari.new()
	gi.uygula("asker", -8, false)
	var baglam: Dictionary = gi.baglama_yaz({}, "asker")

	var secici := SatirSecici.new()
	var varyantlar := [
		{"id": "varsayilan", "kosullar": {}},
		{"id": "asker_kizgin", "kosullar": {"grup_itibari.asker": -8}},
	]
	var secilen: Dictionary = secici.sec(varyantlar, baglam)
	_kontrol(String(secilen.get("id", "")) == "asker_kizgin", "Grup itibarı DIY-09 satır seçimine girmeli")
	_kontrol(gi.zar_etkisi("asker") == 1, "Düşük grup itibarında (-8) zar değiştiricisi +1 olmalı")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
