extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_snapshot.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 123)
		kayit = GuvenliKayit.new("user://test_admin_snapshot_save.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.yonetim.kabul({"ad": "Snapshot", "sinif": "ciftci"})
	ana.oturum.yonetim.sur_seviye = 2
	ana.oturum.yonetim.sur_hasar = 50
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	var p := admin.anlik_goruntu
	p.arac.slot = GuvenliKayit.new("user://test_admin_snapshot.json")
	p.arac.slot.sil()
	admin.ac(true)
	p.yenile()
	_kontrol(p.geri.disabled and not p.kaydet.disabled, "Eksik snapshot ile geri pasif, kararlı köyde al aktif")
	ana._ekran.sahne3b.hedef = Vector3(1, 0, 3)
	ana._ekran.sahne3b.yon = 63.0
	ana._ekran.sahne3b.uzaklik = 21.0
	var once := ana.oturum.kaydet()
	var normal := FileAccess.get_file_as_string(ana.kayit.yol)
	p.kaydet.pressed.emit()
	_kontrol(p.son_rapor["ok"] and not p.geri.disabled and normal == FileAccess.get_file_as_string(ana.kayit.yol), "Snapshot düğmesi ayrı slota yazar; normal dosya değişmez")
	ana.oturum.yonetim.akce += 700
	ana.oturum.yonetim.koylular[0].saglik = 12
	ana.oturum.yonetim.sur_hasar = 100
	ana.oturum.yonetim._rng.randi()
	ana._ekran._hiz_sec(2)
	p.geri.pressed.emit()
	_kontrol(p.son_rapor["ok"] and ana.oturum.kaydet() == once and Engine.time_scale == 1.0, "Gerçek düğme tüm model/RNG'yi geri alır; hız 1x")
	_kontrol(ana._ekran is KoyEkrani and ana._ekran.sahne3b.yonetim == ana.oturum.yonetim and ana._ekran.sahne3b.hedef == Vector3(1, 0, 3) and ana._ekran.sahne3b.yon == 63.0 and ana._ekran.sahne3b.uzaklik == 21.0, "Ekran canlı modele bağlı ve kamera geri yüklenir")
	_kontrol(Oturum.kayittan(ana.katalog, ana.kayit.oku()).kaydet() == once, "Normal güvenli slot da geri dönülen model")
	var eski := ana.oturum
	ana.kayit = GuvenliKayit.new("user://olmayan_snapshot_dizini/save.json")
	p.geri.pressed.emit()
	_kontrol(not p.son_rapor["ok"] and ana.oturum == eski, "Normal kayıt başarısızsa mevcut model korunur")
	ana.kayit = GuvenliKayit.new("user://test_admin_snapshot_save.json")
	ana._ekran._geceye_gec()
	p.yenile()
	var rapor_model := ana.oturum.kaydet()
	var nokta := FileAccess.get_file_as_string(p.arac.slot.yol)
	_kontrol(p.kaydet.disabled and p.geri.disabled, "Açık raporda iki düğme kilitli")
	p.kaydet.pressed.emit()
	p.geri.pressed.emit()
	_kontrol(not p.son_rapor["ok"] and ana.oturum.kaydet() == rapor_model and nokta == FileAccess.get_file_as_string(p.arac.slot.yol), "Doğrudan sinyal rapor kilidini aşamaz")
	ana._son_goster(&"halk_kirildi")
	p.yenile()
	_kontrol(not p.geri.disabled and not ana.kayit.var_mi(), "Son ekrandan snapshot dönüşü mümkün")
	p.geri.pressed.emit()
	_kontrol(p.son_rapor["ok"] and ana.oturum.kaydet() == once and ana.kayit.var_mi(), "Terminal ekrandan canlı köye dönülür")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm10_snapshot.png"))
	await _kapi_dene(ana, p)
	p.arac.slot.sil()
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN SNAPSHOT: GEÇTİ" if hata == 0 else "ADMIN SNAPSHOT: KALDI")
	await Ses.cik(hata)

func _kapi_dene(ana: Ana, p: AnlikGoruntuPaneli) -> void:
	for id in [&"chr_015", &"aydogdu"]:
		var e := KapiEkrani.new()
		e.oturum = ana.oturum
		e.ayarlar = ana.ayarlar
		ana._kapi = e
		ana._goster(e)
		var g := ana.oturum._adli_gelen(id)
		g.heybe = Heybe.new()
		g.heybe.ekle("test", "mal", 7, 3, true)
		g.heybe.astar_yokla()
		g.heybe.esyalar[0]["alinan"] = 2
		e._gelen = g
		e._kuyruk = [ana.oturum._adli_gelen(&"chr_030"), ana.oturum._adli_gelen(&"chr_002")]
		e._gece_gelen = 3
		ana.oturum.ziyaret_basladi(g)
		var s := g.chr_sorgusu() as ChrSorgusu
		if s != null:
			s.tansiyon = 5
			s._ipucu_servisi.kaydet(&"Clue_Test")
			s._denemeler["00:1"] = true
			s._rng.state = 723456789123456789
			e._sohbet_goster()
		else:
			e._sorulan = [0]
			e._karar_goster()
			e._karar_bas("ret")
		e._tumunu_goster()
		e._kayit.text = "[b]Korunan sorgu[/b]\nKanıt bulundu."
		var once := ana.oturum.kaydet()
		var kapi: Dictionary = JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.kaydet(e)))
		p.kaydet.pressed.emit()
		_kontrol(p.son_rapor["ok"], "Kararlı CHR/legacy kapı sorgusu düğmeyle kaydedilir")
		ana.oturum.muhafiz_akce += 12
		g.heybe.esyalar[0]["alinan"] = 0
		e._kuyruk.reverse()
		ana._koye_git()
		p.geri.pressed.emit()
		while p._calisiyor: await get_tree().process_frame
		_kontrol(p.son_rapor["ok"] and ana._ekran is KapiEkrani and ana.oturum.kaydet() == once, "Köyden aynı kapı sorgusuna dönüş; ziyaret/karar/gece/RNG yeniden çalışmaz")
		var geri: KapiEkrani = ana._ekran
		var sonuc: Dictionary = JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.kaydet(geri)))
		_kontrol(sonuc == kapi, "Tam kapı sözlüğü: kuyruk, soru, seçim, konuşma, heybe, CHR ve kamera eşleşir")
		_kontrol(geri.sahne._gelen != null and geri.sahne._kuyruk_adlari[0] == "chr_030", "Gelen ve bekleyen gerçek 3B modeller doğru sırada")
		_kontrol(geri._gelen.heybe.esyalar[0]["alinan"] == 2, "Heybe alınacak eşya geri yüklenir")
		if s != null:
			var yeni := geri._gelen.chr_sorgusu() as ChrSorgusu
			_kontrol(yeni != s and yeni.tansiyon == 5 and yeni.ipuclari.has(&"Clue_Test") and not yeni.replik_baslat(), "CHR restore izole; ipucu/tansiyon ve tekrar ses koruması")
		else:
			_kontrol(geri._secili == "ret" and geri._sorulan == [0], "Legacy sorular ve ilk karar onayı korunur")
		geri.evre = &"sonuc"
		_kontrol(not p.arac.yakala(ana)["ok"], "Karar yürüyüşü sırasında snapshot alınmaz")
		geri.evre = &"karar"
		await get_tree().process_frame
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
