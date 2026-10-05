## Kapı kuyruğu (design/gdd/kapi-manzarasi.md, kural 15). Düz betik:
##   godot --headless --path . -s tests/unit/kapi_kuyrugu/kapi_kuyrugu_test.gd   (çıkış 0 = geçti)
extends SceneTree

const ADLAR: Array[String] = ["ciftci", "esnaf", "ciftci_kadin", "asker", "ciftci", "esnaf", "asker", "ciftci_kadin"]

var _hata := 0


func _init() -> void:
	# Yerler kapıdan geriye sıralanır, aralık bir insan boyu kadar; ilk yer kapının önündeki durma yerinin gerisinde.
	var onceki := KapiSahnesi.DURMA
	for i in KapiSahnesi.KUYRUK_GORUNEN + 2:
		var y := KapiSahnesi.kuyruk_yeri(i)
		_esit("yer %d kapıdan geride" % i, y.z < onceki.z, true)
		if i > 0:
			var ara := Vector2(y.x, y.z).distance_to(Vector2(onceki.x, onceki.z))
			_esit("yer %d aralığı makul (%.2f m)" % [i, ara], ara > 0.8 and ara < 2.0, true)
		onceki = y
	process_frame.connect(_sahne_dene, CONNECT_ONE_SHOT)


func _sahne_dene() -> void:
	var s := KapiSahnesi.new()
	root.add_child(s)
	s.kuyruk_doldur(ADLAR)
	_esit("görünen ve bekleyen", s.kuyruk_sayilari(), Vector2i(KapiSahnesi.KUYRUK_GORUNEN, ADLAR.size() - KapiSahnesi.KUYRUK_GORUNEN))
	var bastaki: KarakterModel = s._kuyruktakiler[0]
	# Sıradaki kuyruğun başından gelir (yeni biri belirmez); kuyruk bir kişi kısalır, uzaktan biri katılır.
	await s.gelen_yaklas(ADLAR[0])
	_esit("gelen kuyruğun başındaki", s._gelen == bastaki, true)
	_esit("gelen kapının önünde", s._gelen.position.distance_to(KapiSahnesi.DURMA) < 0.05, true)
	_esit("biri uzaktan katıldı", s.kuyruk_sayilari(), Vector2i(KapiSahnesi.KUYRUK_GORUNEN, 1))
	# Dalga bittiğinde herkes kendi yerinde ve tam görünür.
	await create_timer(KapiSahnesi.KUYRUK_GORUNEN * KapiSahnesi.ILERLEME_GECIKMESI + 9.0).timeout
	for i in s._kuyruktakiler.size():
		var k: KarakterModel = s._kuyruktakiler[i]
		_esit("kişi %d yerinde" % i, k.position.distance_to(KapiSahnesi.kuyruk_yeri(i)) < 0.05, true)
		_esit("kişi %d görünür" % i, k._gorunurluk > 0.99, true)
	_esit("model adları sırayla", s._kuyruk_adlari, ADLAR.slice(1, 1 + KapiSahnesi.KUYRUK_GORUNEN))
	# Kuyruk gecenin listesiyle kaymışsa baştaki, gelecek kişinin modeliyle değiştirilir; kuyruk boyu bozulmaz.
	s.gelen_git(true)
	await s.gelen_yaklas("cocuk_yok")
	_esit("kayan kuyrukta da kuyruk kısalır", s.kuyruk_sayilari(), Vector2i(KapiSahnesi.KUYRUK_GORUNEN, 0))
	s.queue_free()
	await process_frame
	print("KAPI KUYRUGU TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
