extends SceneTree

const DunyaZamaniSinifi = preload("res://src/sistemler/dunya_zamani.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("DUNYA TEST HATASI: " + mesaj)


func _besle(o: Oturum) -> void:
	o.yonetim.kaynaklar.stok["gida"] = 500
	o.yonetim.kaynaklar.stok["odun"] = 500
	o.yonetim.akce = 200
	o.yonetim.adalet = 70
	o.yonetim.asayis_riski = 0
	for k in o.yonetim.koylular:
		k.saglik = 100
		k.moral = 90


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()

	# 1. Doğrulayıcı: gerçek zaman_cizelgesi.json hatasız
	var gercek_hatalar := DunyaZamaniSinifi.dogrula()
	_kontrol(gercek_hatalar.is_empty(), "Gercek zaman_cizelgesi.json hatasiz olmali: %s" % str(gercek_hatalar))

	# 2. Üç mevsim yılı boyunca 6 olayın tümü 3 evreyi de gezer + aynı tohumda deterministik
	var o1 := Oturum.new(kat, 1243)
	var o2 := Oturum.new(kat, 1243)
	o1.yonetim.kabul({"ad": "Ali", "sinif": &"ciftci", "stat": 5})
	o2.yonetim.kabul({"ad": "Ali", "sinif": &"ciftci", "stat": 5})
	var yil_uzunlugu := int(MevsimYoneticisi.durum(o1.yonetim).yil_uzunlugu)
	var uc_yil := 3 * yil_uzunlugu

	var gun_log_1 := {}
	var gun_log_2 := {}
	for gece_idx in uc_yil:
		_besle(o1)
		_besle(o2)
		# HAR-02 kalan günü kontrolü (gece öncesi)
		_kontrol(DunyaZamaniSinifi.mogol_kalan_gun(o1) == int(MogolOncusu.durum(o1).kalan), "HAR-02 kalan gunu ayni olmali")
		o1.gece_sonu()
		o2.gece_sonu()
		gun_log_1[o1.gun] = DunyaZamaniSinifi.isaretler(o1).duplicate()
		gun_log_2[o2.gun] = DunyaZamaniSinifi.isaretler(o2).duplicate()
		_kontrol(gun_log_1[o1.gun] == gun_log_2[o2.gun], "Ayni tohum ayni gunde ayni isaretleri uretmeli (gun=%d)" % o1.gun)

	var beklenen_olaylar: Array = DunyaZamaniSinifi.cizelge().get("olaylar", [])
	_kontrol(beklenen_olaylar.size() == 6, "zaman_cizelgesi.json icinde 6 olay olmali")
	var tum_isaretler_1 := DunyaZamaniSinifi.isaretler(o1)
	for olay in beklenen_olaylar:
		var oid := String(olay.get("id", ""))
		for evre in DunyaZamaniSinifi.EVRELER:
			var anahtar := "%s.%s" % [oid, evre]
			_kontrol(anahtar in tum_isaretler_1, "3 yil sonunda %s evresi gecilmis olmali" % anahtar)

	# Çizelgede ikinci sayaç alanı ve cümle metni gömülü olmamalı
	var kayit_1 := o1.kaydet()
	var dz_kayit: Dictionary = kayit_1.get("dunya_zamani", {})
	_kontrol(not dz_kayit.has("kalan") and not dz_kayit.has("mogol_kalan") and not dz_kayit.has("varis_gunu"), "Cizelge kaydinda ikinci sayac alani olmamali")
	for x in dz_kayit.get("isaretler", []):
		_kontrol(not String(x).contains(" "), "Kayit yalniz isaret kimligi tasimali, cumle olmamali: %s" % str(x))

	# Aynı olay kimliği ikinci kez düşmez (ek gecelerde)
	var sayac_once := tum_isaretler_1.size()
	for _ek in 10:
		_besle(o1)
		o1.gece_sonu()
	_kontrol(DunyaZamaniSinifi.isaretler(o1).size() == sayac_once, "Ayni olay kimligi ikinci kez dusmemeli")

	# 3. İki olay aynı gün etki evresine gelirse o gece tek etki yazılır, öbürü ertesi geceye kalır
	var cakisik_cizelge := {
		"olaylar": [
			{
				"id": "olay_a",
				"evreler": {
					"erken_soylenti": {"gun": 2},
					"kesin_haber": {"gun": 3},
					"etki": {"gun": 5, "hedef_kapi": "harac"},
				},
			},
			{
				"id": "olay_b",
				"evreler": {
					"erken_soylenti": {"gun": 2},
					"kesin_haber": {"gun": 3},
					"etki": {"gun": 5, "hedef_kapi": "tuketim"},
				},
			},
		],
	}
	var o_cak := Oturum.new(kat, 99)
	o_cak.yonetim.kabul({"ad": "Veli", "sinif": &"ciftci", "stat": 4})
	for _g in 4:
		o_cak.yonetim.gun += 1
	var r5 := {"gun": 4, "olaylar": []}
	o_cak.yonetim.gun = 5
	var s5 := DunyaZamaniSinifi.gece(o_cak, r5, cakisik_cizelge)
	var etki_sayisi_5 := 0
	for isaret in s5.get("yeni_isaretler", []):
		if String(isaret).ends_with(".etki"):
			etki_sayisi_5 += 1
	_kontrol(etki_sayisi_5 == 1, "Ayni gun etki evresine gelen iki olaydan o gece tek etki yazilmali")
	_kontrol("olay_a.etki" in DunyaZamaniSinifi.isaretler(o_cak), "Ilk olay o gece etki evresine gecmeli")
	_kontrol(not ("olay_b.etki" in DunyaZamaniSinifi.isaretler(o_cak)), "Ikinci olay ertesi geceye kalmali")
	var r6 := {"gun": 5, "olaylar": []}
	o_cak.yonetim.gun = 6
	DunyaZamaniSinifi.gece(o_cak, r6, cakisik_cizelge)
	_kontrol("olay_b.etki" in DunyaZamaniSinifi.isaretler(o_cak), "Ertesi gece ikinci olay etki evresine gecmeli")

	# 4. Kayıt olayın ortasında açılırsa evre kaldığı günden sürer
	var o_orta := Oturum.new(kat, 77)
	o_orta.yonetim.kabul({"ad": "Hasan", "sinif": &"ciftci", "stat": 4})
	for _i in 12:
		_besle(o_orta)
		o_orta.gece_sonu()
	_kontrol("selcuklu_taht_kavgasi.erken_soylenti" in DunyaZamaniSinifi.isaretler(o_orta), "Gun 12'de erken_soylenti alinmis olmali")
	_kontrol(not ("selcuklu_taht_kavgasi.kesin_haber" in DunyaZamaniSinifi.isaretler(o_orta)), "Gun 12'de kesin_haber henuz gelmemis olmali")
	var orta_kayit := o_orta.kaydet()
	var o_yuklu := Oturum.kayittan(kat, orta_kayit)
	_kontrol(o_yuklu != null, "Orta kayit yuklenebilmeli")
	if o_yuklu != null:
		for _j in 4:
			_besle(o_yuklu)
			o_yuklu.gece_sonu()
		_kontrol("selcuklu_taht_kavgasi.kesin_haber" in DunyaZamaniSinifi.isaretler(o_yuklu), "Yukleme sonrasi kesin_haber gun 14'te surmeli")
		_kontrol("selcuklu_taht_kavgasi.etki" in DunyaZamaniSinifi.isaretler(o_yuklu), "Yukleme sonrasi etki gun 16'da surmeli")

	# 5. Eski kayıtta işaret listesi yoksa liste boş başlar ve geçmiş geceler zorla işletilmez
	var eski_kayit := o_orta.kaydet()
	# gun = 20 iken eski kayıtmış gibi dunya_zamani anahtarını çıkar
	var o_gec := Oturum.new(kat, 88)
	o_gec.yonetim.kabul({"ad": "Murat", "sinif": &"ciftci", "stat": 4})
	for _k in 20:
		_besle(o_gec)
		o_gec.gece_sonu()
	eski_kayit = o_gec.kaydet()
	eski_kayit.erase("dunya_zamani")
	var o_eski := Oturum.kayittan(kat, eski_kayit)
	_kontrol(o_eski != null, "dunya_zamani olmayan eski kayit yuklenebilmeli")
	if o_eski != null:
		_kontrol(DunyaZamaniSinifi.isaretler(o_eski).is_empty(), "Eski kayitta isaret listesi bos baslamali")
		_besle(o_eski)
		o_eski.gece_sonu()
		_kontrol(not ("selcuklu_taht_kavgasi.etki" in DunyaZamaniSinifi.isaretler(o_eski)), "Gecmis gecedeki olay zorla isletilmemeli")

	# 6. Dünya kitabı olgusuyla çelişen satır 1 doğrulama hatası verir ve o olay düşmez
	var celisen_cizelge := {
		"olaylar": [
			{
				"id": "malazgirt_hatasi",
				"olgu": "olmayan_olgu",
				"evreler": {
					"erken_soylenti": {"gun": 1, "replikler": [{"metin": "Fetret devri basladi."}]},
					"kesin_haber": {"gun": 2},
					"etki": {"gun": 3, "hedef_kapi": "harac"},
				},
			}
		]
	}
	var celiski_hatalari := DunyaZamaniSinifi.dogrula(celisen_cizelge)
	_kontrol(celiski_hatalari.size() == 1, "Dunya kitabiyla celisen satir 1 dogrulama hatasi vermeli (bulunan: %d)" % celiski_hatalari.size())
	var o_cel := Oturum.new(kat, 55)
	o_cel.yonetim.gun = 5
	DunyaZamaniSinifi.gece(o_cel, {"gun": 4, "olaylar": []}, celisen_cizelge)
	_kontrol(DunyaZamaniSinifi.isaretler(o_cel).is_empty(), "Dunya kitabiyla celisen olay dusmemeli")

	# 7. Mevsim değişince olay günü kaymaz
	var o_mev := Oturum.new(kat, 101)
	o_mev.yonetim.kabul({"ad": "Emre", "sinif": &"ciftci", "stat": 4})
	IklimDeneyi.yukle(o_mev.yonetim, {"mevsim": 3, "hava": "normal"}) # zorla kış
	for _m in 10:
		_besle(o_mev)
		o_mev.gece_sonu()
	_kontrol("selcuklu_taht_kavgasi.erken_soylenti" in DunyaZamaniSinifi.isaretler(o_mev), "Mevsim degisse de olay gunu kaymamali (gun=10)")

	# 8. Çizelge bar, kasa veya nüfus değiştirmez; Divan hükmü çizelge işaretine yazmaz
	var o_saf := Oturum.new(kat, 102)
	o_saf.yonetim.kabul({"ad": "Kadir", "sinif": &"ciftci", "stat": 4})
	var akce_once := o_saf.akce
	var nufus_once := o_saf.yonetim.nufus()
	var adalet_once := o_saf.yonetim.adalet
	o_saf.yonetim.gun = 16
	DunyaZamaniSinifi.gece(o_saf, {"gun": 15, "olaylar": []})
	_kontrol(o_saf.akce == akce_once and o_saf.yonetim.nufus() == nufus_once and o_saf.yonetim.adalet == adalet_once, "DunyaZamani tek basina bar, kasa veya nufus degistirmemeli")
	var isaret_once := DunyaZamaniSinifi.isaretler(o_saf).duplicate()
	var g_div := o_saf._adli_gelen(&"chr_001")
	var rr_div := o_saf.karar_ver(g_div, &"kabul")
	var k_div := o_saf.yonetim.koylu(rr_div.koylu_id)
	CasusGeceTakibi.kaydet(o_saf.yonetim, k_div, "ambar", -1, "kundaklama", "gida", 0, true)
	_kontrol(DivanHukmu.uygula(o_saf, k_div.id, "zindan"), "Divan hukmu uygulanabilmeli")
	_kontrol(DunyaZamaniSinifi.isaretler(o_saf) == isaret_once, "Divan hukmu cizelge isaretine yazmamali")

	# 9. dunya_zamani.gd koy_sahnesi import etmez ve sabit yil gunu gommez
	var dz_kod := FileAccess.get_file_as_string("res://src/sistemler/dunya_zamani.gd")
	_kontrol(not dz_kod.contains("koy_sahnesi"), "dunya_zamani.gd koy_sahnesi import etmemeli")

	# 10. DNY-02: Haber önce insanlardan duyulur
	_test_dny02_haber(kat)

	if _hata == 0:
		print("DUNYA ZAMANI TESTI: GEÇTİ (0 hata)")
		quit(0)
	else:
		print("DUNYA ZAMANI TESTI: KALDI (%d hata)" % _hata)
		quit(1)


func _test_dny02_haber(kat: Katalog) -> void:
	# a) Etki evresinden önceki pencerede (>=2 satır, birbirinin kopyası değil) + aynı tohum determinizmi
	var o_a := Oturum.new(kat, 2021)
	var o_b := Oturum.new(kat, 2021)
	o_a.yonetim.kabul({"ad": "Veli", "sinif": &"ciftci", "stat": 5})
	o_b.yonetim.kabul({"ad": "Veli", "sinif": &"ciftci", "stat": 5})
	for _i in 14:
		_besle(o_a)
		_besle(o_b)
		o_a.gece_sonu()
		o_b.gece_sonu()
		_kontrol(DunyaZamaniSinifi.haber_satirlari(o_a) == DunyaZamaniSinifi.haber_satirlari(o_b), "Aynı tohum aynı günde aynı haber satırını üretmeli (gun=%d)" % o_a.gun)

	var taht_satirlari := DunyaZamaniSinifi.haber_satirlari(o_a, "", null, DunyaZamaniSinifi.KITAP_DIZINI, "selcuklu_taht_kavgasi")
	_kontrol(not ("selcuklu_taht_kavgasi.etki" in DunyaZamaniSinifi.isaretler(o_a)), "Gün 14'te etki henüz açılmamış olmalı")
	_kontrol(taht_satirlari.size() >= 2, "Etki öncesi pencerede aynı olay için en az 2 satır olmalı (bulunan=%d)" % taht_satirlari.size())
	if taht_satirlari.size() >= 2:
		_kontrol(String(taht_satirlari[0].metin) != String(taht_satirlari[1].metin), "Etki öncesi karakter satırları birebir aynı olamaz")
	var dedikodu_once := DunyaZamaniSinifi.koy_dedikodu_satirlari(o_a)
	_kontrol(dedikodu_once.size() >= 1, "Köyde konuşacak kimse varken DIY-13 köy dedikodusu üretilmeli")
	var baglam := BaglamSorgusu.new().kur(o_a, null)
	_kontrol((baglam.get("dunya_olaylari", {}).get("haberler", []) as Array).size() >= 2, "BaglamSorgusu dunya_olaylari.haberler aktif haberleri taşımalı")

	# b) Gözcü özeti açıkken dünya olay satırı sayısı artmaz
	var kule := KoyBinasi.new()
	kule.id = 91
	kule.tur = GozcuKulesi.TUR
	kule.hucre = Vector2i(3, 3)
	kule.insa_kalan = 0
	o_a.yonetim.binalar.append(kule)
	var gozcu := o_a.yonetim.kabul({"ad": "Gözcü", "sinif": &"ciftci", "stat": 5})
	o_a.yonetim.ata(gozcu.id, kule.id)
	var isaret_gozcu_once := DunyaZamaniSinifi.isaretler(o_a).size()
	var haber_gozcu_once := DunyaZamaniSinifi.haber_satirlari(o_a).size()
	var ddk_gozcu_once := o_a.dedikodu.kayitlar().size()
	var ozet_metin := GozcuOngoru.metin(o_a)
	_kontrol(not ozet_metin.is_empty(), "Gözcü özeti açılmalı")
	_kontrol(DunyaZamaniSinifi.isaretler(o_a).size() == isaret_gozcu_once, "Gözcü özeti dünya işaretlerini artırmamalı")
	_kontrol(DunyaZamaniSinifi.haber_satirlari(o_a).size() == haber_gozcu_once, "Gözcü özeti dünya haber satırı sayısını artırmamalı")
	_kontrol(o_a.dedikodu.kayitlar().size() == ddk_gozcu_once, "Gözcü özeti dedikodu kaydını artırmamalı")

	# c) Boş günde yazılı haber satırı durur ve silinmez, yüz o gece gelmez; bir sonraki gerçek gelene bağlanır
	var bos_kuyruk: Array[Gelen] = []
	DunyaZamaniSinifi.kapi_haberi_ekle(o_a, bos_kuyruk)
	_kontrol(bos_kuyruk.is_empty(), "Boş günde sahte yüz üretilmemeli")
	_kontrol(DunyaZamaniSinifi.haber_satirlari(o_a).size() == haber_gozcu_once, "Boş günde yazılı haber silinmemeli")
	var gercek_kuyruk := o_a.gece_kuyrugu()
	if not gercek_kuyruk.is_empty():
		var soru_var := false
		for g in gercek_kuyruk:
			for s in g.sorular:
				if String(s[0]).contains("Yolda ne gördün"):
					soru_var = true
					break
		_kontrol(soru_var, "Bir sonraki gerçek gelende 'Yolda ne gördün?' sorusu açılmalı")

	# d) Köyde konuşacak kimse yoksa dedikodu satırı 0'dır ve etki DNY-01 gününü bekler
	var o_bos := Oturum.new(kat, 2022)
	for _i in 15:
		o_bos.gun += 1
		o_bos.yonetim.gun = o_bos.gun
		DunyaZamaniSinifi.gece(o_bos, {"gun": o_bos.gun - 1, "olaylar": []})
	_kontrol(DunyaZamaniSinifi.koy_dedikodu_satirlari(o_bos).is_empty(), "Köyde konuşacak kimse yoksa köy dedikodusu 0 olmalı")
	_kontrol(not ("selcuklu_taht_kavgasi.etki" in DunyaZamaniSinifi.isaretler(o_bos)), "Boş köyde etki öne çekilmemeli (gün 15)")
	o_bos.gun += 1
	o_bos.yonetim.gun = o_bos.gun
	DunyaZamaniSinifi.gece(o_bos, {"gun": o_bos.gun - 1, "olaylar": []})
	_kontrol("selcuklu_taht_kavgasi.etki" in DunyaZamaniSinifi.isaretler(o_bos), "Etki DNY-01 gününü bekleyip gün 16'da gelmeli")

	# e) Salgın haber satırı hastalık yöneticisini çağırmaz + dalı olmayan karar işareti yazılı haberde kalır
	var o_salgin := Oturum.new(kat, 2023)
	var saglam := o_salgin.yonetim.kabul({"ad": "Mehmet", "sinif": &"ciftci", "stat": 4})
	for g_no in range(1, 51):
		o_salgin.yonetim.gun = g_no
		DunyaZamaniSinifi.gece(o_salgin, {"gun": g_no - 1, "olaylar": []})
	_kontrol("salgin_dalgasi.kesin_haber" in DunyaZamaniSinifi.isaretler(o_salgin), "Salgın kesin_haber gün 50'de gelmeli")
	_kontrol(not SaglikYoneticisi.hasta(saglam), "Salgın haber satırı hastalık yöneticisini çağırmamalı")
	var b_karar := SatirSecici.baglama_dunya_isareti_yaz(BaglamSorgusu.new().kur(o_salgin, null), "mogol_elcisi", "kabul")
	var dalsiz_sec := SatirSecici.new().sec([{"id": "varsayilan", "metin": "Sıradan söz.", "kosullar": {}}], b_karar)
	_kontrol(String(dalsiz_sec.get("id", "")) == "varsayilan" and String(b_karar.get("dunya.mogol_elcisi", "")) == "kabul", "Dalı olmayan karar işareti yalnızca yazılı bağlamda kalmalı")
