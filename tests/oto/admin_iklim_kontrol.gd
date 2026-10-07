extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_admin_iklim.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 98)
		kayit = GuvenliKayit.new("user://test_admin_iklim.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	for i in 2: ana.oturum.yonetim.kabul({"ad": "Test", "sinif": "ciftci"})
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.iklim_paneli
	_kontrol(not p.visible and not p.is_processing(), "Kapalı iklim paneli işlemez")
	p.ac(true)
	p.mevsim.select(4)
	p.hava.select(1)
	var gun := ana.oturum.gun
	var rng := ana.oturum.yonetim._rng.state
	p.uygula.pressed.emit()
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	_kontrol(p.son_rapor["ok"] and ana.oturum.yonetim.kis_mi() and ana.oturum.gun == gun and ana.oturum.yonetim._rng.state == rng, "Gerçek mevsim/hava düğmesi gün/RNG ilerletmez")
	_kontrol(is_equal_approx(float(s.arazi._zemin_mat.get_shader_parameter("kar_ortusu")), 0.85) and s.get_node("DebugKarYagisi").visible and is_equal_approx(s.atmosfer.cevre.fog_density, 0.014), "Gerçek arazi shader/yağış/sis fırtınaya bağlanır")
	var geri := Oturum.kayittan(ana.katalog, ana.kayit.oku())
	_kontrol(geri.yonetim.mevsim() == 3 and IklimDeneyi.hava(geri.yonetim) == "kar_firtinasi", "Düğme gerçek güvenli slota iklimi kaydeder")
	ana.ayarlar.ayarla(&"grafik_profili", &"dusuk")
	await get_tree().process_frame
	_kontrol(s.get_node("DebugKarYagisi").layers == 0, "Düşük profilde dekoratif kar çizilmez")
	ana.ayarlar.ayarla(&"grafik_profili", &"normal")
	await get_tree().process_frame
	_kontrol(s.get_node("DebugKarYagisi").layers != 0, "Normal profile dönüşte kar yeniden çizilir")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.7).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("adm12_kar.png"))
	p.mevsim.select(2)
	p.hava.select(2)
	p.uygula.pressed.emit()
	_kontrol(is_equal_approx(float(s.arazi._zemin_mat.get_shader_parameter("kuruluk")), 1.0) and not s.get_node("DebugKarYagisi").visible and IklimDeneyi.gida_carpani(ana.oturum.yonetim) == 1.5, "Kuraklık gerçek shader ve tüketim çarpanı")
	p.sifirla.pressed.emit()
	_kontrol(IklimDeneyi.ayar(ana.oturum.yonetim).is_empty() and is_zero_approx(float(s.arazi._zemin_mat.get_shader_parameter("kar_ortusu"))) and is_equal_approx(float(s.arazi._zemin_mat.get_shader_parameter("kuruluk")), s.KURULUK[0]), "Reset doğal mevsim shaderına ve normal çarpanlara döner")
	ana._ekran._geceye_gec()
	p.yenile()
	var once := ana.oturum.kaydet()
	p.uygula.pressed.emit()
	_kontrol(p.uygula.disabled and not p.son_rapor["ok"] and ana.oturum.kaydet() == once, "Rapor açıkken doğrudan sinyal iklimi değiştirmez")
	admin.ac(false)
	_kontrol(not p.visible and not p.is_processing(), "Konsolla panel kapanır ve işlemez")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ADMIN İKLİM: GEÇTİ" if hata == 0 else "ADMIN İKLİM: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
