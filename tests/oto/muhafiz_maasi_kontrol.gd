extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_payroll.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_payroll_ui.json")
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
	var kisla := _kur(y, "muhafiz_kislasi")
	var k := y.kabul({"ad": "Maaş bekleyen nöbetçi", "sinif": "asker", "stat": 5})
	k.moral = 50
	y.ata(k.id, kisla.id)
	var once := y.akce
	y.gece()
	_kontrol(y.akce == once - 1 and y.etkin_muhafiz_sayisi() == 1, "Gerçek gece bir kamu maaşı öder")
	y.akce = 0
	y.gece()
	_kontrol(y.muhafiz_sayisi() == 0 and y.maas_durumu[str(k.id)].borc == 1, "Gerçek ödenmeyen gece görev bırakma ve borç")
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	ekran._kategori = "savunma"
	ekran._secili_bina = kisla.id
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(_metin(ekran._bilgi_icerik).contains("borç: 1 akçe"), "Gerçek kışla bilgi paneli açık maaş borcunu gösterir")
	var kart_var := false
	for kart in ekran._yapi_satiri.get_children():
		if kart is YapiKarti and kart.tooltip_text.contains("Nöbetçileri barındırır"): kart_var = true
	_kontrol(kart_var, "Savunma sekmesinde gerçek kışla inşaat kartı")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko07_maas.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("MUHAFIZ MAAŞI UI: GEÇTİ" if hata == 0 else "MUHAFIZ MAAŞI UI: KALDI")
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
