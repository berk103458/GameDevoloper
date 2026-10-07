extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_consumption.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_consumption_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	for i in 3: y.kabul({"ad": "Soğukta köylü %d" % i})
	IklimDeneyi.degistir(ana.oturum, 3, "normal")
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	var odun: KaynakGostergesi = ekran.hud._stok_etiketleri["odun"]
	var gida: KaynakGostergesi = ekran.hud._stok_etiketleri["gida"]
	_kontrol(odun.tooltip_text.contains("Gecelik ihtiyaç: 3 (nüfus: 3)") and gida.tooltip_text.contains("Gecelik ihtiyaç: 3"), "Gerçek HUD ihtiyaçları nüfus ve iklimden alır")
	var r := y.gece()
	_kontrol(r.tuketim.gida == 3 and r.tuketim.odun == 3, "Gerçek gece HUD ihtiyacıyla aynı kaynakları tüketir")
	ekran._yenile()
	await get_tree().process_frame
	var once := y.kaydet()
	var e := InputEventMouseMotion.new()
	e.position = get_viewport().get_final_transform() * (odun.global_position + odun.size / 2.0)
	e.global_position = e.position
	e.window_id = get_window().get_window_id()
	Input.parse_input_event(e)
	await get_tree().create_timer(1.2).timeout
	_kontrol(y.kaydet() == once, "Gerçek HUD ihtiyaç gözlemi modeli değiştirmez")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko09_tuketim.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("TÜKETİM DENGESİ UI: GEÇTİ" if hata == 0 else "TÜKETİM DENGESİ UI: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
