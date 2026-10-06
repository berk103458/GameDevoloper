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
				Ses.cik()
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
			await get_tree().create_timer(1.0).timeout
			var kart := koy._ust_kart
			if kart != null and is_instance_valid(kart) and not kart.is_queued_for_deletion():
				# Rapor, olay ya da olay sonucu kartı: seçeneklerden birine (mini oyunu da oyna).
				await _foto("04_kart")
				var secim := _dugmeler(kart)
				if not secim.is_empty():
					secim[rng.randi_range(0, secim.size() - 1)].pressed.emit()
					await get_tree().create_timer(0.3).timeout
					var foto := true
					while koy.mini_oyun != null:
						await get_tree().create_timer(rng.randf_range(0.3, 0.9)).timeout
						if foto and koy.mini_oyun != null:
							await _foto("04_mini_oyun")
							foto = false
						if koy.mini_oyun != null:
							koy.mini_oyun.bas()
				continue
			# Köy yönetimi: basit bir oyuncu gibi barınak ve üretim kurar, boştakileri atar, isyanda aş dağıtır.
			_koy_yonet(koy)
			await get_tree().create_timer(0.3).timeout
			await _foto("05_koy_perde%d" % ana.oturum.perde)
			var y := ana.oturum.yonetim
			print("gün ", y.gun, " nüfus=", y.nufus(), " akce=", y.akce, " gida=", y.kaynaklar.miktar("gida"), " odun=", y.kaynaklar.miktar("odun"),
				" yapı=", y.binalar.size(), " huzur=", y.huzur(), " husumet=", y.husumet.puan, " sur=", y.sur_seviye)
			if OS.get_environment("GECE_SINIRI") != "" and y.gun >= int(OS.get_environment("GECE_SINIRI")):
				print("GECE_SINIRI")
				Ses.cik()
				return
			koy._geceye_gec()
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
			elif k.evre == &"is":
				await _foto("03b_is_yeri")
				d[rng.randi_range(0, d.size() - 1)].pressed.emit()
			elif k.evre == &"sira":
				await _foto("03c_sira_olayi")
				d[rng.randi_range(0, d.size() - 1)].pressed.emit()
	print("ZAMAN ASIMI")
	Ses.cik()


## Basit köy stratejisi (tools/denge/koy_benzetimi.gd ile aynı fikir): yatak yetmezse çadır, nüfusa göre tarla,
## bir hızarhane; yol yoksa meydandan dışa yol; boştakileri yuvalara; isyanda aş; haracı ödeyebilirse öder.
func _koy_yonet(koy: KoyEkrani) -> void:
	var y := ana.oturum.yonetim
	var istek: Array[String] = []
	if y.yatak_kapasitesi() < y.nufus() + 2:
		istek.append("cadir")
	var say := {}
	for b in y.binalar:
		say[b.tur] = int(say.get(b.tur, 0)) + 1
	if int(say.get("tarla", 0)) * 3 < y.nufus() * 6 / 10 + 1:
		istek.append("tarla")
	if int(say.get("hizarhane", 0)) < 1:
		istek.append("hizarhane")
	if int(say.get("avci", 0)) < 1 and y.nufus() > 5:
		istek.append("avci")
	for t in istek:
		var kuruldu := false
		for yy in y.izgara.boyut.y:
			for xx in y.izgara.boyut.x:
				if not kuruldu and y.yerlesim(t, Vector2i(xx, yy))["olur"]:
					kuruldu = y.bina_kur(t, Vector2i(xx, yy))["olur"]
		if not kuruldu:
			var m := y.izgara.meydan
			var orta := m.position + m.size / 2
			for r in range(1, 12):
				for d in [Vector2i(r, 0), Vector2i(-r, 0), Vector2i(0, -r)]:
					for kol in [-4, 0, 4]:
						y.yol_kur(orta + d + (Vector2i(0, kol) if d.y == 0 else Vector2i(kol, 0)))
	for k in y.bostakiler():
		for tur in ["tarla", "avci", "hizarhane"]:
			var atandi := false
			for b in y.binalar:
				if not atandi and b.tur == tur and y.ata(k.id, b.id):
					atandi = true
			if atandi:
				break
	if y.isyan_kalan >= 0:
		y.as_dagit()
	if y.harac_bekliyor and not y.harac_ode():
		y.harac_reddet()
	if y.kaynaklar.miktar("odun") > 40:
		y.tezgah_sat("odun", 20)
	koy._yenile()

