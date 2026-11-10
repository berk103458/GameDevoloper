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
	var once := ana.oturum.kaydet().merged({"faz": "koy"}, true)
	ana._koye_git()
	await get_tree().process_frame
	once["ogretici"] = ana.oturum.kaydet()["ogretici"]
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
	kontrol(JSON.stringify(ana.oturum.kaydet()) == JSON.stringify(once), "Idle görünümü kayıt/stok/RNG değiştirmez")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		s.set_process(false)
		s.kamera.position = Vector3(0, 2.5, 10)
		s.kamera.look_at(Vector3(0, 0.9, 3))
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("ani12_idle.png"))
	await _geciste_ofseti_dene(h)
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
func _geciste_ofseti_dene(h: KoyHalkHareketi) -> void:
	var ids := h.modeller.keys().slice(0, 2)
	kontrol(ids.size() == 2, "SAH-28: İki gerçek köylü")
	if ids.size() < 2:
		return
	var ofsetler := PackedFloat64Array()
	for id in ids:
		var f: KarakterModel = h.modeller[id]
		ofsetler.append(f.duzeltici().faz)
		f.yuru(f.position + Vector3(0, 0, 5), 1.35)
	var yuru := await _karisimi_olc(h, ids, "yuru")
	for id in ids:
		h.modeller[id].yurumeyi_durdur()
	var dur := await _karisimi_olc(h, ids, "dur")
	kontrol(absf(ofsetler[0] - ofsetler[1]) > 0.1 and yuru.korundu and dur.korundu, "SAH-28: İki ayrı ANI-12 ofseti ve klip zamanı korunur")
	kontrol(yuru.ara == 2 and dur.ara == 2, "SAH-28: İki modelde yürüyüş ve duruş ara karesi görülür")
	print("SAH-28 ofsetler=%s, yürüyüş/duruş ara pozlu model=%d/%d, kare=%d/%d" % [
		ofsetler, yuru.ara, dur.ara, yuru.kare, dur.kare])

func _karisimi_olc(h: KoyHalkHareketi, ids: Array, band: String) -> Dictionary:
	var son := {}
	var ara := {}
	var gecti := true
	var sure := 0.0
	var kare := 0
	while sure < KarakterModel.GECIS + 0.05:
		await get_tree().process_frame
		sure += get_process_delta_time()
		kare += 1
		for id in ids:
			var f: KarakterModel = h.modeller[id]
			var d := f.duzeltici()
			var profil := KarakterBeklemeCesitliligi.profil(id)
			var zamanlar := Vector2(d._zaman, f._oynatici.current_animation_position)
			var onceki: Vector2 = son.get(id, Vector2.ZERO)
			gecti = gecti and is_equal_approx(d.faz, float(profil.ofset)) and d.bekleme_varyanti == int(profil.varyant)
			gecti = gecti and f.hareket_bandi() == band and zamanlar.x >= onceki.x and zamanlar.y >= onceki.y
			if d.bekleme > 0.01 and d.bekleme < 0.99:
				ara[id] = true
			son[id] = zamanlar
	return {"korundu": gecti, "ara": ara.size(), "kare": kare}

func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
