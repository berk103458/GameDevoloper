extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_kasa.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 88)
		kayit = GuvenliKayit.new("user://test_admin_kasa.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.yonetim.kabul({"ad": "Test", "sinif": "ciftci"})
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.kasa_paneli
	_kontrol(not p.visible and not p.is_processing(), "Kapalı kasa denetçisi işlemez")
	p.ac(true)
	var gun := ana.oturum.gun
	for islem in ["koy_akce", "muhafiz_akce", "kese_ekle"]:
		p.girdiler[islem].get_line_edit().text = "27"
		p.dugmeler[islem].pressed.emit()
		_kontrol(p.son_rapor["ok"] and p.son_rapor["kaydedildi"], "Gerçek SpinBox ve düğme güvenli slota yazar")
	_kontrol(ana.oturum.koy_akce == 27 and ana.oturum.muhafiz_akce == 54, "İki bakiye ayrı; ekleme kişisel kesede")
	p.girdiler["koy_akce"].value = 91
	p.yenile()
	_kontrol(p.girdiler["koy_akce"].value == 91, "Canlı yenileme yazılmakta olan bakiye girdisini ezmez")
	var r := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(r.koy_akce == 27 and r.muhafiz_akce == 54 and r.gun == gun, "Güvenli kayıt bakiyeleri/günü korur")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm11_kasa.png"))
	ana.oturum.muhafiz_esyalari.append({"kaynak": "test", "adet": 3})
	p.dugmeler["kese_sifirla"].pressed.emit()
	_kontrol(ana.oturum.muhafiz_akce == 0 and ana.oturum.muhafiz_esyalari.is_empty() and ana.oturum.koy_akce == 27, "Gerçek sıfırlama kişisel kese ve eşyaları temizler")
	ana._ekran._geceye_gec()
	p.yenile()
	var once := ana.oturum.kaydet()
	_kontrol(p.dugmeler["koy_akce"].disabled, "Gece raporunda kontrol kilitli")
	p.dugmeler["koy_akce"].pressed.emit()
	_kontrol(not p.son_rapor["ok"] and ana.oturum.kaydet() == once, "Doğrudan sinyal rapor kilidini aşmaz")
	# Kapı fazında aynı gerçek API, aktif sorguya dokunmadan çalışır.
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._goster(e)
	e._gelen = ana.oturum._adli_gelen(&"chr_001")
	e._kuyruk = [ana.oturum._adli_gelen(&"chr_002")]
	e.evre = &"karar"
	var g := e._gelen
	p.girdiler["muhafiz_akce"].value = 13
	p.girdiler["muhafiz_akce"].get_line_edit().text = "13"
	p.dugmeler["muhafiz_akce"].pressed.emit()
	_kontrol(p.son_rapor["ok"] and ana.oturum.muhafiz_akce == 13 and e._gelen == g and e._kuyruk.size() == 1, "Kapıda kasa düzenlemesi aktif ziyaret ve sırayı korur")
	admin.ac(false)
	_kontrol(not p.visible and not p.is_processing() and not get_tree().paused, "Konsolu kapatınca kasa paneli kapanır ve işlemez")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN KASA: GEÇTİ" if hata == 0 else "ADMIN KASA: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
