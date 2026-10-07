extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_grev.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 89)
		kayit = GuvenliKayit.new("user://test_grev.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.akce = 100
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
	var karar := ana.oturum.karar_ver(ana.oturum._adli_gelen(&"chr_007"), &"kabul")
	var k := y.koylu(karar["koylu_id"])
	k.moral = 80
	y.ata(k.id, b.id)
	y.gece()
	ana._koye_git()
	var ekran: KoyEkrani
	for c in ana.get_children():
		if c is KoyEkrani: ekran = c
	_kontrol(ekran != null, "Canlı köy ekranı")
	await get_tree().process_frame
	var model: Node3D = ekran.sahne3b.halk_hareketi.modeller[k.id]
	# Gerçek giriş yolunu kontrollü bir görünür figür konumunda doğrula.
	model.position = Vector3.ZERO
	var nokta := ekran.sahne3b.kamera.unproject_position(model.global_position + Vector3.UP * 0.9)
	var tik := InputEventMouseButton.new()
	tik.button_index = MOUSE_BUTTON_LEFT
	tik.pressed = true
	tik.position = nokta * ekran._kap.size / Vector2(ekran._vp.size)
	ekran._dunya_girdisi(tik)
	_kontrol(is_instance_valid(ekran._ust_kart), "Figür tıklaması köylü kartını açar")
	var d := _hedef(ekran._ust_kart, b.id)
	_kontrol(d != null and d.disabled and d.text.contains("Grev"), "Canlı kart hazır tarla seçeneği")
	_kontrol(k.is_yeri == b.id and ekran._ust_kart != null, "Canlı düğme gerçek işi atar ve kartı yeniler")
	var kaydedilen := ana.oturum.kaydet()
	KoyluKarti.ac(ekran, k.id)
	_kontrol(ana.oturum.kaydet() == kaydedilen, "Kart tekrar açılması simülasyonu ilerletmez")
	var tum := _metin(ekran._ust_kart)
	_kontrol(tum.contains("Grev: ağır fiziksel işi reddediyor") and not tum.contains("haydut") and not tum.contains("DEBUG"), "Görünür kart yetenek/geçmiş içerir ve gizliyi sızdırmaz")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("uzm13_grev.png"))
	var bos := _hedef(ekran._ust_kart, KoyYonetimi.BOSTA)
	bos.pressed.emit()
	_kontrol(k.is_yeri == KoyYonetimi.BOSTA and not MeslekGrevi.aktif(k, y), "Canlı kart görevden çıkarır")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("MESLEK GREVİ UI: GEÇTİ" if hata == 0 else "MESLEK GREVİ UI: KALDI")
	await Ses.cik(hata)
func _hedef(n: Node, id: int) -> Button:
	if n is Button and n.get_meta("hedef", 99999) == id: return n
	for c in n.get_children():
		var sonuc := _hedef(c, id)
		if sonuc != null: return sonuc
	return null
func _metin(n: Node) -> String:
	var sonuc: String = n.text + "\n" if n is Label else ""
	for c in n.get_children(): sonuc += _metin(c)
	return sonuc
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
