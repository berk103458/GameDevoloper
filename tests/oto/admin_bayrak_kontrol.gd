extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_bayrak.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 45)
		kayit = GuvenliKayit.new("user://test_admin_bayrak.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var ekran := KapiEkrani.new()
	ekran.oturum = ana.oturum
	ekran.ayarlar = ana.ayarlar
	ana._kapi = ekran
	ana._goster(ekran)
	ekran._gelen = ana.oturum._adli_gelen(&"chr_001")
	ekran._sohbet_goster()
	var s := ekran._gelen.chr_sorgusu() as ChrSorgusu
	var kaynak := s.karakter.sorgu_bayraklari.duplicate()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.bayrak_paneli
	p.ac(true)
	var b: CheckBox = p.kontroller["Flag_Kimlik_Cozuldu"]
	b.button_pressed = true
	_kontrol(s.bayraklar["Flag_Kimlik_Cozuldu"] and s.karakter.sorgu_bayraklari == kaynak, "Gerçek CheckBox yalnız ziyaret flagini değiştirir")
	b = p.kontroller["Flag_Kimlik_Cozuldu"]
	b.button_pressed = false
	_kontrol(not s.bayraklar["Flag_Kimlik_Cozuldu"], "Aynı flag UI'da geri kapatılır")
	s.obje_incele(1)
	p.yenile()
	var clue: Label = p.liste.get_child(p.liste.get_child_count() - 1)
	_kontrol(clue.text.contains("Clue_CHR001_KavliCakmak"), "Gerçek keşif Clue listesine yansır")
	s.bayraklar["Flag_Kilitlendi"] = true
	p.yenile()
	_kontrol(p.kontroller["Flag_Kilitlendi"].disabled, "Kalıcı panik flagi denetçide salt okunur")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if DisplayServer.get_name() != "headless":
		var baslangic := Time.get_ticks_msec()
		while Time.get_ticks_msec() - baslangic < 1500:
			await get_tree().process_frame
		admin.performans._yenile(true)
		_kontrol(admin.performans.son_olcum["fps"] > 0, "Gerçek native sahnede FPS ölçümü yenilenir")
		print("NATIVE PERFORMANS: ", admin.performans.son_olcum)
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm06_bayrak.png"))
	ekran._gelen = ana.oturum._adli_gelen(&"chr_002")
	_kontrol(not BayrakDenetcisi.uygula(ana, s, "Flag_Kimlik_Cozuldu", true)["ok"], "Eski ziyaret callbacki yeni kişiyi etkilemez")
	p.yenile()
	_kontrol(not p.kontroller["Flag_Kimlik_Cozuldu"].button_pressed, "Yeni ziyaret ayrı flag durumu gösterir")
	admin.ac(false)
	_kontrol(not p.visible and not p.is_processing(), "Konsol kapanınca denetçi de uyur")
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN BAYRAK: GEÇTİ" if hata == 0 else "ADMIN BAYRAK: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
