extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_ambar.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_ambar_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana._koye_git()
	await get_tree().process_frame
	var y: KoyYonetimi = ana.oturum.yonetim
	y.kaynaklar = Kaynaklar.new(150, {"gida": 100, "tas": 20})
	ana.oturum.muhafiz_akce = 37
	var kamu := y.akce
	var r := y.gece()
	kontrol(r.ziyan.bozulma.get("gida", 0) == 2, "Gerçek gecede kalan gıdanın %2'si bozulur")
	kontrol(ana.oturum.muhafiz_akce == 37 and y.akce == kamu, "Ziyan kasalara yazmaz")
	kontrol(r.olaylar.any(func(e: Dictionary) -> bool: return IflasYoneticisi.olay_metin(e).contains("bozulması")), "Gerçek raporda ziyan metni")
	var hud: Hud = ana._ekran.hud
	hud.guncelle()
	kontrol(hud._ambar_bar.tooltip_text.contains("%2"), "Mevcut ambar ipucu bozulma oranını açıklar")
	var once := JSON.stringify(ana.oturum.kaydet())
	hud.guncelle()
	kontrol(once == JSON.stringify(ana.oturum.kaydet()), "HUD stok değiştirmez")
	var geri := Oturum.kayittan(ana.katalog, JSON.parse_string(once))
	kontrol(y.gece() == geri.yonetim.gece(), "Restore sonraki gerçek geceyi aynı üretir")
	hud.guncelle()
	await get_tree().create_timer(0.5).timeout
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko12_ambar.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("AMBAR UI: GEÇTİ" if hata == 0 else "AMBAR UI: KALDI")
	await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
