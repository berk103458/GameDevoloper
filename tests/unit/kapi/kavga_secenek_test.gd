## CAT-02 ve YAP-53: Kavga secenekleri — askerle karsilik, akceyle erteleme, sozle yatistirma, reddetme ve esya kavga ganimeti birim testi.
## Kabul kriterleri:
## - Dort secenek dort ayri sonuc kimligi uretir.
## - Erteleme `verilen_soz` kaydina 1 satir yazar.
## - Olum cenaze akisina tek cagri yazar.
## - Ek sart: kalp anahtari 1 hata verir.
## - Ek sart: ayni secenege iki tikta sonuc bir kez yazilir.
## - YAP-53: Esya kavga ganimeti olabilir; CAT ayri esya sinifi acmaz (data/ozel_esyalar.json tanimiyla ayni).
extends SceneTree

const KapiKavgasiSinifi = preload("res://src/kapi/kapi_kavgasi.gd")
const DedikoduSinifi = preload("res://src/sistemler/dedikodu.gd")
const GrupItibariSinifi = preload("res://src/sistemler/grup_itibari.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 4213)
	var kadro := oturum.kadro
	var ornek_id: StringName = katalog.karakterler()[0].id

	_test_dort_secenek_dort_ayri_sonuc_kimligi(kadro, ornek_id)
	_test_erteleme_verilen_soz_ve_soz_tutulmadi(kadro, ornek_id)
	_test_olum_cenaze_tek_cagri_ve_kin_kacti_ayrimi(kadro, ornek_id)
	_test_kalp_anahtari_ve_besinci_secenek_hatasi()
	_test_ayni_secenege_iki_tikta_tek_yazim(kadro, ornek_id)
	_test_kilit_durumlari_akce_bes_soz_ve_asker_olumu()
	_test_yap53_esya_kavga_ganimeti(kadro, ornek_id)

	await process_frame
	print("KAVGA SECENEK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_dort_secenek_dort_ayri_sonuc_kimligi(kadro: KarakterKadrosu, id: StringName) -> void:
	var kk := KapiKavgasiSinifi.new()
	var dedikodu := DedikoduSinifi.new()
	var kimlikler: Dictionary = {}

	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 1})
	var s1: Dictionary = kk.secenek_uygula("askerle_karsilik", {"kisi_id": String(id), "gun": 1, "asker_sayisi": 1, "zar_atis": 5}, kadro, dedikodu)
	kimlikler[String(s1.get("sonuc_kimligi", ""))] = true

	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 2})
	var s2: Dictionary = kk.secenek_uygula("akceyle_erteleme", {"kisi_id": String(id), "gun": 2, "muhafiz_akce": 5}, kadro, dedikodu)
	kimlikler[String(s2.get("sonuc_kimligi", ""))] = true

	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 3})
	var s3: Dictionary = kk.secenek_uygula("sozle_yatistirma", {"kisi_id": String(id), "gun": 3, "zar_atis": 5}, kadro, dedikodu)
	kimlikler[String(s3.get("sonuc_kimligi", ""))] = true

	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 4, "tanik": "koylu_hasan"})
	var s4: Dictionary = kk.secenek_uygula("reddetme", {"kisi_id": String(id), "gun": 4, "tanik": "koylu_hasan"}, kadro, dedikodu)
	kimlikler[String(s4.get("sonuc_kimligi", ""))] = true

	kimlikler.erase("")
	_kontrol(kimlikler.size() == 4, "Dört seçenek dört ayrı sonuç kimliği üretmeli (üretilen=%s)" % str(kimlikler.keys()))


