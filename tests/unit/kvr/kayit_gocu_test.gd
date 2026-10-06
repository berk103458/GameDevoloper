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
	yeni["muhafiz_akce"] = "secret"
	_kontrol(motor.uygula(yeni, 7).is_empty(), "Hatalı kasa tipi reddediliyor")
	print("KAYIT GÖÇÜ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
