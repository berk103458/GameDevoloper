## KAP-45: Kabul/ret kararına art arda basışta etki 1 kez yazılır; oturum_bitti bar kırılınca 1 kez yayılır; heybe açıkken kilitlidir.
extends Node

var _hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if kosul:
		return
	_hata += 1
	push_error("KAP-45 HATA: " + mesaj)


func _yeni_ekran(kat: Katalog, tohum: int) -> Dictionary:
	var o := Oturum.new(kat, tohum)
	o.gun = 3
	var ke := KapiEkrani.new()
	ke.oturum = o
	ke.ayarlar = Ayarlar.new("user://unused_kap45.cfg")
	ke.ayarlar.degerler[&"belirme_hizi"] = &"aninda"
	add_child(ke)
	return {"o": o, "ke": ke}


func _sablon_gelen(o: Oturum) -> Gelen:
	var g := o._figur_sablon()
	g.heybe = Heybe.new()
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.esikler = PackedInt32Array([0, 0])
	g.etkiler[&"kabul"] = PackedInt32Array([0, 2, 0, 0])
	g.etkiler[&"ret"] = PackedInt32Array([0, -2, 0, 0])
	return g


func _ready() -> void:
	get_tree().create_timer(25.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()

	# 1. Heybe açıkken karar düğmesi etki yazmaz.
	var c1 := _yeni_ekran(kat, 1945)
	var o1: Oturum = c1.o
	var ke1: KapiEkrani = c1.ke
	await get_tree().process_frame
	ke1._gelen = _sablon_gelen(o1)
	ke1._karar_goster()
	await get_tree().process_frame
	var adalet_bas := o1.yonetim.adalet
	ke1._heybe_ac()
	await get_tree().process_frame
	ke1._karar_dugmeleri[0].pressed.emit()
	ke1._karar_dugmeleri[0].pressed.emit()
	ke1._karar_ver("kabul")
	dene(o1.yonetim.adalet == adalet_bas and o1.yonetim.kabul_sayisi == 0, "Heybe acikken kabul dugmesi etki yazmaz")
	ke1._heybe_paneli._kapat.pressed.emit()
	await get_tree().process_frame

	# 2. Aynı karara art arda 4 tıklama + doğrudan ikinci _karar_ver: bar deltası tam 1 kez uygulanır.
	ke1._karar_dugmeleri[0].pressed.emit()
	ke1._karar_dugmeleri[0].pressed.emit()
	ke1._karar_dugmeleri[0].pressed.emit()
	ke1._karar_dugmeleri[0].pressed.emit()
	ke1._karar_ver("kabul")
	ke1._karar_bas("ret")
	ke1._karar_bas("ret")
	var tek_kabul_delta := 2 * Oturum.KOPRU_ADALET
	dene(o1.yonetim.adalet == adalet_bas + tek_kabul_delta, "Kabul art arda tikta bar deltasi 1 kez uygulanir (beklenen %d, gelen %d)" % [adalet_bas + tek_kabul_delta, o1.yonetim.adalet])
	dene(o1.yonetim.kabul_sayisi == 1 and o1.yonetim.nufus() == 1, "Kabul sayisi 1 kalir")
	ke1.queue_free()
	await get_tree().process_frame

	# 3. Ret kararına art arda tıklama ve doğrudan iki _karar_ver: bar deltası 1 kez uygulanır.
	var c2 := _yeni_ekran(kat, 1946)
	var o2: Oturum = c2.o
	var ke2: KapiEkrani = c2.ke
	await get_tree().process_frame
	ke2._gelen = _sablon_gelen(o2)
	ke2._karar_goster()
	await get_tree().process_frame
	var adalet_ret_bas := o2.yonetim.adalet
	ke2._karar_dugmeleri[1].pressed.emit()
	ke2._karar_dugmeleri[1].pressed.emit()
	ke2._karar_dugmeleri[1].pressed.emit()
	ke2._karar_ver("ret")
	var tek_ret_delta := -2 * Oturum.KOPRU_ADALET
	dene(o2.yonetim.adalet == adalet_ret_bas + tek_ret_delta, "Ret art arda tikta bar deltasi 1 kez uygulanir")

	# 4. Bar sıfıra inip kırılınca oturum_bitti tam 1 kez yayılır; ikinci kırılma ikinci sinyal üretmez.
	var bitti := {"sayisi": 0, "kirilan": -1}
	ke2.oturum_bitti.connect(func(k: int) -> void:
		bitti["sayisi"] += 1
		bitti["kirilan"] = k
	)
	var gecti1 := ke2._oturum_bitir(0)
	var gecti2 := ke2._oturum_bitir(2)
	dene(gecti1 and not gecti2, "Ikinci bar kirilmasi oturum_bitti tetiklemez")
	dene(int(bitti["sayisi"]) == 1 and int(bitti["kirilan"]) == 0, "oturum_bitti tam 1 kez yayilir (yayilan=%d)" % int(bitti["sayisi"]))

	ke2.queue_free()
	await get_tree().process_frame
	print("KARAR BIR KEZ: %s" % ("GEÇTİ" if _hata == 0 else "KALDI (%d hata)" % _hata))
	get_tree().quit(0 if _hata == 0 else 1)
