extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_flock.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_flock_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(40.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	for t in ["odun", "gida"]: y.kaynaklar.ekle(t, 100)
	var b := _kur(y)
	var k := y.kabul({"ad":"Nöbetçi", "sinif":"ciftci", "stat":5})
	y.gun = 21
	y.muhafiz_ata(k.id)
	var once := JSON.stringify(ana.oturum.kaydet().merged({"faz": "koy"}, true))
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	s.faz(&"gece", 0.0)
	h._process(0.0)
	var kurt := h.get_node_or_null("KurtSurusu") as KurtSurusu
	kontrol(kurt != null and kurt.visible and kurt.kurtlar.size() == 3 and kurt.yol.size() > 1, "Üç kutu kurt gerçek ağıl çevresine A* yolu")
	kurt.set_process(false)
	for n in kurt.kurtlar: kontrol((n.get_child(0) as MeshInstance3D).mesh is BoxMesh, "Asset yerine kutu")
	var d: Dictionary = h._durum[k.id]
	kontrol(d.devriye_ad == "Ağılda kurt nöbeti", "Mevcut muhafız aynı A* ile ağıl nöbetinde")
	var ekip := h.modeller[k.id].get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
	kontrol(ekip != null and ekip.mesale.visible and ekip.silah != null, "Aynı mevcut el meşalesi/silahı")
	h.yenile()
	kontrol(h.get_node("KurtSurusu") == kurt, "İkinci kurt sürüsü üretilmez")
	for i in 7: kurt._process(0.5)
	if not OS.get_environment("ADMIN_TEST_CIKTI").is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		var pos := kurt.kurtlar[0].global_position
		s.kamera.position = pos + Vector3(5, 4, 7)
		s.kamera.look_at(pos + Vector3(0, 0.4, 0))
		await get_tree().create_timer(0.3).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(OS.get_environment("ADMIN_TEST_CIKTI").path_join("mev10_kurt.png"))
	for i in 200: kurt._process(1.0)
	kontrol(kurt.geri and kurt.adim >= kurt.yol.size(), "Meşale nöbetinde kurtlar geri çekilir")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Görsel hareket ekonomi/RNG/kayıt değiştirmez")
	s.faz(&"gunduz", 0.0)
	kontrol(h.get_node_or_null("KurtSurusu") == null, "Gündüz sürü temizlenir")
	s.faz(&"gece", 0.0)
	y.gun = 0
	h.yenile()
	kontrol(h.get_node_or_null("KurtSurusu") == null, "Bahar sürüyü temizler")
	ana.queue_free()
	await get_tree().process_frame
	print("KURT SÜRÜSÜ UI: GEÇTİ" if hata == 0 else "KURT SÜRÜSÜ UI: KALDI")
	await Ses.cik(hata)
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("agil", h).olur:
				var b := y.bina(y.bina_kur("agil", h).id)
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
