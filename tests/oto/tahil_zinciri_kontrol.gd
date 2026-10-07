extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_grain.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_grain_ui.json")
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
	for t in ["gida", "odun", "tas", "kereste", "alet"]: y.kaynaklar.ekle(t, 100)
	var tarla := _kur(y, "tarla")
	var degirmen := _kur(y, "degirmen")
	var firin := _kur(y, "firin")
	var i := 0
	for b in [tarla, degirmen, firin]:
		var k := y.kabul({"ad": "Zincir çalışanı", "sinif": ["ciftci", "degirmenci", "firinci"][i], "stat": 5})
		k.moral = 50
		y.ata(k.id, b.id)
		i += 1
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	for pair in [[tarla, "Buğday hasadı"], [degirmen, "Un · 2 buğday"]]:
		ekran._secili_bina = pair[0].id
		ekran._bilgi_goster()
		var d := _dugme(ekran._bilgi_icerik, pair[1])
		_kontrol(d != null, "Gerçek UI tarifi görünür: " + pair[1])
		if d != null: d.pressed.emit()
		await get_tree().process_frame
	_kontrol(tarla.recete == "bugday" and degirmen.recete == "un", "Bağlı gerçek düğmeler tahıl tariflerini seçer")
	var r := y.gece()
	ekran._secili_bina = firin.id
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(r.uretim.get("gida", 0) >= 4 and _metin(ekran._bilgi_icerik).contains("Ekmek · 2 un + 1 odun"), "Fırın un maliyetiyle ekmek üretir")
	for tur in ["bugday", "un"]:
		_kontrol(ekran.hud._stok_etiketleri.has(tur), "Yeni stok HUD'a bağlı: " + tur)
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko04_tahil.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("TAHIL ZİNCİRİ UI: GEÇTİ" if hata == 0 else "TAHIL ZİNCİRİ UI: KALDI")
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
