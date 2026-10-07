extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_purse.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_purse_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana._koye_git()
	await get_tree().process_frame
	var hud: Hud = ana._ekran.hud
	_kontrol(hud._kese._miktar.text == "0 akçe", "Boş kişisel kese ayrı görünür")
	var kamu := ana.oturum.koy_akce
	var gelen := Gelen.new()
	gelen.ad_anahtari = "test"
	gelen.heybe = Heybe.new()
	gelen.heybe.ekle("akce", "akce", 1, 3, false)
	gelen.heybe.ekle("gida", "gida", 2, 2, false)
	gelen.heybe.teklif = 3
	gelen.heybe.al(gelen.heybe.esyalar[0], 3)
	gelen.heybe.al(gelen.heybe.esyalar[1], 2)
	ana.oturum.karar_ver(gelen, &"rusvet")
	await get_tree().process_frame
	_kontrol(hud._kese._miktar.text == "3 akçe", "Gerçek rüşvet kararı sinyalle kişisel göstergede görünür")
	_kontrol(ana.oturum.koy_akce == kamu and hud._akce._miktar.text == str(kamu), "Kamu göstergesi kişisel rüşvetten değişmez")
	_kontrol(hud._kese.tooltip_text.contains("2 adet"), "Kişisel eşya miktarı kamu ambarından ayrı açıklanır")
	var once := JSON.stringify(ana.oturum.kaydet())
	for i in 3: hud.guncelle()
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Gösterge salt okunur; tekrar çizim para üretmez")
	var geri := Oturum.kayittan(ana.katalog, JSON.parse_string(once))
	hud._kese.guncelle(geri)
	_kontrol(hud._kese._miktar.text == "3 akçe", "Kayıttan dönen kişisel kese doğru görünür")
	ana.oturum.muhafiz_akce = 1234567
	hud.guncelle()
	await get_tree().create_timer(0.5).timeout
	_kontrol(hud._kese._miktar.size.x >= hud._kese._miktar.get_minimum_size().x, "Büyük bakiye kesilmeden yerleşir")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko11_kese.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("KESE GÖSTERGESİ UI: GEÇTİ" if hata == 0 else "KESE GÖSTERGESİ UI: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
