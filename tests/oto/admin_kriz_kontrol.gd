extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_kriz.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 88)
		kayit = GuvenliKayit.new("user://test_admin_kriz.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var k := ana.oturum.yonetim.kabul({"ad": "Test", "sinif": "ciftci"})
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.kriz_paneli
	_kontrol(not p.visible and not p.is_processing(), "Kapali kriz paneli islemez")
	p.ac(true)
	var gun := ana.oturum.gun
	var rng := ana.oturum.yonetim._rng.state
	p.dugmeler[0].pressed.emit()
	_kontrol(p.son_rapor["ok"] and k.saglik == 60 and k.bayrak_var("hasta"), "Veba dugmesi gercek saglik/bayrak uygular")
	p.dugmeler[1].pressed.emit()
	_kontrol(p.son_rapor["ok"] and p.dugmeler[1].disabled and KrizEnjektoru.kalan(ana.oturum.yonetim) == 3, "Kuyu dugmesi zehri kurar, tekrari engeller")
	var once := ana.oturum.yonetim.kaynaklar.toplam()
	p.dugmeler[2].pressed.emit()
	_kontrol(p.son_rapor["ok"] and ana.oturum.yonetim.kaynaklar.toplam() < once and ana.oturum.gun == gun and ana.oturum.yonetim._rng.state == rng, "Kundak dugmesi stok yakar, gun/RNG ilerletmez")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri.yonetim.koylular[0].saglik == 60 and KrizEnjektoru.kalan(geri.yonetim) == 3 and geri.yonetim.kaynaklar.kaydet() == ana.oturum.yonetim.kaynaklar.kaydet(), "Guvenli kayit uc etkiyi korur")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm14_kriz.png"))
	var model := ana.oturum.kaydet()
	var kart := PanelContainer.new()
	ana._ekran.add_child(kart)
	ana._ekran._ust_kart = kart
	p.yenile()
	_kontrol(p.dugmeler[0].disabled and not KrizEnjektoru.uygula(ana, "veba")["ok"] and ana.oturum.kaydet() == model, "Acik raporda enjeksiyon engellenir")
	ana._ekran._ust_kart = null
	kart.queue_free()
	admin.ac(false)
	_kontrol(not p.visible and not p.is_processing() and not get_tree().paused, "Konsolla panel kapanir; oyun durmaz")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN KRIZ: GEÇTİ" if hata == 0 else "ADMIN KRIZ: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
