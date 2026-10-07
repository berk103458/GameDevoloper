extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_iron.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_iron_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["gida", "odun", "tas", "kereste", "alet", "harc"]: y.kaynaklar.ekle(t, 100)
	var maden := _kur(y, "demir_madeni")
	var ocak := _kur(y, "demir_ocagi")
	var demirci := _kur(y, "demirhane")
	for bina in [maden, ocak, demirci]:
		var k := y.kabul({"ad": "Ocak çalışanı", "sinif": "esnaf", "stat": 5})
		k.moral = 50
		y.ata(k.id, bina.id)
	var r := y.gece()
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	ekran._secili_bina = ocak.id
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(r.uretim.get("demir", 0) >= 2 and r.uretim.get("alet", 0) >= 1, "Gerçek UI modelinde demir ve alet üretimi")
	_kontrol(_metin(ekran._bilgi_icerik).contains("Demir · 2 cevher + 1 odun"), "Ocak girdileri oyuncuya görünür")
	y.kaynaklar.azalt("alet", 10000)
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(_metin(ekran._bilgi_icerik).contains("Alet yok · üretim −%70"), "Alet yokluğu bina bilgi panelinde açıklanır")
	for tur in ["cevher", "demir"]:
		_kontrol(ekran.hud._stok_etiketleri.has(tur), "Stok HUD'a bağlı: " + tur)
	var kaydir := ekran.hud._stok_etiketleri["demir"].get_parent().get_parent() as ScrollContainer
	if kaydir != null: kaydir.scroll_horizontal = 2000
	await get_tree().process_frame
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko06_demir.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("DEMİR ZİNCİRİ UI: GEÇTİ" if hata == 0 else "DEMİR ZİNCİRİ UI: KALDI")
	await Ses.cik(hata)
func _metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children():
		if not c.is_queued_for_deletion(): r += " " + _metin(c)
	return r
func _dugme(n: Node, ad: String) -> Button:
	if n is Button and n.text == ad: return n
	for c in n.get_children():
		if c.is_queued_for_deletion(): continue
		var b := _dugme(c, ad)
		if b != null: return b
	return null
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
