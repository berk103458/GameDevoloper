extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_wood.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_wood_ui.json")
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
	var kamp := _kur(y, "odunluk")
	var hizar := _kur(y, "hizarhane")
	for b in [kamp, hizar]:
		var k := y.kabul({"ad": "Oduncu", "sinif": "oduncu", "stat": 5})
		k.moral = 50
		y.ata(k.id, b.id)
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	ekran._kategori = "uretim"
	ekran._yapi_satirini_ciz()
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(_metin(ekran._yapi_satiri).contains("Orman Kampı"), "İnşaat listesinde kaynak anahtarı yerine Orman Kampı okunur")
	var etiketler: KaynakGostergesi = ekran.hud._stok_etiketleri.get("tomruk")
	_kontrol(etiketler != null and _metin(etiketler).contains("Tomruk"), "HUD tomruk adı ve stok göstergesi içerir")
	ekran._secili_bina = hizar.id
	ekran._bilgi_goster()
	var tarif := _dugme(ekran._bilgi_icerik, "Kalas · 2 tomruk")
	_kontrol(tarif != null, "Hızar tarif seçimi tomruk maliyetini gösterir")
	if tarif != null: tarif.pressed.emit()
	_kontrol(hizar.recete == "kereste", "Gerçek UI düğmesinin bağlı sinyali kalas tarifini seçer")
	var r := y.gece()
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(r.uretim.get("kereste", 0) == 1 and etiketler._miktar.text == "1", "Tarif seçimi sonrası gerçek gecede kalas üretilir; kalan tomruk HUD'da görünür")
	for b in [kamp, hizar]:
		var bulundu := false
		for n in ekran.sahne3b._yapilar.get_children():
			if n.get_meta("bina_id", -1) == b.id and n.get_child_count() > 0: bulundu = true
		_kontrol(bulundu, "Gerçek bina kimliği için dünya görseli var: " + b.tur)
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko02_zincir.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ODUN ZİNCİRİ UI: GEÇTİ" if hata == 0 else "ODUN ZİNCİRİ UI: KALDI")
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
