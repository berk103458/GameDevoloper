extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_kart.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_kart.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(30.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var k := y.kabul({"ad":"Ali", "sinif":"ciftci"})
	y.gun = 24
	k.kis_hastaligi = {"bitis":27,"son_gece":24}
	k.bayrak_ekle(KisHastaligi.FLAG)
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	var once := JSON.stringify(ana.oturum.kaydet())
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	_kontrol(_metin(e._ust_kart).contains("Kış hastalığı: 3 gün") and _metin(e._ust_kart).contains("Şifahane boş kontenjanı 0") and not _metin(e._ust_kart).contains("koy.bayrak.kis_hastasi"), "Mevcut gerçek köylü kartı hasta/doluluk bilgisi")
	_kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Kart hastalık/gece/RNG ilerletmez")
	if not OS.get_environment("ADMIN_TEST_CIKTI").is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(OS.get_environment("ADMIN_TEST_CIKTI").path_join("mev13_hasta.png"))
	ana.queue_free()
	await get_tree().process_frame
	print("KIŞ HASTALIĞI UI: GEÇTİ" if hata == 0 else "KIŞ HASTALIĞI UI: KALDI")
	await Ses.cik(hata)
func _metin(n: Node) -> String:
	var sonuc: String = n.text + "\n" if n is Label else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
