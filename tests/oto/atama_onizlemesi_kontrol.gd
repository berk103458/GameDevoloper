extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_drag.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_drag.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
var _son_fare := Vector2.ZERO
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	var b := _kur(y)
	var k := y.kabul({"ad": "Ali", "sinif": "ciftci", "stat": 5})
	k.moral = 50
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	ekran.sahne3b.hedef = ekran.sahne3b.alan_merkezi(b.hucre, b.boyut(y.katalog))
	ekran.sahne3b._kamera_yerlestir()
	KoyluKarti.ac(ekran, k.id)
	await get_tree().process_frame
	await get_tree().process_frame
	var kulp := _kulp(ekran._ust_kart)
	var bas := kulp.global_position + kulp.size * 0.5
	var merkez := ekran.sahne3b.alan_merkezi(b.hucre, b.boyut(y.katalog))
	var nokta := ekran.sahne3b.kamera.unproject_position(merkez) * ekran._kap.size / Vector2(ekran._vp.size)
	var once := ana.oturum.kaydet()
	_hareket(bas, false)
	_dugme(bas, true)
	await get_tree().process_frame
	_hareket(bas + Vector2(45, 25), true)
	await get_tree().process_frame
	_hareket(nokta, true)
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(get_viewport().gui_is_dragging(), "Gerçek GUI fare hareketi kart sürüklemesini başlatır")
	var alan := ekran._atama_alani
	_kontrol(alan.onizleme.visible and alan.son.get("yesil", false) and alan.aciklama.text.contains("3.20"), "Gerçek hedef üstünde yeşil 3.20 önizleme")
	_kontrol(ana.oturum.kaydet() == once, "Gerçek sürükleme canlı simülasyonu değiştirmez")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("uzm15_surukle.png"))
	_dugme(nokta, false)
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(k.is_yeri == b.id and not get_viewport().gui_is_dragging() and not alan.onizleme.visible, "Gerçek bırakma atar ve önizlemeyi kapatır")
	_kontrol(is_instance_valid(ekran._ust_kart) and ekran._ust_kart.visible, "Bırakma sonrası köylü kartı görünür")
	# Sürükleme iptali ve önizleme sonrası değişen hedef gerçek GUI yolunda.
	await _surukle(ekran, nokta)
	var bos := Vector2(5, ekran.size.y * 0.6)
	_hareket(bos, true)
	await get_tree().process_frame
	_dugme(bos, false)
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(k.is_yeri == b.id and not get_viewport().gui_is_dragging() and not alan.visible and ekran._ust_kart.visible, "Boş hedefe bırakma mevcut işi korur ve kartı geri açar")
	y.bosalt(k.id)
	await _surukle(ekran, nokta)
	_kontrol(alan.son.olur, "Hedef başlangıçta atamaya uygun")
	b.insa_kalan = 1
	_dugme(nokta, false)
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(k.is_yeri != b.id and not get_viewport().gui_is_dragging() and not alan.visible and ekran._ust_kart.visible, "Önizleme sonrası kullanılamaz olan hedef bırakmada yeniden denetlenir")
	b.insa_kalan = 0
	k.zanaat_turu = ZanaatTuru.Tur.DEMIRCI
	await _surukle(ekran, nokta)
	_kontrol(alan.onizleme.visible and not alan.son.olur, "ISG-30: demirci tarlaya bırakılamaz")
	_dugme(nokta, false)
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(k.is_yeri == KoyYonetimi.BOSTA and ekran._ust_kart.visible, "ISG-30: yanlış bina atama yapmaz ve kart geri gelir")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("ATAMA SÜRÜKLEME UI: GEÇTİ" if hata == 0 else "ATAMA SÜRÜKLEME UI: KALDI")
	await Ses.cik(hata)
func _surukle(ekran: KoyEkrani, nokta: Vector2) -> void:
	var kulp := _kulp(ekran._ust_kart)
	var bas := kulp.global_position + kulp.size * 0.5
	_hareket(bas, false)
	_dugme(bas, true)
	await get_tree().process_frame
	_hareket(bas + Vector2(45, 25), true)
	await get_tree().process_frame
	_hareket(nokta, true)
	await get_tree().process_frame
	await get_tree().process_frame
	_kontrol(get_viewport().gui_is_dragging(), "Tekrar sürükleme gerçek GUI ile başlar")
func _hareket(p: Vector2, basili: bool) -> void:
	var e := InputEventMouseMotion.new()
	e.position = get_viewport().get_final_transform() * p
	e.global_position = e.position
	e.relative = get_viewport().get_final_transform() * p - get_viewport().get_final_transform() * _son_fare
	_son_fare = p
	e.button_mask = MOUSE_BUTTON_MASK_LEFT if basili else 0
	e.window_id = get_window().get_window_id()
	Input.parse_input_event(e)
func _dugme(p: Vector2, basili: bool) -> void:
	var e := InputEventMouseButton.new()
	e.position = get_viewport().get_final_transform() * p
	e.global_position = e.position
	e.button_index = MOUSE_BUTTON_LEFT
	e.pressed = basili
	e.window_id = get_window().get_window_id()
	Input.parse_input_event(e)
func _kulp(n: Node) -> KoyluSuruklemeKulpu:
	if n is KoyluSuruklemeKulpu: return n
	for c in n.get_children():
		var sonuc := _kulp(c)
		if sonuc != null: return sonuc
	return null
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var b := y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