func _test_erteleme_verilen_soz_ve_soz_tutulmadi(kadro: KarakterKadrosu, id: StringName) -> void:
	var kk := KapiKavgasiSinifi.new()
	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 3})
	var sonuc: Dictionary = kk.secenek_uygula("akceyle_erteleme", {
		"kisi_id": String(id),
		"gun": 3,
		"muhafiz_akce": 6,
		"erteleme_bedeli": 2,
		"donus_gun_ek": 3,
	}, kadro)
	_kontrol(bool(sonuc.get("olur", false)), "Akçeyle erteleme uygulanmalı")
	_kontrol(kk.verilen_sozler().size() == 1 and int(sonuc.get("verilen_soz_satir_sayisi", 0)) == 1, "Erteleme verilen_soz kaydına tam 1 satır yazmalı")
	_kontrol(String(sonuc.get("verilen_soz", "")) == "yarin_gel", "Erteleme yarin_gel sözünü açmalı")
	_kontrol(int(sonuc.get("donus_gun", 0)) == 6, "Kişi 2–4 gün sonra dönmeli (3 + 3 = 6)")
	_kontrol(int(sonuc.get("kalan_muhafiz_akce", -1)) == 4, "Akçe muhafiz_akce hesabından düşmeli (6 - 2 = 4)")

	var gi := GrupItibariSinifi.new()
	kk.erteleme_sozu_tutulmadi(gi, "turkmen")
	_kontrol(gi.deger("turkmen") == -1, "Söz tutulmazsa grup itibarı -1 olmalı")


func _test_olum_cenaze_tek_cagri_ve_kin_kacti_ayrimi(kadro: KarakterKadrosu, id: StringName) -> void:
	var kk := KapiKavgasiSinifi.new()
	var cenaze_sayaci := {"cagri": 0}
	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 5})
	var olum_sonuc: Dictionary = kk.secenek_uygula(
		"askerle_karsilik",
		{"kisi_id": String(id), "gun": 5, "asker_sayisi": 1, "zar_atis": 1},
		kadro,
		null,
		func(_kayit: Dictionary) -> void: cenaze_sayaci["cagri"] = int(cenaze_sayaci["cagri"]) + 1
	)
	_kontrol(String(olum_sonuc.get("alt_sonuc", "")) == "olum", "Kritik başarısızlıkta sonuç ölüm olmalı")
	_kontrol(int(cenaze_sayaci["cagri"]) == 1 and kk.cenaze_cagrilari().size() == 1, "Ölüm cenaze akışına tek çağrı yazmalı")

	# Kin ile kacis ayri kayit kimligidir
	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 6})
	var kacis_sonuc: Dictionary = kk.secenek_uygula("askerle_karsilik", {"kisi_id": String(id), "gun": 6, "asker_sayisi": 1, "zar_atis": 6})
	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 7})
	var kin_sonuc: Dictionary = kk.secenek_uygula("askerle_karsilik", {"kisi_id": String(id), "gun": 7, "asker_sayisi": 1, "zar_atis": 2, "zorluk": 5})
	_kontrol(String(kacis_sonuc.get("kayit_kimligi", "")) != String(kin_sonuc.get("kayit_kimligi", "")), "Kin ile kaçış ayrı kayıt kimliği olmalı (%s != %s)" % [String(kacis_sonuc.get("kayit_kimligi", "")), String(kin_sonuc.get("kayit_kimligi", ""))])


func _test_kalp_anahtari_ve_besinci_secenek_hatasi() -> void:
	var hatalar_kalp: Array[String] = KapiKavgasiSinifi.veri_dogrula({"kalp": 1, "secenek": "askerle_karsilik"})
	_kontrol(hatalar_kalp.size() == 1, "kalp anahtarı tam 1 hata vermeli (alınan=%d)" % hatalar_kalp.size())

	var hatalar_besinci: Array[String] = KapiKavgasiSinifi.veri_dogrula({"secenek": "besinci_secenek"})
	_kontrol(hatalar_besinci.size() == 1, "Beşinci seçenek 1 hata vermeli")


func _test_ayni_secenege_iki_tikta_tek_yazim(kadro: KarakterKadrosu, id: StringName) -> void:
	var kk := KapiKavgasiSinifi.new()
	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 8})
	var ilk_tik: Dictionary = kk.secenek_uygula("akceyle_erteleme", {"kisi_id": String(id), "gun": 8, "muhafiz_akce": 10}, kadro)
	var ikinci_tik: Dictionary = kk.secenek_uygula("akceyle_erteleme", {"kisi_id": String(id), "gun": 8, "muhafiz_akce": 10}, kadro)
	_kontrol(bool(ilk_tik.get("olur", false)) and not bool(ikinci_tik.get("olur", true)), "Aynı seçeneğe ikinci tık engellenmeli")
	_kontrol(kk.verilen_sozler().size() == 1, "Aynı seçeneğe iki tıkta sonuç yalnız 1 kez yazılmalı")


