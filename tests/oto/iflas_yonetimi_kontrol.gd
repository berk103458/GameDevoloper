extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_insolvency.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_insolvency_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.akce = 100
	var bina := _kur(y)
	_kontrol(bina != null, "El koyma için gerçek kamu tarlası kurulur")
	var k := y.kabul({"ad": "Kamu çiftçisi", "stat": 5})
	if bina != null: y.ata(k.id, bina.id)
	ana.oturum.muhafiz_akce = 77
	ana.oturum.koy_akce = -10
	for i in 2: y.gece()
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	_kontrol(ekran.hud._akce.tooltip_text.contains("eksi geceler: 2/3"), "Gerçek HUD kamu açığı sayacını açıklar")
	ekran._geceye_gec()
	await get_tree().process_frame
	_kontrol(y.binalar.is_empty() and k.is_yeri == KoyYonetimi.BOSTA and ana.oturum.muhafiz_akce == 77, "Gerçek gece düğmesi kamu varlığına el koyar, kişisel keseyi korur")
	_kontrol(_metin(ekran).contains("Tefeci baskını: 3 gece kamu açığı") and not _metin(ekran).contains("koy.olay.iflas"), "Gerçek rapor CSV kilidinde okunur tefeci olayını gösterir")
	await get_tree().create_timer(0.6).timeout
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko10_iflas.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("İFLAS YÖNETİMİ UI: GEÇTİ" if hata == 0 else "İFLAS YÖNETİMİ UI: KALDI")
	await Ses.cik(hata)
func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children():
		if not c.is_queued_for_deletion(): r += " " + _metin(c)
	return r
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var b := y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				return b
	return null
