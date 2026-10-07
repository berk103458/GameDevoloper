extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_bina.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 48)
		kayit = GuvenliKayit.new("user://test_admin_bina.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.kabul({"ad": "Test", "sinif": "ciftci"})
	var hucre := Vector2i(y.a.meydan.position.x + y.a.meydan.size.x / 2 + 1, y.a.meydan.end.y + 1)
	var d := y.bina_kur("cadir", hucre)
	_kontrol(d["olur"], "Gerçek inşaat oluşturulur")
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.bina_paneli
	_kontrol(not p.bitir.disabled and p.durum.text == "1 inşaat bekliyor", "Gerçek panel inşaatı gösterir")
	p.bitir.pressed.emit()
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(y.bina(d["id"]).hazir() and geri.yonetim.bina(d["id"]).hazir() and p.durum.text == "0 inşaat bekliyor", "Gerçek düğme model/kayıt/göstergeyi günceller")
	var once := JSON.stringify(ana.oturum.kaydet())
	p.bitir.pressed.emit()
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "İkinci tıklama modeli değiştirmez")
	p.secim.select(1)
	p.seviye.pressed.emit()
	geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(y.bina(d["id"]).seviye == 2 and y.yatak_kapasitesi() == 4 and geri.yonetim.bina(d["id"]).seviye == 2, "Gerçek normal bina seviye düğmesi yatak/kayıt/modeli günceller")
	p.secim.select(0)
	p.seviye.pressed.emit()
	_kontrol(y.sur_seviye == 1, "Sur özel seçimi normal bina kimliğiyle karışmaz")
	for i in [1, 0, 2]:
		p.sur_dugmeleri[i].pressed.emit()
		var hasar: int = [0, 50, 100][i]
		geri = Oturum.kayittan(ana.katalog, ana.kayit.oku())
		_kontrol(y.sur_hasar == hasar and geri.yonetim.sur_hasar == hasar, "Gerçek sur durum düğmesi ve kayıt")
		var parcalar: Array = ana._ekran.sahne3b.find_children("*", "Node3D", true, false).filter(func(n: Node) -> bool: return n.has_meta("sur_hasar") and not n.is_queued_for_deletion())
		_kontrol(not parcalar.is_empty(), "Gerçek sur görünümü oluşturuldu")
		for n: Node3D in parcalar:
			_kontrol(n.get_meta("sur_hasar") == hasar, "Gerçek 3B sur parçaları güncel hasarı gösterir")
	_kontrol(not y.bina(d["id"]).kaydet().has("hasar"), "Normal binaya hasar alanı yazılmaz")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm08_bina.png"))
	ana._ekran._geceye_gec()
	p.yenile()
	once = JSON.stringify(ana.oturum.kaydet())
	_kontrol(p.bitir.disabled, "Gece raporunda bina aracı kilitli")
	p.bitir.pressed.emit()
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Doğrudan sinyal gece kilidini aşmaz")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN BİNA: GEÇTİ" if hata == 0 else "ADMIN BİNA: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
