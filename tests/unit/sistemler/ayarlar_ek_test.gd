## AYR-02, AYR-05, AYR-22, AYR-43, AYR-44, AYR-46 birim testleri.
## Ek anahtar listeleri `src/sistemler/ayarlar_ek.gd` içindedir; `ayarlar.gd` değişmez.
extends SceneTree

const YOL := "user://test_ayar_ek.cfg"
const OdakSesiSinifi = preload("res://src/sistemler/odak_sesi.gd")
const KayitYuvalariSinifi = preload("res://src/sistemler/kayit_yuvalari.gd")
const KayitYuvaKartiSinifi = preload("res://src/arayuz/kayit_yuva_karti.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	# --- AYR-02: dosya yokken ek varsayılanlar kaydolur, çekirdek değerler bozulmaz.
	_sil()
	var a := Ayarlar.new(YOL)
	a.yukle()
	AyarlarEk.bagla(a)
	_kontrol(a.al(&"satir_araligi") == &"normal", "AYR-02: ek anahtar varsayılanıyla okunur (dosya yok)")
	_kontrol(a.al(&"metin_agirligi") == 400 and a.al(&"koy_hizi_varsayilan") == 1, "AYR-02: öteki ek anahtarlar da kaydoldu")
	_kontrol(a.al(&"ses_ana") == 8 and a.al(&"ekran_modu") == &"tam_ekran", "AYR-02: çekirdek değerler bozulmaz")

	# --- AYR-02 kabulü: `ayarlar.gd` değişmez — çekirdek dosya ek anahtarı taşımaz.
	var satirlar := FileAccess.get_file_as_string("res://src/sistemler/ayarlar.gd").split("\n")
	for anahtar in AyarlarEk.VARSAYILAN:
		var bulundu := false
		for satir in satirlar:
			if String(anahtar) in satir:
				bulundu = true
				break
		_kontrol(not bulundu, "AYR-02: ayarlar.gd ek anahtarı taşımıyor (%s)" % anahtar)

	# --- AYR-02: dosyadaki ek değer al() ile okunur, çekirdek değer korunur.
	_yaz_cfg({&"satir_araligi": "genis", &"koy_hizi_varsayilan": 3})
	var b := Ayarlar.new(YOL)
	b.yukle()
	AyarlarEk.bagla(b)
	_kontrol(b.al(&"satir_araligi") == &"genis", "AYR-02: dosyadaki ek değer al() ile okunur")
	_kontrol(b.al(&"koy_hizi_varsayilan") == 3 and b.al(&"ses_ana") == 8, "AYR-02: ek değer üzerine yazılır, çekirdek korunur")
	_kontrol(AyarlarEk.gecersizler.is_empty(), "AYR-02: geçerli dosyada günlük satırı yok")

	# --- AYR-02: ek anahtar dosyaya da yazılır ve geri okunur.
	_kontrol(AyarlarEk.ayarla(b, &"metin_agirligi", 500), "AYR-02: ek anahtar ayarla() ile değişir")
	b.yaz()
	var c := Ayarlar.new(YOL)
	c.yukle()
	AyarlarEk.bagla(c)
	_kontrol(c.al(&"metin_agirligi") == 500, "AYR-02: ek değer dosyaya yazılır ve geri okunur")

	# --- AYR-05: Okuma sekmesi sıfırlanınca ses değerleri aynı kalır.
	c.ayarla(&"ses_ana", 3)
	c.ayarla(&"metin_olcegi", 150)
	AyarlarEk.ayarla(c, &"satir_araligi", &"genis")
	_kontrol(not AyarlarEk.sekme_sifirla(c, &"okuma", false), "AYR-05: onaysız sekme sıfırlanmaz")
	_kontrol(AyarlarEk.sekme_sifirla(c, &"okuma", true), "AYR-05: onaylı okuma sekmesi sıfırlanır")
	_kontrol(c.al(&"metin_olcegi") == 100 and c.al(&"satir_araligi") == &"normal", "AYR-05: okuma değerleri varsayılana döndü")
	_kontrol(c.al(&"ses_ana") == 3, "AYR-05: okuma sekmesi sıfırlanınca ses değeri aynı kalır")

	# --- AYR-22: NOTIFICATION_APPLICATION_FOCUS_OUT sonrası Master -80 dB; dönüşte eski.
	var odak_ayar := Ayarlar.new(YOL)
	odak_ayar.yukle()
	AyarlarEk.bagla(odak_ayar)
	odak_ayar.ayarla(&"ses_ana", 8)
	var master_bus := AudioServer.get_bus_index("Master")
	var eski_db := AudioServer.get_bus_volume_db(master_bus) if master_bus >= 0 else 0.0
	var odak := OdakSesiSinifi.new(odak_ayar)
	odak._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	_kontrol(odak_ayar.al(&"ses_ana") == 0, "AYR-22: odak kaybında ses_ana geçici 0 olur")
	if master_bus >= 0:
		_kontrol(is_equal_approx(AudioServer.get_bus_volume_db(master_bus), -80.0), "AYR-22: odak kaybında Master -80 dB olur")
	odak._notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	_kontrol(odak_ayar.al(&"ses_ana") == 8, "AYR-22: odak dönüşünde ses_ana eski değere döner")
	if master_bus >= 0:
		_kontrol(is_equal_approx(AudioServer.get_bus_volume_db(master_bus), eski_db), "AYR-22: odak dönüşünde Master eski dB değerine döner")
	odak.free()

	# --- AYR-43: İleri sürüm dosyası açılır, bilinmeyen anahtar korunur.
	_yaz_cfg({&"surum": 9, &"gelecek_surum_anahtari": "korunacak_deger"})
	var ileri := Ayarlar.new(YOL)
	ileri.yukle()
	AyarlarEk.bagla(ileri)
	_kontrol(ileri.al(&"surum") == 9 and ileri.al(&"gelecek_surum_anahtari") == "korunacak_deger", "AYR-43: ileri sürüm ve bilinmeyen anahtar açılışta korunur")
	ileri.yaz()
	var ileri2 := Ayarlar.new(YOL)
	ileri2.yukle()
	AyarlarEk.bagla(ileri2)
	_kontrol(ileri2.al(&"gelecek_surum_anahtari") == "korunacak_deger", "AYR-43: yaz() sonrası bilinmeyen anahtar korunur")

	# --- AYR-46: `--ayar anahtar=deger` argümanla açılış değeri uygular, `yaz()` sonrası dosya değişmez.
	_yaz_cfg({&"ses_ana": 8, &"satir_araligi": "normal"})
	var cli_ayar := Ayarlar.new(YOL)
	cli_ayar.yukle()
	AyarlarEk.bagla(cli_ayar, PackedStringArray(["--ayar", "ses_ana=2", "--ayar=satir_araligi=genis"]))
	_kontrol(cli_ayar.al(&"ses_ana") == 2 and cli_ayar.al(&"satir_araligi") == &"genis", "AYR-46: komut satırı argümanı oturumda uygulanır")
	cli_ayar.yaz()
	var dosya_sonrasi := Ayarlar.new(YOL)
	dosya_sonrasi.yukle()
	AyarlarEk.bagla(dosya_sonrasi)
	_kontrol(dosya_sonrasi.al(&"ses_ana") == 8 and dosya_sonrasi.al(&"satir_araligi") == &"normal", "AYR-46: yaz() sonrası asıl dosya değişmez")

	# --- AYR-44: tek bozuk değer varsayılana düşer ve tek satır loglanır.
	_yaz_cfg({&"satir_araligi": "cok_genis"})
	var d := Ayarlar.new(YOL)
	d.yukle()
	AyarlarEk.gecersizler.clear()
	Engine.print_error_messages = false
	AyarlarEk.bagla(d)
	Engine.print_error_messages = true
	_kontrol(AyarlarEk.gecersizler.size() == 1, "AYR-44: bozuk cfg için tek günlük satırı")
	_kontrol(AyarlarEk.gecersizler[0].contains("satir_araligi") and AyarlarEk.gecersizler[0].contains("varsayılan"), "AYR-44: günlük satırı anahtarı ve varsayılanı yazar")
	_kontrol(d.al(&"satir_araligi") == &"normal", "AYR-44: geçersiz değer varsayılana düşer")
	_kontrol(d.al(&"ses_ana") == 8, "AYR-44: oyun çökmez, çekirdek değerler yerinde")

	# --- AYR-44: aralık dışı ve türü yanlış değer reddedilir; değer değişmez.
	Engine.print_error_messages = false
	var aralik_disi := AyarlarEk.ayarla(d, &"koy_hizi_varsayilan", 7)
	var tur_yanlis := AyarlarEk.ayarla(d, &"metin_agirligi", "kalin")
	Engine.print_error_messages = true
	_kontrol(not aralik_disi and d.al(&"koy_hizi_varsayilan") == 1, "AYR-44: aralık dışı değer ayarla() ile reddedilir")
	_kontrol(not tur_yanlis and d.al(&"metin_agirligi") == 400, "AYR-44: tür yanlışsa varsayılan kalır")
	_kontrol(AyarlarEk.gecersizler.size() == 3, "AYR-44: reddedilen her değer tek satır")

	# --- AYR-31: Otomatik kayıt ayarı (`her_gece`, `uc_gecede_bir`, `kapali`)
	AyarlarEk.ayarla(d, &"otomatik_kayit", &"uc_gecede_bir")
	_kontrol(not AyarlarEk.otomatik_kayit_yazilmali_mi(d, 1) and not AyarlarEk.otomatik_kayit_yazilmali_mi(d, 2) and AyarlarEk.otomatik_kayit_yazilmali_mi(d, 3), "AYR-31: üç gecede bir seçiliyken yalnız 3. gecede kayıt yazılır")
	AyarlarEk.ayarla(d, &"otomatik_kayit", &"kapali")
	_kontrol(not AyarlarEk.otomatik_kayit_yazilmali_mi(d, 3), "AYR-31: kapalıyken otomatik kayıt yazılmaz")

	# --- AYR-28 & AYR-32: Üç kayıt yuvası, eski kaydın yuva 1'e göçü, iki adımlı silme ve cop temizliği
	var test_kok := "user://test_yuvalar/"
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(test_kok))
	for eski_kalinti in ["kayit.json", "kayit_1.json", "kayit_2.json", "kayit_3.json"]:
		if FileAccess.file_exists(test_kok + eski_kalinti):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(test_kok + eski_kalinti))
	KayitDeposu.new(test_kok + "kayit.json").yaz({"surum": Oturum.KAYIT_SURUMU, "gun": 4, "nufus": 9, "perde": 1, "muhafiz_gecmisi": "katip"})
	var yuvalar := KayitYuvalariSinifi.new(test_kok)
	_kontrol(yuvalar.tum_yuva_yollari().size() == 3, "AYR-28: üç kayıt yuvası vardır")
	_kontrol(yuvalar.var_mi(1) and FileAccess.file_exists(test_kok + "kayit.json"), "AYR-28: eski dosya varsa yuva 1'de görünür ve eski dosya silinmez")
	_kontrol(not yuvalar.yuva_sil(1, false) and yuvalar.var_mi(1), "AYR-32: onaysız yuva silinmez")
	_kontrol(yuvalar.yuva_sil(1, true) and not yuvalar.var_mi(1) and yuvalar.cop_dosya_sayisi() == 1, "AYR-32: silme sonrası cop/ içinde dosya 1")
	var yuvalar_ikinci := KayitYuvalariSinifi.new(test_kok)
	_kontrol(yuvalar_ikinci.cop_dosya_sayisi() == 0, "AYR-32: ikinci açılışta cop/ içindeki dosya 0")

	# --- AYR-29 & AYR-33: Yuva kartı 5 alan, bozuk dosya "okunamadı", sürüm 99 "yeni sürüm kaydı"
	var kart := KayitYuvaKartiSinifi.new(2)
	yuvalar_ikinci.yaz(2, {"surum": Oturum.KAYIT_SURUMU, "gun": 7, "nufus": 12, "perde": 1, "son_kayit_saati": "2026-10-13T21:00:00", "muhafiz_gecmisi": "eski_levent"})
	var ozet_hazir := kart.dosyadan_yukle(yuvalar_ikinci.yuva_yolu(2))
	_kontrol(bool(ozet_hazir.get("acilabilir", false)) and int(ozet_hazir.get("gun", 0)) == 7 and int(ozet_hazir.get("nufus", 0)) == 12 and int(ozet_hazir.get("perde", 0)) == 1 and String(ozet_hazir.get("gecmis", "")) == "eski_levent", "AYR-29: beş alan kayıt başlığından okunur")
	var bozuk_yol := test_kok + "bozuk.json"
	var bf := FileAccess.open(bozuk_yol, FileAccess.WRITE)
	bf.store_string("{bozuk_json")
	bf.close()
	var ozet_bozuk := kart.dosyadan_yukle(bozuk_yol)
	_kontrol(not bool(ozet_bozuk.get("acilabilir", true)) and String(ozet_bozuk.get("uyari", "")) == "okunamadı", "AYR-29: bozuk kayıt 'okunamadı' yazar, çökmez")
	var ileri_yol := test_kok + "ileri_surum.json"
	var ifile := FileAccess.open(ileri_yol, FileAccess.WRITE)
	ifile.store_string(JSON.stringify({"surum": 99, "gun": 10}))
	ifile.close()
	var ozet_ileri := kart.dosyadan_yukle(ileri_yol)
	_kontrol(not bool(ozet_ileri.get("acilabilir", true)) and String(ozet_ileri.get("uyari", "")) == "yeni sürüm kaydı" and FileAccess.file_exists(ileri_yol), "AYR-33: sürüm 99 dosyası 'yeni sürüm kaydı' yazar, açılmaz ve silinmez")
	kart.free()

	_sil()
	d = null
	c = null
	b = null
	a = null
	satirlar = []
	await process_frame
	await process_frame
	await create_timer(0.2).timeout
	print("AYARLAR EK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _yaz_cfg(degerler: Dictionary) -> void:
	var cfg := ConfigFile.new()
	for anahtar in degerler:
		cfg.set_value("ayarlar", String(anahtar), degerler[anahtar])
	cfg.save(YOL)


func _sil() -> void:
	if FileAccess.file_exists(YOL):
		DirAccess.remove_absolute(YOL)
	if FileAccess.file_exists(YOL + ".cli_gecici"):
		DirAccess.remove_absolute(YOL + ".cli_gecici")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
