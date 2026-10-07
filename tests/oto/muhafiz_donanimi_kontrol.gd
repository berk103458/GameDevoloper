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
	var once := JSON.stringify(ana.oturum.kaydet())
	ana._koye_git()
	await get_tree().process_frame
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
	for model in h.modeller.values():
		var e := model.get_node_or_null("muhafiz_donanimi") as MuhafizDonanimi
		if e != null and e.isik.visible: isiklar += 1
	kontrol(isiklar == int(MuhafizDonanimi.AYAR.azami_isik), "Gerçek sahnede ışık bütçesi")
	kontrol(d != null and d.mesale.visible, "Gece meşalesi elde")
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
	kontrol(d != null and not d.isik.visible and d.kalkan.visible, "Gündüz kalkan geri ve ışık kapalı")
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
