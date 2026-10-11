## BUG-20: gerçek karar düğmesi, gerçek yüklenmiş model, kabul ve gece/cenaze raporu.
extends Node
func _ready() -> void:
	get_tree().create_timer(100.0).timeout.connect(func() -> void: get_tree().quit(1))
	Engine.time_scale = 4.0
	var kat := Katalog.new()
	kat.yukle()
	var olay := load("res://data/sira_olaylari/sira_bayilma.tres") as OlayVerisi
	var eski: Dictionary = SiraOlayiSonucu.AYAR.agirliklar.duplicate()
	for tur in ["olum", "sakatlik", "ayrilma", "toparlanma", "yardim"]:
		SiraOlayiSonucu.AYAR.agirliklar = {tur:1.0} if tur != "yardim" else eski
		var e := KapiEkrani.new()
		e.oturum = Oturum.new(kat, 2120)
		e.ayarlar = Ayarlar.new()
		e.theme = Tema.olustur(e.ayarlar)
		e.oturum.ambar = 3 if tur == "yardim" else 0
		add_child(e)
		var adlar: Array[String] = ["ciftci", "esnaf", "ciftci_kadin", "asker"]
		for i in adlar.size():
			var g := Gelen.new()
			g.ad_anahtari = "Sıra tanığı %d" % i
			g.sinif = &"ciftci"
			e._kuyruk.append(g)
		e.sahne.kuyruk_doldur(adlar)
		var g := e._kuyruk[2]
		var model := e.sahne._kuyruktakiler[2]
		_sec.call_deferred(e, 0 if tur == "yardim" else 1, tur != "yardim")
		assert(not await e._sira_olayi(olay))
		assert(e._kayit.get_parsed_text().contains("bir kadın") and not e._kayit.get_parsed_text().contains("{kisi}"))
		if tur in ["olum", "ayrilma"]:
			assert(not g in e._kuyruk and not is_instance_valid(model))
			assert(e._kuyruk.size() == 3 and e.sahne._kuyruk_adlari.size() == 3)
			assert(e.oturum.karar_ver(g, &"kabul").get("engellendi", false))
		else:
			assert(g in e._kuyruk and model in e.sahne._kuyruktakiler and is_zero_approx(model.rotation.x))
			var kabul := e.oturum.karar_ver(g, &"kabul")
			var k := e.oturum.yonetim.koylu(int(kabul.koylu_id))
			assert(k.saglik == (int(SiraOlayiSonucu.AYAR.sakat_saglik) if tur == "sakatlik" else 100))
		if tur == "yardim": assert(e.oturum.ambar == 2)
		var rapor: Dictionary = e.oturum.gece_sonu().rapor
		var satir := 0
		for d in rapor.olaylar:
			if d.get("sira_sonuc", false): satir += 1
		assert(satir == 1)
		if tur == "olum": assert(rapor.cenaze.sayi == 1 and CenazeYasi.bekliyor(e.oturum.yonetim))
		e.queue_free()
		await get_tree().process_frame
	SiraOlayiSonucu.AYAR.agirliklar = eski
	Engine.time_scale = 1.0
	await Ses.sustur()
	print("SIRA SONUÇ UI: GEÇTİ")
	get_tree().quit(0)
func _sec(e: KapiEkrani, i: int, kaynaksiz: bool) -> void:
	while e._sira_satirlari.size() < 2 or not e._sira_satirlari[i].visible:
		await get_tree().process_frame
	assert(e._sira_satirlari[0].disabled == kaynaksiz)
	assert(not e._sira_satirlari[i].disabled)
	e._sira_satirlari[i].pressed.emit()
