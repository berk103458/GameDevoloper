extends SceneTree

var hata := 0

func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 12345)
	o.yonetim.gun = 9
	o.yonetim.akce = 71
	var eski := o.kaydet()
	eski["surum"] = 2
	for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "mevsim", "yeni_binalar"]:
		eski.erase(alan)
	var motor := preload("res://src/sistemler/kayit_gocu.gd")
	var yeni: Dictionary = motor.uygula(eski, 7)
	_kontrol(yeni["surum"] == 3 and yeni["muhafiz_akce"] == 0 and yeni["mevsim"] == 1, "v2→v3 kasa/mevsim")
	_kontrol(eski["surum"] == 2 and not eski.has("muhafiz_akce"), "Göç kaynak sözlüğünü değiştirmez")
	_kontrol(yeni["koy_yonetimi"] == eski["koy_yonetimi"] and yeni["rng"] == eski["rng"] and yeni["kadro"] == eski["kadro"], "Köy/kadro/RNG aynen korunur")
	_kontrol(motor.uygula(yeni, 7) == yeni, "Göç idempotent")
	var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(eski)))
	_kontrol(geri != null and geri.gun == 9 and geri.koy_akce == 71 and geri.muhafiz_akce == 0, "Eski JSON gerçek Oturum olarak yükleniyor")
	var gelecekteki := yeni.duplicate(true)
	gelecekteki["surum"] = 99
	_kontrol(motor.uygula(gelecekteki, 7).is_empty(), "Gelecek sürüm geriye düşürülmüyor")
	for bozuk_surum in [2.5, "2", 1, 0, INF, NAN]:
		var bozuk := eski.duplicate(true)
		bozuk["surum"] = bozuk_surum
		_kontrol(motor.uygula(bozuk, 7).is_empty(), "Geçersiz sürüm tahmini tam sayıya dönüştürülmez")
	var kisisel := eski.duplicate(true)
	kisisel["muhafiz_akce"] = 17
	kisisel["muhafiz_esyalari"] = [{"ad": "yuzuk", "adet": 1}]
	var kisisel_yeni: Dictionary = motor.uygula(kisisel, 7)
	_kontrol(kisisel_yeni["muhafiz_akce"] == 17 and kisisel_yeni["muhafiz_esyalari"] == kisisel["muhafiz_esyalari"], "N→N+1 mevcut kişisel alanları korur")
	kisisel_yeni["muhafiz_esyalari"][0]["adet"] = 3
	_kontrol(kisisel["muhafiz_esyalari"][0]["adet"] == 1, "Adım derin kopyada çalışır")
	yeni["muhafiz_akce"] = "secret"
	_kontrol(motor.uygula(yeni, 7).is_empty(), "Hatalı kasa tipi reddediliyor")
	# KAY-44: dört barlı sürüm 1 kaydı hâlâ reddedilir; göç onu Söz kaydına çevirmez.
	var v1 := {"surum": 1, "tohum": "7", "kadro": {}, "koy_yonetimi": eski["koy_yonetimi"]}
	_kontrol(motor.uygula(v1, 7).is_empty(), "Dört barlı sürüm 1 kaydı reddedilir")
	var v1_donus: Dictionary = motor.uygula(v1, 7)
	_kontrol(v1_donus.is_empty() and not v1_donus.has("muhafiz_akce"), "Göç v1'i Söz kaydına çevirmez")
	var slot := GuvenliKayit.new("user://kay44_v1.json")
	slot.sil()
	_kontrol(slot.yaz(v1), "v1 dosya diske yazıldı")
	_kontrol(not slot.oku().is_empty() and motor.uygula(slot.oku(), 7).is_empty(), "v1 dosya diskten reddedilir")
	var diskte: Variant = JSON.parse_string(FileAccess.get_file_as_string(slot.yol))
	_kontrol(diskte is Dictionary and int(diskte["surum"]) == 1 and String(diskte["tohum"]) == "7", "Reddedilen v1 dosyası diskte değişmez")
	slot.sil()
	# KAY-43: chr-runtime sürüm 3 fixtürü yeni sürümde açılır; köy, kadro ve rastgelelik durur.
	var v3oturum := Oturum.new(katalog, 3143)
	v3oturum.yonetim.gun = 4
	v3oturum.yonetim.kabul({"ad": "Sürüm 3"})
	var v3nufus := v3oturum.yonetim.nufus()
	var v3rng: Array = v3oturum.kaydet()["rng"]
	var v3kadro: Dictionary = v3oturum.kadro.kaydet()
	var v3: Dictionary = JSON.parse_string(JSON.stringify(v3oturum.kaydet()))
	v3["surum"] = 3
	var v3geri := Oturum.kayittan(katalog, v3)
	_kontrol(v3geri != null and v3geri.yonetim.nufus() == v3nufus, "Sürüm 3 kaydı açılır, köylü sayısı eşit")
	_kontrol(v3geri != null and v3geri.kaydet()["rng"] == v3rng, "Sürüm 3 rastgeleliği durur")
	_kontrol(v3geri != null and v3geri.kadro.kaydet() == v3kadro, "Sürüm 3 kadrosu durur")
	print("KAYIT GÖÇÜ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
