## Köy yapıları: konak ve sur (design/gdd/koy-gelisimi.md). Düz betik:
##   godot --headless --path . -s tests/unit/koy_yapilari/koy_yapilari_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0


func _init() -> void:
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	var a := k.ayarlar
	# Konak nüfus ister: akçe yeter, nüfus yetmezse kurulmaz.
	var o := Oturum.new(k, 5)
	o.akce = a.konak_bedel[0]
	for i in a.konak_nufus[0] - 1:
		o.koy.ekle(&"ciftci")
	_esit("konak: nüfus eksik", o.yapi_durumu(&"konak")["olur"], false)
	_esit("konak: kurulmadı", o.yapi_kur(&"konak"), false)
	# Nüfus tamamlanınca kurulur: akçe düşer, Soylular +1.
	o.koy.ekle(&"ciftci")
	var soylu := o.barlar.degerler[1]
	_esit("konak: kuruldu", o.yapi_kur(&"konak"), true)
	_esit("konak: seviye", o.yapilar[&"konak"], 1)
	_esit("konak: akçe", o.akce, 0)
	_esit("konak: Soylular", o.barlar.degerler[1], soylu + 1)
	# En üst seviyeden sonra kurulamaz.
	o.yapilar[&"konak"] = a.konak_bedel.size()
	_esit("konak: üst seviye", o.yapi_durumu(&"konak")["bedel"], -1)
	# Sur birinci perdede de kurulabilir.
	o = Oturum.new(k, 5)
	o.akce = a.sur_bedel[0]
	_esit("sur: birinci perde", o.yapi_kur(&"sur"), true)
	# Kayıt konağı taşır.
	o.yapilar[&"konak"] = 2
	var y := Oturum.kayittan(k, o.kaydet())
	_esit("kayıt: konak", y.yapilar[&"konak"], 2)
	print("KOY YAPILARI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