func _test_kilit_durumlari_akce_bes_soz_ve_asker_olumu() -> void:
	var kk := KapiKavgasiSinifi.new()
	var d_akcesiz: Dictionary = kk.secenek_durumlari({"asker_sayisi": 1, "muhafiz_akce": 0, "erteleme_bedeli": 2})
	var erteleme_1: Dictionary = d_akcesiz.get("akceyle_erteleme", {})
	_kontrol(bool(erteleme_1.get("gorunur", false)) and bool(erteleme_1.get("kilitli", false)), "Akçe yetmezse erteleme kilitli görünmeli")

	var d_bes_soz: Dictionary = kk.secenek_durumlari({"asker_sayisi": 1, "muhafiz_akce": 10, "acik_soz_sayisi": 5})
	var erteleme_2: Dictionary = d_bes_soz.get("akceyle_erteleme", {})
	_kontrol(bool(erteleme_2.get("kilitli", false)) and not String(erteleme_2.get("kilit_nedeni", "")).is_empty(), "Açık söz sayısı 5 iken erteleme kilitli olmalı ve nedeni yazmalı")

	var d_asker_oldu: Dictionary = kk.secenek_durumlari({"asker_hayatta": false, "asker_sayisi": 0, "muhafiz_akce": 10})
	_kontrol(not bool((d_asker_oldu.get("askerle_karsilik", {}) as Dictionary).get("gorunur", true)), "Asker ölürse karşılık seçeneği kapanmalı")
	_kontrol(bool((d_asker_oldu.get("akceyle_erteleme", {}) as Dictionary).get("gorunur", false)), "Diğer seçenek 1 (erteleme) durmalı")
	_kontrol(bool((d_asker_oldu.get("sozle_yatistirma", {}) as Dictionary).get("gorunur", false)), "Diğer seçenek 2 (yatıştırma) durmalı")
	_kontrol(bool((d_asker_oldu.get("reddetme", {}) as Dictionary).get("gorunur", false)), "Diğer seçenek 3 (reddetme) durmalı")


func _test_yap53_esya_kavga_ganimeti(kadro: KarakterKadrosu, id: StringName) -> void:
	var kk := KapiKavgasiSinifi.new()
	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 9})
	var basarili_kavga: Dictionary = kk.secenek_uygula("askerle_karsilik", {
		"kisi_id": String(id),
		"gun": 9,
		"asker_sayisi": 1,
		"zar_atis": 6,
		"ganimet_esya_id": "kirim_akcaagac_yayi"
	}, kadro)
	_kontrol(String(basarili_kavga.get("ganimet_esya_id", "")) == "kirim_akcaagac_yayi", "YAP-53: Başarılı askerle karşılıkta özel eşya kavga ganimeti olabilmeli")
	var ganimet: Variant = basarili_kavga.get("ganimet_esya")
	_kontrol(ganimet is Dictionary and not (ganimet is Object) and String(ganimet.get("hedef_sistem", "")) == "savunma_formulu", "YAP-53: CAT ayrı eşya sınıfı açmaz, data/ozel_esyalar.json sözlüğünü kullanır")

	kk.yeni_kavga_ac({"kisi_id": String(id), "gun": 10})
	var basarisiz_kavga: Dictionary = kk.secenek_uygula("askerle_karsilik", {
		"kisi_id": String(id),
		"gun": 10,
		"asker_sayisi": 1,
		"zar_atis": 2,
		"zorluk": 5,
		"ganimet_esya_id": "kirim_akcaagac_yayi"
	}, kadro)
	_kontrol(String(basarisiz_kavga.get("ganimet_esya_id", "")).is_empty(), "YAP-53: Başarısız kavgada ganimet eşya düşmez")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
