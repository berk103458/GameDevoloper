## Gerçek model kuyruğu ve gerçek olay etkisi; kullanıcı kaydına yazmaz.
extends Node

const ADLAR := ["ciftci", "esnaf", "ciftci_kadin", "asker", "ciftci", "esnaf", "asker", "ciftci_kadin"]

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 17)
	var ekran := KapiEkrani.new()
	ekran.oturum = o
	var sahne := KapiSahnesi.new()
	add_child(sahne)
	ekran.sahne = sahne
	var adlar: Array[String] = []
	for ad in ADLAR:
		var g := Gelen.new()
		g.portre = ad
		g.sinif = StringName(ad)
		ekran._kuyruk.append(g)
		adlar.append(ekran._model_adi(g))
	sahne.kuyruk_doldur(adlar)
	# BUG-19: gerçek yüklenmiş kuyruk modelleri, metin ve canlandırma aynı nesneye bağlı.
	for anahtar in ["atlama", "bayilma", "kavga", "panik", "vazgecme"]:
		var i := SiraOlayiKisisi.indeks(anahtar, sahne._kuyruktakiler.size())
		var secilen := SiraOlayiKisisi.sec(sahne, anahtar)
		assert(secilen == sahne._kuyruktakiler[i])
		assert(secilen.get_meta("cinsiyet", "") == SiraOlayiKisisi.BILGI[sahne._kuyruk_adlari[i]])
		assert(not GuvenliMetin.metin(SiraOlayiKisisi.anahtar(secilen)).contains("KEY_NOT_FOUND"))

	var aday: Gelen = ekran._kuyruk[KapiSahnesi.KUYRUK_GORUNEN - 1]
	var model: KarakterModel = sahne._kuyruktakiler[KapiSahnesi.KUYRUK_GORUNEN - 1]
	var eski_sira := ekran._kuyruk.duplicate()
	var eski_adlar := sahne._kuyruk_adlari.duplicate()
	var adapt := preload("res://src/kapi/sira_atlama_adaptoru.gd")
	assert(not await adapt.uygula(ekran, "atlama", {"geri": true}))
	assert(ekran._kuyruk == eski_sira and sahne._kuyruk_adlari == eski_adlar)
	var kamu := o.koy_akce
	var kisisel := o.muhafiz_akce
	var olay := load("res://data/sira_olaylari/sira_atlama.tres") as OlayVerisi
	o.olay_uygula(olay, 1)
	assert(await adapt.uygula(ekran, "atlama", olay.secenek_etkileri[1]))
	assert(ekran._kuyruk[0] == aday and ekran._kuyruk.size() == ADLAR.size())
	assert(sahne._kuyruktakiler[0] == model and model.position.distance_to(KapiSahnesi.DURMA) < 0.05)
	assert(o.koy_akce == kamu and o.muhafiz_akce == kisisel + 2)
	for i in sahne._kuyruktakiler.size():
		assert(ekran._model_adi(ekran._kuyruk[i]) == sahne._kuyruk_adlari[i])
	# Aynı adlı figürler olsa da öne gelen gerçek nesne kapıda yeniden yaratılmaz.
	await sahne.gelen_yaklas(ekran._model_adi(aday))
	assert(sahne._gelen == model)
	ekran.free()
	sahne.queue_free()
	await get_tree().process_frame
	print("SIRA ATLAMA UI: GEÇTİ")
	get_tree().quit(0)
