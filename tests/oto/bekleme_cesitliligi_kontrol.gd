extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_idle.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_idle_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	for i in 6: y.kabul({"sinif": "ciftci", "stat": 5})
	var once := JSON.stringify(ana.oturum.kaydet().merged({"faz": "koy"}, true))
	ana._koye_git()
	await get_tree().process_frame
	var s: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := s.halk_hareketi
	h.set_process(false)
	h._bekleyen.clear()
	var profiller := {}
	var pozlar := {}
	for id in h.modeller:
		var f: KarakterModel = h.modeller[id]
		f.yurumeyi_durdur()
		f.calis(&"")
		f.position = Vector3((id - 3.5) * 1.2, 0, 3)
		f.bak(f.position + Vector3(0, 0, 10))
		var d := f.duzeltici()
		var p := KarakterBeklemeCesitliligi.profil(id)
		kontrol(d != null and is_equal_approx(d.faz, p.ofset) and d.bekleme_varyanti == p.varyant, "Gerçek modifier kimlik profilini alır")
		profiller[d.bekleme_varyanti] = true
		var sk: Skeleton3D = f.find_children("*", "Skeleton3D", true, false)[0]
		sk.skeleton_updated.connect(func() -> void: pozlar[id] = sk.get_bone_global_pose(sk.find_bone("Head")).basis.get_rotation_quaternion())
	kontrol(profiller.size() == 3, "Gerçek modellerde üç idle varyasyonu")
	await get_tree().create_timer(0.5).timeout
	var fark := false
	var eski := Quaternion.IDENTITY
	for id in h.modeller:
		var f: KarakterModel = h.modeller[id]
		var sk: Skeleton3D = f.find_children("*", "Skeleton3D", true, false)[0]
		var q: Quaternion = pozlar.get(id, Quaternion.IDENTITY)
		if id > 1 and not q.is_equal_approx(eski): fark = true
		eski = q
	kontrol(pozlar.size() == h.modeller.size() and fark, "Son iskelet güncellemesinde gerçek baş pozları farklı")
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Idle görünümü kayıt/stok/RNG değiştirmez")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		s.kamera.position = Vector3(0, 2.5, 10)
		s.kamera.look_at(Vector3(0, 0.9, 3))
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("ani12_idle.png"))
	h.faz(&"gece")
	for id in h.modeller:
		var d: DurusDuzeltici = h.modeller[id].duzeltici()
		kontrol(d.bekleme_varyanti == KarakterBeklemeCesitliligi.profil(id).varyant, "Gece fazında profil korunur")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("BEKLEME ÇEŞİTLİLİĞİ UI: GEÇTİ" if hata == 0 else "BEKLEME ÇEŞİTLİLİĞİ UI: KALDI")
	await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
