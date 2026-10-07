extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_transfer.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_transfer_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.koy_akce = -12
	ana.oturum.muhafiz_akce = 20
	ana._koye_git()
	await get_tree().process_frame
	var ekran: KoyEkrani = ana._ekran
	ekran._pazar_ac()
	await get_tree().process_frame
	var kurtar := bul(ekran._ust_kart, "Açığı kurtar · 12")
	kontrol(kurtar != null and not kurtar.disabled, "Gerçek pazarda kurtarma düğmesi")
	if kurtar != null: kurtar.pressed.emit()
	await get_tree().process_frame
	kontrol(ana.oturum.koy_akce == 0 and ana.oturum.muhafiz_akce == 8 and ekran.hud._kese._miktar.text == "8 akçe", "Gerçek düğme iki kasayı ve HUD'u günceller")
	ana.oturum.koy_akce = 30
	ekran._pazar_ac()
	await get_tree().process_frame
	var zimmet := bul(ekran._ust_kart, "Zimmet · 5")
	kontrol(zimmet != null and zimmet.tooltip_text.contains("Adalet -5"), "Bedel işlem öncesi açıklanır")
	if zimmet != null: zimmet.pressed.emit()
	await get_tree().process_frame
	kontrol(ana.oturum.koy_akce == 25 and ana.oturum.muhafiz_akce == 13, "Zimmet para yaratmaz")
	zimmet = bul(ekran._ust_kart, "Zimmet · 5")
	kontrol(zimmet != null and zimmet.disabled, "Pazar yeniden açılınca aynı gün zimmet kilitli")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko14_transfer.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("KASA TRANSFERİ UI: GEÇTİ" if hata == 0 else "KASA TRANSFERİ UI: KALDI")
	await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func bul(n: Node, ad: String) -> Button:
	if n is Button and n.text == ad: return n
	for c in n.get_children():
		if c.is_queued_for_deletion(): continue
		var b := bul(c, ad)
		if b != null: return b
	return null
