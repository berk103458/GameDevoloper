## Kapı manzarası ve kapı çerçevesi (design/gdd/kapi-manzarasi.md). Düz betik:
##   godot --headless --path . -s tests/unit/kapi_manzarasi/kapi_manzarasi_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0


func _init() -> void:
	# Sorgu alanı düz; yol kapıdan başlar, ufka doğru yükselir.
	_esit("kapının önü düz", absf(KapiManzarasi.yukseklik(0.0, -3.0)) < 0.01, true)
	var bas := KapiManzarasi.yol_noktasi(0.0)
	_esit("yol kapıdan başlar", Vector2(bas.x, bas.z).length() < 0.01, true)
	_esit("yol ufukta yüksekte", KapiManzarasi.yol_noktasi(1.0).y > 5.0, true)
	process_frame.connect(_sahne_dene, CONNECT_ONE_SHOT)


func _sahne_dene() -> void:
	# 1. perde: ilk gece yalnız duman (ateş yok); geceler geçtikçe ateş büyür.
	var ilk := _manzara(0, 1, 0.0)
	var son := _manzara(6, 1, 0.0)
	_esit("ilk gece ateş yok", ilk.ates_sayisi(), 0)
	_esit("6. gece ateş var", son.ates_sayisi() > 0, true)
	# 2. perde: Tekfur yaklaştıkça kamp ateşi çoğalır.
	var uzak := _manzara(0, 2, 0.0)
	var yakin := _manzara(12, 2, 1.0)
	_esit("Tekfur yaklaştıkça ateş çoğalır", yakin.ates_sayisi() > uzak.ates_sayisi(), true)
	# Her sur seviyesi kurulur ve iki meşale yakar.
	for seviye in 4:
		var c := KapiCercevesi.new()
		c.seviye = seviye
		root.add_child(c)
		_esit("seviye %d meşale" % seviye, c.isiklar.size(), 2)
		c.free()
	for m in [ilk, son, uzak, yakin]:
		m.free()
	print("KAPI MANZARASI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _manzara(gece: int, perde: int, yakinlik: float) -> KapiManzarasi:
	var m := KapiManzarasi.new()
	m.gece = gece
	m.perde = perde
	m.yakinlik = yakinlik
	root.add_child(m)
	return m


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
