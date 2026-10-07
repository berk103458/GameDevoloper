extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_mortar.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_mortar_ui.json")
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
	var kuyu := _kur(y, "kirec_kuyusu")
	var k := y.kabul({"ad": "Kireç ustası", "sinif": "tasci", "stat": 5})
	k.moral = 50
	y.ata(k.id, kuyu.id)
	y.gece()
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	await get_tree().process_frame
	ekran._secili_bina = kuyu.id
	ekran._bilgi_goster()
	var d := _dugme(ekran._bilgi_icerik, "Harç · 2 kireç + 2 taş")
	_kontrol(d != null, "Gerçek tarif düğmesi kireç/taş girdisini açıklar")
	if d != null: d.pressed.emit()
	await get_tree().process_frame
	_kontrol(kuyu.recete == "harc", "Gerçek düğme harç tarifini seçer")
	var r := y.gece()
	ekran._yenile()
	await get_tree().process_frame
	_kontrol(r.uretim.get("harc", 0) >= 4, "UI seçimi gerçek harç üretir")
	for tur in ["kirec", "harc"]:
		_kontrol(ekran.hud._stok_etiketleri.has(tur), "Yeni stok HUD'a bağlı: " + tur)
	y.sur_seviye = 1
	y.sur_taksit_odenen = y.a.sur_taksit - 1
	ekran._kategori = "savunma"
	ekran._yenile()
	await get_tree().process_frame
	var sur := _sur_dugmesi(ekran._yapi_satiri)
	_kontrol(sur != null and sur.disabled, "Harç eksik son taksit UI tarafından engellenir")
	y.kaynaklar.ekle("harc", 20)
	ekran._yenile()
	await get_tree().process_frame
	sur = _sur_dugmesi(ekran._yapi_satiri)
	_kontrol(sur != null and not sur.disabled, "Malzeme gelince son taksit açılır")
	if sur != null: sur.pressed.emit()
	_kontrol(y.sur_seviye == 2, "Bağlı sur düğmesi gerçek seviye yükseltir")
	ekran._kategori = "uretim"
	ekran._secili_bina = kuyu.id
	ekran._yenile()
	await get_tree().process_frame
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("eko05_harc.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("HARÇ ZİNCİRİ UI: GEÇTİ" if hata == 0 else "HARÇ ZİNCİRİ UI: KALDI")
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

func _sur_dugmesi(n: Node) -> Button:
	if n is Button and n.text.contains("Son taksit:"): return n
	for c in n.get_children():
		if c.is_queued_for_deletion(): continue
		var b := _sur_dugmesi(c)
		if b != null: return b
	return null
