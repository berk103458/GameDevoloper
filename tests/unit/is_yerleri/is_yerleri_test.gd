## İş yeri kuralları (design/gdd/is-yerleri.md). Düz betik:
##   godot --headless --path . -s tests/unit/is_yerleri/is_yerleri_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0


func _init() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	var a := k.ayarlar
	# Uygun: çiftçi tarlaya → çiftçi sayılır, bar bedeli yok.
	var o := Oturum.new(k, 5)
	var g := _gelen(&"ciftci")
	var halk := o.barlar.degerler[0]
	var s := o.karar_ver(g, &"kabul", &"tarla")
	_esit("uygun: bedel yok", s["uyumsuz"], false)
	_esit("uygun: çiftçi sayıldı", o.koy.sayi(&"ciftci"), 1)
	_esit("uygun: Halk yalnız karar etkisiyle", o.barlar.degerler[0], halk + g.etkiler[&"kabul"][0])
	# Uygunsuz: esnaf (çırak) kışlaya → asker sayılır, Ordu −1.
	o = Oturum.new(k, 5)
	g = _gelen(&"esnaf")
	var ordu := o.barlar.degerler[3]
	s = o.karar_ver(g, &"kabul", &"kisla")
	_esit("uygunsuz: işaret", s["uyumsuz"], true)
	_esit("uygunsuz: asker sayıldı", o.koy.sayi(&"asker"), 1)
	_esit("uygunsuz: Ordu düştü", o.barlar.degerler[3], ordu + g.etkiler[&"kabul"][3] - a.uyumsuz_ceza)
	# Kervansaray yapı ister.
	o = Oturum.new(k, 5)
	_esit("kervansaraysız liste", Array(o.is_yerleri()), ["tarla", "pazar", "kisla"])
	o.yapilar[&"kervansaray"] = 1
	_esit("kervansaraylı liste", Array(o.is_yerleri()), ["tarla", "pazar", "kervansaray", "kisla"])
	print("IS YERLERI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _gelen(sinif: StringName) -> Gelen:
	var g := Gelen.new()
	g.sinif = sinif
	g.etkiler = {&"kabul": PackedInt32Array([1, 0, 0, 0])}
	return g


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
