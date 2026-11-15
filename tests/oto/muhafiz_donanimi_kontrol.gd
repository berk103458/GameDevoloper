extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_guard.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_guard_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.muhafiz_azami = 6
	for i in 6:
		var k := y.kabul({"sinif": "asker", "stat": 5})
		y.muhafiz_ata(k.id)
	ana._koye_git()
	await get_tree().process_frame
	var once := JSON.stringify(ana.oturum.kaydet())
	var sahne: KoyYonetimSahnesi = ana._ekran.sahne3b
	var h := sahne.halk_hareketi
	h.yenile()
	await get_tree().process_frame
	var f: KarakterModel = h.modeller[y.koylular[0].id]
	var d := f.get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
	kontrol(d != null, "Gerçek asker GLB el kemiklerine donanım")
	h.yenile()
	kontrol(f.find_children("muhafiz_donanimi", "", false, false).size() == 1, "Yenileme çift donanım yaratmaz")
	sahne.faz(&"gece", 0.0)
	await get_tree().process_frame
	var isiklar := 0
	var mesaleler := 0
	for model in h.modeller.values():
		var e := model.get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
		if e == null:
			continue
		if e.isik.visible:
			isiklar += 1
		mesaleler += 1
		var soket_isiklari := e.mesale.find_children("*", "Light3D", true, false)
		kontrol(soket_isiklari.size() == 1 and soket_isiklari.has(e.isik), "SAH-66: Her meşale soketinde yalnız kendi ışığı var")
	kontrol(mesaleler == 6, "SAH-66: Altı gerçek muhafızın meşalesi ölçüldü")
	print("SAH-66 meşale=%d, meşale başına ışık=1" % mesaleler)
	kontrol(isiklar == int(MuhafizDonanimi.AYAR.azami_isik), "Gerçek sahnede ışık bütçesi")
	kontrol(d != null and d.mesale.visible, "Gece meşalesi elde")
	if d != null:
		var bas := f.position
		var yuruyus_kareleri := 0
		var son := 0.0
		while son < 2.0:
			await get_tree().process_frame
			son += get_process_delta_time()
			if f.hareket_bandi() == "yuru" and f._yurume != null and f._yurume.is_running():
				yuruyus_kareleri += 1
				kontrol(d.mesale.visible and d.isik.visible and d.isik.get_parent() == d.mesale, "SAH-63: Gece yürüyüşünde aynı el soketi ve ışık açık")
		kontrol(yuruyus_kareleri >= 20 and f.position.distance_to(bas) > 0.1, "SAH-63: Gerçek devriye yürüyüşü gözlendi")
		print("SAH-63 gece yürüyüş karesi=%d" % yuruyus_kareleri)
	kontrol(JSON.stringify(ana.oturum.kaydet()) == once, "Donanım/faz RNG, kayıt veya ekonomiyi değiştirmez")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		sahne.set_process(false)
		h.set_process(false)
		sahne.kamera.position = f.position + Vector3(3, 2.2, 4)
		sahne.kamera.look_at(f.position + Vector3(0, 1, 0))
		await get_tree().create_timer(0.4).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("ani01_gece.png"))
	sahne.faz(&"gunduz", 0.0)
	kontrol(d != null and not d.isik.visible and not d.mesale.visible and d.kalkan.visible, "SAH-63: Gündüz kalkan geri ve ışık kapalı")
	y.bosalt(y.koylular[0].id)
	h.yenile()
	await get_tree().process_frame
	kontrol(f.get_node_or_null("muhafiz_donanimi") == null, "Görev bitince donanım silinir")
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("MUHAFIZ DONANIMI UI: GEÇTİ" if hata == 0 else "MUHAFIZ DONANIMI UI: KALDI")
	await Ses.cik(hata)
func kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
