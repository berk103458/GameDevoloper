## AYR-02, AYR-05, AYR-22, AYR-43, AYR-44, AYR-46 birim testleri.
## Ek anahtar listeleri `src/sistemler/ayarlar_ek.gd` içindedir; `ayarlar.gd` değişmez.
extends SceneTree

const YOL := "user://test_ayar_ek.cfg"
const OdakSesiSinifi = preload("res://src/sistemler/odak_sesi.gd")

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
