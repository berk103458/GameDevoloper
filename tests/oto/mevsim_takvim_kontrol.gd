extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_flock.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_flock_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(30.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	var y := ana.oturum.yonetim
	var adet := e.hud.get_child_count()
	for gun in [0, 6, 7, 14, 21, 27, 28, 55]:
		y.gun = gun
		var once := JSON.stringify(ana.oturum.kaydet())
		e.hud.guncelle()
		var d := MevsimYoneticisi.durum(y)
		kontrol(e.hud._mevsim.text == MevsimTakvim.metin(y) and e.hud._mevsim.text.contains("%d. yıl · %d/28" % [d.yil, d.yil_gunu]), "Gerçek mevsim/yıl günü sınırı")
		kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "HUD kayıt/gün/RNG değiştirmez")
	y.gun = 28
	for hava in IklimDeneyi.HAVALAR:
		IklimDeneyi.degistir(ana.oturum, 3, hava)
		e.hud.guncelle()
		kontrol(e.hud._mevsim.text.contains(MevsimTakvim.HAVALAR[hava]), "Gerçek hava önayarı")
	kontrol(e.hud._mevsim.tooltip_text.contains("takvim ilerlemedi"), "Admin mevsimi gerçek tarihten ayrılır")
	var geri := Oturum.kayittan(ana.katalog, JSON.parse_string(JSON.stringify(ana.oturum.kaydet())))
	kontrol(MevsimTakvim.metin(geri.yonetim) == e.hud._mevsim.text, "Restore HUD eşitliği")
	for i in 5: e.hud.guncelle()
	await get_tree().process_frame
	kontrol(e.hud.get_child_count() == adet and e.hud._mevsim.get_global_rect().end.x <= get_viewport().get_visible_rect().end.x + 1, "Tek HUD, takvim sağ sınırda")
	kontrol(e.hud._mevsim.get_global_rect().end.y <= e.hud.get_global_rect().end.y + 1, "Takvim HUD içinde kalır")
	if not OS.get_environment("ADMIN_TEST_CIKTI").is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(OS.get_environment("ADMIN_TEST_CIKTI").path_join("mev12_takvim.png"))
	ana.queue_free()
	await get_tree().process_frame
	print("MEVSİM TAKVİM UI: GEÇTİ" if hata == 0 else "MEVSİM TAKVİM UI: KALDI")
	await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
