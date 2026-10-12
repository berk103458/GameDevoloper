## AYR-02 + AYR-44: ek anahtarlar ayrı dosyadan kaydolur; geçersiz değer varsayılana düşer ve loglanır.
## Ek anahtar listeleri `src/sistemler/ayarlar_ek.gd` içindedir; `ayarlar.gd` değişmez.
extends SceneTree

const YOL := "user://test_ayar_ek.cfg"

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

	# --- AYR-44: tek bozuk değer varsayılana düşer ve tek satır loglanır.
	# Beklenen hata: bagla() kasıtlı olarak hata basar; bu testte çıktıyı kirletmemek için motorun
	# hata basımı geçici kapatılır, satır AyarlarEk.gecersizler'den doğrulanır.
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


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
