extends Node
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_meslek_uyumu.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 88)
		kayit = GuvenliKayit.new("user://test_meslek_uyumu.json")
		theme = Tema.olustur(ayarlar)
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	y.kaynaklar.kapasite = 10000
	for tur in ["gida", "odun", "tas", "kereste", "demir", "alet"]: y.kaynaklar.ekle(tur, 100)
	var k := y.kabul({"ad": "Emine", "adli_id": "chr_015", "sinif": "ciftci", "stat": 5})
	var j := y.kabul({"ad": "Rahime", "adli_id": "chr_018", "sinif": "ciftci", "stat": 5})
	k.moral = 50
	j.moral = 50
	var b := _kur(y, "bostan")
	var d := _kur(y, "demirhane")
	y.ata(k.id, b.id)
	y.ata(j.id, d.id)
	ana._koye_git()
	var admin := AdminHud.new()
	admin.baglam = ana
	ana.add_child(admin)
	admin.ac(true)
	var p := admin.koylu_paneli
	p.ac(true)
	_kontrol(is_equal_approx(p.satirlar[0]["uretim"]["gida"], 3.2) and is_equal_approx(p.satirlar[1]["uretim"]["alet"], 0.5), "Gercek UI uyumlu/uyumsuz üretim onizlemesi")
	_kontrol(p.tablo.get_root().get_first_child().get_next().get_tooltip_text(4).contains("%10"), "Uyumsuzluk alet riski tooltipte")
	var modeller := 0
	for n in ana._ekran.sahne3b._yapilar.get_children():
		if n.is_queued_for_deletion(): continue
		if n.has_meta("bina_id") and n.get_meta("bina_id") in [b.id, d.id] and n.get_child_count() > 0: modeller += 1
	_kontrol(modeller == 2 and MeslekYapilari.ad("bostan") == "Bostan" and MeslekYapilari.ad("demirhane") == "Demirhane", "Iki gercek bina modeli ve CSV beklemeden okunabilir isimler")
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if not dizin.is_empty() and DisplayServer.get_name() != "headless":
		await get_tree().create_timer(0.5).timeout
		await RenderingServer.frame_post_draw
		get_viewport().get_texture().get_image().save_png(dizin.path_join("uzm03_uyum.png"))
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	await get_tree().create_timer(0.3).timeout
	print("MESLEK UYUMU UI: GEÇTİ" if hata == 0 else "MESLEK UYUMU UI: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var d := y.bina_kur(tur, h)
				var b := y.bina(d["id"])
				b.insa_kalan = 0
				return b
	return null
