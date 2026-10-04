## Duman testi: oyunu baştan sona otomatik oynar, her ekranın ilk görünüşünde ekran görüntüsü alır.
## Çalıştırma: godot --path . tests/oto/otomatik_oyuncu.tscn  (ortam: TOHUM, KLASOR, KABUL_ORANI)
extends Node

var ana: Ana
var rng := RandomNumberGenerator.new()
var _cekilen := {}
var _klasor := "user://oto"
var _kabul_orani := 0.75


func _ready() -> void:
	var t := OS.get_environment("TOHUM")
	rng.seed = int(t) if t != "" else 11
	if OS.get_environment("KLASOR") != "":
		_klasor = OS.get_environment("KLASOR")
	if OS.get_environment("KABUL_ORANI") != "":
		_kabul_orani = float(OS.get_environment("KABUL_ORANI"))
	DirAccess.make_dir_recursive_absolute(_klasor)
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://kayit.json"))
	ana = load("res://src/arayuz/ana.tscn").instantiate()
	get_tree().root.add_child.call_deferred(ana)
	_dongu()


func _foto(ad: String) -> void:
	if _cekilen.has(ad) or DisplayServer.get_name() == "headless":
		_cekilen[ad] = true
		return
	_cekilen[ad] = true
	await get_tree().create_timer(1.2).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png("%s/%s.png" % [_klasor, ad])


func _dugmeler(kok: Node) -> Array[Button]:
	var sonuc: Array[Button] = []
	for c in kok.find_children("*", "Button", true, false):
		var b := c as Button
		if b.is_visible_in_tree() and not b.disabled and not b.is_queued_for_deletion():
			sonuc.append(b)
	return sonuc


func _dongu() -> void:
	await get_tree().create_timer(1.0).timeout
	var menu_gecildi := false
	for adim in 4000:
		await get_tree().create_timer(0.12).timeout
		var ekran: Control = ana._ust if ana._ust != null else ana._ekran
		if ekran == null:
			continue
		if ekran is BilgiEkrani:
			var e := ekran as BilgiEkrani
			if not menu_gecildi:
				await _foto("01_menu")
				if not _cekilen.has("ayarlar_denendi"):
					_cekilen["ayarlar_denendi"] = true
					e.secildi.emit(2)
					continue
				menu_gecildi = true
				e.secildi.emit(0)
			elif e.sayi >= 0:
				await _foto("09_son")
				print("SON: ", e.baslik, " gun=", e.sayi, " perde=", ana.oturum.perde, " koy=", ana.oturum.koy.toplam(), " barlar=", ana.oturum.barlar.degerler)
				get_tree().quit()
				return
			else:
				await _foto("07_perde_gecisi")
				e.secildi.emit(0)
		elif ekran is AyarlarEkrani:
			var a := ekran as AyarlarEkrani
			for satir in AyarlarEkrani.SATIRLAR:
				a._degistir(satir[0], 1)
			a._degistir(&"metin_olcegi", 1)
			await _foto("00_ayarlar")
			a.ayarlar.varsayilana_don()
			a._kapat()
		elif ekran is KoyEkrani:
			var koy := ekran as KoyEkrani
			await get_tree().create_timer(2.5).timeout
			if koy._kart != null and is_instance_valid(koy._kart) and not koy._kart.is_queued_for_deletion():
				await _foto("04_olay")
				var secim := _dugmeler(koy._kart)
				if not secim.is_empty():
					secim[rng.randi_range(0, secim.size() - 1)].pressed.emit()
					await get_tree().create_timer(0.3).timeout
					var tamam := _dugmeler(koy._kart)
					if not tamam.is_empty():
						await _foto("04_olay_sonuc")
						tamam[0].pressed.emit()
				continue
			for y in _dugmeler(koy._yapi_kutusu):
				y.pressed.emit()
				await get_tree().create_timer(0.2).timeout
			await _foto("05_koy_perde%d" % ana.oturum.perde)
			print("gece ", ana.oturum.gun, " akce=", ana.oturum.akce, " ambar=", ana.oturum.ambar, " yapilar=", ana.oturum.yapilar, " bayraklar=", ana.oturum.bayraklar.keys())
			koy.devam_istendi.emit()
		elif ekran is KapiEkrani:
			var k := ekran as KapiEkrani
			var d := _dugmeler(k._secenekler)
			if d.is_empty():
				continue
			if k.evre == &"sohbet":
				await _foto("02_sohbet_perde%d" % ana.oturum.perde)
				d[rng.randi_range(0, d.size() - 1)].pressed.emit()
			elif k.evre == &"karar":
				var secenekler := k._karar_anahtarlari
				var anahtar := "kabul" if rng.randf() < _kabul_orani else secenekler[rng.randi_range(0, secenekler.size() - 1)]
				if not anahtar in secenekler:
					anahtar = secenekler[0]
				k._karar_bas(anahtar)
				await _foto("03_karar_secili_perde%d" % ana.oturum.perde)
				k._karar_bas(anahtar)
	print("ZAMAN ASIMI")
	get_tree().quit()
