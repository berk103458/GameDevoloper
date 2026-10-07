extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_gizli.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_gizli.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.akce = 100
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	var b: KoyBinasi
	for cy in y.a.izgara_boyut.y:
		if b != null: break
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				b = y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				break
	var karar := ana.oturum.karar_ver(ana.oturum._adli_gelen(&"chr_004"), &"kabul")
	var k := y.koylu(karar["koylu_id"])
	k.stat = 5
	k.moral = 50
	y.ata(k.id, b.id)
	var zar := RandomNumberGenerator.new()
	for n in range(1, 10000):
		zar.seed = n
		if zar.randf() < 0.2 and zar.randf() >= 0.05:
			y._rng.seed = n
			break
	var rapor := y.gece()
	_kontrol(int(rapor["uretim"]["gida"]) == 2 and k.gizli_egilim["calinan"] == 3, "Gerçek gece çalışanın örtüsü ve erzak kaybı")
	_kontrol(GizliEgilimler.oyuncu_metin(k) == "Gizli eğilimler bilinmiyor", "Yakalanmamış kişi oyuncuya ifşa olmaz")
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	admin.koylu_paneli.ac(true)
	var satir := admin.koylu_paneli.tablo.get_root().get_first_child()
	var bilgi := satir.get_tooltip_text(8)
	_kontrol(bilgi.contains("DEBUG gizli eğilim: haydut") and bilgi.contains("çalınan 3"), "Canlı geliştirici kartı özel sayaçları açıkça debug olarak gösterir")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("uzm09_gizli.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("GİZLİ EĞİLİM UI: GEÇTİ" if hata == 0 else "GİZLİ EĞİLİM UI: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
