## Gerçek model kuyruğu ve gerçek olay etkisi; kullanıcı kaydına yazmaz.
extends Node

var _hata := 0

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
	await _cizgi_sirasini_dene(sahne)
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
		_dene(secilen == sahne._kuyruktakiler[i], "sira_atlama_kontrol.gd:28")
		_dene(secilen.get_meta("cinsiyet", "") == SiraOlayiKisisi.BILGI[sahne._kuyruk_adlari[i]], "sira_atlama_kontrol.gd:29")
		_dene(not GuvenliMetin.metin(SiraOlayiKisisi.anahtar(secilen)).contains("KEY_NOT_FOUND"), "sira_atlama_kontrol.gd:30")

	var aday: Gelen = ekran._kuyruk[KapiSahnesi.KUYRUK_GORUNEN - 1]
	var model: KarakterModel = sahne._kuyruktakiler[KapiSahnesi.KUYRUK_GORUNEN - 1]
	var eski_sira := ekran._kuyruk.duplicate()
	var eski_adlar := sahne._kuyruk_adlari.duplicate()
	var adapt := preload("res://src/kapi/sira_atlama_adaptoru.gd")
	_dene(not await adapt.uygula(ekran, "atlama", {"geri": true}), "sira_atlama_kontrol.gd:37")
	_dene(ekran._kuyruk == eski_sira and sahne._kuyruk_adlari == eski_adlar, "sira_atlama_kontrol.gd:38")
	var kamu := o.koy_akce
	var kisisel := o.muhafiz_akce
	var olay := load("res://data/sira_olaylari/sira_atlama.tres") as OlayVerisi
	o.olay_uygula(olay, 1)
	_dene(await adapt.uygula(ekran, "atlama", olay.secenek_etkileri[1]), "sira_atlama_kontrol.gd:43")
	_dene(ekran._kuyruk[0] == aday and ekran._kuyruk.size() == ADLAR.size(), "sira_atlama_kontrol.gd:44")
	_dene(sahne._kuyruktakiler[0] == model and model.position.distance_to(KapiSahnesi.DURMA) < 0.05, "sira_atlama_kontrol.gd:45")
	_dene(o.koy_akce == kamu and o.muhafiz_akce == kisisel + 2, "sira_atlama_kontrol.gd:46")
	for i in sahne._kuyruktakiler.size():
		_dene(ekran._model_adi(ekran._kuyruk[i]) == sahne._kuyruk_adlari[i], "sira_atlama_kontrol.gd:48")
	# Aynı adlı figürler olsa da öne gelen gerçek nesne kapıda yeniden yaratılmaz.
	await sahne.gelen_yaklas(ekran._model_adi(aday))
	_dene(sahne._gelen == model, "sira_atlama_kontrol.gd:51")
	ekran.free()
	sahne.queue_free()
	await get_tree().process_frame
	print("SIRA ATLAMA UI: GEÇTİ" if _hata == 0 else "SIRA ATLAMA UI: KALDI (%d hata)" % _hata)
	get_tree().quit(1 if _hata > 0 else 0)


func _cizgi_sirasini_dene(sahne: KapiSahnesi) -> void:
	sahne.kuyruk_doldur(ADLAR.slice(0, 4))
	var ilk := sahne._kuyruktakiler.duplicate()
	_dene(ilk.size() == 4, "SAH-35: Dört gerçek kuyruk modeli")
	if ilk.size() != 4:
		return
	var head: KarakterModel = ilk.pop_front()
	sahne.gelen_yaklas(sahne._kuyruk_adlari[0])
	var ters_sira := 0
	var sure := 0.0
	while sure < 4.0:
		await get_tree().process_frame
		sure += get_process_delta_time()
		for i in range(1, ilk.size()):
			if ilk[i - 1].position.z <= ilk[i].position.z:
				ters_sira += 1
	_dene(sahne._gelen == head and sahne._kuyruktakiler == ilk, "SAH-35: Baştaki ilerlerken diğer üç modelin sırası korunur")
	_dene(ters_sira == 0, "SAH-35: Yürüyüş karelerinde sıra tersine dönmez")
	for i in ilk.size():
		_dene(ilk[i].position.distance_to(KapiSahnesi.kuyruk_yeri(i)) < 0.03, "SAH-35: Kişi mevcut çizgide kendi yerine varır")
	print("SAH-35 kişi=4, sıra değişimi=%d" % ters_sira)


func _dene(kosul: bool, ad: String) -> void:
	if not kosul:
		_hata += 1
		push_error(ad)
